package com.atrosys.dao;

import com.atrosys.entity.EquipmentParameter;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class EquipmentParameterDAO {
    public static List<EquipmentParameter> findAllEquipmentParameters() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from EquipmentParameter");
        return (List<EquipmentParameter>) query.getResultList();
    }


    public static EquipmentParameter findEquipmentParameterById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from EquipmentParameter c where c.id=:id");
        query.setParameter("id", id);
        return (EquipmentParameter) query.uniqueResult();
    }


    public static void delete(long id) throws Exception {
        EquipmentParameter equipmentParameter= new EquipmentParameter();
        equipmentParameter.setId(id);
        new HibernateUtil().delete(equipmentParameter);
    }

    public static EquipmentParameter save(EquipmentParameter equipmentParameter) throws Exception {
        return (EquipmentParameter) new HibernateUtil().save(equipmentParameter);
    }

}
