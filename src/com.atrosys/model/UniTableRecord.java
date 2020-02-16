package com.atrosys.model;

import com.atrosys.entity.University;

import java.sql.Timestamp;

/**
 * Created by met on 2/3/18.
 * POJO class for Customers table row data.
 */

public class UniTableRecord {
    private University university;
    private Timestamp lastLogTimeStamp;
    private String stateName;
    private String cityName;

    public University getUniversity() {
        return university;
    }

    public void setUniversity(University university) {
        this.university = university;
    }

    public Timestamp getLastLogTimeStamp() {
        return lastLogTimeStamp;
    }

    public void setLastLogTimeStamp(Timestamp lastLogTimeStamp) {
        this.lastLogTimeStamp = lastLogTimeStamp;
    }

    public String getStateName() {
        return stateName;
    }

    public void setStateName(String stateName) {
        this.stateName = stateName;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }
}
