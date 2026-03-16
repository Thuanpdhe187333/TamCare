package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Notification;

public class NotificationDAO extends DBContext {

    // 1. Lấy danh sách thông báo của một User (Mới nhất lên đầu)
    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT NotificationID, UserID, Title, Message, IsRead, CreatedAt "
                   + "FROM Notifications WHERE UserID = ? ORDER BY CreatedAt DESC";
        
        try (Connection con = getConnection(); 
             PreparedStatement st = con.prepareStatement(sql)) {
            
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Notification n = new Notification();
                n.setId(rs.getInt("NotificationID"));
                n.setUserId(rs.getInt("UserID"));
                n.setTitle(rs.getString("Title"));
                n.setMessage(rs.getString("Message"));
                n.setRead(rs.getBoolean("IsRead"));
                n.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thêm thông báo mới (Dùng khi Nâng cấp Premium, Nạp tiền, Điểm danh...)
    public boolean addNotification(int userId, String title, String message) {
        String sql = "INSERT INTO Notifications (UserID, Title, Message, IsRead, CreatedAt) "
                   + "VALUES (?, ?, ?, 0, GETDATE())";
        
        try (Connection con = getConnection(); 
             PreparedStatement st = con.prepareStatement(sql)) {
            
            st.setInt(1, userId);
            st.setString(2, title);
            st.setString(3, message);
            
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Đếm số thông báo CHƯA ĐỌC (Để hiện số đỏ trên icon chuông ở Header)
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE UserID = ? AND IsRead = 0";
        try (Connection con = getConnection(); 
             PreparedStatement st = con.prepareStatement(sql)) {
            
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 4. Đánh dấu tất cả thông báo của User là đã đọc
    public void markAllAsRead(int userId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE UserID = ?";
        try (Connection con = getConnection(); 
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Lấy 5 cái mới nhất cho Dropdown Header
public List<Notification> getTop5Notifications(int userId) {
    List<Notification> list = new ArrayList<>();
    String sql = "SELECT TOP 5 * FROM Notifications WHERE UserID = ? ORDER BY CreatedAt DESC";
    try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
        st.setInt(1, userId);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            list.add(new Notification(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4), rs.getBoolean(5), rs.getTimestamp(6)));
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

// Lấy thông báo theo trang (OFFSET và FETCH NEXT)
public List<Notification> getNotificationsByPage(int userId, int page, int pageSize) {
    List<Notification> list = new ArrayList<>();
    String sql = "SELECT * FROM Notifications WHERE UserID = ? ORDER BY CreatedAt DESC " +
                 "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
    try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
        st.setInt(1, userId);
        st.setInt(2, (page - 1) * pageSize);
        st.setInt(3, pageSize);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            list.add(new Notification(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4), rs.getBoolean(5), rs.getTimestamp(6)));
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

// Đếm tổng số để tính số trang
public int getTotalCount(int userId) {
    String sql = "SELECT COUNT(*) FROM Notifications WHERE UserID = ?";
    try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
        st.setInt(1, userId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) { e.printStackTrace(); }
    return 0;
}
}