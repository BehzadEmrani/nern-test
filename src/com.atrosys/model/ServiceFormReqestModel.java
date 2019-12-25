package com.atrosys.model;

public class ServiceFormReqestModel {
    private Long id;
    private String uniName;
    private String title;
    private String status;
    private String subscriptionDate;
    private String serviceFormContractNo;
    private boolean exampleForm;
    private boolean signedForm;
    private boolean finalSignedForm;
    private boolean letter;
    private boolean postReceipt;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUniName() {
        return uniName;
    }

    public void setUniName(String uniName) {
        this.uniName = uniName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSubscriptionDate() {
        return subscriptionDate;
    }

    public void setSubscriptionDate(String subscriptionDate) {
        this.subscriptionDate = subscriptionDate;
    }

    public String getServiceFormContractNo() {
        return serviceFormContractNo;
    }

    public void setServiceFormContractNo(String serviceFormContractNo) {
        this.serviceFormContractNo = serviceFormContractNo;
    }

    public boolean isExampleForm() {
        return exampleForm;
    }

    public void setExampleForm(boolean exampleForm) {
        this.exampleForm = exampleForm;
    }

    public boolean isSignedForm() {
        return signedForm;
    }

    public void setSignedForm(boolean signedForm) {
        this.signedForm = signedForm;
    }

    public boolean isFinalSignedForm() {
        return finalSignedForm;
    }

    public void setFinalSignedForm(boolean finalSignedForm) {
        this.finalSignedForm = finalSignedForm;
    }

    public boolean isLetter() {
        return letter;
    }

    public void setLetter(boolean letter) {
        this.letter = letter;
    }

    public boolean isPostReceipt() {
        return postReceipt;
    }

    public void setPostReceipt(boolean postReceipt) {
        this.postReceipt = postReceipt;
    }
}
