package com.atrosys.dao;

import com.atrosys.entity.EquipmentType;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class EquipmentTypeDAO {
    public static List<EquipmentType> findAllEquipmentTypes() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from EquipmentType");
        return (List<EquipmentType>) query.getResultList();
    }


    public static EquipmentType findEquipmentTypeById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from EquipmentType c where c.id=:id");
        query.setParameter("id", id);
        return (EquipmentType) query.uniqueResult();
    }

    public static void delete(long id) throws Exception {
        EquipmentType equipmentType= new EquipmentType();
        equipmentType.setId(id);
        new HibernateUtil().delete(equipmentType);
    }
    public static EquipmentType save(EquipmentType equipmentType) throws Exception {
        return (EquipmentType) new HibernateUtil().save(equipmentType);
    }

}
