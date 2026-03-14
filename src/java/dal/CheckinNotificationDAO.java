package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CheckinNotificationDAO extends DBContext {

    public static class CheckinNotificationView {
        private int notificationId;
        private String elderlyName;
        private Timestamp createdAt;
        private boolean isRead;

        public int getNotificationId() {
            return notificationId;
        }

        public void setNotificationId(int notificationId) {
            this.notificationId = notificationId;
        }

        public String getElderlyName() {
            return elderlyName;
        }

        public void setElderlyName(String elderlyName) {
            this.elderlyName = elderlyName;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(Timestamp createdAt) {
            this.createdAt = createdAt;
        }

        public boolean isRead() {
            return isRead;
        }

        public void setRead(boolean isRead) {
            this.isRead = isRead;
        }
    }

    /**
     * Khi ông/bà điểm danh, tạo thông báo cho tất cả caregiver đang
     * liên kết với tài khoản này.
     */
    public void createForDailyCheckin(int elderlyUserId) {
        String sql = """
                INSERT INTO CheckinNotification(ElderlyUserID, CaregiverUserID, CreatedAt, IsRead)
                SELECT r.ElderlyUserID, r.CaregiverUserID, GETDATE(), 0
                FROM dbo.Relationship r
                WHERE r.ElderlyUserID = ? AND r.Status = 'Active'
                """;

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, elderlyUserId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy danh sách thông báo điểm danh cho người chăm sóc.
     */
    public List<CheckinNotificationView> getByCaregiver(int caregiverUserId) {
        List<CheckinNotificationView> list = new ArrayList<>();

        String sql = """
                SELECT n.NotificationID,
                       n.CreatedAt,
                       n.IsRead,
                       u.FullName AS ElderlyName
                FROM CheckinNotification n
                JOIN Users u ON u.UserID = n.ElderlyUserID
                WHERE n.CaregiverUserID = ?
                ORDER BY n.CreatedAt DESC
                """;

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, caregiverUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CheckinNotificationView v = new CheckinNotificationView();
                    v.setNotificationId(rs.getInt("NotificationID"));
                    v.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    v.setRead(rs.getBoolean("IsRead"));
                    v.setElderlyName(rs.getString("ElderlyName"));
                    list.add(v);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}

