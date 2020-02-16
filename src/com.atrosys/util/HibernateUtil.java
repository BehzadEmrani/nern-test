package com.atrosys.util;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.LinkedList;
import java.util.List;


/**
 * hibernate jquery builder util.
 */

public class HibernateUtil {


    public Session getSession() {
        return SessionUtil.getSession();
    }

    public  Object getOneRow(Query query) throws Exception{
        query.setMaxResults(1);
        List list = query.list();
        if (list!=null && !list.isEmpty())
            return list.get(0);
        else
            return null;
    }

    public  Object findById(Class aClass, Long id) throws Exception{
        Object obj;
        Session session = getSession();
        try {
            obj = session.get(aClass, id);
        } finally {
            session.close();
        }
        return obj;
    }

    public  Object findBypassword(Class aClass, String password) throws Exception{
        Object obj;
        Session session = getSession();
        try {
            obj = session.get(aClass, password);
        } finally {
            session.close();
        }
        return obj;
    }
    public  List findAll(String entityClassName, String orderByColumn) throws Exception{
        List result = new LinkedList();
        Session session = getSession();
        try {
            Query query = session.createQuery("from "+entityClassName+" t order by t." + orderByColumn);
            result = query.list();
        } finally {
            session.close();
        }
        return result;
    }

    public  Object save(Object obj) throws Exception{
        Session session = getSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.saveOrUpdate(obj);

            tx.commit();
        } catch (Exception e) {
            if (tx != null)
                tx.rollback();
            throw e;
        } finally {
            session.close();
        }

        return obj;
    }

    public  Object update(Object obj) throws Exception {
        Session session = getSession();
        Transaction tx = null;

        try {
            tx = session.beginTransaction();
            session.update((obj));

            tx.commit();
        } catch (Exception e) {
            if (tx != null)
                tx.rollback();
            throw e;
        } finally {
            session.close();
        }

        return obj;
    }
    public  void  delete(Object obj) throws Exception{
        Session session = getSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.delete(obj);

            tx.commit();
        } catch (Exception e) {
            if (tx != null)
                tx.rollback();
            throw e;
        } finally {

            session.close();
        }


    }

    public  List findListByCondition(String entityClassName, String entityAlias, String orderByColumn, String hqlCondition, List values, boolean oneResult) throws Exception{
        List result = new LinkedList();
        Session session = getSession();
        try {
            Query query = session.createQuery(new StringBuilder().append("from ").append(entityClassName).append(" ").append(entityAlias).append(" where ").append(hqlCondition).append(" order by ").append(entityAlias).append(".").append(orderByColumn).toString());
            for (int i=0; i<values.size(); i++)
                query.setParameter(i, values.get(i));
            if (oneResult)
                query.setMaxResults(1);
            result = query.list();
        } finally {
            session.close();
        }
        return result;
    }

    public  Object findObjectByCondition(String entityClassName, String entityAlias, String orderByColumn, String hqlCondition, List values) throws Exception{
        List list = findListByCondition(entityClassName, entityAlias, orderByColumn, hqlCondition, values, true);
        if (list!=null && !list.isEmpty())
            return list.get(0);
        else
            return null;
    }
}
