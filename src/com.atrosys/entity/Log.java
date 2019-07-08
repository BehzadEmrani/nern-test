package com.atrosys.entity;

import javax.persistence.*;
import java.sql.Timestamp;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
@Entity
@Table(name = "log")
public class Log {
    private Long logId;
    private Long nationalId;
    private Timestamp time;
    private String description;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "log_id")
    public Long getLogId() {
        return logId;
    }

    public void setLogId(Long logId) {
        this.logId = logId;
    }

    
    @Column(name = "national_id")
    public Long getNationalId() {
        return nationalId;
    }

    public void setNationalId(Long nationalId) {
        this.nationalId = nationalId;
    }

    
    @Column(name = "time")
    public Timestamp getTime() {
        return time;
    }

    public void setTime(Timestamp time) {
        this.time = time;
    }

    
    @Column(name = "description")
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Log log = (Log) o;

        if (nationalId != log.nationalId) return false;
        if (time != null ? !time.equals(log.time) : log.time != null) return false;
        if (description != null ? !description.equals(log.description) : log.description != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = (int) (nationalId ^ (nationalId >>> 32));
        result = 31 * result + (time != null ? time.hashCode() : 0);
        result = 31 * result + (description != null ? description.hashCode() : 0);
        return result;
    }
}
