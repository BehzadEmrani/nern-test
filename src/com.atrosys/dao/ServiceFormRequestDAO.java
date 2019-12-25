package com.atrosys.dao;


import com.atrosys.entity.ServiceForm;
import com.atrosys.entity.ServiceFormRequest;
import com.atrosys.model.ServiceFormReqestModel;
import com.atrosys.model.ServiceFormRequestDocType;
import com.atrosys.model.ServiceFormRequestStatus;
import com.atrosys.util.*;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.sql.Date;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Misagh Dayer on 3/11/19.
 */

public class ServiceFormRequestDAO {
    public static List<ServiceFormRequest> findAllServiceFormRequests() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from ServiceFormRequest s where  s.active=true");
        return (List<ServiceFormRequest>) query.getResultList();
    }

    public static  boolean findServiceFormRequestObjectsNotEmpty(int docType, Long id) throws  Exception {
        Session session = SessionUtil.getSession();
        String str="";
        switch (ServiceFormRequestDocType.fromValue(docType)) {
            case FINAL_SIGNED_FORM:
                str = " and length(s.finalSignedForm)>0";
                break;
            case LETTER:
                str = " and length(s.letter)>0";
                break;
            case SIGNED_FORM:
                str = " and length(s.signedForm)>0";
                break;
            case POST_RECEIPT:
                str = " and length(s.postReceipt)>0";
                break;
        }

        str = str + " and s.id = " + id;

        Query query = session.createQuery("select s.id from ServiceFormRequest s where s.active=true" + str);
        List list = query.getResultList();
        return !list.isEmpty();
    }

    public static List<ServiceFormReqestModel> findAllServiceFormRequestModels() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select s.id, u.uniName, sf, s.statusVal, s.serviceFormContractNo, s.subscriptionDate from ServiceFormRequest s inner join University u on s.uniId=u.id " +
                "inner join ServiceFormParameter sfp on s.serviceFormParameterId=sfp.id inner join ServiceForm sf on sfp.serviceFormId=sf.id where s.active=true and u.active=true");

        List list = query.getResultList();
        List<ServiceFormReqestModel> result = new LinkedList<>();

        for (int i=0; i<list.size(); i++) {
            Object[] sub = (Object[]) list.get(i);
            ServiceFormReqestModel model = new ServiceFormReqestModel();
            ServiceForm serviceForm = new ServiceForm();

            model.setId((Long) sub[0]);
            model.setUniName((String) sub[1]);
            serviceForm = (ServiceForm) sub[2];
            model.setTitle(serviceForm.faCombine());
            model.setStatus(ServiceFormRequestStatus.fromValue((int) sub[3]).getFaStr());
            String contractNo="تعیین نشده";
            if (sub[4]!= null) {
                contractNo = (String) sub[4];
            }
            model.setServiceFormContractNo(contractNo);

            String subsDate = "نامشخص";
            if (sub[5] != null) {
                subsDate = Util.convertGregorianToJalali((Date) sub[5]);
            }
            model.setSubscriptionDate(subsDate);

            model.setExampleForm(true);
            model.setSignedForm(findServiceFormRequestObjectsNotEmpty(ServiceFormRequestDocType.SIGNED_FORM.getValue(),(Long) sub[0]));
            model.setFinalSignedForm(findServiceFormRequestObjectsNotEmpty(ServiceFormRequestDocType.FINAL_SIGNED_FORM.getValue(),(Long) sub[0]));
            model.setLetter(findServiceFormRequestObjectsNotEmpty(ServiceFormRequestDocType.LETTER.getValue(),(Long) sub[0]));
            model.setPostReceipt(findServiceFormRequestObjectsNotEmpty(ServiceFormRequestDocType.POST_RECEIPT.getValue(),(Long) sub[0]));
            result.add(model);
        }

        return result;
    }

    public static ServiceFormRequest findServiceFormRequestById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ServiceFormRequest c where c.id=:id and c.active=true");
        query.setParameter("id", id);
        return (ServiceFormRequest) query.uniqueResult();
    }

    public static List<ServiceFormRequest> findServiceFormRequestByUniId(
            long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ServiceFormRequest c where c.uniId=:uniId and c.active=true");
        query.setParameter("uniId", uniId);
        return (List<ServiceFormRequest>) query.getResultList();
    }

    public static Integer findServiceFormRequestCountByUniId(
            long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c.id from ServiceFormRequest c where c.uniId=:uniId and c.active=true");
        query.setParameter("uniId", uniId);
        return query.getResultList().size();
    }

    public static List<ServiceFormRequest> filterServiceFormRequestByUniId(
            String uniName, String stateName, String cityName , String serviceId, String status) throws Exception {
        Session session = SessionUtil.getSession();
        List<QueryParameter> prList = new LinkedList<>();
        prList.add(new QueryParameter("u.uniName", String.valueOf(uniName), "%"));
        prList.add(new QueryParameter("u.active","true", "="));
        prList.add(new QueryParameter("s.name", stateName, "%"));
        prList.add(new QueryParameter("c.name", cityName, "%"));
        prList.add(new QueryParameter("subService.serviceId", serviceId, "="));
        prList.add(new QueryParameter("r.statusVal", status, "="));
        prList.add(new QueryParameter("r.active", "true", "="));


        Query query = session.createQuery("select r.id, r.serviceFormContractDate, r.serviceFormContractNo, r.serviceFormParameterId, r.subsBuildingId, r.subscriptionContractNo, r.subscriptionDate, r.uniId, r.statusVal, r.active from ServiceFormRequest r inner join University u on r.uniId=u.uniNationalId inner join City c on u.cityId = c.cityId inner join State s on s.stateId=u.stateId " +
                "inner join ServiceFormParameter seviceFormParameter on r.serviceFormParameterId=seviceFormParameter.id inner join ServiceForm serviceForm on seviceFormParameter.serviceFormId=serviceForm.id " +
                "inner join SubService subService on serviceForm.subServiceId=subService.id " +
                QueryBuilder.buildWhereQuery(prList, true));
        List list = (List<ServiceFormRequest>) query.getResultList();
        List<ServiceFormRequest> output = new LinkedList<>();
        for (int i=0; i<list.size(); i++) {
            Object[] sub = (Object[]) list.get(i);
            ServiceFormRequest serviceFormRequest = new ServiceFormRequest();
            serviceFormRequest.setId((Long) sub[0]);
            serviceFormRequest.setServiceFormContractDate((Date) sub[1]);
            serviceFormRequest.setServiceFormContractNo((String) sub[2]);
            serviceFormRequest.setServiceFormParameterId((Long) sub[3]);
            serviceFormRequest.setSubsBuildingId((Long) sub[4]);
            serviceFormRequest.setSubscriptionContractNo((String) sub[5]);
            serviceFormRequest.setSubscriptionDate((Date) sub[6]);
            serviceFormRequest.setUniId((Long) sub[7]);
            serviceFormRequest.setStatusVal((Integer) sub[8]);
            serviceFormRequest.setActive((boolean) sub[9]);
            output.add(serviceFormRequest);
        }
        return output;
    }

    public static void delete(long id) throws Exception {
        ServiceFormRequest serviceFormRequest = findServiceFormRequestById(id);
        serviceFormRequest.setActive(false);
        save(serviceFormRequest);
    }

    public static ServiceFormRequest save(ServiceFormRequest serviceFormRequest) throws Exception {
        return (ServiceFormRequest) new HibernateUtil().save(serviceFormRequest);
    }
}
