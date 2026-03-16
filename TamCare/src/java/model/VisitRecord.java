package model;

import java.sql.Timestamp;

/**
 * One hospital/clinical visit. Links to ElderlyProfile.ProfileID.
 */
public class VisitRecord {
    private int visitID;
    private int profileID;
    private Timestamp visitDateTime;
    private String visitType;
    private String doctorName;
    private String diagnosis;
    private String treatmentPlan;

    public int getVisitID() { return visitID; }
    public void setVisitID(int visitID) { this.visitID = visitID; }
    public int getProfileID() { return profileID; }
    public void setProfileID(int profileID) { this.profileID = profileID; }
    public Timestamp getVisitDateTime() { return visitDateTime; }
    public void setVisitDateTime(Timestamp visitDateTime) { this.visitDateTime = visitDateTime; }
    public String getVisitType() { return visitType; }
    public void setVisitType(String visitType) { this.visitType = visitType; }
    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    public String getTreatmentPlan() { return treatmentPlan; }
    public void setTreatmentPlan(String treatmentPlan) { this.treatmentPlan = treatmentPlan; }
}
