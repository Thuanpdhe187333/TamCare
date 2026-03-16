package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.MedicalHistory;

public class MedicalHistoryDAO {

    DBContext db = new DBContext();

    public List<MedicalHistory> getByProfileId(int profileId) {

        List<MedicalHistory> list = new ArrayList<>();

        String sql = "SELECT * FROM MedicalHistory WHERE ProfileID = ?";

        try {

            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, profileId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                MedicalHistory m = new MedicalHistory();

                m.setHistoryId(rs.getInt("HistoryID"));
                m.setProfileId(rs.getInt("ProfileID"));
                m.setDiseaseCode(rs.getString("DiseaseCode"));
                m.setConditionName(rs.getString("ConditionName"));
                m.setHistoryType(rs.getString("HistoryType"));
                m.setCurrentStatus(rs.getString("CurrentStatus"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insert(MedicalHistory m) {

        String sql
                = "INSERT INTO MedicalHistory "
                + "(ProfileID, DiseaseCode, ConditionName, HistoryType, DiagnosisDate, CurrentStatus) "
                + "VALUES (?, ?, ?, ?, GETDATE(), ?)";

        try {

            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, m.getProfileId());
            ps.setString(2, m.getDiseaseCode());
            ps.setString(3, m.getConditionName());
            ps.setString(4, m.getHistoryType());
            ps.setString(5, m.getCurrentStatus());

            System.out.println("INSERTING...");
            ps.executeUpdate();
            System.out.println("INSERT SUCCESS");

        } catch (Exception e) {
            System.out.println("INSERT ERROR");
            e.printStackTrace();
        }
    }
}
