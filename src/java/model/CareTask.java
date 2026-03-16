package model;

import java.time.LocalDate;
import java.time.LocalTime;

public class CareTask {

    private int taskID;
    private int elderlyUserID;
    private String title;
    private String shortDescription;
    private String taskType;      // ONCE, DAILY, WEEKLY
    private LocalDate startDate;
    private LocalDate endDate;    // có thể null
    private LocalTime timeOfDay;
    private String taskCategory;
    private String daysOfWeek;    // ví dụ "1,3,5"

    public int getTaskID() {
        return taskID;
    }

    public void setTaskID(int taskID) {
        this.taskID = taskID;
    }

    public int getElderlyUserID() {
        return elderlyUserID;
    }

    public void setElderlyUserID(int elderlyUserID) {
        this.elderlyUserID = elderlyUserID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public LocalTime getTimeOfDay() {
        return timeOfDay;
    }

    public void setTimeOfDay(LocalTime timeOfDay) {
        this.timeOfDay = timeOfDay;
    }

    public String getTaskCategory() {
        return taskCategory;
    }

    public void setTaskCategory(String taskCategory) {
        this.taskCategory = taskCategory;
    }

    public String getDaysOfWeek() {
        return daysOfWeek;
    }

    public void setDaysOfWeek(String daysOfWeek) {
        this.daysOfWeek = daysOfWeek;
    }
}

