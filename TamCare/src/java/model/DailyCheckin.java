package model;

import java.util.Date;

public class DailyCheckin {

    private int checkinId;
    private int elderlyUserId;
    private Date checkinTime;

    public DailyCheckin() {
    }

    public DailyCheckin(int checkinId, int elderlyUserId, Date checkinTime) {
        this.checkinId = checkinId;
        this.elderlyUserId = elderlyUserId;
        this.checkinTime = checkinTime;
    }

    public int getCheckinId() {
        return checkinId;
    }

    public void setCheckinId(int checkinId) {
        this.checkinId = checkinId;
    }

    public int getElderlyUserId() {
        return elderlyUserId;
    }

    public void setElderlyUserId(int elderlyUserId) {
        this.elderlyUserId = elderlyUserId;
    }

    public Date getCheckinTime() {
        return checkinTime;
    }

    public void setCheckinTime(Date checkinTime) {
        this.checkinTime = checkinTime;
    }
}

