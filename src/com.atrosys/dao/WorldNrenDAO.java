package com.atrosys.dao;

import com.atrosys.entity.WorldNren;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.ArrayList;

public class WorldNrenDAO {
    public static final String TABLE_NAME = "world_nren";

    public static WorldNren save(WorldNren worldNren) throws Exception {
        return (WorldNren) new HibernateUtil().save(worldNren);
    }


    public static ArrayList<WorldNren> findAllNrens() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT u FROM WorldNren u");
        return (ArrayList<WorldNren>) query.getResultList();
    }

    public static WorldNren findNrenByCountryId(String id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT u FROM WorldNren u where u.countryId=:id");
        query.setParameter("id",id);
        return (WorldNren) query.uniqueResult();
    }


}
