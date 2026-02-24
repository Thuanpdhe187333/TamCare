package dao;

import context.DBContext;
import dto.SOLineCreateDTO;
import dto.SaleOrderHeaderDTO;
import dto.SaleOrderLineDTO;
import dto.SaleOrderListDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SaleOrderDAO extends DBContext {

    Connection conn = DBContext.getConnection();

    public List<SaleOrderListDTO> searchSalesOrders(
            String keyword,
            String status,
            Date shipFrom,
            Date shipTo,
            int limit,
            int offset) throws Exception {

        StringBuilder sql = new StringBuilder("""
            SELECT
                so.so_id,
                so.so_number,
                c.name AS customer_name,
                so.requested_ship_date,
                so.ship_to_address,
                so.status,
                u.username AS imported_by
            FROM sales_order so
            JOIN customer c ON so.customer_id = c.customer_id
            LEFT JOIN user u ON so.imported_by = u.user_id
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();

        // 🔎 Keyword search
        if (keyword != null) {
            keyword = keyword.trim();
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (so.so_number LIKE ? OR c.name LIKE ?) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        // 📌 Status filter
        if (status != null) {
            status = status.trim();
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND so.status = ? ");
            params.add(status);
        }

        // 📅 Date filter
        if (shipFrom != null) {
            sql.append(" AND so.requested_ship_date >= ? ");
            params.add(shipFrom);
        }

        if (shipTo != null) {
            sql.append(" AND so.requested_ship_date <= ? ");
            params.add(shipTo);
        }

        sql.append(" ORDER BY so.so_id DESC LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        List<SaleOrderListDTO> list = new ArrayList<>();

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SaleOrderListDTO dto = new SaleOrderListDTO();
                    dto.setSoId(rs.getLong("so_id"));
                    dto.setSoNumber(rs.getString("so_number"));
                    dto.setCustomerName(rs.getString("customer_name"));

                    Date sqlDate = rs.getDate("requested_ship_date");
                    dto.setRequestedShipDate(
                            sqlDate != null ? sqlDate.toLocalDate() : null);

                    dto.setShipToAddress(rs.getString("ship_to_address"));
                    dto.setStatus(rs.getString("status"));
                    dto.setImportedByUsername(rs.getString("imported_by"));

                    list.add(dto);
                }
            }
        }

        return list;
    }

    public int countSalesOrders(
            String keyword,
            String status,
            Date shipFrom,
            Date shipTo) throws Exception {

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM sales_order so
            JOIN customer c ON so.customer_id = c.customer_id
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            keyword = keyword.trim();
            sql.append(" AND (so.so_number LIKE ? OR c.name LIKE ?) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        if (status != null && !status.isBlank()) {
            sql.append(" AND so.status = ? ");
            params.add(status.trim());
        }

        if (shipFrom != null) {
            sql.append(" AND so.requested_ship_date >= ? ");
            params.add(shipFrom);
        }

        if (shipTo != null) {
            sql.append(" AND so.requested_ship_date <= ? ");
            params.add(shipTo);
        }

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /**
     * Get SO by SO number (for GDN creation)
     */
    public SaleOrderHeaderDTO getSaleOrderByNumber(String soNumber) throws Exception {
        String sql = """
            SELECT
                so.so_id AS soId,
                so.so_number AS soNumber,
                so.customer_id AS customerId,
                c.code AS customerCode,
                c.name AS customerName,
                c.email AS customerEmail,
                c.address AS customerAddress,
                c.phone AS customerPhone,
                so.ship_to_address AS shipToAddress,
                so.requested_ship_date AS requestedShipDate,
                so.status AS status,
                so.imported_by AS importedBy,
                u.username AS importedByUsername,
                so.imported_at AS importedAt
            FROM sales_order so
            JOIN customer c ON c.customer_id = so.customer_id
            LEFT JOIN user u ON u.user_id = so.imported_by
            WHERE so.so_number = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, soNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SaleOrderHeaderDTO dto = new SaleOrderHeaderDTO();
                    dto.setSoId(rs.getLong("soId"));
                    dto.setSoNumber(rs.getString("soNumber"));
                    dto.setCustomerId(rs.getLong("customerId"));
                    dto.setCustomerCode(rs.getString("customerCode"));
                    dto.setCustomerName(rs.getString("customerName"));
                    dto.setCustomerEmail(rs.getString("customerEmail"));
                    dto.setCustomerAddress(rs.getString("customerAddress"));
                    dto.setCustomerPhone(rs.getString("customerPhone"));
                    dto.setShipToAddress(rs.getString("shipToAddress"));
                    Date shipDate = rs.getDate("requestedShipDate");
                    dto.setRequestedShipDate(shipDate != null ? shipDate.toLocalDate() : null);
                    dto.setStatus(rs.getString("status"));
                    long importedBy = rs.getLong("importedBy");
                    dto.setImportedBy(rs.wasNull() ? null : importedBy);
                    dto.setImportedByUsername(rs.getString("importedByUsername"));
                    Timestamp importedAt = rs.getTimestamp("importedAt");
                    dto.setImportedAt(importedAt != null ? importedAt.toLocalDateTime() : null);
                    return dto;
                }
            }
        }
        return null;
    }

    public SaleOrderHeaderDTO getSaleOrderHeader(long soId) throws Exception {
        String sql = """
            SELECT
                so.so_id AS soId,
                so.so_number AS soNumber,

                so.customer_id AS customerId,
                c.code AS customerCode,
                c.name AS customerName,
                c.email AS customerEmail,
                c.address AS customerAddress,
                c.phone AS customerPhone,

                so.ship_to_address AS shipToAddress,
                so.requested_ship_date AS requestedShipDate,
                so.status AS status,

                so.imported_by AS importedBy,
                u.username AS importedByUsername,
                so.imported_at AS importedAt
            FROM sales_order so
            JOIN customer c ON c.customer_id = so.customer_id
            LEFT JOIN user u ON u.user_id = so.imported_by
            WHERE so.so_id = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, soId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SaleOrderHeaderDTO dto = new SaleOrderHeaderDTO();
                    dto.setSoId(rs.getLong("soId"));
                    dto.setSoNumber(rs.getString("soNumber"));

                    dto.setCustomerId(rs.getLong("customerId"));
                    dto.setCustomerCode(rs.getString("customerCode"));
                    dto.setCustomerName(rs.getString("customerName"));
                    dto.setCustomerEmail(rs.getString("customerEmail"));
                    dto.setCustomerAddress(rs.getString("customerAddress"));
                    dto.setCustomerPhone(rs.getString("customerPhone"));

                    dto.setShipToAddress(rs.getString("shipToAddress"));

                    Date shipDate = rs.getDate("requestedShipDate");
                    dto.setRequestedShipDate(shipDate != null ? shipDate.toLocalDate() : null);

                    dto.setStatus(rs.getString("status"));

                    long importedBy = rs.getLong("importedBy");
                    dto.setImportedBy(rs.wasNull() ? null : importedBy);

                    dto.setImportedByUsername(rs.getString("importedByUsername"));

                    Timestamp importedAt = rs.getTimestamp("importedAt");
                    dto.setImportedAt(importedAt != null ? importedAt.toLocalDateTime() : null);

                    return dto;
                }
            }
        }
        return null; // hoặc throw "SO not found"
    }

    public List<SaleOrderLineDTO> getSaleOrderDetailLines(long soId) throws Exception {
        String sql = """
            SELECT
                sol.so_line_id,
                sol.so_id,
                p.product_id,
                p.sku AS product_sku,
                p.name AS product_name,
                pv.variant_id,
                pv.variant_sku,
                pv.color,
                pv.size,
                pv.barcode,
                sol.qty_ordered AS ordered_qty,
                sol.unit_price,
                sol.discount
            FROM sales_order_line sol
            JOIN product_variant pv ON pv.variant_id = sol.variant_id
            JOIN product p ON p.product_id = pv.product_id
            WHERE sol.so_id = ?
            ORDER BY sol.so_line_id
        """;

        List<SaleOrderLineDTO> lines = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, soId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SaleOrderLineDTO dto = new SaleOrderLineDTO();

                    dto.setSoLineId(rs.getLong("so_line_id"));
                    dto.setSoId(rs.getLong("so_id"));

                    dto.setProductId(rs.getLong("product_id"));
                    dto.setProductSku(rs.getString("product_sku"));
                    dto.setProductName(rs.getString("product_name"));

                    dto.setVariantId(rs.getLong("variant_id"));
                    dto.setVariantSku(rs.getString("variant_sku"));
                    dto.setColor(rs.getString("color"));
                    dto.setSize(rs.getString("size"));
                    dto.setBarcode(rs.getString("barcode"));

                    dto.setOrderedQty(rs.getBigDecimal("ordered_qty"));
                    dto.setUnitPrice(rs.getBigDecimal("unit_price"));
                    dto.setDiscount(rs.getBigDecimal("discount"));

                    lines.add(dto);
                }
            }
        }

        return lines;
    }

    public long createManualSO(
            String soNumber,
            long customerId,
            Date requestedShipDate,
            String shipToAddress,
            long userId,
            List<SOLineCreateDTO> lines) throws Exception {

        String sqlSO = """
        INSERT INTO sales_order
            (so_number, customer_id, requested_ship_date,
             ship_to_address, status, imported_by, imported_at, note)
        VALUES (?, ?, ?, ?, 'CREATED', ?, NOW(), ?)
    """;

        String sqlLine = """
        INSERT INTO sales_order_line
            (so_id, variant_id, qty_ordered, unit_price, discount)
        VALUES (?, ?, ?, ?, ?)
    """;

        try (Connection con = DBContext.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement psSO = con.prepareStatement(sqlSO, Statement.RETURN_GENERATED_KEYS)) {

                psSO.setString(1, soNumber);
                psSO.setLong(2, customerId);

                if (requestedShipDate != null) {
                    psSO.setDate(3, requestedShipDate);
                } else {
                    psSO.setNull(3, Types.DATE);
                }

                if (shipToAddress != null && !shipToAddress.isBlank()) {
                    psSO.setString(4, shipToAddress.trim());
                } else {
                    psSO.setNull(4, Types.VARCHAR);
                }

                psSO.setLong(5, userId);
                
                // Parameter 6 for note (can be null)
                psSO.setNull(6, Types.VARCHAR);

                psSO.executeUpdate();

                long soId;
                try (ResultSet rs = psSO.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new SQLException("Cannot get generated so_id");
                    }
                    soId = rs.getLong(1);
                }

                // Insert lines
                try (PreparedStatement psLine = con.prepareStatement(sqlLine)) {
                    for (SOLineCreateDTO l : lines) {

                        psLine.setLong(1, soId);
                        psLine.setLong(2, l.getVariantId());
                        psLine.setBigDecimal(3, l.getQty());

                        if (l.getUnitPrice() != null) {
                            psLine.setBigDecimal(4, l.getUnitPrice());
                        } else {
                            psLine.setNull(4, Types.DECIMAL);
                        }

                        if (l.getDiscount() != null) {
                            psLine.setBigDecimal(5, l.getDiscount());
                        } else {
                            psLine.setNull(5, Types.DECIMAL);
                        }

                        psLine.addBatch();
                    }
                    psLine.executeBatch();
                }

                con.commit();
                return soId;

            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public void updateSalesOrder(SaleOrderHeaderDTO header,
            List<SaleOrderLineDTO> lines) throws Exception {

        if (lines == null || lines.isEmpty()) {
            throw new IllegalArgumentException("SO must have at least 1 line");
        }

        boolean oldAutoCommit = conn.getAutoCommit();
        try {
            conn.setAutoCommit(false);

            // 1. Check status + lock row
            String status = getSoStatusForUpdate(header.getSoId());
            if (!"CREATED".equalsIgnoreCase(status)) {
                throw new IllegalArgumentException(
                        "SO cannot be updated when status = " + status);
            }

            // 2. Update header
            updateSoHeader(header);

            // 3. Delete old lines
            deleteSoLinesBySoId(header.getSoId());

            // 4. Insert new lines
            insertSoLines(header.getSoId(), lines);

            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(oldAutoCommit);
        }
    }

    private String getSoStatusForUpdate(long soId) throws Exception {
        String sql = "SELECT status FROM sales_order WHERE so_id=? FOR UPDATE";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, soId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalArgumentException("SO not found: " + soId);
                }
                return rs.getString("status");
            }
        }
    }

private void updateSoHeader(SaleOrderHeaderDTO h) throws Exception {
    String sql = """
        UPDATE sales_order
        SET so_number = ?,
            customer_id = ?,
            requested_ship_date = ?,
            ship_to_address = ?
        WHERE so_id = ?
        """;

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, h.getSoNumber());
        ps.setLong(2, h.getCustomerId());
        ps.setDate(3, Date.valueOf(h.getRequestedShipDate()));
        ps.setString(4, h.getShipToAddress());
        ps.setLong(5, h.getSoId());

        ps.executeUpdate();
    }
}

    private void deleteSoLinesBySoId(long soId) throws Exception {
        String sql = "DELETE FROM sales_order_line WHERE so_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, soId);
            ps.executeUpdate();
        }
    }

    private void insertSoLines(long soId, List<SaleOrderLineDTO> lines) throws Exception {
        String sql = """
            INSERT INTO sales_order_line
            (so_id, variant_id, qty_ordered, unit_price, discount)
            VALUES (?,?,?,?,?)
            """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (SaleOrderLineDTO l : lines) {
                ps.setLong(1, soId);
                ps.setLong(2, l.getVariantId());
                ps.setBigDecimal(3, l.getOrderedQty());
                ps.setBigDecimal(4, l.getUnitPrice());

                // discount nullable
                if (l.getDiscount() != null) {
                    ps.setBigDecimal(5, l.getDiscount());
                } else {
                    ps.setNull(5, java.sql.Types.DECIMAL);
                }

                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
}
