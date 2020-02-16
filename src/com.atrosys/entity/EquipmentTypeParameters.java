package com.atrosys.entity;

import javax.persistence.*;

/**
 * each equipment for all instances in a type have some user defined parameters.
 */

@Entity
@Table(name = "equipment_type_parameters")
public class EquipmentTypeParameters {
    private Long id;
    private Long equipmentParameterId;
    private Long equipmentTypeId;
    private String amount;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "equipment_parameter_id")
    public Long getEquipmentParameterId() {
        return equipmentParameterId;
    }

    public void setEquipmentParameterId(Long equipmentParameterId) {
        this.equipmentParameterId = equipmentParameterId;
    }

    @Column(name = "equipment_type_id")
    public Long getEquipmentTypeId() {
        return equipmentTypeId;
    }

    public void setEquipmentTypeId(Long equipmentTypeId) {
        this.equipmentTypeId = equipmentTypeId;
    }

    @Column(name = "amount")
    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }
}
