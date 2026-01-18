package dao;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Permission;

public class PermissionDAO extends DBContext implements Dao<Permission> {

    private final Connection CONNECTION = DBContext.getConnection();

    @Override
    public List<Permission> getAll() throws SQLException {
        String sql = """
            SELECT permission_id, code, name
            FROM permission
            ORDER BY permission_id ASC
        """;

        List<Permission> list = new ArrayList<>();
        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Permission permission = new Permission();
                    permission.setPermissionId(rs.getLong("permission_id"));
                    permission.setCode(rs.getString("code"));
                    permission.setName(rs.getString("name"));
                    list.add(permission);
                }
            }
        }
        return list;
    }

    @Override
    public Permission getById(Long id) throws SQLException {
        String sql = """
            SELECT permission_id, code, name
            FROM permission
            WHERE permission_id = ?
        """;

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setLong(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Permission permission = new Permission();
                    permission.setPermissionId(rs.getLong("permission_id"));
                    permission.setCode(rs.getString("code"));
                    permission.setName(rs.getString("name"));
                    return permission;
                }
            }
        }
        return null;
    }

    @Override
    public boolean create(Permission permission) throws SQLException {
        String sql = """
            INSERT INTO permission (code, name)
            VALUES (?, ?)
        """;

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, permission.getCode());
            ps.setString(2, permission.getName());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        permission.setPermissionId(rs.getLong(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean update(Permission permission) throws SQLException {
        String sql = """
            UPDATE permission
            SET code = ?, name = ?
            WHERE permission_id = ?
        """;

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setString(1, permission.getCode());
            ps.setString(2, permission.getName());
            ps.setLong(3, permission.getPermissionId());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(Long id) throws SQLException {
        String sql = """
            DELETE FROM permission
            WHERE permission_id = ?
        """;

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setLong(1, id);

            return ps.executeUpdate() > 0;
        }
    }

    public long count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM permission";

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        return 0;
    }

    public boolean codeExists(String code, Long excludeId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM permission 
            WHERE code = ? AND (? IS NULL OR permission_id != ?)
        """;

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setString(1, code);
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
}
