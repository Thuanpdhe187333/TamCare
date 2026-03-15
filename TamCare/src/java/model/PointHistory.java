package model;

import java.sql.Timestamp;

public class PointHistory {
    private int historyID;
    private int userID;
    private String source;
    private String description;
    private long pointAmount; // Đã là long - Chuẩn
    private Timestamp transactionDate;

    public PointHistory() {}

    // Sửa tham số truyền vào từ int sang long ở đây
    public PointHistory(int historyID, int userID, String source, String description, long pointAmount, Timestamp transactionDate) {
        this.historyID = historyID;
        this.userID = userID;
        this.source = source;
        this.description = description;
        this.pointAmount = pointAmount;
        this.transactionDate = transactionDate;
    }

    // Getters
    public int getHistoryID() { return historyID; }
    public int getUserID() { return userID; }
    public String getSource() { return source; }
    public String getDescription() { return description; }
    public long getPointAmount() { return pointAmount; }
    public Timestamp getTransactionDate() { return transactionDate; }

    // Bổ sung Setters (Cần thiết khi bác dùng các thư viện mapping hoặc muốn sửa dữ liệu)
    public void setHistoryID(int historyID) { this.historyID = historyID; }
    public void setUserID(int userID) { this.userID = userID; }
    public void setSource(String source) { this.source = source; }
    public void setDescription(String description) { this.description = description; }
    public void setPointAmount(long pointAmount) { this.pointAmount = pointAmount; }
    public void setTransactionDate(Timestamp transactionDate) { this.transactionDate = transactionDate; }
}