package com.atrosys.entity;

import javax.persistence.*;
import java.sql.Date;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
@Entity
@Table(name = "university")
public class University {
    private Long uniNationalId;
    private Long uniStatusLog;
    private Long cityId;
    private Long countryId;
    private Long stateId;
    private Integer uniStatus;
    private Integer uniSubStatus;
    private Integer uniSubSystemCode;
    private Integer typeVal;
    private Double mapLocLat;
    private Double mapLocLng;
    private String signatoryNationalId;
    private String uniName;
    private String topManagerName;
    private String topManagerPos;
    private String signatoryName;
    private String signatoryPos;
    private String address;
    private String postalCode;
    private String ecoCode;
    private String teleNo;
    private String faxNo;
    private String siteAddress;
    private String uniPublicEmail;
    private String subscriptionContractNo;
    private Date subscriptionContractDate;
    private byte[] requestForm;
    private byte[] subscriptionForm;
    private byte[] subscriptionFormSigned;
    private byte[] subscriptionPostTicket;
    private byte[] subscriptionLetter;
    private byte[] subscriptionExampleForm;
    private byte[] editForm;
    private byte[] cancellForm;
    private byte[] reasonCancellForm;
    private byte[] confirmCancellForm;
    private boolean active;

    @Id
    @Column(name = "uni_national_id")
    public Long getUniNationalId() {
        return uniNationalId;
    }

    public String nationalIdForContract() {
        String str = uniNationalId + "";
        str = str.substring(0, 11) + "-" + str.substring(11, str.length() );
        return str;
    }

    public void setUniNationalId(Long uniNationalId) {
        this.uniNationalId = uniNationalId;
    }

    @Column(name = "signatory_national_id")
    public String getSignatoryNationalId() {
        return signatoryNationalId;
    }

    public void setSignatoryNationalId(String signatoryNationalId) {
        this.signatoryNationalId = signatoryNationalId;
    }

    @Column(name = "uni_name")
    public String getUniName() {
        return uniName;
    }

    public void setUniName(String uniName) {
        this.uniName = uniName;
    }


    @Column(name = "top_manager_name")
    public String getTopManagerName() {
        return topManagerName;
    }

    public void setTopManagerName(String topManagerName) {
        this.topManagerName = topManagerName;
    }

    @Column(name = "top_manager_pos")
    public String getTopManagerPos() {
        return topManagerPos;
    }

    public void setTopManagerPos(String topManagerPos) {
        this.topManagerPos = topManagerPos;
    }

    @Column(name = "signatory_name")
    public String getSignatoryName() {
        return signatoryName;
    }

    public void setSignatoryName(String signatoryName) {
        this.signatoryName = signatoryName;
    }

    @Column(name = "signatory_pos")
    public String getSignatoryPos() {
        return signatoryPos;
    }

    public void setSignatoryPos(String signatoryPos) {
        this.signatoryPos = signatoryPos;
    }

    @Column(name = "country_id")
    public Long getCountryId() {
        return countryId;
    }

    public void setCountryId(Long countryId) {
        this.countryId = countryId;
    }


    @Column(name = "state_id")
    public Long getStateId() {
        return stateId;
    }

    public void setStateId(Long stateId) {
        this.stateId = stateId;
    }


    @Column(name = "city_id")
    public Long getCityId() {
        return cityId;
    }

    public void setCityId(Long cityId) {
        this.cityId = cityId;
    }

    @Column(name = "uni_sub_code")
    public Integer getUniSubSystemCode() {
        return uniSubSystemCode;
    }

    public void setUniSubSystemCode(Integer uniSubSystemCode) {
        this.uniSubSystemCode = uniSubSystemCode;
    }

    @Column(name = "type_val")
    public Integer getTypeVal() {
        return typeVal;
    }

    public void setTypeVal(Integer typeVal) {
        this.typeVal = typeVal;
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

    @Column(name = "address")
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }


    @Column(name = "postal_code")
    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    @Column(name = "eco_code")
    public String getEcoCode() {
        return ecoCode;
    }

    public void setEcoCode(String ecoCode) {
        this.ecoCode = ecoCode;
    }

    @Column(name = "tele_no")
    public String getTeleNo() {
        return teleNo;
    }

    public void setTeleNo(String teleNo) {
        this.teleNo = teleNo;
    }


    @Column(name = "fax_no")
    public String getFaxNo() {
        return faxNo;
    }

    public void setFaxNo(String faxNo) {
        this.faxNo = faxNo;
    }


    @Column(name = "site_address")
    public String getSiteAddress() {
        return siteAddress;
    }

