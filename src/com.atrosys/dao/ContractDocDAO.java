package com.atrosys.dao;


import com.atrosys.entity.ContractDoc;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.List;

public class ContractDocDAO {
    public static List<ContractDoc> findAllContractDocs() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from ContractDoc ");
        return (List<ContractDoc>) query.getResultList();
    }


    public static ContractDoc findContractDocById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ContractDoc c where c.id=:id");
        query.setParameter("id", id);
        return (ContractDoc) query.uniqueResult();
    }

    public static List<ContractDoc> findContractDocsInRange(int startIndex, int count) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT u FROM ContractDoc u");
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        return (List<ContractDoc>) query.getResultList();
    }

    public static Long getCount() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT count(*) FROM ContractDoc u");
        return (Long) query.uniqueResult();
    }

    public static void delete(long id) throws Exception {
        ContractDoc ContractDoc = new ContractDoc();
        ContractDoc.setId(id);
        new HibernateUtil().delete(ContractDoc);
    }

    public static ContractDoc save(ContractDoc ContractDoc) throws Exception {
        return (ContractDoc) new HibernateUtil().save(ContractDoc);
    }
}
