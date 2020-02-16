package com.atrosys.entity;

import javax.persistence.*;

/**
 * sub services info(zir khedmat)
 */

@Entity
@Table(name = "sub_service")
public class SubService {
    private Long id;
    private Long serviceId;
    private Integer approveTypeVal;
    private String faName;
    private String enName;
    private String approveSessionNo;
    private String otherCostTitle;
    private String code;
    private String exclusiveTerms;
    private String slaMeasurement;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "fa_name")
    public String getFaName() {
        return faName;
    }

    public void setFaName(String faName) {
        this.faName = faName;
    }

    @Column(name = "en_name")
    public String getEnName() {
        return enName;
    }

    public void setEnName(String enName) {
        this.enName = enName;
    }

    @Column(name = "code")
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Column(name = "service_id")
    public Long getServiceId() {
        return serviceId;
    }

    public void setServiceId(Long serviceId) {
        this.serviceId = serviceId;
    }

    @Column(name = "approve_type_val")
    public Integer getApproveTypeVal() {
        return approveTypeVal;
    }

    public void setApproveTypeVal(Integer approveTypeVal) {
        this.approveTypeVal = approveTypeVal;
    }

    @Column(name = "approve_session_no")
    public String getApproveSessionNo() {
        return approveSessionNo;
    }

    public void setApproveSessionNo(String refSessionNo) {
        this.approveSessionNo = refSessionNo;
    }

    @Column(name = "cost_title")
    public String getOtherCostTitle() {
        return otherCostTitle;
    }

    public void setOtherCostTitle(String otherCostTitle) {
        this.otherCostTitle = otherCostTitle;
    }

    @Column(name = "exclusive_terms", length = 4000)
    public String getExclusiveTerms() {
        return exclusiveTerms;
    }

    public void setExclusiveTerms(String exclusiveTerms) {
        this.exclusiveTerms = exclusiveTerms;
    }

    @Column(name = "sla_measurement")
    public String getSlaMeasurement() {
        return slaMeasurement;
    }

    public void setSlaMeasurement(String slaMeasurement) {
        this.slaMeasurement = slaMeasurement;
    }
}
