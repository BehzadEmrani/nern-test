package com.atrosys.model;

import com.atrosys.entity.ServiceFormRequest;
import com.atrosys.entity.University;

/**
 * Created by met on 2/3/18.
 * POJO class which contain data of contract table row.
 */

public class ServiceContractTableRecord {
    ServiceFormRequest serviceFormRequest;
    University subUni;
    ServiceContractTableRecordType serviceContractTableRecordType;

    public ServiceFormRequest getServiceFormRequest() {
        return serviceFormRequest;
    }

    public void setServiceFormRequest(ServiceFormRequest serviceFormRequest) {
        this.serviceFormRequest = serviceFormRequest;
    }

    public ServiceContractTableRecordType getServiceContractTableRecordType() {
        return serviceContractTableRecordType;
    }

    public void setServiceContractTableRecordType(ServiceContractTableRecordType serviceContractTableRecordType) {
        this.serviceContractTableRecordType = serviceContractTableRecordType;
    }

    public University getSubUni() {
        return subUni;
    }

    public void setSubUni(University subUni) {
        this.subUni = subUni;
    }
}
