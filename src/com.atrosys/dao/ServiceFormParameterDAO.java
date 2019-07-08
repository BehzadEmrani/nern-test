package com.atrosys.dao;

import com.atrosys.entity.ServiceFormParameter;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class ServiceFormParameterDAO {
    public static List<ServiceFormParameter> findAllServiceFormParameters() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from ServiceFormParameter");
        return (List<ServiceFormParameter>) query.getResultList();
    }


    public static ServiceFormParameter findServiceFormParameterById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ServiceFormParameter c where c.id=:id");
        query.setParameter("id", id);
        return (ServiceFormParameter) query.uniqueResult();
    }

    public static List<ServiceFormParameter> findServiceFormParameterByServiceFormId(long serviceFormId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ServiceFormParameter c where c.serviceFormId=:serviceFormId order by id  ");
        query.setParameter("serviceFormId", serviceFormId);
        return (List<ServiceFormParameter>) query.getResultList();
    }

    public static void delete(long id) throws Exception {
        ServiceFormParameter serviceFormParameter = new ServiceFormParameter();
        serviceFormParameter.setId(id);
        new HibernateUtil().delete(serviceFormParameter);
    }

    public static ServiceFormParameter save(ServiceFormParameter serviceFormParameter) throws Exception {
        return (ServiceFormParameter) new HibernateUtil().save(serviceFormParameter);
    }

    public static void deleteAllParameter(long serviceFormId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete ServiceFormParameter u where u.serviceFormId= :serviceFormId");
        query.setParameter("serviceFormId", serviceFormId);
        query.executeUpdate();
        transaction.commit();
    }

}
