package dal;

import java.sql.*;
import model.VisitRecord;

/**
 * VisitRecords: ProfileID, VisitDateTime, VisitType, DoctorName, Diagnosis, TreatmentPlan.
 */
public class VisitRecordDAO extends DBContext {

    /**
     * Insert one visit and return the new VisitID (SCOPE_IDENTITY).
     */
    public int insert(VisitRecord v) {
        String sql = "INSERT INTO VisitRecords (ProfileID, VisitDateTime, VisitType, DoctorName, Diagnosis, TreatmentPlan) "
                + "OUTPUT INSERTED.VisitID VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, v.getProfileID());
            ps.setTimestamp(2, v.getVisitDateTime() != null ? v.getVisitDateTime() : new Timestamp(System.currentTimeMillis()));
            ps.setString(3, v.getVisitType());
            ps.setString(4, v.getDoctorName());
            ps.setString(5, v.getDiagnosis());
            ps.setString(6, v.getTreatmentPlan());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}
