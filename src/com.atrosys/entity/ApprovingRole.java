package com.atrosys.entity;

import javax.persistence.*;

@Entity
@Table(name = "approving_role")
public class ApprovingRole {
    private Long id;
    private Long uniId;
    private Long stateId;
    private Integer subSystemVal;
    private Integer subSystemTypeVal;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "uni_id")
    public Long getUniId() {
        return uniId;
    }

    public void setUniId(Long uniId) {
        this.uniId = uniId;
    }

    @Column(name = "state_id")
    public Long getStateId() {
        return stateId;
    }

    public void setStateId(Long stateId) {
        this.stateId = stateId;
    }

    @Column(name = "sub_system_val")
    public Integer getSubSystemVal() {
        return subSystemVal;
    }

    public void setSubSystemVal(Integer subSystemVal) {
        this.subSystemVal = subSystemVal;
    }

    @Column(name = "uni_type_val")
    public Integer getSubSystemTypeVal() {
        return subSystemTypeVal;
    }

    public void setSubSystemTypeVal(Integer uniTypeVal) {
        this.subSystemTypeVal = uniTypeVal;
    }
}
