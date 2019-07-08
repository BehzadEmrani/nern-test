package com.atrosys.model;


public class ServiceResponse {
    long id;
    String faStr;

    public ServiceResponse(long value, String faStr) {
        this.id = value;
        this.faStr = faStr;
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
}