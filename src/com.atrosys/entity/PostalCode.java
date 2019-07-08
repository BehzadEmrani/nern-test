package com.atrosys.entity;

import javax.persistence.*;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
@Entity
@Table(name = "postal_code")
public class PostalCode {
    private Long id;
    private Long cityId;
    private Long startCode;
    private Long endCode;

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

    @Column(name = "start_code")
    public Long getStartCode() {
        return startCode;
    }

    public void setStartCode(Long startCode) {
        this.startCode = startCode;
    }

    @Column(name = "end_code")
    public Long getEndCode() {
        return endCode;
    }

    public void setEndCode(Long endCode) {
        this.endCode = endCode;
    }
}
