package com.atrosys.entity;

import javax.persistence.*;

/**
 * type of port for an equipment.
 */

@Entity
@Table(name = "equipment_type_port")
public class EquipmentTypePort {
    private Long id;
    private Long equipmentTypeId;
    private Integer portNo;
    private Integer unitVal;
    private Double value;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "equipment_type_id")
    public Long getEquipmentTypeId() {
        return equipmentTypeId;
    }

    public void setEquipmentTypeId(Long equipmentTypeId) {
        this.equipmentTypeId = equipmentTypeId;
    }

    @Column(name = "port_no")
    public Integer getPortNo() {
        return portNo;
    }

    public void setPortNo(Integer portNo) {
        this.portNo = portNo;
    }

    @Column(name = "port_unit_val")
    public Integer getUnitVal() {
        return unitVal;
    }

    public void setUnitVal(Integer unitVal) {
        this.unitVal = unitVal;
    }

    @Column(name = "value")
    public Double getValue() {
        return value;
    }

    public void setValue(Double value) {
        this.value = value;
    }
}
