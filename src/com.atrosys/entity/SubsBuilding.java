package com.atrosys.entity;

import javax.persistence.*;

@Entity
@Table(name = "subs_building")
public class SubsBuilding {
    private Long id;
    private Long cityId;
    private Long agentId;
    private Long UniId;
    private Double mapLocLat;
    private Double mapLocLng;
    private Integer fiberCoreCount;
    private Integer freeFiberCoreCount;
    private Boolean haveFiber;
    private Boolean haveFreeFiber;
    private String buildingName;
    private String telecomName;
    private String address;
    private String postalCode;
    private String firstTel;
    private String secondTel;
    private String fax;
    private String firstFosContract;
    private String secondFosContract;
    private String distanceToTelecom;


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "city_id")
    public Long getCityId() {
        return cityId;
    }

    public void setCityId(Long cityId) {
        this.cityId = cityId;
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

    @Column(name = "fiber_core_count")
    public Integer getFiberCoreCount() {
        return fiberCoreCount;
    }

    public void setFiberCoreCount(Integer fiberCoreCount) {
        this.fiberCoreCount = fiberCoreCount;
    }

    @Column(name = "free_fiber_core_count")
    public Integer getFreeFiberCoreCount() {
        return freeFiberCoreCount;
    }

    public void setFreeFiberCoreCount(Integer freeFiberCoreCount) {
        this.freeFiberCoreCount = freeFiberCoreCount;
    }

    @Column(name = "have_fiber")
    public Boolean getHaveFiber() {
        return haveFiber;
    }

    public void setHaveFiber(Boolean haveFiber) {
        this.haveFiber = haveFiber;
    }

    @Column(name = "have_free_fiber")
    public Boolean getHaveFreeFiber() {
        return haveFreeFiber;
    }

    public void setHaveFreeFiber(Boolean haveFreeFiber) {
        this.haveFreeFiber = haveFreeFiber;
    }

    @Column(name = "building_name")
    public String getBuildingName() {
        return buildingName;
    }

    public void setBuildingName(String buildingName) {
        this.buildingName = buildingName;
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

    @Column(name = "first_tel")
    public String getFirstTel() {
        return firstTel;
    }

    public void setFirstTel(String firstTel) {
        this.firstTel = firstTel;
    }

    @Column(name = "second_tel")
    public String getSecondTel() {
        return secondTel;
    }

    public void setSecondTel(String secondTel) {
        this.secondTel = secondTel;
    }

    @Column(name = "fax")
    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    @Column(name = "first_foss_contract")
    public String getFirstFosContract() {
        return firstFosContract;
    }

    public void setFirstFosContract(String firstFossContract) {
        this.firstFosContract = firstFossContract;
    }

    @Column(name = "second_foss_contract")
    public String getSecondFosContract() {
        return secondFosContract;
    }

    public void setSecondFosContract(String secondFossContract) {
        this.secondFosContract = secondFossContract;
    }

    @Column(name = "distance_to_telecom")
    public String getDistanceToTelecom() {
        return distanceToTelecom;
    }

    public void setDistanceToTelecom(String distanceToTelecom) {
        this.distanceToTelecom = distanceToTelecom;
    }

    @Column(name = "agent_id")
    public Long getAgentId() {
        return agentId;
    }

    public void setAgentId(Long agentId) {
        this.agentId = agentId;
    }


    @Column(name = "telecom_name")
    public String getTelecomName() {
        return telecomName;
    }

    public void setTelecomName(String telecomName) {
        this.telecomName = telecomName;
    }

    @Column(name = "uni_id")
    public Long getUniId() {
        return UniId;
    }

    public void setUniId(Long uniId) {
        UniId = uniId;
    }
}
