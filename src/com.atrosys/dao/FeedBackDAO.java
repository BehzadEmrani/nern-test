package com.atrosys.dao;

import com.atrosys.entity.FeedBack;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class FeedBackDAO {
    public static final String TABLE_NAME = "feed_back";

    public static List<FeedBack> findAllFeedBacksByAdminId(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from FeedBack u where u.adminId=:adminId order by timeStamp desc ");
        query.setParameter("adminId",adminId);
        return (List<FeedBack>) query.getResultList();
    }

    public static List<FeedBack> findAllFeedBacks() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from FeedBack order by timeStamp desc ");
        return (List<FeedBack>) query.getResultList();
    }

    public static byte[] findFeedBackFileById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.attachedFile from FeedBack u where u.id=:id");
        query.setParameter("id", id);
        return (byte[]) query.uniqueResult();
    }

    public static FeedBack findFeedBackById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from FeedBack u where u.id=:id");
        query.setParameter("id", id);
        return (FeedBack) query.uniqueResult();
    }

    public static FeedBack save(FeedBack feedBack) throws Exception {
        return (FeedBack) new HibernateUtil().save(feedBack);
    }
}
