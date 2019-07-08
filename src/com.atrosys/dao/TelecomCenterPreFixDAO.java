package com.atrosys.dao;

import com.atrosys.entity.TelecomCenterPreFix;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class TelecomCenterPreFixDAO {
    public static List<TelecomCenterPreFix> findAllTelecomCenterPreFixs() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenterPreFix u");
        return (List<TelecomCenterPreFix>) query.getResultList();
    }

    public static List<TelecomCenterPreFix> findAllTelecomCenterPreFixsDesc() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenterPreFix u order by u.id desc ");
        return (List<TelecomCenterPreFix>) query.getResultList();
    }

    public static TelecomCenterPreFix findTelecomCenterPreFixByid(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenterPreFix u where u.id= :id ");
        query.setParameter("id", id);
        return (TelecomCenterPreFix) query.uniqueResult();
    }

    public static List<TelecomCenterPreFix>findTelecomCenterPreFixByTelecomId(long telecomCenterId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenterPreFix u where u.telecomCenterId=:telecomCenterId");
        query.setParameter("telecomCenterId", telecomCenterId);
        return ( List<TelecomCenterPreFix>) query.getResultList();
    }

    public static List<TelecomCenterPreFix>findTelecomCenterPreFixByTelecomIdDesc(long telecomCenterId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenterPreFix u where u.telecomCenterId=:telecomCenterId order by u.id");
        query.setParameter("telecomCenterId", telecomCenterId);
        return ( List<TelecomCenterPreFix>) query.getResultList();
    }

    public static TelecomCenterPreFix save(TelecomCenterPreFix telecomCenterPreFix) throws Exception {
        return (TelecomCenterPreFix) new HibernateUtil().save(telecomCenterPreFix);
    }

    public static void delete(long id) throws Exception {
        TelecomCenterPreFix telecomCenterPreFix = new TelecomCenterPreFix();
        telecomCenterPreFix.setId(id);
        new HibernateUtil().delete(telecomCenterPreFix);
    }

    public static void deleteAllPrefixes(long telecomCenterId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete TelecomCenterPreFix u where u.telecomCenterId= :telecomCenterId");
        query.setParameter("telecomCenterId", telecomCenterId);
        query.executeUpdate();
        transaction.commit();
    }
}