    public void setSiteAddress(String siteAddress) {
        this.siteAddress = siteAddress;
    }


    @Column(name = "uni_public_email")
    public String getUniPublicEmail() {
        return uniPublicEmail;
    }

    public void setUniPublicEmail(String uniPublicEmail) {
        this.uniPublicEmail = uniPublicEmail;
    }


    @Lob
    @Column(name = "cancell_form", columnDefinition = "mediumblob")
    public byte[] getCancellForm() {
        return cancellForm;
    }

    public void setCancellForm(byte[] cancellForm) {
        this.cancellForm = cancellForm;
    }


    @Lob
    @Column(name = "reason_cancell_form", columnDefinition = "mediumblob")
    public byte[] getReasonCancellForm() {
        return reasonCancellForm;
    }

    public void setReasonCancellForm(byte[] reasonCancellForm) {
        this.reasonCancellForm = reasonCancellForm;
    }


    @Lob
    @Column(name = "edit_form", columnDefinition = "mediumblob")
    public byte[] getEditForm() {
        return editForm;
    }

    public void setEditForm(byte[] editForm) {
        this.editForm = editForm;
    }


    @Column(name = "map_loc_lat")
    public Double getMapLocLat() {
        return mapLocLat;
    }

    public void setMapLocLat(Double mapLocLat) {
        this.mapLocLat = mapLocLat;
    }


    @Column(name = "map_loc_lng")
    public Double getMapLocLng() {
        return mapLocLng;
    }

    public void setMapLocLng(Double mapLocLng) {
        this.mapLocLng = mapLocLng;
    }

    @Lob
    @Column(name = "request_form", columnDefinition = "mediumblob")
    public byte[] getRequestForm() {
        return requestForm;
    }

    public void setRequestForm(byte[] requestForm) {
        this.requestForm = requestForm;
    }


    @Lob
    @Column(name = "subscription_form", columnDefinition = "mediumblob")
    public byte[] getSubscriptionForm() {
        return subscriptionForm;
    }

    public void setSubscriptionForm(byte[] subscriptionForm) {
        this.subscriptionForm = subscriptionForm;
    }


    @Lob
    @Column(name = "subscription_example_form", columnDefinition = "mediumblob")
    public byte[] getSubscriptionExampleForm() {
        return subscriptionExampleForm;
    }

    public void setSubscriptionExampleForm(byte[] subscriptionExampleForm) {
        this.subscriptionExampleForm = subscriptionExampleForm;
    }


    @Lob
    @Column(name = "confirm_form", columnDefinition = "mediumblob")
    public byte[] getConfirmCancellForm() {
        return confirmCancellForm;
    }

    public void setConfirmCancellForm(byte[] confirmCancewllForm) {
        this.confirmCancellForm = confirmCancellForm;
    }

    @Column(name = "uni_status_log")
    public Long getUniStatusLog() {
        return uniStatusLog;
    }

    public void setUniStatusLog(Long uniStatusLog) {
        this.uniStatusLog = uniStatusLog;
    }

    @Lob
    @Column(name = "subscription_form_signed", columnDefinition = "mediumblob")
    public byte[] getSubscriptionFormSigned() {
        return subscriptionFormSigned;
    }

    public void setSubscriptionFormSigned(byte[] subscriptionFormSigned) {
        this.subscriptionFormSigned = subscriptionFormSigned;
    }


    @Lob
    @Column(name = "subscription_post_ticket", columnDefinition = "mediumblob")
    public byte[] getSubscriptionPostTicket() {
        return subscriptionPostTicket;
    }

    public void setSubscriptionPostTicket(byte[] subscriptionPostTicket) {
        this.subscriptionPostTicket = subscriptionPostTicket;
    }

    @Lob
    @Column(name = "subscription_letter", columnDefinition = "mediumblob")
    public byte[] getSubscriptionLetter() {
        return subscriptionLetter;
    }

    public void setSubscriptionLetter(byte[] subscriptionLetter) {
        this.subscriptionLetter = subscriptionLetter;
    }
    @Column(name = "subscription_contract_no")
    public String getSubscriptionContractNo() {
        return subscriptionContractNo;
    }

    public void setSubscriptionContractNo(String subscriptionContractNo) {
        this.subscriptionContractNo = subscriptionContractNo;
    }
    @Column(name = "subscription_contract_date")
    public Date getSubscriptionContractDate() {
        return subscriptionContractDate;
    }

    public void setSubscriptionContractDate(Date subscriptionContractDate) {
        this.subscriptionContractDate = subscriptionContractDate;
    }

    @Column(name = "active")
    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
