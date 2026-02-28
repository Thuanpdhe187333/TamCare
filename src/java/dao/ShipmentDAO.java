package dao;

import context.DBContext;
import dto.ShipmentDTO;
import model.Shipment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShipmentDAO extends DBContext {

    /**
     * Create shipment from SO number
     */
    public Long createShipmentFromSO(String soNumber, Long gdnId, Long carrierId, 
            String shipmentType, Long createdBy) throws Exception {
        String sql = """
                INSERT INTO shipment
                    (shipment_number, gdn_id, carrier_id, shipment_type, status, created_at, note)
                VALUES (?, ?, ?, ?, 'CREATED', NOW(), ?)
            """;

        String shipmentNumber = generateShipmentNumber();

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, shipmentNumber);
            ps.setLong(2, gdnId);
            if (carrierId != null) {
                ps.setLong(3, carrierId);
            } else {
                ps.setNull(3, Types.BIGINT);
            }
            ps.setString(4, shipmentType);
            ps.setString(5, "Shipment for SO: " + soNumber);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (!rs.next()) {
                    throw new SQLException("Cannot get generated shipment_id");
                }
                return rs.getLong(1);
            }
        }
    }

    /**
     * Get shipment info by SO number
     */
    public ShipmentDTO getShipmentInfoBySONumber(String soNumber) throws Exception {
        String sql = """
                SELECT 
                    so.so_id,
                    so.so_number,
                    so.customer_id,
                    c.name AS customer_name,
                    so.ship_to_address,
                    so.requested_ship_date,
                    gdn.gdn_id,
                    gdn.gdn_number
                FROM sales_order so
                LEFT JOIN customer c ON so.customer_id = c.customer_id
                LEFT JOIN goods_delivery_note gdn ON gdn.so_id = so.so_id AND gdn.status = 'CONFIRMED'
                WHERE so.so_number = ?
                ORDER BY gdn.gdn_id DESC
                LIMIT 1
            """;

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, soNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ShipmentDTO dto = new ShipmentDTO();
                    dto.setSoNumber(rs.getString("so_number"));
                    dto.setCustomerId(rs.getObject("customer_id") != null ? rs.getLong("customer_id") : null);
                    dto.setCustomerName(rs.getString("customer_name"));
                    dto.setShipToAddress(rs.getString("ship_to_address"));
                    Date shipDate = rs.getDate("requested_ship_date");
                    if (shipDate != null) {
                        dto.setRequestedShipDate(shipDate.toLocalDate().atStartOfDay());
                    }
                    dto.setGdnId(rs.getObject("gdn_id") != null ? rs.getLong("gdn_id") : null);
                    dto.setGdnNumber(rs.getString("gdn_number"));
                    return dto;
                }
            }
        }
        return null;
    }

    /**
     * Update shipment status
     */
    public boolean updateShipmentStatus(Long shipmentId, String status) throws Exception {
        String sql = """
                UPDATE shipment
                SET status = ?,
                    picked_up_at = CASE WHEN ? = 'PICKED_UP' THEN NOW() ELSE picked_up_at END,
                    delivered_at = CASE WHEN ? = 'DELIVERED' THEN NOW() ELSE delivered_at END
                WHERE shipment_id = ?
            """;

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setString(3, status);
            ps.setLong(4, shipmentId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Generate shipment number
     */
    private String generateShipmentNumber() throws Exception {
        String sql = "SELECT COUNT(*) + 1 AS next_num FROM shipment";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int nextNum = rs.getInt("next_num");
                return "SHIP-" + String.format("%06d", nextNum);
            }
        }
        return "SHIP-000001";
    }
}
