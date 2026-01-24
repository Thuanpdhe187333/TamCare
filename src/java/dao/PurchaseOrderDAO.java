package dao;

import context.DBContext;
import dto.POLineCreateDTO;
import dto.PurchaseOrderDetailDTO;
import dto.PurchaseOrderListDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class PurchaseOrderDAO extends DBContext {
    Connection conn = DBContext.getConnection();
    public List<PurchaseOrderListDTO> getPurchaseOrderList(int limit, int offset) throws SQLException {
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

    public List<PurchaseOrderDetailDTO> getPurchaseOrderDetailLines(long poId) throws Exception {
        String sql = """
                         SELECT
                                  pl.po_line_id,
                                  p.product_id,
                                  p.name AS product_name,
                                  pv.variant_id,
                                  pv.variant_sku,
                                  pv.color,
                                  pv.size,
                                  pv.barcode,
                                  pv.status AS variant_status,
                                  pl.qty_ordered AS ordered_qty,
                                  pl.unit_price,
                                  (pl.qty_ordered * pl.unit_price) AS line_amount
                                FROM purchase_order_line pl
                                JOIN product_variant pv ON pv.variant_id = pl.variant_id
                                JOIN product p ON p.product_id = pv.product_id
                                WHERE pl.po_id = ?
                                ORDER BY pl.po_line_id
                        """;
        List<PurchaseOrderDetailDTO> lines = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, poId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PurchaseOrderDetailDTO dto = new PurchaseOrderDetailDTO();
                    dto.setPoLineId(rs.getLong("po_line_id"));
                    dto.setProductId(rs.getLong("product_id"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setVariantId(rs.getLong("variant_id"));
                    dto.setVariantSku(rs.getString("variant_sku"));
                    dto.setColor(rs.getString("color"));
                    dto.setSize(rs.getString("size"));
                    dto.setBarcode(rs.getString("barcode"));
                    dto.setVariantStatus(rs.getString("variant_status"));
                    dto.setOrderedQty(rs.getBigDecimal("ordered_qty"));
                    dto.setUnitPrice(rs.getBigDecimal("unit_price"));
                    dto.setLineAmount(rs.getBigDecimal("line_amount"));
                    lines.add(dto);
                }
            }
        }
        return lines;
    }
    
    public int countPurchaseOrders() throws Exception {
    String sql = "SELECT COUNT(*) FROM purchase_order";
    try (
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
    }
    return 0;
}
    
    public long createManualPO(
            String poNumber,
            long supplierId,
            java.sql.Date expectedDate,
            String note,
            long userId,
            List<POLineCreateDTO> lines
    ) throws Exception {

        String sqlPO = """
            INSERT INTO purchase_order
                (po_number, supplier_id, expected_delivery_date, status,
                 imported_by, imported_at, source_file_name, note)
              VALUES (?, ?, ?, 'CREATED', ?, NOW(), 'manual_create', ?)
        """;

        String sqlLine = """
            INSERT INTO purchase_order_line
              (po_id, variant_id, qty_ordered, unit_price, tax_rate, currency)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        try (Connection con = DBContext.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement psPO = con.prepareStatement(sqlPO, Statement.RETURN_GENERATED_KEYS)) {
                psPO.setString(1, poNumber);
                psPO.setLong(2, supplierId);
                if (expectedDate != null) psPO.setDate(3, expectedDate);
                else psPO.setNull(3, Types.DATE);
                psPO.setLong(4, userId);
                psPO.setString(5, note);

                psPO.executeUpdate();

                long poId;
                try (ResultSet rs = psPO.getGeneratedKeys()) {
                    if (!rs.next()) throw new SQLException("Cannot get generated po_id");
                    poId = rs.getLong(1);
                }

                try (PreparedStatement psLine = con.prepareStatement(sqlLine)) {
                    for (POLineCreateDTO l : lines) {
                        psLine.setLong(1, poId);
                        psLine.setLong(2, l.getVariantId());
                        psLine.setBigDecimal(3, l.getQty());

                        if (l.getUnitPrice() != null) psLine.setBigDecimal(4, l.getUnitPrice());
                        else psLine.setNull(4, Types.DECIMAL);

                        if (l.getTaxRate() != null) psLine.setBigDecimal(5, l.getTaxRate());
                        else psLine.setNull(5, Types.DECIMAL);

                        String currency = (l.getCurrency() == null || l.getCurrency().isBlank())
                                ? "VND"
                                : l.getCurrency().trim();
                        psLine.setString(6, currency);

                        psLine.addBatch();
                    }
                    psLine.executeBatch();
                }

                con.commit();
                return poId;

            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
    
    public boolean deletePurchaseOrder(long poId) throws SQLException {
    String deleteLinesSql = "DELETE FROM purchase_order_line WHERE po_id = ?";
    String deletePoSql    = "DELETE FROM purchase_order WHERE po_id = ?";

    boolean oldAutoCommit = conn.getAutoCommit();
    try {
        conn.setAutoCommit(false);

        // 1) Xóa lines trước để tránh FK constraint
        try (PreparedStatement ps = conn.prepareStatement(deleteLinesSql)) {
            ps.setLong(1, poId);
            ps.executeUpdate();
        }

        // 2) Xóa PO header
        int affected;
        try (PreparedStatement ps = conn.prepareStatement(deletePoSql)) {
            ps.setLong(1, poId);
            affected = ps.executeUpdate();
        }

        conn.commit();
        return affected > 0;
    } catch (SQLException e) {
        conn.rollback();
        throw e;
    } finally {
        conn.setAutoCommit(oldAutoCommit);
    }
}

}
