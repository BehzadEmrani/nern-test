package com.atrosys.entity;

import com.atrosys.model.SLAType;

import javax.persistence.*;

/**
 * sub service SLA standard.
 */

@Entity
@Table(name = "sub_service_parameter")
public class SubServiceParameter {
    private Long id;
    private Long subServiceId;
    private Double bronzeValue;
    private Double silverValue;
    private Double goldValue;
    private Double diamondValue;
    private Integer unitVal;
    private String faName;

    public Double valueBySLAVal(int slaVal) throws Exception {
        switch (SLAType.fromValue(slaVal)) {
            case BRONZE:
                return bronzeValue;
            case SILVER:
                return silverValue;
            case GOLD:
                return goldValue;
            case DIAMOND:
                return diamondValue;
            default:
                return null;
        }
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "fa_name")
    public String getFaName() {
        return faName;
    }

    public void setFaName(String faName) {
        this.faName = faName;
    }

    @Column(name = "sub_service_id")
    public Long getSubServiceId() {
        return subServiceId;
    }

    public void setSubServiceId(Long subServiceId) {
        this.subServiceId = subServiceId;
    }

    @Column(name = "unit_val")
    public Integer getUnitVal() {
        return unitVal;
    }

    public void setUnitVal(Integer unitVal) {
        this.unitVal = unitVal;
    }


    @Column(name = "bronze_value")
    public Double getBronzeValue() {
        return bronzeValue;
    }

    public void setBronzeValue(Double bronzeValue) {
        this.bronzeValue = bronzeValue;
    }

    @Column(name = "silver_value")
    public Double getSilverValue() {
        return silverValue;
    }

    public void setSilverValue(Double silverValue) {
        this.silverValue = silverValue;
    }

    @Column(name = "gold_value")
    public Double getGoldValue() {
        return goldValue;
    }

    public void setGoldValue(Double goldValue) {
        this.goldValue = goldValue;
    }

    @Column(name = "diamond_value")
    public Double getDiamondValue() {
        return diamondValue;
    }

    public void setDiamondValue(Double diamondValue) {
        this.diamondValue = diamondValue;
    }
}
