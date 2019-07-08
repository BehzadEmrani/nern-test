package com.atrosys.dao;

import com.atrosys.entity.SubsBuilding;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.List;

public class SubsBuildingDAO {
    public static List<SubsBuilding> findAllBuildings() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from SubsBuilding");
        return (List<SubsBuilding>) query.getResultList();
    }


    public static SubsBuilding findSubsBuildingById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from SubsBuilding c where c.id=:id");
        query.setParameter("id", id);
        return (SubsBuilding) query.uniqueResult();
    }

    public static List<SubsBuilding> findSubsBuildingsByUniId(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from SubsBuilding c where c.uniId=:uniId");
        query.setParameter("uniId", uniId);
        return (List<SubsBuilding>) query.getResultList();
    }

    public static void delete(long id) throws Exception {
        SubsBuilding subsBuilding = new SubsBuilding();
        subsBuilding.setId(id);
        new HibernateUtil().delete(subsBuilding);
    }

    public static SubsBuilding save(SubsBuilding subsBuilding) throws Exception {
        return (SubsBuilding) new HibernateUtil().save(subsBuilding);
    }

}
