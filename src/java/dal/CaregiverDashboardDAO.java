package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.User;

/**
 * DAO phục vụ màn hình người chăm sóc: đọc danh sách người thân
 * kèm trạng thái đã điểm danh hôm nay hay chưa.
 */
public class CaregiverDashboardDAO extends DBContext {

    public static class ElderlyCheckinStatus {
        private User elderly;
        private boolean checkedInToday;

        public ElderlyCheckinStatus(User elderly, boolean checkedInToday) {
            this.elderly = elderly;
            this.checkedInToday = checkedInToday;
        }

        public User getElderly() {
            return elderly;
        }

        public boolean isCheckedInToday() {
            return checkedInToday;
        }
    }

    /**
     * Lấy danh sách người cao tuổi mà caregiver đang theo dõi
     * cùng cờ đã điểm danh hôm nay.
     */
    public List<ElderlyCheckinStatus> getElderlyCheckinStatuses(int caregiverId) {
        List<ElderlyCheckinStatus> result = new ArrayList<>();

        String sql = """
                SELECT u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Role, u.LinkKey,
                       CASE 
                           WHEN EXISTS (
                               SELECT 1 FROM DailyCheckin d
                               WHERE d.ElderlyUserID = u.UserID
                                 AND CAST(d.CheckinTime AS DATE) = CAST(GETDATE() AS DATE)
                           )
                           THEN 1 ELSE 0
                       END AS CheckedInToday
                FROM dbo.Relationship r
                JOIN dbo.Users u ON u.UserID = r.ElderlyUserID
                WHERE r.CaregiverUserID = ? 
                  AND r.Status = 'Active'
                  AND u.Role = 'Elderly'
                ORDER BY u.FullName
                """;

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserID(rs.getInt("UserID"));
                    u.setFullName(rs.getString("FullName"));
                    u.setEmail(rs.getString("Email"));
                    u.setPhoneNumber(rs.getString("PhoneNumber"));
                    u.setRole(rs.getString("Role"));
                    u.setLinkKey(rs.getString("LinkKey"));

                    boolean checkedInToday = rs.getInt("CheckedInToday") == 1;
                    result.add(new ElderlyCheckinStatus(u, checkedInToday));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }
}

