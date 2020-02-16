package com.atrosys.entity;

import javax.persistence.*;

/**
 * Admin and manager permissions data.
 */

@Entity
@Table(name = "admin_access")
public class AdminAccess {
    private Long id;
    private Long adminId;
    private Integer accessVal;
    private Integer subAccessVal;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "admin_id")
    public Long getAdminId() {
        return adminId;
    }

    public void setAdminId(Long adminId) {
        this.adminId = adminId;
    }

    @Column(name = "access_val")
    public Integer getAccessVal() {
        return accessVal;
    }

    public void setAccessVal(Integer accessVal) {
        this.accessVal = accessVal;
    }

    @Column(name = "sub_access_val")
    public Integer getSubAccessVal() {
        return subAccessVal;
    }

    public void setSubAccessVal(Integer subAccessVal) {
        this.subAccessVal = subAccessVal;
    }
}
