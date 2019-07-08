package com.atrosys.model;

/**
 * Created by Pedram on 8/10/2017.
 */
public enum RequestStatus {
    ACTIVE(0) ,
    NOTACTIVE(1);
    private final int value;

    private RequestStatus(int value){
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static RequestStatus fromValue(int value){
        for (RequestStatus rs : RequestStatus.values())
            if (rs.getValue() == value)
                return rs;
        return null;
    }
}
