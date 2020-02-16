package com.atrosys.entity;

import javax.persistence.*;

/**
 * equipment instances can have some user defined parameters which saves here.
 */

@Entity
@Table(name = "equipment_parameter")
public class EquipmentParameter {
    private Long id;
    private String parameterName;
    private String unitName;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "parameter_name")
    public String getParameterName() {
        return parameterName;
    }

    public void setParameterName(String parameterName) {
        this.parameterName = parameterName;
    }

    @Column(name = "unit_name")
    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }
}
