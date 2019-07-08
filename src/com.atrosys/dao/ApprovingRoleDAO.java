package com.atrosys.dao;

import com.atrosys.entity.ApprovingRole;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class ApprovingRoleDAO {

    public static List<ApprovingRole> findAllApprovingRoles() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from ApprovingRole u");
        return (List<ApprovingRole>) query.getResultList();
    }

    public static ApprovingRole findApprovingRoleByid(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from ApprovingRole u where u.id= :id ");
        query.setParameter("id", id);
        return (ApprovingRole) query.uniqueResult();
    }

    public static List<ApprovingRole> findApprovingRoleByUniId(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from ApprovingRole u where u.uniId= :uniId ");
        query.setParameter("uniId", uniId);
        return (List<ApprovingRole>) query.getResultList();
    }


    public static long countApprovingRoleByUniId(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select count(*) from ApprovingRole u where u.uniId= :uniId ");
        query.setParameter("uniId", uniId);
        return (long) query.uniqueResult();
    }


    public static void deleteAllApprovingRoleByUniId(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete ApprovingRole u where u.uniId= :uniId");
        query.setParameter("uniId", uniId);
        query.executeUpdate();
        transaction.commit();
    }

    public static String statementForFindUnis(long uniId,boolean isFirstClause) throws Exception {
        List<ApprovingRole> approvingRoles = ApprovingRoleDAO.findApprovingRoleByUniId(uniId);
        String statement = !isFirstClause?"and":"";
        if (approvingRoles.size() > 1)
            statement += "(";
        for (int i = 0; i < approvingRoles.size(); i++) {
            ApprovingRole approvingRole = approvingRoles.get(i);
            String tStatement = "";
            boolean statementBefore = false;
            if (approvingRole.getStateId() != -1) {
                if (!statementBefore) {
                    if (i > 0)
                        tStatement += "or";
                    tStatement += "(";
                }
                tStatement += "u.stateId=" + approvingRole.getStateId();
                statementBefore = true;
            }
            if (approvingRole.getSubSystemTypeVal() != -1) {
                if (statementBefore)
                    tStatement += " AND ";
                else {
                    if (i > 0)
                        tStatement += "or";
                    tStatement += "(";
                }
                tStatement += "u.typeVal=" + approvingRole.getSubSystemTypeVal();
                statementBefore = true;
            }
            if (statementBefore)
                tStatement += " AND ";
            else {
                if (i > 0)
                    tStatement += "or";
                tStatement += "(";
            }
            tStatement += "u.uniSubSystemCode=" + approvingRole.getSubSystemVal() + ")";
            statement += tStatement;
        }
        if (approvingRoles.size() > 1)
            statement += ")";
        return statement;
    }

    public static ApprovingRole save(ApprovingRole approvingRole) throws Exception {
        return (ApprovingRole) new HibernateUtil().save(approvingRole);
    }

    public static void delete(long id) throws Exception {
        ApprovingRole approvingRole = new ApprovingRole();
        approvingRole.setId(id);
        new HibernateUtil().delete(approvingRole);
    }
}
