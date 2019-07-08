package com.atrosys.dao;

import com.atrosys.entity.TelecomCenter;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class TelecomCenterDAO {
    public static List<TelecomCenter> findAllTelecomCenters() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenter u");
        return (List<TelecomCenter>) query.getResultList();
    }

    public static TelecomCenter findTelecomCenterById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenter u where u.id= :id ");
        query.setParameter("id", id);
        return (TelecomCenter) query.uniqueResult();
    }

    public static List<TelecomCenter> findTelecomCentersThatHaveInstallRecord() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenter u,InstallRecord i where i.telecomCenterId=u.id group by u.id");
        return (List<TelecomCenter>) query.getResultList();
    }

    public static List<TelecomCenter> findTelecomCentersByCityId(Long cityId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from TelecomCenter u where u.telCityId=:cityId");
        query.setParameter("cityId",cityId);
        return (List<TelecomCenter>) query.getResultList();
    }

    public static TelecomCenter save(TelecomCenter telecomCenter) throws Exception {
        return (TelecomCenter) new HibernateUtil().save(telecomCenter);
    }

    public static void delete(long id) throws Exception {
        TelecomCenter telecomCenter = new TelecomCenter();
        telecomCenter.setId(id);
        new HibernateUtil().delete(telecomCenter);
    }
}
