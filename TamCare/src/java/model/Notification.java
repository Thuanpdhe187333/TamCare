package model;

import java.sql.Timestamp;

public class Notification {
    private int id;
    private int userId;
    private String title;
    private String message;
    private boolean isRead; // Tên biến là isRead
    private Timestamp createdAt;

    public Notification() {
    }

    public Notification(int id, int userId, String title, String message, boolean isRead, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    // --- CÁC HÀM GETTER/SETTER QUAN TRỌNG ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    // Hàm Getter cho boolean thường bắt đầu bằng "is"
    public boolean isRead() { return isRead; }
    
    // ĐÂY LÀ HÀM MÀ DAO ĐANG TÌM: setRead
    public void setRead(boolean isRead) { this.isRead = isRead; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}