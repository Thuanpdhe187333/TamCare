package dao;

import context.DBContext;
import dto.SupplierDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Supplier;

public class SupplierDAO extends DBContext {

    private final Connection CONNECTION = DBContext.getConnection();

    public List<SupplierDTO> getActiveSuppliers() throws Exception {
        List<SupplierDTO> list = new ArrayList<>();

        String sql = """
                    SELECT supplier_id, code, name
                    FROM supplier
                    WHERE status = 'ACTIVE'
                    ORDER BY name
                """;

        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SupplierDTO s = new SupplierDTO();
                s.setSupplierId(rs.getLong("supplier_id"));
                s.setCode(rs.getString("code"));
                s.setName(rs.getString("name"));
                list.add(s);
            }
        }

        return list;
    }

    public List<Supplier> getList(String search, String sort, Long page, Long size) throws SQLException {
        List<Supplier> list = new ArrayList<>();

        String query = """
                    SELECT * FROM supplier
                    WHERE (name LIKE ? OR code LIKE ? OR email LIKE ? OR phone LIKE ?)
                    ORDER BY
                        CASE WHEN ? = 'name' THEN name END ASC,
                        CASE WHEN ? = 'code' THEN code END ASC,
                        supplier_id DESC
                    LIMIT ? OFFSET ?;
                """;

        PreparedStatement statement = CONNECTION.prepareStatement(query);
        var offset = (page - 1) * size;

        // Search parameters
        String searchPattern = "%" + search + "%"; // Assumes search is passed raw, if passed as %search% then just use
                                                   // search
        // Check how PermissionDAO handles it.
        // In PermissionDAO: var search = searchRaw == null ? "%%" : "%" + searchRaw +
        // "%";
        // Here I will assume the caller passes the formatted pattern or handle it
        // inside controller.
        // Let's stick to receiving prepared pattern for consistency with PermissionDAO
        // usage in Controller.

        statement.setString(1, search);
        statement.setString(2, search);
        statement.setString(3, search);
        statement.setString(4, search);

        statement.setString(5, sort);
        statement.setString(6, sort);

        statement.setLong(7, size);
        statement.setLong(8, offset);

        ResultSet result = statement.executeQuery();

        while (result.next()) {
            list.add(mapResultSetToSupplier(result));
        }

        return list;
    }

    public Long getPageCount(String search) throws SQLException {
        String query = """
                    SELECT COUNT(*) FROM supplier
                    WHERE (name LIKE ? OR code LIKE ? OR email LIKE ? OR phone LIKE ?)
                """;

        PreparedStatement statement = CONNECTION.prepareStatement(query);
        statement.setString(1, search);
        statement.setString(2, search);
        statement.setString(3, search);
        statement.setString(4, search);

        ResultSet result = statement.executeQuery();
        if (result.next()) {
            return result.getLong(1);
        }

        return 0L;
    }

    public Supplier getDetail(Long id) throws SQLException {
        String query = "SELECT * FROM supplier WHERE supplier_id = ?";
        try (PreparedStatement statement = CONNECTION.prepareStatement(query)) {
            statement.setLong(1, id);
            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return mapResultSetToSupplier(result);
                }
            }
        }
        return null;
    }

    public boolean create(Supplier supplier) throws SQLException {
        String sql = """
                    INSERT INTO supplier (code, name, email, phone, address, status)
                    VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, supplier.getCode());
            ps.setString(2, supplier.getName());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getAddress());
            ps.setString(6, supplier.getStatus() == null ? "ACTIVE" : supplier.getStatus());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        supplier.setSupplierId(rs.getLong(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean update(Supplier supplier) throws SQLException {
        String sql = """
                    UPDATE supplier
                    SET code = ?, name = ?, email = ?, phone = ?, address = ?, status = ?
                    WHERE supplier_id = ?
                """;

        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setString(1, supplier.getCode());
            ps.setString(2, supplier.getName());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getAddress());
            ps.setString(6, supplier.getStatus());
            ps.setLong(7, supplier.getSupplierId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Long id) throws SQLException {
        // Soft delete is usually preferred, but following PermissionDAO pattern which
        // uses DELETE
        // Note: Check foreign keys constraints (e.g. Purchase Orders). If constraint
        // exists, should catch exception or soft delete.
        // For now, mirroring standard CRUD.
        String sql = "DELETE FROM supplier WHERE supplier_id = ?";
        try (PreparedStatement ps = CONNECTION.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean codeExists(String code, Long excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM supplier WHERE code = ? AND (? IS NULL OR supplier_id != ?)";
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

    private Supplier mapResultSetToSupplier(ResultSet rs) throws SQLException {
        Supplier s = new Supplier();
        s.setSupplierId(rs.getLong("supplier_id"));
        s.setCode(rs.getString("code"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        s.setAddress(rs.getString("address"));
        s.setStatus(rs.getString("status"));
        return s;
    }
}
