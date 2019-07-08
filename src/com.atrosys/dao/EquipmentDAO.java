package com.atrosys.dao;

import com.atrosys.entity.Equipment;
import com.atrosys.entity.EquipmentParentRel;
import com.atrosys.entity.InstallRecord;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class EquipmentDAO {
    public static List<Equipment> findAllEquipments() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from Equipment");
        return (List<Equipment>) query.getResultList();
    }


    public static Equipment findEquipmentById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from Equipment c where c.id=:id");
        query.setParameter("id", id);
        return (Equipment) query.uniqueResult();
    }

    public static List<Equipment> findAllEquipmentsCanInstallByTelecomId(Long telecomId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select e from Equipment e where " +
                        //1-tajhize madar nadashte bashad (not in childs)
                        "(e.id not in(select e1.id from Equipment e1 inner join EquipmentType t1 on t1.id=e1.equipmentTypeId inner join EquipmentParentRel p1 on p1.childId=t1.id) " +
                        //2-tajhiz bacheye tajhize digar dar haman markaz bashad [be child of (parent type is in telecom)]
                        "or e.id in (select e2.id from Equipment e2 inner join EquipmentType t2 on t2.id=e2.equipmentTypeId inner join EquipmentParentRel p2 on p2.childId=t2.id " +
                        "where p2.parentId in (select t21.id from Equipment e21 inner join InstallRecord r21 on r21.equipmentId=e21.id inner join EquipmentType t21 on t21.id=e21.equipmentTypeId  where r21.telecomCenterId=:telecomId)) " +
                        //3-tajhiz dar nasb shode ha nabashad (not in installed)
                        ")and e.id not in(select r3.equipmentId from InstallRecord r3)");
        query.setParameter("telecomId", telecomId);
        return (List<Equipment>) query.getResultList();
    }

    public static List<Equipment> findParentEquipmentsByTelecomIdAndEquipId(Long telecomId, Long equipmentId) throws Exception {
        //tajhizat madar ra darsoorati ke dar markaz marboot bashand pas midahad
        List<Equipment> equipmentList = new LinkedList<>();
        //1-tajhizat markaz ra migirad
        List<InstallRecord> records = InstallRecordDAO.findInstallRecordByTelecomCenterId(telecomId);

        //2-check mikonad ke parent hastand ya na
        Long childTypeId = EquipmentDAO.findEquipmentById(equipmentId).getEquipmentTypeId();
        List<EquipmentParentRel> rels = EquipmentParentRelDAO.findEquipmentParentRelByChildId(childTypeId);
        List<Long> parentTypeIds = new LinkedList<>();
        for (EquipmentParentRel rel:rels)
            parentTypeIds.add(rel.getParentId());

        for (InstallRecord record : records) {
            Equipment equipment = EquipmentDAO.findEquipmentById(record.getEquipmentId());
            if (parentTypeIds.contains(equipment.getEquipmentTypeId()))
                equipmentList.add(equipment);
        }

        return equipmentList;
    }


    public static void delete(long id) throws Exception {
        Equipment equipment = new Equipment();
        equipment.setId(id);
        new HibernateUtil().delete(equipment);
    }

    public static Equipment save(Equipment equipment) throws Exception {
        return (Equipment) new HibernateUtil().save(equipment);
    }

}
