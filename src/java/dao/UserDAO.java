package dao;

import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.Duration;
import java.util.Base64;

public class UserDAO {

    
    private final Connection conn = DBContext.getConnection();
    private static final Duration RESET_TOKEN_TTL = Duration.ofMinutes(15);
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    
    public User login(String identity, String password) {
        String sql = """
            SELECT user_id, username, full_name, email, phone,
                   password_hash, status, warehouse_id, created_at
            FROM `user`
            WHERE (username = ? OR email = ?)
              AND status = 'ACTIVE'
              AND is_deleted = 0
            LIMIT 1
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identity);
            ps.setString(2, identity);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    String hash = rs.getString("password_hash");

                    // So sánh password (BCrypt)
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


    public List<User> getAll(int limit, int offset) throws SQLException {
        String sql = """
            SELECT user_id, username, full_name, email, phone,
                   password_hash, status, warehouse_id, created_by,
                   created_at, last_login_at, last_login_ip, is_deleted
            FROM user
            WHERE is_deleted = 0
            ORDER BY user_id DESC
            LIMIT ? OFFSET ?
        """;

        List<User> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = mapResultSetToUser(rs);
                    list.add(user);
                }
            }
        }
        return list;
    }

    public User getById(Long id) throws SQLException {
        String sql = """
            SELECT user_id, username, full_name, email, phone,
                   password_hash, status, warehouse_id, created_by,
                   created_at, last_login_at, last_login_ip, is_deleted
            FROM user
            WHERE user_id = ? AND is_deleted = 0
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    public boolean create(User user) throws SQLException {
        String sql = """
            INSERT INTO user (username, full_name, email, phone, password_hash,
                             status, warehouse_id, created_by, created_at, is_deleted)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), 0)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getPasswordHash());
            ps.setString(6, user.getStatus());
            ps.setObject(7, user.getWarehouseId());
            ps.setObject(8, user.getCreatedBy());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getLong(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean update(User user) throws SQLException {
        String sql = """
            UPDATE user
            SET full_name = ?, email = ?, phone = ?,
                status = ?, warehouse_id = ?
            WHERE user_id = ? AND is_deleted = 0
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getStatus());
            ps.setObject(5, user.getWarehouseId());
            ps.setLong(6, user.getUserId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Long id) throws SQLException {
        String sql = """
            UPDATE user
            SET is_deleted = 1
            WHERE user_id = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public long count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM user WHERE is_deleted = 0";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        return 0;
    }

    public boolean usernameExists(String username, Long excludeId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM user
            WHERE username = ? AND is_deleted = 0 AND (? IS NULL OR user_id != ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setObject(2, excludeId);
            ps.setObject(3, excludeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean emailExists(String email, Long excludeId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM user
            WHERE email = ? AND is_deleted = 0 AND (? IS NULL OR user_id != ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setObject(2, excludeId);
            ps.setObject(3, excludeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1) > 0;
                }
            }
        }
        return false;
    }

    public List<Long> getRolesByUserId(Long userId) throws SQLException {
        String sql = """
            SELECT role_id
            FROM user_role
            WHERE user_id = ?
        """;

        List<Long> roleIds = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roleIds.add(rs.getLong("role_id"));
                }
            }
        }
        return roleIds;
    }

    public boolean deleteUserRoles(Long userId) throws SQLException {
        String sql = "DELETE FROM user_role WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
            return true;
        }
    }

    public void setUserRoles(Long userId, List<Long> roleIds) throws SQLException {
        // 1. Delete existing roles
        deleteUserRoles(userId);

        // 2. Insert new roles
        if (roleIds != null && !roleIds.isEmpty()) {
            String sql = "INSERT INTO user_role (user_id, role_id, assigned_at) VALUES (?, ?, NOW())";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (Long roleId : roleIds) {
                    ps.setLong(1, userId);
                    ps.setLong(2, roleId);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
        }
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getLong("user_id"));
        user.setUsername(rs.getString("username"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setStatus(rs.getString("status"));

        Long warehouseId = rs.getObject("warehouse_id", Long.class);
        user.setWarehouseId(warehouseId);

        Long createdBy = rs.getObject("created_by", Long.class);
        user.setCreatedBy(createdBy);

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp lastLoginAt = rs.getTimestamp("last_login_at");
        if (lastLoginAt != null) {
            user.setLastLoginAt(lastLoginAt.toLocalDateTime());
        }

        user.setLastLoginIp(rs.getString("last_login_ip"));
        user.setIsDeleted(rs.getBoolean("is_deleted"));

        return user;
    }
    
    public User findByEmail(String email) throws SQLException {
        String sql = """
            SELECT user_id, username, full_name, email, phone,
                   password_hash, status, warehouse_id, created_by,
                   created_at, last_login_at, last_login_ip, is_deleted
            FROM user
            WHERE email = ?
              AND status = 'ACTIVE'
              AND is_deleted = 0
            LIMIT 1
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    /**
     * Tạo token reset password, lưu hash vào DB.
     * Return rawToken để tạo link gửi email / show dev.
     */
    public String createPasswordResetToken(Long userId) throws SQLException {
        // Step 1: token raw (URL-safe)
        String rawToken = generateTokenUrlSafe(32);

        // Step 2: hash token để lưu DB
        String tokenHash = sha256Hex(rawToken);

        // Step 3: hạn token
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + RESET_TOKEN_TTL.toMillis());

        // Step 4: insert token
        String sql = """
            INSERT INTO password_reset_token (user_id, token_hash, expires_at)
            VALUES (?, ?, ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setString(2, tokenHash);
            ps.setTimestamp(3, expiresAt);
            ps.executeUpdate();
        }

        return rawToken;
    }

    /**
     * Verify token raw:
     * - token_hash match
     * - used_at is null
     * - expires_at > now
     * => return user_id nếu hợp lệ
     */
    public Long verifyResetTokenAndGetUserId(String rawToken) throws SQLException {
        String tokenHash = sha256Hex(rawToken);

        String sql = """
            SELECT user_id
            FROM password_reset_token
            WHERE token_hash = ?
              AND used_at IS NULL
              AND expires_at > NOW()
            LIMIT 1
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tokenHash);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("user_id");
                }
            }
        }
        return null;
    }

    /**
     * Đổi password_hash cho user.
     * newHash phải là BCrypt hash (PasswordUtil.hashPassword(...) hoặc BCrypt.hashpw).
     */
    public boolean updatePasswordHash(Long userId, String newHash) throws SQLException {
        String sql = "UPDATE user SET password_hash = ? WHERE user_id = ? AND is_deleted = 0";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Mark token used.
     */
    public boolean markResetTokenUsed(String rawToken) throws SQLException {
        String tokenHash = sha256Hex(rawToken);

        String sql = """
            UPDATE password_reset_token
            SET used_at = NOW()
            WHERE token_hash = ?
              AND used_at IS NULL
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tokenHash);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Optional: update last login time/ip (để controller gọi sau login).
     */
    public boolean updateLastLogin(Long userId, String ip) throws SQLException {
        String sql = "UPDATE user SET last_login_at = NOW(), last_login_ip = ? WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ip);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // ===== Helpers for forgot password =====

    private String generateTokenUrlSafe(int numBytes) {
        byte[] bytes = new byte[numBytes];
        SECURE_RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private String sha256Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));

            StringBuilder sb = new StringBuilder(hash.length * 2);
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }
}
