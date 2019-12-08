package com.atrosys.entity;

import javax.persistence.*;
import java.sql.Date;

@Entity
@Table(name = "service_form_request")
public class ServiceFormRequest {
    private Long id;
    private Long serviceFormParameterId;
    private Long subsBuildingId;
    private Long uniId;
    private Integer statusVal;
    private Date subscriptionDate;
    private Date serviceFormContractDate;
    private String subscriptionContractNo;
    private String serviceFormContractNo;
    private byte[] signedForm;
    private byte[] finalSignedForm;
    private byte[] letter;
    private byte[] postReceipt;
    private boolean active;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "service_form_parameter_id")
    public Long getServiceFormParameterId() {
        return serviceFormParameterId;
    }

    public void setServiceFormParameterId(Long serviceFormParameterId) {
        this.serviceFormParameterId = serviceFormParameterId;
    }

    @Column(name = "subs_building_id")
    public Long getSubsBuildingId() {
        return subsBuildingId;
    }

    public void setSubsBuildingId(Long subsBuildingId) {
        this.subsBuildingId = subsBuildingId;
    }

    @Column(name = "uni_id")
    public Long getUniId() {
        return uniId;
    }

    public void setUniId(Long uniId) {
        this.uniId = uniId;
    }

    @Column(name = "subscription_contract_no")
    public String getSubscriptionContractNo() {
        return subscriptionContractNo;
    }

    public void setSubscriptionContractNo(String subscriptionContractNo) {
        this.subscriptionContractNo = subscriptionContractNo;
    }

    @Column(name = "service_form_contract_no")
    public String getServiceFormContractNo() {
        return serviceFormContractNo;
    }

    public void setServiceFormContractNo(String serviceFormContractNo) {
        this.serviceFormContractNo = serviceFormContractNo;
    }

    @Column(name = "subscription_date")
    public Date getSubscriptionDate() {
        return subscriptionDate;
    }

    public void setSubscriptionDate(Date subscriptionDate) {
        this.subscriptionDate = subscriptionDate;
    }

    @Column(name = "service_form_contract_date")
    public Date getServiceFormContractDate() {
        return serviceFormContractDate;
    }

    public void setServiceFormContractDate(Date serviceFormContractDate) {
        this.serviceFormContractDate = serviceFormContractDate;
    }

    @Lob
    @Column(name = "signed_form", columnDefinition = "mediumblob")
    public byte[] getSignedForm() {
        return signedForm;
    }

    public void setSignedForm(byte[] signed_form) {
        this.signedForm = signed_form;
    }

    @Lob
    @Column(name = "final_signed_form", columnDefinition = "mediumblob")
    public byte[] getFinalSignedForm() {
        return finalSignedForm;
    }

    public void setFinalSignedForm(byte[] final_signed_form) {
        this.finalSignedForm = final_signed_form;
    }

    @Lob
    @Column(name = "letter", columnDefinition = "mediumblob")
    public byte[] getLetter() {
        return letter;
    }

    public void setLetter(byte[] letter) {
        this.letter = letter;
    }

    @Lob
    @Column(name = "post_receipt", columnDefinition = "mediumblob")
    public byte[] getPostReceipt() {
        return postReceipt;
    }

    public void setPostReceipt(byte[] postReceipt) {
        this.postReceipt = postReceipt;
    }

    @Column(name = "status_val")
    public Integer getStatusVal() {
        return statusVal;
    }

    public void setStatusVal(Integer statusVal) {
        this.statusVal = statusVal;
    }

    @Column (name= "active")
    public boolean isActive() {return active;}

    public void setActive(boolean active) {this.active = active;}
}
