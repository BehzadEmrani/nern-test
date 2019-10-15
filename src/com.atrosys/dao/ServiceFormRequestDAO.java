package com.atrosys.dao;


import com.atrosys.entity.ServiceFormRequest;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.QueryBuilder;
import com.atrosys.util.QueryParameter;
import com.atrosys.util.SessionUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.LinkedList;
import java.util.List;

public class ServiceFormRequestDAO {
    public static List<ServiceFormRequest> findAllServiceFormRequests() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from ServiceFormRequest");
        return (List<ServiceFormRequest>) query.getResultList();
    }


    public static ServiceFormRequest findServiceFormRequestById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ServiceFormRequest c where c.id=:id");
        query.setParameter("id", id);
        return (ServiceFormRequest) query.uniqueResult();
    }

    public static List<ServiceFormRequest> findServiceFormRequestByUniId(
            long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ServiceFormRequest c where c.uniId=:uniId");
        query.setParameter("uniId", uniId);
        return (List<ServiceFormRequest>) query.getResultList();
    }

    public static List<ServiceFormRequest> filterServiceFormRequestByUniId(
            String uniName, String stateName, String cityName , String serviceId, String status) throws Exception {
        Session session = SessionUtil.getSession();List<QueryParameter> prList = new LinkedList<>();
        prList.add(new QueryParameter("u.uniName", String.valueOf(uniName), "%"));
        prList.add(new QueryParameter("s.name", stateName, "%"));
        prList.add(new QueryParameter("c.name", cityName, "%"));
        prList.add(new QueryParameter("subService.serviceId", serviceId, "="));
        prList.add(new QueryParameter("r.statusVal", status, "="));


        Query query = session.createQuery("select r from ServiceFormRequest r inner join University u on r.uniId=u.uniNationalId inner join City c on u.cityId = c.cityId inner join State s on s.stateId=u.stateId " +
                "inner join ServiceFormParameter seviceFormParameter on r.serviceFormParameterId=seviceFormParameter.id inner join ServiceForm serviceForm on seviceFormParameter.serviceFormId=serviceForm.id " +
                "inner join SubService subService on serviceForm.subServiceId=subService.id " +
                QueryBuilder.buildWhereQuery(prList, true));
        return (List<ServiceFormRequest>) query.getResultList();
    }

    public static void delete(long id) throws Exception {
        ServiceFormRequest serviceFormRequest = new ServiceFormRequest();
        serviceFormRequest.setId(id);
        new HibernateUtil().delete(serviceFormRequest);
    }

    public static ServiceFormRequest save(ServiceFormRequest serviceFormRequest) throws Exception {
        return (ServiceFormRequest) new HibernateUtil().save(serviceFormRequest);
    }
}
