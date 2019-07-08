package com.atrosys.dao;


import com.atrosys.entity.ServiceFormRequest;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

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

    public static void delete(long id) throws Exception {
        ServiceFormRequest serviceFormRequest = new ServiceFormRequest();
        serviceFormRequest.setId(id);
        new HibernateUtil().delete(serviceFormRequest);
    }

    public static ServiceFormRequest save(ServiceFormRequest serviceFormRequest) throws Exception {
        return (ServiceFormRequest) new HibernateUtil().save(serviceFormRequest);
    }
}
