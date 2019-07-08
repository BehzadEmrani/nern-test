package com.atrosys.dao;

import com.atrosys.entity.InfoDoc;
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
public class InfoDocDAO {
    public static final String TABLE_NAME = "info_doc";

    public static InfoDoc save(InfoDoc infoDoc) throws Exception {
        return (InfoDoc) new HibernateUtil().save(infoDoc);
    }

    public static ArrayList<InfoDoc> findInfoDocsInRange(int startIndex, int count, int dest) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT u FROM InfoDoc u where u.docDest=:dest order by u.pubDate desc ");
        query.setParameter("dest", dest);
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        return (ArrayList<InfoDoc>) query.getResultList();
    }

    public static long getRowCount( int dest) throws Exception {
        Session session = SessionUtil.getSession();
        Criteria criteria = session.createCriteria(InfoDoc.class);
        criteria.add(Restrictions.eq("docDest", dest));
        criteria.setProjection(Projections.rowCount());
        return (long) criteria.uniqueResult();
    }

}
