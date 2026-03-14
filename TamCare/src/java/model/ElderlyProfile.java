package model;

import java.sql.Date;

public class ElderlyProfile {
    private int profileID;
    private int userID;
    private Date dateOfBirth;
    private String address;
    private double weight;
    private double height;
    private String chronicConditions; // Ví dụ: "Tiểu đường, Huyết áp cao"

    public ElderlyProfile() {
    }

    public ElderlyProfile(int userID, Date dateOfBirth, String address, double weight, double height, String chronicConditions) {
        this.userID = userID;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.weight = weight;
        this.height = height;
        this.chronicConditions = chronicConditions;
    }

    // Getter và Setter (Nhấn Alt+Insert để tự tạo)
    public int getProfileID() { return profileID; }
    public void setProfileID(int profileID) { this.profileID = profileID; }
    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }
    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }
    public double getHeight() { return height; }
    public void setHeight(double height) { this.height = height; }
    public String getChronicConditions() { return chronicConditions; }
    public void setChronicConditions(String chronicConditions) { this.chronicConditions = chronicConditions; }
}