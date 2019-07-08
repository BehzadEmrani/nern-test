package com.atrosys.dao;

import com.atrosys.entity.News;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import java.util.ArrayList;

/**
 * Created by mehdisabermahani on 6/16/17.
 */
public class NewsDAO {
    public static final String TABLE_NAME = "news";

    public static News save(News news) throws Exception {
        return (News) new HibernateUtil().save(news);
    }

    public static ArrayList<News> findNewssInRange(int startIndex, int count, int dest) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT u FROM News u where u.newsDest=:dest order by u.date desc");
        query.setParameter("dest", dest);
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        return (ArrayList<News>) query.getResultList();
    }

    public static long getRowCount( int dest) throws Exception {
        Session session = SessionUtil.getSession();
        Criteria criteria = session.createCriteria(News.class);
        criteria.add(Restrictions.eq("docDest", dest));
        criteria.setProjection(Projections.rowCount());
        return (long) criteria.uniqueResult();
    }

}
