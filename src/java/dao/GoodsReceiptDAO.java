package dao;

import context.DBContext;
import model.GoodsReceipt;
import model.GoodsReceiptLine;
import dto.ProductVariantDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GoodsReceiptDAO extends DBContext {

    public List<dto.GoodsReceiptListDTO> getFilteredGRNs(String grnNumber, Long supplierId, String status,
            String sortField,
            String sortOrder, int limit, int offset) throws SQLException {
        Connection conn = getConnection();
        StringBuilder sql = new StringBuilder("""
                    SELECT gr.grn_id, gr.grn_number, gr.status, gr.created_at, gr.delivered_by,
                           s.name as supplier_name, u.full_name as creator_name
                    FROM goods_receipt gr
                    JOIN purchase_order po ON gr.po_id = po.po_id
                    JOIN supplier s ON po.supplier_id = s.supplier_id
                    JOIN user u ON gr.created_by = u.user_id
                    WHERE 1=1
                """);

        if (grnNumber != null && !grnNumber.isBlank()) {
            sql.append(" AND gr.grn_number LIKE ?");
        }
        if (supplierId != null) {
            sql.append(" AND po.supplier_id = ?");
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND gr.status = ?");
        }

        // Validate sortField and sortOrder to prevent SQL injection
        String validSortField = "gr.grn_id";
        if ("grn_number".equals(sortField)) {
            validSortField = "gr.grn_number";
        } else if ("supplier_name".equals(sortField)) {
            validSortField = "s.name";
        } else if ("status".equals(sortField)) {
            validSortField = "gr.status";
        } else if ("grn_id".equals(sortField)) {
            validSortField = "gr.grn_id";
        }

        String validSortOrder = "DESC";
        if ("ASC".equalsIgnoreCase(sortOrder)) {
            validSortOrder = "ASC";
        }

        sql.append(" ORDER BY ").append(validSortField).append(" ").append(validSortOrder);
        sql.append(" LIMIT ? OFFSET ?");

        List<dto.GoodsReceiptListDTO> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (grnNumber != null && !grnNumber.isBlank()) {
                ps.setString(paramIdx++, "%" + grnNumber + "%");
            }
            if (supplierId != null) {
                ps.setLong(paramIdx++, supplierId);
            }
            if (status != null && !status.isBlank()) {
                ps.setString(paramIdx++, status);
            }
            ps.setInt(paramIdx++, limit);
            ps.setInt(paramIdx++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    dto.GoodsReceiptListDTO item = new dto.GoodsReceiptListDTO();
                    item.setGrnId(rs.getLong("grn_id"));
                    item.setGrnNumber(rs.getString("grn_number"));
                    item.setSupplierName(rs.getString("supplier_name"));
                    item.setStatus(rs.getString("status"));
                    item.setCreatorName(rs.getString("creator_name"));
                    item.setDeliveredBy(rs.getString("delivered_by"));
                    Timestamp createdAtTs = rs.getTimestamp("created_at");
                    if (createdAtTs != null) {
                        item.setCreatedAt(createdAtTs.toLocalDateTime());
                    }
                    list.add(item);
                }
            }
        }
        return list;
    }

    public int countFilteredGRNs(String grnNumber, Long supplierId, String status) throws SQLException {
        Connection conn = getConnection();
        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(*)
                    FROM goods_receipt gr
                    JOIN purchase_order po ON gr.po_id = po.po_id
                    WHERE 1=1
                """);

        if (grnNumber != null && !grnNumber.isBlank()) {
            sql.append(" AND gr.grn_number LIKE ?");
        }
        if (supplierId != null) {
            sql.append(" AND po.supplier_id = ?");
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND gr.status = ?");
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (grnNumber != null && !grnNumber.isBlank()) {
                ps.setString(paramIdx++, "%" + grnNumber + "%");
            }
            if (supplierId != null) {
                ps.setLong(paramIdx++, supplierId);
            }
            if (status != null && !status.isBlank()) {
                ps.setString(paramIdx++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public long createGRN(GoodsReceipt grn, List<GoodsReceiptLine> lines) throws SQLException {
        Connection conn = getConnection();
        String sqlGR = """
                    INSERT INTO goods_receipt (grn_number, po_id, warehouse_id, status, created_by, created_at, delivered_by, note)
                    VALUES (?, ?, ?, 'PENDING', ?, NOW(), ?, ?)
                """;
        String sqlLine = """
                    INSERT INTO goods_receipt_line (grn_id, po_line_id, variant_id, qty_expected, qty_received, qty_good, qty_missing, qty_damaged, qty_extra, note)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try {
            conn.setAutoCommit(false);
            long grnId;
            try (PreparedStatement ps = conn.prepareStatement(sqlGR, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, grn.getGrnNumber());
                ps.setLong(2, grn.getPoId());
                ps.setLong(3, grn.getWarehouseId());
                ps.setLong(4, grn.getCreatedBy());
                ps.setString(5, grn.getDeliveredBy());
                ps.setString(6, grn.getNote());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        grnId = rs.getLong(1);
                    } else {
                        throw new SQLException("Creating GRN failed, no ID obtained.");
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlLine)) {
                for (GoodsReceiptLine line : lines) {
                    ps.setLong(1, grnId);
                    ps.setObject(2, line.getPoLineId());
                    ps.setLong(3, line.getVariantId());
                    ps.setBigDecimal(4, line.getQtyExpected());
                    ps.setBigDecimal(5, line.getQtyReceived());
                    ps.setBigDecimal(6, line.getQtyGood());
                    ps.setBigDecimal(7, line.getQtyMissing());
                    ps.setBigDecimal(8, line.getQtyDamaged());
                    ps.setBigDecimal(9, line.getQtyExtra());
                    ps.setString(10, line.getNote());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
            return grnId;
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    public GoodsReceipt getById(Long id) throws SQLException {
        Connection conn = getConnection();
        String sql = "SELECT * FROM goods_receipt WHERE grn_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToGR(rs);
                }
            }
        }
        return null;
    }

    public List<GoodsReceiptLine> getLinesByGrnId(Long grnId) throws SQLException {
        Connection conn = getConnection();
        String sql = "SELECT * FROM goods_receipt_line WHERE grn_id = ?";
        List<GoodsReceiptLine> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, grnId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLine(rs));
                }
            }
        }
        return list;
    }

    public boolean updateStatus(Long grnId, String status, Long userId) throws SQLException {
        Connection conn = getConnection();
        String sql = "UPDATE goods_receipt SET status = ?, approved_by = ?, approved_at = NOW() WHERE grn_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, userId);
            ps.setLong(3, grnId);
            return ps.executeUpdate() > 0;
        }
    }

    private GoodsReceipt mapResultSetToGR(ResultSet rs) throws SQLException {
        GoodsReceipt gr = new GoodsReceipt();
        gr.setGrnId(rs.getLong("grn_id"));
        gr.setGrnNumber(rs.getString("grn_number"));
        gr.setPoId(rs.getLong("po_id"));
        gr.setWarehouseId(rs.getLong("warehouse_id"));
        gr.setStatus(rs.getString("status"));
        gr.setCreatedBy(rs.getLong("created_by"));
        gr.setApprovedBy(rs.getObject("approved_by") != null ? rs.getLong("approved_by") : null);
        gr.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        Timestamp ts = rs.getTimestamp("approved_at");
        if (ts != null) {
            gr.setApprovedAt(ts.toLocalDateTime());
        }
        gr.setDeliveredBy(rs.getString("delivered_by"));
        Timestamp rsTs = rs.getTimestamp("received_at");
        if (rsTs != null) {
            gr.setReceivedAt(rsTs.toLocalDateTime());
        }
        gr.setNote(rs.getString("note"));
        return gr;
    }

    private GoodsReceiptLine mapResultSetToLine(ResultSet rs) throws SQLException {
        GoodsReceiptLine l = new GoodsReceiptLine();
        l.setGrnLineId(rs.getLong("grn_line_id"));
        l.setGrnId(rs.getLong("grn_id"));
        l.setPoLineId(rs.getObject("po_line_id") != null ? rs.getLong("po_line_id") : null);
        l.setVariantId(rs.getLong("variant_id"));
        l.setQtyExpected(rs.getBigDecimal("qty_expected"));
        l.setQtyReceived(rs.getBigDecimal("qty_received"));
        l.setQtyGood(rs.getBigDecimal("qty_good"));
        l.setQtyMissing(rs.getBigDecimal("qty_missing"));
        l.setQtyDamaged(rs.getBigDecimal("qty_damaged"));
        l.setQtyExtra(rs.getBigDecimal("qty_extra"));
        l.setNote(rs.getString("note"));
        return l;
    }

    public List<ProductVariantDTO> getActiveVariants() throws Exception {
        List<ProductVariantDTO> list = new ArrayList<>();

        String sql = """
                    SELECT
                        pv.variant_id,
                        pv.variant_sku,
                        p.sku AS product_sku,
                        p.name AS product_name
                    FROM product_variant pv
                    JOIN product p ON p.product_id = pv.product_id
                    WHERE pv.status = 'ACTIVE'
                    ORDER BY pv.variant_id
                """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductVariantDTO v = new ProductVariantDTO();
                v.setVariantId(rs.getLong("variant_id"));
                v.setVariantSku(rs.getString("variant_sku"));
                v.setProductSku(rs.getString("product_sku"));
                v.setProductName(rs.getString("product_name"));
                list.add(v);
            }
        }
        return list;
    }
}
