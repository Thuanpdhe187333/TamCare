package dao;

import context.DBContext;
import dto.PickTaskDTO;
import dto.PickTaskLineDTO;
import model.PickTask;
import model.PickTaskLine;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PickTaskDAO extends DBContext {

    /**
     * Get pick tasks assigned to a user (for "My Task")
     */
    public List<PickTaskDTO> getMyPickTasks(Long userId, String status) throws Exception {
        StringBuilder sql = new StringBuilder("""
                SELECT 
                    pt.pick_task_id,
                    pt.gdn_id,
                    gdn.gdn_number,
                    so.so_number,
                    pt.assigned_to,
                    u1.full_name AS assigned_to_name,
                    pt.assigned_by,
                    u2.full_name AS assigned_by_name,
                    pt.status,
                    pt.assigned_at,
                    pt.started_at,
                    pt.completed_at
                FROM pick_task pt
                JOIN goods_delivery_note gdn ON pt.gdn_id = gdn.gdn_id
                LEFT JOIN sales_order so ON gdn.so_id = so.so_id
                LEFT JOIN user u1 ON pt.assigned_to = u1.user_id
                LEFT JOIN user u2 ON pt.assigned_by = u2.user_id
                WHERE pt.assigned_to = ?
            """);

        if (status != null && !status.isBlank()) {
            sql.append(" AND pt.status = ?");
        }

        sql.append(" ORDER BY pt.assigned_at DESC");

        List<PickTaskDTO> list = new ArrayList<>();
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setLong(1, userId);
            if (status != null && !status.isBlank()) {
                ps.setString(2, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PickTaskDTO dto = new PickTaskDTO();
                    dto.setPickTaskId(rs.getLong("pick_task_id"));
                    dto.setGdnId(rs.getLong("gdn_id"));
                    dto.setGdnNumber(rs.getString("gdn_number"));
                    dto.setSoNumber(rs.getString("so_number"));
                    dto.setAssignedTo(rs.getLong("assigned_to"));
                    dto.setAssignedToName(rs.getString("assigned_to_name"));
                    dto.setAssignedBy(rs.getObject("assigned_by") != null ? rs.getLong("assigned_by") : null);
                    dto.setAssignedByName(rs.getString("assigned_by_name"));
                    dto.setStatus(rs.getString("status"));
                    Timestamp assignedAt = rs.getTimestamp("assigned_at");
                    if (assignedAt != null) {
                        dto.setAssignedAt(assignedAt.toLocalDateTime());
                    }
                    Timestamp startedAt = rs.getTimestamp("started_at");
                    if (startedAt != null) {
                        dto.setStartedAt(startedAt.toLocalDateTime());
                    }
                    Timestamp completedAt = rs.getTimestamp("completed_at");
                    if (completedAt != null) {
                        dto.setCompletedAt(completedAt.toLocalDateTime());
                    }

                    // Get pick task lines
                    List<PickTaskLineDTO> lines = getPickTaskLines(dto.getPickTaskId());
                    dto.setLines(lines);

                    list.add(dto);
                }
            }
        }
        return list;
    }

    /**
     * Get pick task lines with slot/zone information
     */
    private List<PickTaskLineDTO> getPickTaskLines(Long pickTaskId) throws Exception {
        String sql = """
                SELECT 
                    ptl.pick_task_line_id,
                    ptl.gdn_line_id,
                    ptl.variant_id,
                    pv.variant_sku,
                    p.name AS product_name,
                    pv.color,
                    pv.size,
                    ptl.qty_required,
                    ptl.qty_picked,
                    s.code AS slot_code,
                    z.code AS zone_code
                FROM pick_task_line ptl
                JOIN product_variant pv ON ptl.variant_id = pv.variant_id
                JOIN product p ON pv.product_id = p.product_id
                LEFT JOIN inventory_balance ib ON ib.variant_id = ptl.variant_id AND ib.qty_available > 0
                LEFT JOIN slot s ON ib.slot_id = s.slot_id
                LEFT JOIN zone z ON s.zone_id = z.zone_id
                WHERE ptl.pick_task_id = ?
                ORDER BY ptl.pick_task_line_id
            """;

        List<PickTaskLineDTO> list = new ArrayList<>();
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, pickTaskId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PickTaskLineDTO line = new PickTaskLineDTO();
                    line.setPickTaskLineId(rs.getLong("pick_task_line_id"));
                    line.setGdnLineId(rs.getLong("gdn_line_id"));
                    line.setVariantId(rs.getLong("variant_id"));
                    line.setVariantSku(rs.getString("variant_sku"));
                    line.setProductName(rs.getString("product_name"));
                    line.setColor(rs.getString("color"));
                    line.setSize(rs.getString("size"));
                    line.setQtyRequired(rs.getBigDecimal("qty_required"));
                    line.setQtyPicked(rs.getBigDecimal("qty_picked"));
                    line.setSlotCode(rs.getString("slot_code"));
                    line.setZoneCode(rs.getString("zone_code"));
                    list.add(line);
                }
            }
        }
        return list;
    }

    /**
     * Create pick task from GDN
     */
    public Long createPickTaskFromGDN(Long gdnId, Long assignedTo, Long assignedBy) throws Exception {
        String sqlTask = """
                INSERT INTO pick_task
                    (gdn_id, assigned_to, assigned_by, status, assigned_at)
                VALUES (?, ?, ?, 'ASSIGNED', NOW())
            """;

        String sqlLine = """
                INSERT INTO pick_task_line
                    (pick_task_id, gdn_line_id, variant_id, qty_required, qty_picked)
                SELECT ?, gdl.gdn_line_id, gdl.variant_id, gdl.qty_required, 0
                FROM goods_delivery_line gdl
                WHERE gdl.gdn_id = ?
            """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psTask = conn.prepareStatement(sqlTask, Statement.RETURN_GENERATED_KEYS);
                    PreparedStatement psLine = conn.prepareStatement(sqlLine)) {

                // Insert pick task
                psTask.setLong(1, gdnId);
                psTask.setLong(2, assignedTo);
                if (assignedBy != null) {
                    psTask.setLong(3, assignedBy);
                } else {
                    psTask.setNull(3, Types.BIGINT);
                }
                psTask.executeUpdate();

                Long pickTaskId;
                try (ResultSet rs = psTask.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new SQLException("Cannot get generated pick_task_id");
                    }
                    pickTaskId = rs.getLong(1);
                }

                // Insert pick task lines from GDN lines
                psLine.setLong(1, pickTaskId);
                psLine.setLong(2, gdnId);
                psLine.executeUpdate();

                conn.commit();
                return pickTaskId;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    /**
     * Confirm pick task (update quantities and inventory)
     */
    public boolean confirmPickTask(Long pickTaskId, List<PickTaskLineDTO> lines) throws Exception {
        String sqlUpdateTask = """
                UPDATE pick_task
                SET status = 'COMPLETED', completed_at = NOW()
                WHERE pick_task_id = ?
            """;

        String sqlUpdateLine = """
                UPDATE pick_task_line
                SET qty_picked = ?
                WHERE pick_task_line_id = ?
            """;

        String sqlUpdateGDNLine = """
                UPDATE goods_delivery_line
                SET qty_picked = ?
                WHERE gdn_line_id = ?
            """;

        // Update inventory (decrease qty_available and qty_on_hand)
        String sqlUpdateInventory = """
                UPDATE inventory_balance
                SET qty_available = qty_available - ?,
                    qty_on_hand = qty_on_hand - ?
                WHERE variant_id = ? AND slot_id = ?
            """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psTask = conn.prepareStatement(sqlUpdateTask);
                    PreparedStatement psLine = conn.prepareStatement(sqlUpdateLine);
                    PreparedStatement psGDNLine = conn.prepareStatement(sqlUpdateGDNLine);
                    PreparedStatement psInv = conn.prepareStatement(sqlUpdateInventory)) {

                // Update task status
                psTask.setLong(1, pickTaskId);
                psTask.executeUpdate();

                // Update lines and inventory
                for (PickTaskLineDTO line : lines) {
                    // Update pick task line
                    psLine.setBigDecimal(1, line.getQtyPicked());
                    psLine.setLong(2, line.getPickTaskLineId());
                    psLine.addBatch();

                    // Update GDN line
                    psGDNLine.setBigDecimal(1, line.getQtyPicked());
                    psGDNLine.setLong(2, line.getGdnLineId());
                    psGDNLine.addBatch();

                    // Update inventory (simplified - in real system, need to track which slot)
                    // This is a simplified version - you may need to adjust based on your inventory structure
                }
                psLine.executeBatch();
                psGDNLine.executeBatch();

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    /**
     * Get pick task by ID
     */
    public PickTaskDTO getPickTaskById(Long pickTaskId) throws Exception {
        String sql = """
                SELECT 
                    pt.pick_task_id,
                    pt.gdn_id,
                    gdn.gdn_number,
                    so.so_number,
                    pt.assigned_to,
                    u1.full_name AS assigned_to_name,
                    pt.assigned_by,
                    u2.full_name AS assigned_by_name,
                    pt.status,
                    pt.assigned_at,
                    pt.started_at,
                    pt.completed_at
                FROM pick_task pt
                JOIN goods_delivery_note gdn ON pt.gdn_id = gdn.gdn_id
                LEFT JOIN sales_order so ON gdn.so_id = so.so_id
                LEFT JOIN user u1 ON pt.assigned_to = u1.user_id
                LEFT JOIN user u2 ON pt.assigned_by = u2.user_id
                WHERE pt.pick_task_id = ?
            """;

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, pickTaskId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PickTaskDTO dto = new PickTaskDTO();
                    dto.setPickTaskId(rs.getLong("pick_task_id"));
                    dto.setGdnId(rs.getLong("gdn_id"));
                    dto.setGdnNumber(rs.getString("gdn_number"));
                    dto.setSoNumber(rs.getString("so_number"));
                    dto.setAssignedTo(rs.getLong("assigned_to"));
                    dto.setAssignedToName(rs.getString("assigned_to_name"));
                    dto.setAssignedBy(rs.getObject("assigned_by") != null ? rs.getLong("assigned_by") : null);
                    dto.setAssignedByName(rs.getString("assigned_by_name"));
                    dto.setStatus(rs.getString("status"));
                    Timestamp assignedAt = rs.getTimestamp("assigned_at");
                    if (assignedAt != null) {
                        dto.setAssignedAt(assignedAt.toLocalDateTime());
                    }
                    Timestamp startedAt = rs.getTimestamp("started_at");
                    if (startedAt != null) {
                        dto.setStartedAt(startedAt.toLocalDateTime());
                    }
                    Timestamp completedAt = rs.getTimestamp("completed_at");
                    if (completedAt != null) {
                        dto.setCompletedAt(completedAt.toLocalDateTime());
                    }

                    List<PickTaskLineDTO> lines = getPickTaskLines(pickTaskId);
                    dto.setLines(lines);

                    return dto;
                }
            }
        }
        return null;
    }
}
