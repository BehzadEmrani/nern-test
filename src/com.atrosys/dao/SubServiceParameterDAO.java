package com.atrosys.dao;

import com.atrosys.entity.SubServiceParameter;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class SubServiceParameterDAO {
    public static List<SubServiceParameter> findAllSubServiceParameters() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from SubServiceParameter");
        return (List<SubServiceParameter>) query.getResultList();
    }


    public static SubServiceParameter findSubServiceParameterById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from SubServiceParameter c where c.id=:id");
        query.setParameter("id", id);
        return (SubServiceParameter) query.uniqueResult();
    }

    public static List<SubServiceParameter> findSubServiceParameterBySubServiceId(long subServiceId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from SubServiceParameter c where c.subServiceId=:subServiceId order by id  ");
        query.setParameter("subServiceId", subServiceId);
        return (List<SubServiceParameter>) query.getResultList();
    }

    public static void delete(long id) throws Exception {
        SubServiceParameter subServiceParameter = new SubServiceParameter();
        subServiceParameter.setId(id);
        new HibernateUtil().delete(subServiceParameter);
    }

    public static SubServiceParameter save(SubServiceParameter subServiceParameter) throws Exception {
        return (SubServiceParameter) new HibernateUtil().save(subServiceParameter);
    }

    public static void deleteAllParameter(long subServiceId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete SubServiceParameter u where u.subServiceId= :subServiceId");
        query.setParameter("subServiceId", subServiceId);
        query.executeUpdate();
        transaction.commit();
    }

}
