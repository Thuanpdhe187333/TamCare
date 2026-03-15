package model;

import java.sql.Timestamp;

public class PointHistory {
    private int historyID;
    private int userID;
    private String source;
    private String description;
    private int pointAmount;
    private Timestamp transactionDate;

    public PointHistory() {}

    public PointHistory(int historyID, int userID, String source, String description, int pointAmount, Timestamp transactionDate) {
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
    public int getPointAmount() { return pointAmount; }
    public Timestamp getTransactionDate() { return transactionDate; }
}