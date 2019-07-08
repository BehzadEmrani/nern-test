package com.atrosys.dao;

import com.atrosys.entity.ServiceCategory;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class ServiceCategoryDAO {
    public static List<ServiceCategory> findAllCats() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from ServiceCategory");
        return (List<ServiceCategory>) query.getResultList();
    }


    public static ServiceCategory findServiceCategoryById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ServiceCategory c where c.id=:id");
        query.setParameter("id", id);
        return (ServiceCategory) query.uniqueResult();
    }

    public static void delete(long id) throws Exception {
        ServiceCategory serviceCategory = new ServiceCategory();
        serviceCategory.setId(id);
        new HibernateUtil().delete(serviceCategory);
    }

    public static ServiceCategory save(ServiceCategory serviceCategory) throws Exception {
        return (ServiceCategory) new HibernateUtil().save(serviceCategory);
    }

}
