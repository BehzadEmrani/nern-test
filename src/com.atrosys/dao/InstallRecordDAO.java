package com.atrosys.dao;

import com.atrosys.entity.InstallRecord;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class InstallRecordDAO {
    public static List<InstallRecord> findAllInstallRecords() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from InstallRecord");
        return (List<InstallRecord>) query.getResultList();
    }


    public static InstallRecord findInstallRecordById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from InstallRecord c where c.id=:id");
        query.setParameter("id", id);
        return (InstallRecord) query.uniqueResult();
    }

    public static List<InstallRecord> findInstallRecordByTelecomCenterId(long telecomCenterId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from InstallRecord u where u.telecomCenterId=:telecomCenterId order by u.id");
        query.setParameter("telecomCenterId", telecomCenterId);
        return (List<InstallRecord>) query.getResultList();
    }

    public static void deleteAllInstallRecords(long telecomCenterId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete InstallRecord u where u.telecomCenterId= :telecomCenterId");
        query.setParameter("telecomCenterId", telecomCenterId);
        query.executeUpdate();
        transaction.commit();
    }

    public static void delete(long id) throws Exception {
        InstallRecord installRecord = new InstallRecord();
        installRecord.setId(id);
        new HibernateUtil().delete(installRecord);
    }

    public static void deleteInstalled(long id) throws Exception {
        InstallRecord installRecord = findInstallRecordById(id);
        List<InstallRecord> telecomRecords = findInstallRecordByTelecomCenterId(installRecord.getTelecomCenterId());
        for (InstallRecord record : telecomRecords)
            if (record.getParentEquipmentId().equals(installRecord.getEquipmentId()))
                deleteInstalled(record.getId());
        new HibernateUtil().delete(installRecord);
    }

    public static InstallRecord save(InstallRecord InstallRecord) throws Exception {
        return (InstallRecord) new HibernateUtil().save(InstallRecord);
    }

}
