package com.atrosys.entity;

import javax.persistence.*;

@Entity
@Table(name = "telecom_center_pre_fix")
public class TelecomCenterPreFix {
    private Long id;
    private Long telecomCenterId;
    private String preFixNo;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "telecom_center_id")
    public Long getTelecomCenterId() {
        return telecomCenterId;
    }

    public void setTelecomCenterId(Long telecomCenterId) {
        this.telecomCenterId = telecomCenterId;
    }

    @Column(name = "pre_fix_no")
    public String getPreFixNo() {
        return preFixNo;
    }

    public void setPreFixNo(String preFixNo) {
        this.preFixNo = preFixNo;
    }
}
