package dao;

import context.DBContext;
import dto.PurchaseOrderListDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PurchaseOrderDAO extends DBContext {
        Connection conn = DBContext.getConnection();

    public List<PurchaseOrderListDTO> getPurchaseList(int limit, int offset) throws SQLException {
        String sql = """
            SELECT
              po.po_id,              
              po.po_number,
              po.supplier_id,
              s.name AS supplier_name,
              po.expected_delivery_date,
              po.status,
              po.imported_by,
              u.full_name AS imported_by_username,
              po.imported_at
            FROM purchase_order po
            LEFT JOIN supplier s ON s.supplier_id = po.supplier_id
            LEFT JOIN user u ON u.user_id = po.imported_by
            ORDER BY po.po_id DESC
            LIMIT ? OFFSET ?
        """;

        List<PurchaseOrderListDTO> list = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PurchaseOrderListDTO dto = new PurchaseOrderListDTO();

                    dto.setPoId(rs.getLong("po_id"));
                    dto.setPoNumber(rs.getString("po_number"));

                    // supplier
                    dto.setSupplierId(rs.getObject("supplier_id") != null ? rs.getLong("supplier_id") : null);
                    dto.setSupplierName(rs.getString("supplier_name"));

                    // dates
                    Date d = rs.getDate("expected_delivery_date");
                    dto.setExpectedDeliveryDate(d != null ? d.toLocalDate() : null);

                    dto.setStatus(rs.getString("status"));

                    // imported by
                    dto.setImportedBy(rs.getObject("imported_by") != null ? rs.getLong("imported_by") : null);
                    dto.setImportedByUsername(rs.getString("imported_by_username"));

                    Timestamp ts = rs.getTimestamp("imported_at");
                    dto.setImportedAt(ts != null ? ts.toLocalDateTime() : null);

                    list.add(dto);
                }
            }
        }
        return list;
    }
}
