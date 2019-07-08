package com.atrosys.dao;

import com.atrosys.entity.Service;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class ServiceDAO {
    public static List<Service> findAllServices() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from Service");
        return (List<Service>) query.getResultList();
    }


    public static List<Service> findServicesByCatId(long categoryId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Service u where u.categoryId=:categoryId");
        query.setParameter("categoryId", categoryId);
        return (List<Service>) query.getResultList();
    }

    public static long findCatIdByServiceId(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.categoryId from Service u where u.id=:id");
        query.setParameter("id", id);
        return (long) query.uniqueResult();
    }

    public static Service findServiceById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from Service c where c.id=:id");
        query.setParameter("id", id);
        return (Service) query.uniqueResult();
    }

    public static void delete(long id) throws Exception {
        Service service = new Service();
        service.setId(id);
        new HibernateUtil().delete(service);
    }

    public static Service save(Service service) throws Exception {
        return (Service) new HibernateUtil().save(service);
    }

}
