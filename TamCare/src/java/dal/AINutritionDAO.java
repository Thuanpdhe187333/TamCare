package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * AI Nutrition flow: MedicalHistory → Diseases/DiseaseProtocol → DiseaseNutritionRules → Foods.
 * Builds recommendation text and stores in AISolutions.
 */
public class AINutritionDAO extends DBContext {

    /**
     * Get distinct disease codes and names from medical history for a profile.
     * Uses ProfileID (ElderlyProfile). If your MedicalHistory uses UserID for elderly, pass that as profileId.
     */
    public List<String[]> getDiseaseCodesFromHistory(int profileId) {
        List<String[]> out = new ArrayList<>();
        String sql = "SELECT DISTINCT DiseaseCode, ConditionName FROM MedicalHistory WHERE ProfileID = ? AND (CurrentStatus IS NULL OR CurrentStatus NOT IN ('Khỏi', 'Resolved'))";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, profileId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                out.add(new String[]{rs.getString("DiseaseCode"), rs.getString("ConditionName")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return out;
    }

    /**
     * Get nutrition rules for a disease (by DiseaseCode).
     * Tries DiseaseCode column first; if empty, tries join via Diseases table (DiseaseID).
     */
    public List<String[]> getNutritionRules(String diseaseCode) {
        List<String[]> out = getNutritionRulesByDiseaseCode(diseaseCode);
        if (out.isEmpty()) {
            out = getNutritionRulesViaDiseasesTable(diseaseCode);
        }
        return out;
    }

    /** DiseaseNutritionRules has DiseaseCode (e.g. FK to DiseaseProtocol). */
    public List<String[]> getNutritionRulesByDiseaseCode(String diseaseCode) {
        List<String[]> out = new ArrayList<>();
        String sql = "SELECT Nutrient, Recommendation FROM DiseaseNutritionRules WHERE DiseaseCode = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, diseaseCode);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                out.add(new String[]{rs.getString("Nutrient"), rs.getString("Recommendation")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return out;
    }

    /** If DiseaseNutritionRules links to Diseases by DiseaseID. */
    public List<String[]> getNutritionRulesViaDiseasesTable(String diseaseCode) {
        List<String[]> out = new ArrayList<>();
        String sql = "SELECT nr.Nutrient, nr.Recommendation FROM DiseaseNutritionRules nr "
                + "INNER JOIN Diseases d ON d.DiseaseID = nr.DiseaseID WHERE d.DiseaseCode = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, diseaseCode);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                out.add(new String[]{rs.getString("Nutrient"), rs.getString("Recommendation")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return out;
    }

    /**
     * Get suggested food names: high-nutrient for "Increase", low for "Reduce".
     * Foods table: FoodName, and nutrient columns e.g. Potassium, Sodium (nullable).
     */
    public List<String> getSuggestedFoods(String nutrientColumn, boolean increase) {
        List<String> out = new ArrayList<>();
        String col = safeNutrientColumn(nutrientColumn);
        String order = increase ? " DESC" : " ASC";
        String sql = "SELECT TOP 5 FoodName FROM Foods WHERE " + col + " IS NOT NULL ORDER BY " + col + order;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                out.add(rs.getString("FoodName"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return out;
    }

    private static String safeNutrientColumn(String nutrient) {
        if (nutrient == null) return "Potassium";
        switch (nutrient.toLowerCase()) {
            case "potassium":
            case "kali":
                return "Potassium";
            case "sodium":
            case "natri":
                return "Sodium";
            case "fiber":
                return "Fiber";
            case "calcium":
                return "Calcium";
            case "iron":
                return "Iron";
            case "omega3":
                return "Omega3";
            case "protein":
                return "Protein";
            default:
                return "Potassium";
        }
    }

    /**
     * Build recommendation text from history and rules, then save to AISolutions.
     * Format: line 1 = Bệnh: ...; line 2 = Nên tăng: ...; line 3 = Nên giảm: ...; line 4 = Thực phẩm: ...
     */
    public String buildAndSaveRecommendation(int profileId) {
        List<String[]> diseases = getDiseaseCodesFromHistory(profileId);
        if (diseases.isEmpty()) {
            String msg = "Chưa có bệnh án nào. Cập nhật lịch sử bệnh để nhận gợi ý dinh dưỡng.";
            new ProfileDAO().saveAISolution(profileId, msg, "Nutrition");
            return msg;
        }

        Set<String> increaseNutrients = new LinkedHashSet<>();
        Set<String> reduceNutrients = new LinkedHashSet<>();
        Set<String> allFoods = new LinkedHashSet<>();
        StringBuilder diseaseNames = new StringBuilder();

        for (String[] d : diseases) {
            String code = d[0], name = d[1];
            if (diseaseNames.length() > 0) diseaseNames.append(", ");
            diseaseNames.append(name != null && !name.isEmpty() ? name : code);

            List<String[]> rules = getNutritionRules(code);
            for (String[] r : rules) {
                String nutrient = r[0], rec = r[1];
                if (rec == null) continue;
                if (rec.equalsIgnoreCase("Increase") || rec.contains("tăng")) {
                    increaseNutrients.add(nutrient);
                    allFoods.addAll(getSuggestedFoods(nutrient, true));
                } else if (rec.equalsIgnoreCase("Reduce") || rec.contains("giảm") || rec.contains("Reduce")) {
                    reduceNutrients.add(nutrient);
                    allFoods.addAll(getSuggestedFoods(nutrient, false));
                }
            }
        }

        StringBuilder content = new StringBuilder();
        content.append("Bệnh: ").append(diseaseNames).append("\n");
        content.append("Nên tăng: ").append(increaseNutrients.isEmpty() ? "—" : String.join(", ", increaseNutrients)).append("\n");
        content.append("Nên giảm: ").append(reduceNutrients.isEmpty() ? "—" : String.join(", ", reduceNutrients)).append("\n");
        content.append("Thực phẩm: ").append(allFoods.isEmpty() ? "—" : String.join(", ", allFoods));

        String text = content.toString();
        new ProfileDAO().saveAISolution(profileId, text, "Nutrition");
        return text;
    }
}
