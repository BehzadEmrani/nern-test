package com.atrosys.dao;

import com.atrosys.entity.EquipmentTypeParameters;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class EquipmentTypeParametersDAO {
    public static List<EquipmentTypeParameters> findAllEquipmentTypeParameterss() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from EquipmentTypeParameters");
        return (List<EquipmentTypeParameters>) query.getResultList();
    }


    public static EquipmentTypeParameters findEquipmentTypeParametersById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from EquipmentTypeParameters c where c.id=:id");
        query.setParameter("id", id);
        return (EquipmentTypeParameters) query.uniqueResult();
    }

    public static List<EquipmentTypeParameters>findEquipmentTypeParametersByEquipmentTypeIdDesc(long equipmentTypeId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from EquipmentTypeParameters u where u.equipmentTypeId=:equipmentTypeId order by u.id");
        query.setParameter("equipmentTypeId", equipmentTypeId);
        return ( List<EquipmentTypeParameters>) query.getResultList();
    }

    public static void deleteAllParameters(long equipmentTypeId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete EquipmentTypeParameters u where u.equipmentTypeId= :equipmentTypeId");
        query.setParameter("equipmentTypeId", equipmentTypeId);
        query.executeUpdate();
        transaction.commit();
    }

    public static void delete(long id) throws Exception {
        EquipmentTypeParameters equipmentTypeParameters= new EquipmentTypeParameters();
        equipmentTypeParameters.setId(id);
        new HibernateUtil().delete(equipmentTypeParameters);
    }

    public static EquipmentTypeParameters save(EquipmentTypeParameters equipmentTypeParameters) throws Exception {
        return (EquipmentTypeParameters) new HibernateUtil().save(equipmentTypeParameters);
    }

}
