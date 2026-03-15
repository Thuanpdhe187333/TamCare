package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PointHistory;

public class PointDAO extends DBContext {

    // Lấy tổng điểm từ bảng Points
    public int getTotalPoints(int userID) {
        String sql = "SELECT TotalPoints FROM Points WHERE UserID = ?";
        try (Connection con = getConnection(); 
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt("TotalPoints");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy lịch sử giao dịch từ bảng PointHistory
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
                list.add(new PointHistory(
                    rs.getInt("HistoryID"),
                    rs.getInt("UserID"),
                    rs.getString("Source"),
                    rs.getString("Description"),
                    rs.getInt("PointAmount"),
                    rs.getTimestamp("TransactionDate")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}