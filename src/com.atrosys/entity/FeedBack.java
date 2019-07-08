package com.atrosys.entity;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "feed_back")
public class FeedBack {
    private Long id;
    private Long adminId;
    private Integer status;
    private String description;
    private String pageAddress;
    private String attachedFileExtension;
    private byte[] attachedFile;
    private Timestamp timeStamp;
    private Timestamp repairTimeStamp;

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

    @Column(name = "description", length = 2000)
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    @Column(name = "page_address")
    public String getPageAddress() {
        return pageAddress;
    }

    public void setPageAddress(String pageAddress) {
        this.pageAddress = pageAddress;
    }

    @Lob
    @Column(name = "attached_file", columnDefinition = "mediumblob")
    public byte[] getAttachedFile() {
        return attachedFile;
    }

    public void setAttachedFile(byte[] attachedFile) {
        this.attachedFile = attachedFile;
    }

    @Column(name = "time_stamp")
    public Timestamp getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(Timestamp timeStamp) {
        this.timeStamp = timeStamp;
    }

    @Column(name = "attached_file_extension")
    public String getAttachedFileExtension() {
        return attachedFileExtension;
    }

    public void setAttachedFileExtension(String attachedFileExtension) {
        this.attachedFileExtension = attachedFileExtension;
    }

    @Column(name = "status_val")
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Column(name = "repair_time_stamp")
    public Timestamp getRepairTimeStamp() {
        return repairTimeStamp;
    }

    public void setRepairTimeStamp(Timestamp repairTimeStamp) {
        this.repairTimeStamp = repairTimeStamp;
    }
}
