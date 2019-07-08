package com.atrosys.dao;

import com.atrosys.entity.PreUniversityData;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class PreUniversityDataDAO {
    public static final String TABLE_NAME = "pre_university_data";

    public static PreUniversityData findPreUniversityDataByInternalUniCode(long internalUniCode,int sourceVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select u from PreUniversityData u where u.uniInternalCode=:internalUniCode and u.uniSourceType=:sourceVal");
        query.setParameter("internalUniCode", internalUniCode);
        query.setParameter("sourceVal", sourceVal);
        return (PreUniversityData) query.uniqueResult();
    }

    public static List<PreUniversityData> findAllPreUniversityDatas() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(" from PreUniversityData");
        return (List<PreUniversityData>) query.getResultList();
    }

    public static PreUniversityData findPreUniversityDataByInternalUniCodeAndNational(long uniInternalCode, int sourceVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select u from PreUniversityData u where u.uniInternalCode=:uniInternalCode and u.uniSourceType=:sourceVal");
        query.setParameter("uniInternalCode", uniInternalCode);
        query.setParameter("sourceVal", sourceVal);
        return (PreUniversityData) query.uniqueResult();
    }

    public static PreUniversityData save(PreUniversityData preUniversityData) throws Exception {
        return (PreUniversityData) new HibernateUtil().save(preUniversityData);
    }
}
