package com.atrosys.dao;

import com.atrosys.entity.Admin;
import com.atrosys.entity.AdminAccess;
import com.atrosys.entity.AdminAccessLog;
import com.atrosys.entity.PersonalInfo;
import com.atrosys.model.AdminAccessLogType;
import com.atrosys.model.AdminAccessType;
import com.atrosys.model.AdminSessionInfo;
import com.atrosys.model.UserRoleType;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Projections;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class AdminDAO {
    public static final String TABLE_NAME = "admin";

    public static List<Admin> findAllAdmins() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Admin u");
        return (List<Admin>) query.getResultList();
    }


    public static Admin findAdminByRoleId(long RoleId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Admin u where u.roleId= :RoleId");
        query.setParameter("RoleId", RoleId);
        return (Admin) query.uniqueResult();
    }

    public static long getAdminCount() throws Exception {
        Session session = SessionUtil.getSession();
        Criteria criteria = session.createCriteria(Admin.class);
        criteria.setProjection(Projections.rowCount());
        return (long) criteria.uniqueResult();
    }

    public static boolean checkAdminAccess(HttpSession reqSession, Long adminId, int accessVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.id from AdminAccess u where u.adminId= :adminId and u.accessVal=:accessVal");
        query.setParameter("adminId", adminId);
        query.setParameter("accessVal", accessVal);
        boolean haveAccess = query.getResultList().size() > 0;
        if (haveAccess)
            logAccessVal(reqSession, accessVal);
        return haveAccess;
    }

    public static boolean checkAdminSubAccess(long adminId, int accessVal, int subAccessVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.id from AdminAccess u where u.adminId= :adminId and u.accessVal=:accessVal and u.subAccessVal=:subAccessVal");
        query.setParameter("adminId", adminId);
        query.setParameter("accessVal", accessVal);
        query.setParameter("subAccessVal", subAccessVal);
        boolean haveAccess = query.getResultList().size() > 0;
        return haveAccess;
    }

    public static void logAccessVal(HttpSession session, int accessVal) throws Exception {
        AdminSessionInfo adminSessionInfo = new AdminSessionInfo(session);
        Admin admin = adminSessionInfo.getAdmin();
        PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();

        AdminAccessLog adminAccessLog = new AdminAccessLog();
        adminAccessLog.setAdminId(admin.getId());
        adminAccessLog.setAdminAccessLogTypeVal(AdminAccessLogType.ADMIN_ACCESS_TO_PAGE.getValue());
        adminAccessLog.setPageAccessVal(accessVal);
        adminAccessLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));

        adminAccessLog.setMessage(String.format("\"%s\" به بخش \"%s\" دسترسی پیدا کرد.",
                personalInfo.combineName(), AdminAccessType.fromValue(accessVal).getFaStr()));
        AdminAccessLogDAO.save(adminAccessLog);
    }


    public static Admin findAdminByid(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Admin u where u.id= :adminId ");
        query.setParameter("adminId", adminId);
        return (Admin) query.uniqueResult();
    }

    public static List<AdminAccess> findAllAdminAccess(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from AdminAccess u where u.adminId= :adminId");
        query.setParameter("adminId", adminId);
        return (List<AdminAccess>) query.getResultList();
    }

    public static boolean isAdminNewByNationalId(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select u.nationalId from UserRole u where u.nationalId= :nationalId and u.userRoleVal=:userRoleVal");
        query.setParameter("nationalId", nationalId);
        query.setParameter("userRoleVal", UserRoleType.ADMINS.getValue());
        return query.getResultList().size() == 0;
    }

    public static void deleteAllAdminAccess(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete AdminAccess u where u.adminId= :adminId");
        query.setParameter("adminId", adminId);
        query.executeUpdate();
        transaction.commit();
    }

    public static List<AdminAccessType> findAllAdminAccessTypes(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.accessVal from AdminAccess u where u.adminId= :adminId");
        query.setParameter("adminId", adminId);
        List<Integer> accessVals = (List<Integer>) query.getResultList();
        List<AdminAccessType> adminAccessTypes = new LinkedList<>();
        for (Integer accessVal : accessVals)
            adminAccessTypes.add(AdminAccessType.fromValue(accessVal));
        return (List<AdminAccessType>) adminAccessTypes;
    }

    public static Admin save(Admin admin) throws Exception {
        return (Admin) new HibernateUtil().save(admin);
    }
}
