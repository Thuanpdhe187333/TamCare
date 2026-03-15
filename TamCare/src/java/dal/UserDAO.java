package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import java.util.ArrayList; // <-- THÊM DÒNG NÀY
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;      // <-- THÊM DÒNG NÀY
import java.util.Map;
import java.util.Random;

public class UserDAO extends DBContext {

    // 1. Kiểm tra Email tồn tại
    public boolean checkEmailExist(String email) {
        String sql = "SELECT 1 FROM Users WHERE Email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Hàm Đăng ký chuẩn theo Database TamCareDB
    public void register(User u) {
        String sql = "INSERT INTO Users (Email, PasswordHash, FullName, PhoneNumber, Role, LinkKey, DateCreated) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, u.getEmail());
            st.setString(2, u.getPassword());
            st.setString(3, u.getFullName());
            st.setString(4, u.getPhoneNumber());
            st.setString(5, u.getRole());
            st.setString(6, u.getLinkKey());

            st.executeUpdate();
            System.out.println("DEBUG: Register ok. email=" + u.getEmail() + ", linkKey=" + u.getLinkKey());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Hàm Login (Cập nhật theo PasswordHash)
    public User login(String email, String password) {
        String sql = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setPhoneNumber(rs.getString("PhoneNumber"));
                u.setRole(rs.getString("Role"));
                u.setLinkKey(rs.getString("LinkKey")); // <-- THÊM
                return u;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    // 4. Lấy danh sách tất cả người dùng (Trừ Admin ra)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role != 'Admin'";
        try {
            Connection conn = getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setPhoneNumber(rs.getString("PhoneNumber"));
                u.setRole(rs.getString("Role"));
                u.setDateCreated(rs.getDate("DateCreated"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    // 5. Xóa người dùng theo ID
    public void deleteUser(int id) {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public Map<String, Integer> countUserByRole() {
        Map<String, Integer> data = new HashMap<>();
        String sql = "SELECT Role, COUNT(*) as Total FROM Users GROUP BY Role";
        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                data.put(rs.getString("Role"), rs.getInt("Total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    // 2. Thống kê người dùng mới theo tháng (Dùng cho Biểu đồ đường/chuỗi)
    public Map<String, Integer> getUserGrowth() {
        Map<String, Integer> data = new LinkedHashMap<>(); // Giữ đúng thứ tự tháng
        String sql = "SELECT FORMAT(DateCreated, 'MM/yyyy') as Month, COUNT(*) as Total "
                + "FROM Users GROUP BY FORMAT(DateCreated, 'MM/yyyy') ORDER BY Month ASC";
        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                data.put(rs.getString("Month"), rs.getInt("Total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    public boolean isLinkKeyExist(String linkKey) {
        String sql = "SELECT 1 FROM dbo.Users WHERE LinkKey = ?";
        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, linkKey);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String generateUniqueLinkKey() {
        Random r = new Random();
        String key;
        do {
            int num = 100000 + r.nextInt(900000);
            key = "TC" + num;
        } while (isLinkKeyExist(key));
        return key;
    }

    public Integer getElderlyIdByLinkKey(String linkKey) {
        String sql = "SELECT UserID FROM dbo.Users WHERE LinkKey = ? AND Role = 'Elderly'";
        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, linkKey);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("UserID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean linkCaregiverToElderly_Relationship(int caregiverId, int elderlyId) {
        String sql
                = "IF NOT EXISTS (SELECT 1 FROM dbo.Relationship WHERE ElderlyUserID=? AND CaregiverUserID=?) "
                + "BEGIN "
                + "   INSERT INTO dbo.Relationship(ElderlyUserID, CaregiverUserID, RelationshipType, Status) "
                + "   VALUES(?, ?, ?, ?) "
                + "END";
        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, elderlyId);
            st.setInt(2, caregiverId);
            st.setInt(3, elderlyId);
            st.setInt(4, caregiverId);
            st.setString(5, "Family");
            st.setString(6, "Active");
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getLinkedElderlyList_ByRelationship(int caregiverId) {
        List<User> list = new ArrayList<>();
        String sql
                = "SELECT u.UserID, u.FullName, u.PhoneNumber, u.Email, u.Role, u.LinkKey "
                + "FROM dbo.Relationship r "
                + "JOIN dbo.Users u ON u.UserID = r.ElderlyUserID "
                + "WHERE r.CaregiverUserID = ? AND r.Status = 'Active' AND u.Role='Elderly' "
                + "ORDER BY u.FullName";
        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, caregiverId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setFullName(rs.getString("FullName"));
                u.setPhoneNumber(rs.getString("PhoneNumber"));
                u.setEmail(rs.getString("Email"));
                u.setRole(rs.getString("Role"));
                u.setLinkKey(rs.getString("LinkKey"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
    try (Connection conn = getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setFullName(rs.getString("FullName"));
                u.setEmail(rs.getString("Email"));
                u.setPhoneNumber(rs.getString("PhoneNumber"));
                u.setLinkKey(rs.getString("LinkKey"));
                u.setRole(rs.getString("Role"));
                try { u.setGender(rs.getString("Gender")); } catch (Exception ignore) {}
                try { u.setBirthYear((Integer) rs.getObject("BirthYear")); } catch (Exception ignore) {}
                return u;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

    public boolean isCaregiverLinkedToElderly(int caregiverId, int elderlyId) {
        String sql = "SELECT 1 FROM dbo.Relationship WHERE CaregiverUserID=? AND ElderlyUserID=? AND Status='Active'";
        try (Connection conn = getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, caregiverId);
            st.setInt(2, elderlyId);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateBasicProfile(int userId, String fullName, String phoneNumber, String gender, Integer birthYear) {
        String sql = "UPDATE Users SET FullName = ?, PhoneNumber = ?, Gender = ?, BirthYear = ? WHERE UserID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phoneNumber);
            ps.setString(3, gender);
            if (birthYear != null) {
                ps.setInt(4, birthYear);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setInt(5, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
