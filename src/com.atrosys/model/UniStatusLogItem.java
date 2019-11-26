package com.atrosys.model;

public class UniStatusLogItem {
    private String uniNationalId;
    private String approval;
    private String uniStatus;
    private String uniSubStatus;
    private String date;
    private String message;

    public String getUniNationalId() {
        return uniNationalId;
    }

    public void setUniNationalId(String uniNationalId) {
        this.uniNationalId = uniNationalId;
    }

    public String getApproval() {
        return approval;
    }

    public void setApproval(String approval) {
        this.approval = approval;
    }

    public String getUniStatus() {
        return uniStatus;
    }

    public void setUniStatus(String uniStatus) {
        this.uniStatus = uniStatus;
    }

    public String getUniSubStatus() {
        return uniSubStatus;
    }

    public void setUniSubStatus(String uniSubStatus) {
        this.uniSubStatus = uniSubStatus;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
