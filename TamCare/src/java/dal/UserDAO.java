package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import java.util.ArrayList; // <-- THÊM DÒNG NÀY
import java.util.List;      // <-- THÊM DÒNG NÀY

public class UserDAO extends DBContext {

    // 1. Kiểm tra Email tồn tại
    public boolean checkEmailExist(String email) {
        // Cột trong DB là Email
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Hàm Đăng ký chuẩn theo Database TamCareDB
    public void register(User u) {
        // SQL Server query: Cột PasswordHash phải đúng tên
        String sql = "INSERT INTO Users (Email, PasswordHash, FullName, PhoneNumber, Role, DateCreated) VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try {
            Connection conn = getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
            
            // Map dữ liệu từ Java vào SQL
            st.setString(1, u.getEmail());
            st.setString(2, u.getPassword()); // Java là getPassword -> SQL là PasswordHash
            st.setString(3, u.getFullName());
            st.setString(4, u.getPhoneNumber());
            st.setString(5, u.getRole());
            
            st.executeUpdate(); // Thực thi lệnh Insert
            
            System.out.println("DEBUG: Đăng ký thành công cho email: " + u.getEmail());
            
        } catch (SQLException e) {
            System.out.println("Lỗi SQL khi đăng ký:");
            e.printStackTrace(); // In lỗi ra cửa sổ Output của NetBeans
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

}