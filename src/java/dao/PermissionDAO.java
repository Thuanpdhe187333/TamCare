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

    public List<Permission> getList(String search, String sort, Long page, Long size) throws SQLException {
        List<Permission> list = new ArrayList<>();

        String query = """
            SELECT * FROM permission
            WHERE (name LIKE ? OR code LIKE ?)
            ORDER BY
                CASE WHEN ? = 'name' THEN name END ASC,
                CASE WHEN ? = 'code' THEN code END ASC
            LIMIT ? OFFSET ?;
        """;

        PreparedStatement statement = CONNECTION.prepareStatement(query);
        var offset = (page - 1) * size;
        this.prepare(statement, search, search, sort, sort, size, offset);

        ResultSet result = statement.executeQuery();

        while (result.next()) {
            Permission permission = new Permission();
            permission.setPermissionId(result.getLong("permission_id"));
            permission.setCode(result.getString("code"));
            permission.setName(result.getString("name"));
            list.add(permission);
        }

        return list;
    }

    public Long getPageCount(String search) throws SQLException {

        String query = """
            SELECT COUNT(*) FROM permission
            WHERE (name LIKE ? OR code LIKE ?)
        """;

        PreparedStatement statement = CONNECTION.prepareStatement(query);
        this.prepare(statement, search, search);

        ResultSet result = statement.executeQuery();
        if (result.next()) {
            return result.getLong(1);
        }

        return Long.valueOf("0");
    }

    @Override
    public Permission getDetail(Long id) throws SQLException {
        String query = """
            SELECT *
            FROM permission
            WHERE permission_id = ?
        """;

        PreparedStatement statement = CONNECTION.prepareStatement(query);
        this.prepare(statement, id);

        ResultSet result = statement.executeQuery();
        if (result.next()) {
            Permission permission = new Permission();
            permission.setPermissionId(result.getLong("permission_id"));
            permission.setCode(result.getString("code"));
            permission.setName(result.getString("name"));
            return permission;
        }

        return null;
    }

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

    public boolean delete(Long id) throws SQLException {
        // 1. Delete associated role-permissions
        deleteRolePermissionsByPermissionId(id);

        // 2. Delete the permission itself
        String sql = """
            DELETE FROM permission
            WHERE permission_id = ?
        """;

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setLong(1, id);

            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteRolePermissionsByPermissionId(Long permissionId) throws SQLException {
        String sql = "DELETE FROM role_permission WHERE permission_id = ?";
        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setLong(1, permissionId);
            ps.executeUpdate();
            return true;
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

    public List<model.Role> getRolesByPermissionId(Long permissionId) throws SQLException {
        String sql = """
            SELECT r.*
            FROM role r
            JOIN role_permission rp ON r.role_id = rp.role_id
            WHERE rp.permission_id = ?
        """;

        List<model.Role> list = new ArrayList<>();
        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setLong(1, permissionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.Role r = new model.Role();
                    r.setRoleId(rs.getLong("role_id"));
                    r.setName(rs.getString("name"));
                    r.setDescription(rs.getString("description"));
                    list.add(r);
                }
            }
        }
        return list;
    }
    public void setPermissionRoles(Long permissionId, List<Long> roleIds) throws SQLException {
        // 1. Delete existing roles
        deleteRolePermissionsByPermissionId(permissionId);

        // 2. Insert new roles
        if (roleIds != null && !roleIds.isEmpty()) {
            String sql = "INSERT INTO role_permission (role_id, permission_id) VALUES (?, ?)";
            try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
                for (Long roleId : roleIds) {
                    ps.setLong(1, roleId);
                    ps.setLong(2, permissionId);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
        }
    }
}
