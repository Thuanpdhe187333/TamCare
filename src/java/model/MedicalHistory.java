package model;

import java.util.Date;

public class MedicalHistory {

    private int historyId;
    private int profileId;
    private String diseaseCode;
    private String conditionName;
    private String historyType;
    private Date diagnosisDate;
    private String currentStatus;

    public MedicalHistory() {}

    public MedicalHistory(int historyId, int profileId, String diseaseCode,
            String conditionName, String historyType,
            Date diagnosisDate, String currentStatus) {
        this.historyId = historyId;
        this.profileId = profileId;
        this.diseaseCode = diseaseCode;
        this.conditionName = conditionName;
        this.historyType = historyType;
        this.diagnosisDate = diagnosisDate;
        this.currentStatus = currentStatus;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public String getDiseaseCode() {
        return diseaseCode;
    }

    public void setDiseaseCode(String diseaseCode) {
        this.diseaseCode = diseaseCode;
    }

    public String getConditionName() {
        return conditionName;
    }

    public void setConditionName(String conditionName) {
        this.conditionName = conditionName;
    }

    public String getHistoryType() {
        return historyType;
    }

    public void setHistoryType(String historyType) {
        this.historyType = historyType;
    }

    public Date getDiagnosisDate() {
        return diagnosisDate;
    }

    public void setDiagnosisDate(Date diagnosisDate) {
        this.diagnosisDate = diagnosisDate;
    }

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }
}