package com.atrosys.entity;

import javax.persistence.*;

/**
 * telecom centers info
 */

@Entity
@Table(name = "telecom_center")
public class TelecomCenter {
    private Long id;
    private Long telCityId;
    private Integer type;
    private String name;
    private String address;
    private String centerAgentName;
    private String centerTel;
    private Double centerLat;
    private Double centerLng;


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    @Column(name = "name")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "center_agent_name")
    public String getCenterAgentName() {
        return centerAgentName;
    }

    public void setCenterAgentName(String centerAgentName) {
        this.centerAgentName = centerAgentName;
    }

    @Column(name = "center_tel")
    public String getCenterTel() {
        return centerTel;
    }

    public void setCenterTel(String centerTel) {
        this.centerTel = centerTel;
    }

    @Column(name = "type")
    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    @Column(name = "address")
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }


    @Column(name = "center_lat")
    public Double getCenterLat() {
        return centerLat;
    }

    public void setCenterLat(Double centerLat) {
        this.centerLat = centerLat;
    }

    @Column(name = "center_lng")
    public Double getCenterLng() {
        return centerLng;
    }

    public void setCenterLng(Double centerLng) {
        this.centerLng = centerLng;
    }
    @Column(name = "tel_city_id")
    public Long getTelCityId() {
        return telCityId;
    }

    public void setTelCityId(Long telCityId) {
        this.telCityId = telCityId;
    }
}
