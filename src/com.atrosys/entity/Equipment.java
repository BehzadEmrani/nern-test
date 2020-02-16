package com.atrosys.entity;

import javax.persistence.*;

/**
 * equipment instances saves here.
 */

@Entity
@Table(name = "equipment")
public class Equipment {
    private Long id;
    private Long equipmentTypeId;
    private Boolean isShoaOwner;
    private String equipmentNo1;
    private String equipmentNo2;
    private String ownerName;
    private String serialNo;
    private String equipmentShoaNo;
    private String description;

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

    @Column(name = "serial_no")
    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    @Column(name = "shoa_owner")
    public Boolean getShoaOwner() {
        return isShoaOwner;
    }

    public void setShoaOwner(Boolean shoaOwner) {
        isShoaOwner = shoaOwner;
    }

    @Column(name = "equipment_shoa_no")
    public String getEquipmentShoaNo() {
        return equipmentShoaNo;
    }

    public void setEquipmentShoaNo(String equipmentShoaNo) {
        this.equipmentShoaNo = equipmentShoaNo;
    }

    @Column(name = "equipment_no1")
    public String getEquipmentNo1() {
        return equipmentNo1;
    }

    public void setEquipmentNo1(String equipmentNo1) {
        this.equipmentNo1 = equipmentNo1;
    }

    @Column(name = "equipment_no2")
    public String getEquipmentNo2() {
        return equipmentNo2;
    }

    public void setEquipmentNo2(String equipmentNo2) {
        this.equipmentNo2 = equipmentNo2;
    }

    @Column(name = "owner_name")
    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    @Column(name = "description",length = 4000)
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
