package com.atrosys.model;

public class PreUniversityDataItem {

    private Long id;
    private String uniType;
    private Long uniInternalCode;
    private String address;
    private String name;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUniType() {
        return uniType;
    }

    public void setUniType(String uniType) {
        this.uniType = uniType;
    }

    public Long getUniInternalCode() {
        return uniInternalCode;
    }

    public void setUniInternalCode(Long uniInternalCode) {
        this.uniInternalCode = uniInternalCode;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
