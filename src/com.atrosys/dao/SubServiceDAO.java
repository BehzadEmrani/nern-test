package com.atrosys.dao;

import com.atrosys.entity.SubService;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class SubServiceDAO {
    public static List<SubService> findAllSubServices() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from SubService");
        return (List<SubService>) query.getResultList();
    }


    public static SubService findSubServiceById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from SubService c where c.id=:id");
        query.setParameter("id", id);
        return (SubService) query.uniqueResult();
    }

    public static List<SubService>findSubServiceByServiceId(long serviceId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from SubService c where c.serviceId=:serviceId");
        query.setParameter("serviceId", serviceId);
        return (List<SubService>) query.getResultList();
    }



    public static void delete(long id) throws Exception {
        SubService subService= new SubService();
        subService.setId(id);
        new HibernateUtil().delete(subService);
    }
    public static SubService save(SubService subService) throws Exception {
        return (SubService) new HibernateUtil().save(subService);
    }

}
