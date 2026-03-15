package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PointHistory;

public class PointDAO extends DBContext {

    // Lấy tổng điểm - Trả về long để tránh Overflow
    public long getTotalPoints(int userID) {
        String sql = "SELECT TotalPoints FROM Points WHERE UserID = ?";
        try (Connection con = getConnection(); 
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getLong("TotalPoints"); // Dùng getLong
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public List<PointHistory> getHistoryByUserID(int userID) {
        List<PointHistory> list = new ArrayList<>();
        String sql = "SELECT TOP 10 HistoryID, UserID, Source, Description, PointAmount, TransactionDate " +
                     "FROM PointHistory WHERE UserID = ? " +
                     "ORDER BY TransactionDate DESC";
        try (Connection con = getConnection(); 
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                // Giả định Constructor PointHistory đã đổi PointAmount sang long
                list.add(new PointHistory(
                    rs.getInt("HistoryID"),
                    rs.getInt("UserID"),
                    rs.getString("Source"),
                    rs.getString("Description"),
                    rs.getLong("PointAmount"), // Dùng getLong
                    rs.getTimestamp("TransactionDate")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm cập nhật giao dịch - Đã tối ưu nhờ SQL Trigger
    public boolean updatePointTransaction(int userID, long amount, String source, String description) {
    // 1. Câu lệnh trừ điểm ở bảng Points
    String updatePoints = "UPDATE Points SET TotalPoints = TotalPoints - ?, LastUpdated = GETDATE() WHERE UserID = ?";
    // 2. Câu lệnh thêm vào lịch sử
    String insertHistory = "INSERT INTO PointHistory (UserID, Source, Description, PointAmount, TransactionDate) VALUES (?, ?, ?, ?, GETDATE())";
    
    Connection con = null;
    try {
        con = getConnection();
        con.setAutoCommit(false); // Bắt đầu Transaction

        // THỰC HIỆN TRỪ ĐIỂM
        try (PreparedStatement st1 = con.prepareStatement(updatePoints)) {
            st1.setLong(1, amount); // amount là số dương, trừ đi amount
            st1.setInt(2, userID);
            int updatedRows = st1.executeUpdate();
            
            if (updatedRows == 0) {
                con.rollback();
                return false;
            }
        }

        // THỰC HIỆN GHI LỊCH SỬ
        try (PreparedStatement st2 = con.prepareStatement(insertHistory)) {
            st2.setInt(1, userID);
            st2.setString(2, source);
            st2.setString(3, description);
            st2.setLong(4, -amount); // Lưu số âm vào history (chi tiêu)
            st2.executeUpdate();
        }

        con.commit(); // XÁC NHẬN THAY ĐỔI
        return true;
    } catch (Exception e) {
        if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        e.printStackTrace();
    } finally {
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    return false;
}
}