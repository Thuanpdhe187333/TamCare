package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DailyCheckinDAO extends DBContext {

    /**
     * Kiểm tra hôm nay bác đã điểm danh chưa (theo ElderlyUserID).
     */
    public boolean hasCheckedInToday(int elderlyUserId) {
        String sql = "SELECT COUNT(*) AS Total "
                + "FROM DailyCheckin "
                + "WHERE ElderlyUserID = ? "
                + "  AND CAST(CheckinTime AS DATE) = CAST(GETDATE() AS DATE)";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, elderlyUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Total") > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Ghi nhận một lần điểm danh mới cho bác.
     */
    public void insertCheckin(int elderlyUserId) {
        String sql = "INSERT INTO DailyCheckin(ElderlyUserID, CheckinTime) "
                + "VALUES(?, GETDATE())";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, elderlyUserId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

