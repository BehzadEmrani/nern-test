package com.atrosys.entity;

import javax.persistence.*;

/**
 * Created by mehdisabermahani on 6/14/17.
 * users active section.(do they access to admin or customer section)
 */

@Entity
@Table(name = "user_role")
public class UserRole {
    private Long roleId;
    private Long nationalId;
    private Integer validity;
    private Integer userRoleVal;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "role_id")
    public Long getRoleId() {
        return roleId;
    }

    public void setRoleId(Long roleId) {
        this.roleId = roleId;
    }

    @Column(name = "national_id")
    public Long getNationalId() {
        return nationalId;
    }

    public void setNationalId(Long nationalId) {
        this.nationalId = nationalId;
    }

    @Column(name = "validity")
    public Integer getValidity() {
        return validity;
    }

    public void setValidity(Integer validity) {
        this.validity = validity;
    }

    @Column(name = "user_role_val")
    public Integer getUserRoleVal() {
        return userRoleVal;
    }

    public void setUserRoleVal(Integer userRoleVal) {
        this.userRoleVal = userRoleVal;
    }
}