package com.atrosys.dao;

import com.atrosys.entity.AdminStateListRole;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class AdminStateListRoleDAO {

    public static List<AdminStateListRole> findAllAdminStateListRoles() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from AdminStateListRole u order by u.adminId");
        return (List<AdminStateListRole>) query.getResultList();
    }

    public static AdminStateListRole findAdminStateListRoleByid(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from AdminStateListRole u where u.id= :id ");
        query.setParameter("id", id);
        return (AdminStateListRole) query.uniqueResult();
    }

    public static List<AdminStateListRole> findAdminStateListRoleByAdminId(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from AdminStateListRole u where u.adminId= :adminId ");
        query.setParameter("adminId", adminId);
        return (List<AdminStateListRole>) query.getResultList();
    }


    public static long countAdminStateListRoleByAdminId(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select count(*) from AdminStateListRole u where u.adminId= :adminId ");
        query.setParameter("adminId", adminId);
        return (long) query.uniqueResult();
    }


    public static void deleteAllAdminStateListRoleByAdminId(long adminId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete AdminStateListRole u where u.adminId= :adminId");
        query.setParameter("adminId", adminId);
        query.executeUpdate();
        transaction.commit();
    }


    public static AdminStateListRole save(AdminStateListRole adminStateListRole) throws Exception {
        return (AdminStateListRole) new HibernateUtil().save(adminStateListRole);
    }

    public static void delete(long id) throws Exception {
        AdminStateListRole adminStateListRole = new AdminStateListRole();
        adminStateListRole.setId(id);
        new HibernateUtil().delete(adminStateListRole);
    }
}
