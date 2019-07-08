package com.atrosys.dao;

import com.atrosys.entity.EquipmentParentRel;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class EquipmentParentRelDAO {
    public static List<EquipmentParentRel> findAllEquipmentParentRels() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from EquipmentParentRel");
        return (List<EquipmentParentRel>) query.getResultList();
    }


    public static EquipmentParentRel findEquipmentParentRelById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from EquipmentParentRel c where c.id=:id");
        query.setParameter("id", id);
        return (EquipmentParentRel) query.uniqueResult();
    }

    public static List<EquipmentParentRel> findEquipmentParentRelByParentId(long parentEquipmentTypeId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from EquipmentParentRel c where c.parentId=:parentEquipmentTypeId order by id");
        query.setParameter("parentEquipmentTypeId", parentEquipmentTypeId);
        return (List<EquipmentParentRel>) query.getResultList();
    }


    public static List<EquipmentParentRel> findEquipmentParentRelByChildId(long childEquipmentTypeId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from EquipmentParentRel c where c.childId=:childEquipmentTypeId order by id");
        query.setParameter("childEquipmentTypeId", childEquipmentTypeId);
        return (List<EquipmentParentRel>) query.getResultList();
    }

    public static void delete(long id) throws Exception {
        EquipmentParentRel equipmentTypeParentRel = new EquipmentParentRel();
        equipmentTypeParentRel.setId(id);
        new HibernateUtil().delete(equipmentTypeParentRel);
    }

    public static EquipmentParentRel save(EquipmentParentRel equipmentTypeParentRel) throws Exception {
        return (EquipmentParentRel) new HibernateUtil().save(equipmentTypeParentRel);
    }

    public static void deleteAllParentRels(long childEquipmentTypeId) throws Exception {
        Session session = SessionUtil.getSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery("delete EquipmentParentRel u where u.childId= :childEquipmentTypeId");
        query.setParameter("childEquipmentTypeId", childEquipmentTypeId);
        query.executeUpdate();
        transaction.commit();
    }

}
