package dao;

import context.DBContext;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class UserDAO {

    private Connection conn = DBContext.getConnection();

    public User login(String username, String password) {
        String sql = """
        SELECT user_id, username, full_name, email, phone,
           password_hash, status, warehouse_id, created_at
        FROM `User`
        WHERE username = ?
            AND status = 'ACTIVE'
            AND is_deleted = 0
        LIMIT 1
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    String hash = rs.getString("password_hash");

                    // So sánh password
                    if (!BCrypt.checkpw(password, hash)) {
                        return null;
                    }

                    User u = new User();
                    u.setUserId(rs.getLong("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setStatus(rs.getString("status"));
                    u.setWarehouseId(rs.getLong("warehouse_id"));
                    u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
