package com.atrosys.model;


/**
 * Created by Misagh Dayer on 3/11/19.
 */
public class UniApiRecordInspectors {
    private Long uniNationalId;
    private String uniName;
    private Integer uniSubCode;
    private Integer uniType;
    private String stateName;
    private String cityName;
    private String registerDate;
    private Integer numService;

    public Long getUniNationalId() {
        return uniNationalId;
    }

    public void setUniNationalId(Long uniNationalId) {
        this.uniNationalId = uniNationalId;
    }

    public String getUniName() {
        return uniName;
    }

    public Integer getUniSubCode() {
        return uniSubCode;
    }

    public void setUniSubCode(Integer uniSubCode) {
        this.uniSubCode = uniSubCode;
    }

    public void setUniName(String uniName) {
        this.uniName = uniName;
    }

    public Integer getUniType() {
        return uniType;
    }

    public void setUniType(Integer uniType) {
        this.uniType = uniType;
    }

    public String getStateName() {
        return stateName;
    }

    public void setStateName(String stateName) {
        this.stateName = stateName;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getRegisterDate() {
        return registerDate;
    }

    public void setRegisterDate(String registerDate) {
        this.registerDate = registerDate;
    }

    public Integer getNumService() {
        return numService;
    }

    public void setNumService(Integer numService) {
        this.numService = numService;
    }
}
