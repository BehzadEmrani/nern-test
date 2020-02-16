package com.atrosys.entity;

import javax.persistence.*;

/**
 * service form contracts details
 */

@Entity
@Table(name = "service_form_parameter")
public class ServiceFormParameter {
    private Long id;
    private Long serviceFormId;
    private String code;
    private String specs;
    private Long deposit;
    private Long warranty;
    private Long initialCost;
    private Long periodicPayment;
    private Long otherCost;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "code")
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Column(name = "specs")
    public String getSpecs() {
        return specs;
    }

    public void setSpecs(String specs) {
        this.specs = specs;
    }

    @Column(name = "deposit")
    public Long getDeposit() {
        return deposit;
    }

    public void setDeposit(Long deposit) {
        this.deposit = deposit;
    }

    @Column(name = "warranty")
    public Long getWarranty() {
        return warranty;
    }

    public void setWarranty(Long warranty) {
        this.warranty = warranty;
    }

    @Column(name = "initial_cost")
    public Long getInitialCost() {
        return initialCost;
    }

    public void setInitialCost(Long initialCost) {
        this.initialCost = initialCost;
    }

    @Column(name = "periodic_payment")
    public Long getPeriodicPayment() {
        return periodicPayment;
    }

    public void setPeriodicPayment(Long periodicPayment) {
        this.periodicPayment = periodicPayment;
    }

    @Column(name = "other_cost")
    public Long getOtherCost() {
        return otherCost;
    }

    public void setOtherCost(Long otherCost) {
        this.otherCost = otherCost;
    }

    @Column(name = "service_form_id")
    public Long getServiceFormId() {
        return serviceFormId;
    }

    public void setServiceFormId(Long serviceFormId) {
        this.serviceFormId = serviceFormId;
    }
}
