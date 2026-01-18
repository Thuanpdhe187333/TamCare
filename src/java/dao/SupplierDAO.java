package dao;

import context.DBContext;
import dto.SupplierDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO extends DBContext {

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
}
