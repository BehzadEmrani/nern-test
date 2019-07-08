package com.atrosys.dao;

import com.atrosys.entity.UserRole;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class UserRoleDAO {
    public static final String TABLE_NAME = "user-rel";

    public static UserRole findUserRoleById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from UserRole u where u.roleId= :relId");
        query.setParameter("relId", id);
        return (UserRole) query.uniqueResult();
    }

    public static List<UserRole> findUserRolesByNationalId(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from UserRole u where u.nationalId= :nationalId");
        query.setParameter("nationalId", nationalId);
        return (List<UserRole>) query.getResultList();
    }

    public static List<UserRole> findUserRolesByNationalIdAndType(long nationalId, int userRoleVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select u from UserRole u where u.nationalId= :nationalId and u.userRoleVal=:userRoleVal");
        query.setParameter("nationalId", nationalId);
        query.setParameter("userRoleVal", userRoleVal);
        return (List<UserRole>) query.getResultList();
    }

    public static List<UserRole> findUserRolesByUserRoleType(int userRoleVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from UserRole u where u.userRoleVal= :userRoleVal");
        query.setParameter("userRoleVal", userRoleVal);
        return (List<UserRole>) query.getResultList();
    }

    public static UserRole save(UserRole userRole) throws Exception {
        return (UserRole) new HibernateUtil().save(userRole);
    }

    public static void delete(long id) throws Exception {
        UserRole userRole = new UserRole();
        userRole.setRoleId(id);
        new HibernateUtil().delete(userRole);
    }
}
