package com.atrosys.model;

/**
 * POJO class for customer errors field APIs.
 */

public class UniSubStatusResponse {
    int value;
    String faStr;

    public UniSubStatusResponse(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
    }

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
}