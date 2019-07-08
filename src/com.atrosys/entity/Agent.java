package com.atrosys.entity;

import javax.persistence.*;

@Entity
@Table(name = "agent")
public class Agent {
    private Long agentId;
    private Long nationalId;
    private Long uniNationalId;
    private Long roleId;
    private String telNo;
    private String faxNo;
    private String mobileNo;
    private String supportEmail;
    private String agentPos;
    private Boolean primary;
    private byte[] introCert;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "agent_id")
    public Long getAgentId() {
        return agentId;
    }

    public void setAgentId(Long agentId) {
        this.agentId = agentId;
    }

    @Column(name = "national_id")
    public Long getNationalId() {
        return nationalId;
    }

    public void setNationalId(Long nationalId) {
        this.nationalId = nationalId;
    }

    @Column(name = "tel_no")
    public String getTelNo() {
        return telNo;
    }

    public void setTelNo(String teleNo) {
        this.telNo = teleNo;
    }

    @Column(name = "fax_no")
    public String getFaxNo() {
        return faxNo;
    }

    public void setFaxNo(String faxNo) {
        this.faxNo = faxNo;
    }

    @Column(name = "mobile_no")
    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    @Column(name = "support_email")
    public String getSupportEmail() {
        return supportEmail;
    }

    public void setSupportEmail(String supportEmail) {
        this.supportEmail = supportEmail;
    }

    @Lob
    @Column(name = "intro_cert", columnDefinition = "mediumblob")
    public byte[] getIntroCert() {
        return introCert;
    }

    public void setIntroCert(byte[] introCert) {
        this.introCert = introCert;
    }

    @Column(name = "uni_national_id")
    public Long getUniNationalId() {
        return uniNationalId;
    }

    public void setUniNationalId(Long uniNationalId) {
        this.uniNationalId = uniNationalId;
    }

    @Column(name = "role_id")
    public Long getRoleId() {
        return roleId;
    }

    public void setRoleId(Long roleId) {
        this.roleId = roleId;
    }

    @Column(name = "agent_pos")
    public String getAgentPos() {
        return agentPos;
    }

    public void setAgentPos(String agentPos) {
        this.agentPos = agentPos;
    }

    @Column(name = "is_primary")
    public Boolean getPrimary() {
        return primary;
    }

    public void setPrimary(Boolean primary) {
        this.primary = primary;
    }
}
