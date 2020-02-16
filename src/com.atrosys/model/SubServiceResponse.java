package com.atrosys.model;

/**
 * POJO class for sub services APIs.
 */

public class SubServiceResponse {
    long id;
    String faStr;
    String otherCostTitle;

    public SubServiceResponse(long value, String faStr, String otherCostTitle) {
        this.id = value;
        this.faStr = faStr;
        this.otherCostTitle = otherCostTitle;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFaStr() {
        return faStr;
    }

    public void setFaStr(String faStr) {
        this.faStr = faStr;
    }

    public String getOtherCostTitle() {
        return otherCostTitle;
    }

    public void setOtherCostTitle(String otherCostTitle) {
        this.otherCostTitle = otherCostTitle;
    }
}