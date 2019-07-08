package com.atrosys.entity;

import javax.persistence.*;

@Entity
@Table(name = "equipment_type")
public class EquipmentType {
    private Long id;
    private Integer typeVal;
    private Boolean isIranManufactured;
    private String name;
    private String partNumber;
    private String manufacturer;
    private Integer electronicSourceVal;
    private Integer ampere;
    private Integer watt;
    private Integer capacity;
    private Integer capacityUse;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "type_val")
    public Integer getTypeVal() {
        return typeVal;
    }

    public void setTypeVal(Integer typeVal) {
        this.typeVal = typeVal;
    }

    @Column(name = "iran_manufactured")
    public Boolean getIranManufactured() {
        return isIranManufactured;
    }

    public void setIranManufactured(Boolean iranManufactured) {
        isIranManufactured = iranManufactured;
    }

    @Column(name = "name")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "part_number")
    public String getPartNumber() {
        return partNumber;
    }

    public void setPartNumber(String partNumber) {
        this.partNumber = partNumber;
    }

    @Column(name = "manufacturer")
    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }


    @Column(name = "electronic_source_val")
    public Integer getElectronicSourceVal() {
        return electronicSourceVal;
    }

    public void setElectronicSourceVal(Integer elecSourceVal) {
        this.electronicSourceVal = elecSourceVal;
    }

    @Column(name = "ampere")
    public Integer getAmpere() {
        return ampere;
    }

    public void setAmpere(Integer ampere) {
        this.ampere = ampere;
    }

    @Column(name = "watt")
    public Integer getWatt() {
        return watt;
    }

    public void setWatt(Integer watt) {
        this.watt = watt;
    }

    @Column(name = "capacity")
    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    @Column(name = "capacity_use")
    public Integer getCapacityUse() {
        return capacityUse;
    }

    public void setCapacityUse(Integer capacityUse) {
        this.capacityUse = capacityUse;
    }
}
