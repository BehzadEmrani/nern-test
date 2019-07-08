package com.atrosys.entity;

import javax.persistence.*;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
@Entity
@Table(name = "pre_university_data")
public class PreUniversityData {
    private Long id;
    private Integer uniSourceType;
    private Long uniInternalCode;
    private String address;
    private String name;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "source_val")
    public Integer getUniSourceType() {
        return uniSourceType;
    }

    public void setUniSourceType(Integer uniSourceType) {
        this.uniSourceType = uniSourceType;
    }

    @Column(name = "uni_internal_code")
    public Long getUniInternalCode() {
        return uniInternalCode;
    }

    public void setUniInternalCode(Long uniInternalCode) {
        this.uniInternalCode = uniInternalCode;
    }

    @Column(name = "address")
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Column(name = "name")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
