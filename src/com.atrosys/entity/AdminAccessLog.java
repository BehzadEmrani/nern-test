package com.atrosys.entity;

import javax.persistence.*;
import java.sql.Timestamp;

/**
 * Admin and manager logs for accessing pages.
 */

@Entity
@Table(name = "admin_access_log")
public class AdminAccessLog {
    private Long id;
    private Long adminId;
    private Integer adminAccessLogTypeVal;
    private Integer pageAccessVal;
    private String message;
    private Timestamp timeStamp;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "admin_id")
    public Long getAdminId() {
        return adminId;
    }

    public void setAdminId(Long adminId) {
        this.adminId = adminId;
    }

    @Column(name = "admin_access_val")
    public Integer getAdminAccessLogTypeVal() {
        return adminAccessLogTypeVal;
    }

    public void setAdminAccessLogTypeVal(Integer adminAccessLogTypeVal) {
        this.adminAccessLogTypeVal = adminAccessLogTypeVal;
    }

    @Column(name = "message")
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Column(name = "time_stamp")
    public Timestamp getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(Timestamp timeStamp) {
        this.timeStamp = timeStamp;
    }

    @Column(name = "page_access_val")
    public Integer getPageAccessVal() {
        return pageAccessVal;
    }

    public void setPageAccessVal(Integer pageAccessVal) {
        this.pageAccessVal = pageAccessVal;
    }
}
