package model;

import java.sql.Date; // Hoặc java.util.Date

public class User {
    private int userID;
    private String email;
    private String password; // Trong Java đặt là password cho gọn
    private String fullName;
    private String phoneNumber;
    private String role;
    private Date dateCreated;

    public User() {
    }

    public User(String email, String password, String fullName, String phoneNumber, String role) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.role = role;
    }

    // Getters và Setters
    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Date getDateCreated() { return dateCreated; }
    public void setDateCreated(Date dateCreated) { this.dateCreated = dateCreated; }
}