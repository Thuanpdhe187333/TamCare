package model;
import java.sql.Timestamp;
import java.sql.Date; // Hoặc java.util.Date

public class User {
    private int userID;
    private String email;
    private String password; // Trong Java đặt là password cho gọn
    private String fullName;
    private String phoneNumber;
    private String role;
    private Date dateCreated;
    private String linkKey;
    private String gender;
    private Integer birthYear;
    private boolean isPremium;
    private long totalPoints;
    private Timestamp premiumExpiry;
    private int memberLevel;

    public User() {
    }

    public User(String email, String password, String fullName, String phoneNumber, String role) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.role = role;
    }
    public String getLinkKey() {
        return linkKey;
    }

    public void setLinkKey(String linkKey) {
        this.linkKey = linkKey;
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
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public Integer getBirthYear() { return birthYear; }
    public void setBirthYear(Integer birthYear) { this.birthYear = birthYear; }
    public boolean isIsPremium() { return isPremium; }
    public void setIsPremium(boolean isPremium) { this.isPremium = isPremium; }
    public long getTotalPoints() { return totalPoints; }
    public void setTotalPoints(long totalPoints) { this.totalPoints = totalPoints; }
    public Timestamp getPremiumExpiry() {
        return premiumExpiry;
    }

    public void setPremiumExpiry(Timestamp premiumExpiry) {
        this.premiumExpiry = premiumExpiry;
    }
    public int getMemberLevel() { return memberLevel; }
public void setMemberLevel(int memberLevel) { this.memberLevel = memberLevel; }
}