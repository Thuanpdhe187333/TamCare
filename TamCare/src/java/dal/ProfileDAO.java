package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.ElderlyProfile;

public class ProfileDAO extends DBContext {

    // 1. Lưu hồ sơ sức khỏe mới
    public void saveProfile(ElderlyProfile p) {
        // Kiểm tra xem user này đã có hồ sơ chưa, nếu có rồi thì UPDATE, chưa có thì INSERT
        // Ở đây mình làm đơn giản là INSERT (hoặc bạn có thể xóa cái cũ đi trước)
        String sql = "INSERT INTO ElderlyProfile (UserID, DateOfBirth, Address, Weight_kg, Height_cm, ChronicConditions) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, p.getUserID());
            st.setDate(2, p.getDateOfBirth());
            st.setString(3, p.getAddress());
            st.setDouble(4, p.getWeight());
            st.setDouble(5, p.getHeight());
            st.setString(6, p.getChronicConditions());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    // 2. Lấy ProfileID vừa tạo (để dùng cho bảng AISolutions)
    public int getProfileIDByUserID(int userID) {
        String sql = "SELECT TOP 1 ProfileID FROM ElderlyProfile WHERE UserID = ? ORDER BY ProfileID DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("ProfileID");
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return -1;
    }

    // 3. Lưu Lời khuyên của AI (Quan trọng)
    public void saveAISolution(int profileID, String advice, String type) {
        String sql = "INSERT INTO AISolutions (ProfileID, SolutionContent, SolutionType, CreationTime) VALUES (?, ?, ?, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, profileID);
            st.setString(2, advice);
            st.setString(3, type);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}