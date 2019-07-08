package com.atrosys.entity;

import com.atrosys.dao.ServiceCategoryDAO;
import com.atrosys.dao.ServiceDAO;
import com.atrosys.dao.SubServiceDAO;
import com.atrosys.model.PayPeriod;
import com.atrosys.model.PayType;
import com.atrosys.model.SLAType;
import com.atrosys.model.SubsDuration;

import javax.persistence.*;

@Entity
@Table(name = "service_form")
public class ServiceForm {
    private Long id;
    private Long subServiceId;
    private Integer slaVal;
    private Integer payTypeVal;
    private Integer subsDuration;
    private Integer payPeriod;
    private String otherTerms;
    private String version;
    private Boolean active;

    public String combine() throws Exception {
        SubService subService = SubServiceDAO.findSubServiceById(subServiceId);
        Service service = ServiceDAO.findServiceById(subService.getServiceId());
        ServiceCategory serviceCat = ServiceCategoryDAO.findServiceCategoryById(service.getCategoryId());
        return serviceCat.getCode()+"-"+service.getCode()+SLAType.fromValue(slaVal).getAbbrStr()+"-"
                +subService.getCode()+"-"+PayType.fromValue(payTypeVal).getAbbreStr()+"-"
                +SubsDuration.fromValue(subsDuration).getAbbreStr()+PayPeriod.fromValue(payPeriod).getAbbreStr()
                +"-"+version;
    }

    public String faCombine() throws Exception {
        SubService subService = SubServiceDAO.findSubServiceById(subServiceId);
        Service service = ServiceDAO.findServiceById(subService.getServiceId());
        ServiceCategory serviceCat = ServiceCategoryDAO.findServiceCategoryById(service.getCategoryId());
        return subService.getFaName()+"\n"+SLAType.fromValue(slaVal).getFaStr()+"-"
                +PayType.fromValue(payTypeVal).getFaStr()+"-"+SubsDuration.fromValue(subsDuration).getFaStr()+"-"+PayPeriod.fromValue(payPeriod).getFaStr();
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "sub_service_id")
    public Long getSubServiceId() {
        return subServiceId;
    }

    public void setSubServiceId(Long subServiceId) {
        this.subServiceId = subServiceId;
    }

    @Column(name = "other_terms", length = 4000)
    public String getOtherTerms() {
        return otherTerms;
    }

    public void setOtherTerms(String otherTerms) {
        this.otherTerms = otherTerms;
    }

    @Column(name = "sla_val")
    public Integer getSlaVal() {
        return slaVal;
    }

    public void setSlaVal(Integer slaVal) {
        this.slaVal = slaVal;
    }

    @Column(name = "pay_type_val")
    public Integer getPayTypeVal() {
        return payTypeVal;
    }

    public void setPayTypeVal(Integer payTypeVal) {
        this.payTypeVal = payTypeVal;
    }

    @Column(name = "pay_period")
    public Integer getPayPeriod() {
        return payPeriod;
    }

    public void setPayPeriod(Integer payPeriod) {
        this.payPeriod = payPeriod;
    }

    @Column(name = "subs_duration")
    public Integer getSubsDuration() {
        return subsDuration;
    }

    public void setSubsDuration(Integer subsDuration) {
        this.subsDuration = subsDuration;
    }

    @Column(name = "version")
    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    @Column(name = "active")
    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }
}