package com.atrosys.entity;

import javax.persistence.*;
import java.sql.Timestamp;

/**
 * Created by mehdisabermahani on 6/14/17.
 * logs for uni registration stage change
 */

@Entity
@Table(name = "uni_status_log")
public class UniStatusLog {
    private Long id;
    private Long uniNationalId;
    private Long approvalAdminId;
    private Long approvalId;
    private Integer uniStatus;
    private Integer uniSubStatus;
    private Timestamp timeStamp;
    private String message;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "uni_national_id")
    public Long getUniNationalId() {
        return uniNationalId;
    }

    public void setUniNationalId(Long uniNationalId) {
        this.uniNationalId = uniNationalId;
    }


    @Column(name = "uni_status")
    public Integer getUniStatus() {
        return uniStatus;
    }

    public void setUniStatus(Integer uniStatus) {
        this.uniStatus = uniStatus;
    }

    @Column(name = "uni_sub_status")
    public Integer getUniSubStatus() {
        return uniSubStatus;
    }

    public void setUniSubStatus(Integer uniSubStatus) {
        this.uniSubStatus = uniSubStatus;
    }

    @Column(name = "message", length = 2000)
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

    @Column(name = "approval_admin_id")
    public Long getApprovalAdminId() {
        return approvalAdminId;
    }

    public void setApprovalAdminId(Long approvalAdminId) {
        this.approvalAdminId = approvalAdminId;
    }
    @Column(name = "approval_uni_id")
    public Long getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(Long approvalId) {
        this.approvalId = approvalId;
    }
}
