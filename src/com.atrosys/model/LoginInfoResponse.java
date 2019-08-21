package com.atrosys.model;

/**
 * Created by MisaghDayer on 7/28/19.
 */
public class LoginInfoResponse {

    private String uniName;
    private Long uniNationalId;
    private String uniState;
    private String uniCity;
    private String agentName;

    public String getUniState() {
        return uniState;
    }

    public void setUniState(String uniState) {
        this.uniState = uniState;
    }

    public String getUniCity() {
        return uniCity;
    }

    public void setUniCity(String uniCity) {
        this.uniCity = uniCity;
    }

    public String getAgentMobile() {
        return agentMobile;
    }

    public void setAgentMobile(String agentMobile) {
        this.agentMobile = agentMobile;
    }

    public String getAgentTell() {
        return agentTell;
    }

    public void setAgentTell(String agentTell) {
        this.agentTell = agentTell;
    }

    private String agentMobile;
    private String agentTell;
    private Boolean isAdmin;
    private String adminName;
    private Long adminNationalId;
    private String adminUsername;

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public Long getAdminNationalId() {
        return adminNationalId;
    }

    public void setAdminNationalId(Long adminNationalId) {
        this.adminNationalId = adminNationalId;
    }

    public String getAdminUsername() {
        return adminUsername;
    }

    public void setAdminUsername(String adminUsername) {
        this.adminUsername = adminUsername;
    }

    public String getUniName() {
        return uniName;
    }

    public void setUniName(String uniName) {
        this.uniName = uniName;
    }

    public Long getUniNationalId() {
        return uniNationalId;
    }

    public void setUniNationalId(Long uniNationalId) {
        this.uniNationalId = uniNationalId;
    }

    public String getAgentName() {
        return agentName;
    }

    public void setAgentName(String agentName) {
        this.agentName = agentName;
    }

    public Boolean getAdmin() {
        return isAdmin;
    }

    public void setAdmin(Boolean admin) {
        isAdmin = admin;
    }


}
