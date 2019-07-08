package com.atrosys.dao;

import com.atrosys.entity.AdminAccessLog;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class AdminAccessLogDAO {
    public static final String TABLE_NAME = "admin_access_log";

    public static List<AdminAccessLog> findAdminAccessLogByAdminId(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from AdminAccessLog u where u.adminId= :adminId order by u.timeStamp desc ");
        query.setParameter("adminId", adminId);
        return (List<AdminAccessLog>) query.getResultList();
    }

    public static AdminAccessLog save(AdminAccessLog adminAccessLog) throws Exception {
        return (AdminAccessLog) new HibernateUtil().save(adminAccessLog);
    }
}
