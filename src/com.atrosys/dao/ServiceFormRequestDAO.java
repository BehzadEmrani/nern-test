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

/**
 * Created by Misagh Dayer on 3/11/19.
 */

public class ServiceFormRequestDAO {
    public static List<ServiceFormRequest> findAllServiceFormRequests() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from ServiceFormRequest s where  s.active=true");
        return (List<ServiceFormRequest>) query.getResultList();
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


        Query query = session.createQuery("select r from ServiceFormRequest r inner join University u on r.uniId=u.uniNationalId inner join City c on u.cityId = c.cityId inner join State s on s.stateId=u.stateId " +
                "inner join ServiceFormParameter seviceFormParameter on r.serviceFormParameterId=seviceFormParameter.id inner join ServiceForm serviceForm on seviceFormParameter.serviceFormId=serviceForm.id " +
                "inner join SubService subService on serviceForm.subServiceId=subService.id " +
                QueryBuilder.buildWhereQuery(prList, true));
        return (List<ServiceFormRequest>) query.getResultList();
    }

    public static void delete(long id) throws Exception {
        ServiceFormRequest serviceFormRequest = new ServiceFormRequest();
        serviceFormRequest.setId(id);
        serviceFormRequest.setActive(false);
        save(serviceFormRequest);
    }

    public static ServiceFormRequest save(ServiceFormRequest serviceFormRequest) throws Exception {
        return (ServiceFormRequest) new HibernateUtil().save(serviceFormRequest);
    }
}
