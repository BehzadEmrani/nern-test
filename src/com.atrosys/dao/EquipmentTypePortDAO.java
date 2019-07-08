package com.atrosys.dao;

import com.atrosys.entity.EquipmentTypePort;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class EquipmentTypePortDAO {
    public static List<EquipmentTypePort> findAllEquipmentTypePorts() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from EquipmentTypePort");
        return (List<EquipmentTypePort>) query.getResultList();
    }


    public static EquipmentTypePort findEquipmentTypePortById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from EquipmentTypePort c where c.id=:id");
        query.setParameter("id", id);
        return (EquipmentTypePort) query.uniqueResult();
    }

    public static List<EquipmentTypePort> findEquipmentTypePortByEquipmentTypeId(long equipmentTypeId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from EquipmentTypePort c where c.equipmentTypeId=:equipmentTypeId order by id");
        query.setParameter("equipmentTypeId", equipmentTypeId);
        return (List<EquipmentTypePort>) query.getResultList();
    }

    public static void delete(long id) throws Exception {
        EquipmentTypePort equipmentTypePort = new EquipmentTypePort();
        equipmentTypePort.setId(id);
        new HibernateUtil().delete(equipmentTypePort);
    }

    public static EquipmentTypePort save(EquipmentTypePort equipmentTypePort) throws Exception {
        return (EquipmentTypePort) new HibernateUtil().save(equipmentTypePort);
    }

    public static void deleteAllPorts(long equipmentTypeId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete EquipmentTypePort u where u.equipmentTypeId= :equipmentTypeId");
        query.setParameter("equipmentTypeId", equipmentTypeId);
        query.executeUpdate();
        transaction.commit();
    }

}
