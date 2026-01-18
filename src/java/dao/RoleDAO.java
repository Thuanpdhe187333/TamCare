package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import context.DBContext;
import model.Role;

public class RoleDAO extends DBContext {
    
    private Connection conn = DBContext.getConnection();
    
    public List<Role> getAll(int limit, int offset) throws SQLException {
        String sql = """
            SELECT role_id, name, description 
            FROM role 
            ORDER BY role_id DESC 
            LIMIT ? OFFSET ?
        """;
        
        List<Role> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Role role = new Role();
                    role.setRoleId(rs.getLong("role_id"));
                    role.setName(rs.getString("name"));
                    role.setDescription(rs.getString("description"));
                    list.add(role);
                }
            }
        }
        return list;
    }
    
    public Role getById(Long id) throws SQLException {
        String sql = """
            SELECT role_id, name, description 
            FROM role 
            WHERE role_id = ?
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Role role = new Role();
                    role.setRoleId(rs.getLong("role_id"));
                    role.setName(rs.getString("name"));
                    role.setDescription(rs.getString("description"));
                    return role;
                }
            }
        }
        return null;
    }
    
    public boolean create(Role role) throws SQLException {
        String sql = """
            INSERT INTO role (name, description) 
            VALUES (?, ?)
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, role.getName());
            ps.setString(2, role.getDescription());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        role.setRoleId(rs.getLong(1));
                    }
                }
                return true;
            }
        }
        return false;
    }
    
    public boolean update(Role role) throws SQLException {
        String sql = """
            UPDATE role 
            SET name = ?, description = ? 
            WHERE role_id = ?
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.getName());
            ps.setString(2, role.getDescription());
            ps.setLong(3, role.getRoleId());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean delete(Long id) throws SQLException {
        String sql = """
            DELETE FROM role 
            WHERE role_id = ?
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    public long count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM role";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        return 0;
    }
    
    public boolean nameExists(String name, Long excludeId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM role 
            WHERE name = ? AND (? IS NULL OR role_id != ?)
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
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
    
    public List<Long> getPermissionsByRoleId(Long roleId) throws SQLException {
        String sql = """
            SELECT permission_id 
            FROM role_permission 
            WHERE role_id = ?
        """;
        
        List<Long> permissionIds = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, roleId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    permissionIds.add(rs.getLong("permission_id"));
                }
            }
        }
        return permissionIds;
    }
    
    public boolean deleteRolePermissions(Long roleId) throws SQLException {
        String sql = """
            DELETE FROM role_permission 
            WHERE role_id = ?
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, roleId);
            ps.executeUpdate();
            return true;
        }
    }
    
    public void setRolePermissions(Long roleId, List<Long> permissionIds) throws SQLException {
        // 1. Delete existing permissions
        deleteRolePermissions(roleId);
        
        // 2. Insert new permissions
        if (permissionIds != null && !permissionIds.isEmpty()) {
            String sql = "INSERT INTO role_permission (role_id, permission_id) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (Long permissionId : permissionIds) {
                    ps.setLong(1, roleId);
                    ps.setLong(2, permissionId);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
        }
    }
}
