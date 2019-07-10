package com.atrosys.dao;

import com.atrosys.entity.UniStatusLog;
import com.atrosys.model.UniStatus;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.sql.Timestamp;
import java.util.List;

/**
 * Created by mehdisabermahani on 6/16/17.
 */
public class UniStatusLogDAO {
    public static final String TABLE_NAME = "uni_status_log";

    public static List<UniStatusLog> findUniStatusLogByUniNationalId(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from UniStatusLog u where u.uniNationalId= :nationalId order by u.timeStamp desc ");
        query.setParameter("nationalId", nationalId);
        return (List<UniStatusLog>) query.getResultList();
    }

    public static UniStatusLog findUniStatusLogById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from UniStatusLog u where u.id= :id");
        query.setParameter("id", id);
        return (UniStatusLog) query.uniqueResult();
    }

    public static Timestamp findLastLogTimeStampByUniNationalId(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.timeStamp from UniStatusLog u where u.uniNationalId= :nationalId order by u.timeStamp desc ");
        query.setParameter("nationalId", nationalId);
        query.setFirstResult(0);
        query.setMaxResults(1);
        Timestamp timestamp = query.getResultList().size() == 1 ?
                (Timestamp) query.getResultList().get(0) : new Timestamp(0);
        return timestamp;
    }

    public static Timestamp findRegisterTimeStampByUniNationalId(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.timeStamp from UniStatusLog u where u.uniNationalId= :nationalId and uniStatus=:uniStatus order by u.timeStamp");
        query.setParameter("nationalId", nationalId);
        query.setParameter("uniStatus", UniStatus.REGISTER_PAGE_VERIFY.getValue());
        query.setFirstResult(0);
        query.setMaxResults(1);
        Timestamp timestamp = query.getResultList().size() == 1 ?
                (Timestamp) query.getResultList().get(0) : new Timestamp(0);
        return timestamp;
    }

    public static UniStatusLog save(UniStatusLog uniStatusLog) throws Exception {
        return (UniStatusLog) new HibernateUtil().save(uniStatusLog);
    }

    public static String updateUniNationalId(Long uniNationalIdOld, Long uniNationalIdNew) throws Exception {
        List<UniStatusLog> uniStatusLogList = findUniStatusLogByUniNationalId(uniNationalIdOld);

        for (UniStatusLog Log: uniStatusLogList) {
           Log.setUniNationalId(uniNationalIdNew);
           new HibernateUtil().save(Log);
        }
    return "OK";}

}
