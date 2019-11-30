package com.atrosys.model;

public class UniStatusItem {
    private int value;
    private String faStr;
    private boolean isCurrentStatus;
    private boolean hasSubStatus;
    private int currentSubStatus;

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public String getFaStr() {
        return faStr;
    }

    public void setFaStr(String faStr) {
        this.faStr = faStr;
    }

    public boolean isCurrentStatus() {
        return isCurrentStatus;
    }

    public void setCurrentStatus(boolean currentStatus) {
        isCurrentStatus = currentStatus;
    }

    public boolean isHasSubStatus() {
        return hasSubStatus;
    }

    public void setHasSubStatus(boolean hasSubStatus) {
        this.hasSubStatus = hasSubStatus;
    }

    public int getCurrentSubStatus() {
        return currentSubStatus;
    }

    public void setCurrentSubStatus(int currentSubStatus) {
        this.currentSubStatus = currentSubStatus;
    }
}
