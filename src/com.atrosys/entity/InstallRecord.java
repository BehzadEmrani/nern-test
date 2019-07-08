package com.atrosys.entity;

import javax.persistence.*;

@Entity
@Table(name = "install_data")
public class InstallRecord {
    private Long id;
    private Long equipmentId;
    private Long telecomCenterId;
    private Long parentEquipmentId;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "equipment_id")
    public Long getEquipmentId() {
        return equipmentId;
    }

    public void setEquipmentId(Long equipmentId) {
        this.equipmentId = equipmentId;
    }

    @Column(name = "telecom_center_id")
    public Long getTelecomCenterId() {
        return telecomCenterId;
    }

    public void setTelecomCenterId(Long telecomCenterId) {
        this.telecomCenterId = telecomCenterId;
    }

    @Column(name = "parent_equipment_id")
    public Long getParentEquipmentId() {
        return parentEquipmentId;
    }

    public void setParentEquipmentId(Long parentEquipmentId) {
        this.parentEquipmentId = parentEquipmentId;
    }
}
