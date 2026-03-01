package dao;

import context.DBContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class InventorySummaryDAO extends DBContext {

    /**
     * Updates or inserts an inventory summary record.
     * SQL for table creation:
     * CREATE TABLE inventory_summary (
     * inv_summary_id BIGINT PRIMARY KEY AUTO_INCREMENT,
     * warehouse_id BIGINT NOT NULL,
     * variant_id BIGINT NOT NULL,
     * `condition` VARCHAR(50) NOT NULL,
     * qty_on_hand DECIMAL(18, 2) DEFAULT 0,
     * qty_reserved DECIMAL(18, 2) DEFAULT 0,
     * qty_available DECIMAL(18, 2) DEFAULT 0,
     * updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
     * UNIQUE KEY (warehouse_id, variant_id, `condition`)
     * );
     */
    public void updateSummary(Long warehouseId, Long variantId, String condition, BigDecimal qty) throws Exception {
        String sqlCheck = "SELECT inv_summary_id FROM inventory_summary WHERE warehouse_id = ? AND variant_id = ? AND `condition` = ?";
        String sqlInsert = "INSERT INTO inventory_summary (warehouse_id, variant_id, `condition`, qty_on_hand, qty_reserved, qty_available) VALUES (?, ?, ?, ?, 0, ?)";
        String sqlUpdate = "UPDATE inventory_summary SET qty_on_hand = qty_on_hand + ?, qty_available = qty_available + ?, updated_at = NOW() WHERE warehouse_id = ? AND variant_id = ? AND `condition` = ?";

        try (Connection con = DBContext.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement psCheck = con.prepareStatement(sqlCheck)) {
                psCheck.setLong(1, warehouseId);
                psCheck.setLong(2, variantId);
                psCheck.setString(3, condition);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                            psUpdate.setBigDecimal(1, qty);
                            psUpdate.setBigDecimal(2, qty);
                            psUpdate.setLong(3, warehouseId);
                            psUpdate.setLong(4, variantId);
                            psUpdate.setString(5, condition);
                            psUpdate.executeUpdate();
                        }
                    } else {
                        try (PreparedStatement psInsert = con.prepareStatement(sqlInsert)) {
                            psInsert.setLong(1, warehouseId);
                            psInsert.setLong(2, variantId);
                            psInsert.setString(3, condition);
                            psInsert.setBigDecimal(4, qty);
                            psInsert.setBigDecimal(5, qty);
                            psInsert.executeUpdate();
                        }
                    }
                }
            }
            con.commit();
        } catch (Exception e) {
            throw e;
        }
    }
}
