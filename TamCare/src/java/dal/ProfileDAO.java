package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import model.ElderlyProfile;

public class ProfileDAO extends DBContext {

    // 1. Lưu hồ sơ sức khỏe mới
    public void saveProfile(ElderlyProfile p) {
        String sql = "INSERT INTO ElderlyProfile (UserID, DateOfBirth, Address, Weight_kg, Height_cm, ChronicConditions) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setInt(1, p.getUserID());
            st.setDate(2, p.getDateOfBirth());
            st.setString(3, p.getAddress());
            st.setDouble(4, p.getWeight());
            st.setDouble(5, p.getHeight());
            st.setString(6, p.getChronicConditions());

            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 2. Lấy ProfileID vừa tạo (để dùng cho bảng AISolutions)
    public int getProfileIDByUserID(int userID) {
        String sql = "SELECT TOP 1 ProfileID FROM ElderlyProfile WHERE UserID = ? ORDER BY ProfileID DESC";

        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setInt(1, userID);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ProfileID");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // 3. Lưu Lời khuyên của AI (Quan trọng)
    public void saveAISolution(int profileID, String advice, String type) {
        String sql = "INSERT INTO AISolutions (ProfileID, SolutionContent, SolutionType, CreationTime) "
                + "VALUES (?, ?, ?, GETDATE())";

        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setInt(1, profileID);
            st.setString(2, advice);
            st.setString(3, type);

            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ElderlyProfile getLatestProfileByUserID(int userID) {
        String sql = "SELECT TOP 1 ProfileID, UserID, DateOfBirth, Address, Weight_kg, Height_cm, ChronicConditions "
                + "FROM ElderlyProfile WHERE UserID = ? ORDER BY ProfileID DESC";

        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                ElderlyProfile p = new ElderlyProfile();
                p.setProfileID(rs.getInt("ProfileID"));
                p.setUserID(rs.getInt("UserID"));
                p.setDateOfBirth(rs.getDate("DateOfBirth"));
                p.setAddress(rs.getString("Address"));
                p.setWeight(rs.getDouble("Weight_kg"));
                p.setHeight(rs.getDouble("Height_cm"));
                p.setChronicConditions(rs.getString("ChronicConditions"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get latest AI recommendation (e.g. Nutrition) for profile.
     * @return array: [0]=SolutionContent, [1]=CreationTime string; or null if none
     */
    public String[] getLatestAISolution(int profileID, String solutionType) {
        String sql = "SELECT TOP 1 SolutionContent, CONVERT(varchar, CreationTime, 120) AS CreationTime "
                + "FROM AISolutions WHERE ProfileID = ? AND SolutionType = ? ORDER BY CreationTime DESC";
        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, profileID);
            st.setString(2, solutionType == null ? "Nutrition" : solutionType);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new String[]{rs.getString("SolutionContent"), rs.getString("CreationTime")};
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
