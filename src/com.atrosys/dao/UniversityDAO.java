package com.atrosys.dao;

import com.atrosys.entity.University;
import com.atrosys.model.*;
import com.atrosys.util.*;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by mehdisabermahani on 6/16/17.
 */
public class UniversityDAO {
    public static final String TABLE_NAME = "university";

    public static University save(University university) throws Exception {
        return (University) new HibernateUtil().save(university);
    }

    public static University update(Long uniNationalIdOld ,University university) throws Exception {
        University exUni = new University();
        exUni.setUniNationalId(uniNationalIdOld);
        new HibernateUtil().delete(exUni);
        return (University) new HibernateUtil().save(university);
    }
    public static UniStatus findUniStatusByUniNationalId(long uniId) throws Exception {
        try {
            Session session = SessionUtil.getSession();
            Query query = session.createQuery("select u.uniStatus from University u where u.uniNationalId= :uniId");
            query.setParameter("uniId", uniId);
            return UniStatus.fromValue((int) query.uniqueResult());
        } catch (Exception e) {
        }
        return null;
    }

    public static boolean checkUniIdIsNew(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.uniNationalId from University u where u.uniNationalId= :uniId");
        query.setParameter("uniId", uniId);
        return query.uniqueResult() == null;
    }

    public static List<University> findAllUnisBySubCode(int subVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from University u where u.uniSubSystemCode=:subVal");
        query.setParameter("subVal", subVal);
        return (List<University>) query.getResultList();
    }

    public static byte[] findUniRequestFormByUniNationalId(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.requestForm from University u where u.uniNationalId= :uniId");
        query.setParameter("uniId", uniId);
        return (byte[]) query.uniqueResult();
    }

    public static byte[] findUniSubsExampleFormByUniNationalId(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.subscriptionExampleForm from University u where u.uniNationalId= :uniId");
        query.setParameter("uniId", uniId);
        return (byte[]) query.uniqueResult();
    }

    public static byte[] findUniSubsFormByUniNationalId(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.subscriptionForm from University u where u.uniNationalId= :uniId");
        query.setParameter("uniId", uniId);
        return (byte[]) query.uniqueResult();
    }

    public static byte[] findUniSubSignedFormByUniNationalId(long uniId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.subscriptionFormSigned from University u where u.uniNationalId= :uniId");
        query.setParameter("uniId", uniId);
        return (byte[]) query.uniqueResult();
    }

    public static String findUniNameByUniNationalId(long uniId) throws Exception {
        try {
            Session session = SessionUtil.getSession();
            Query query = session.createQuery("select u.uniName from University u where u.uniNationalId= :uniId");
            query.setParameter("uniId", uniId);
            return (String) query.uniqueResult();
        } catch (Exception e) {
        }
        return null;
    }

    public static University findUniByUniNationalId(long uniId) throws Exception {
        try {
            Session session = SessionUtil.getSession();
            Query query = session.createQuery("select u from University u where u.uniNationalId= :uniId");
            query.setParameter("uniId", uniId);
            return (University) query.uniqueResult();
        } catch (Exception e) {
        }
        return null;
    }

    public static List<UniTableRecord> filterUniversitiesInRange(int subCode, long uniNationalId, String uniName, String stateName,
                                                                 String cityName, int typeVal, int uniStatus, int startIndex, int count) throws Exception {
        Session session = SessionUtil.getSession();
        List<QueryParameter> prList = new LinkedList<>();
        prList.add(new QueryParameter("u.uniNationalId", String.valueOf(uniNationalId), "%"));
        prList.add(new QueryParameter("u.uniName", String.valueOf(uniName), "%"));
        prList.add(new QueryParameter("s.name", stateName, "%"));
        prList.add(new QueryParameter("c.name", cityName, "%"));
        prList.add(new QueryParameter("u.uniSubSystemCode", String.valueOf(subCode), "="));
        prList.add(new QueryParameter("u.typeVal", String.valueOf(typeVal), "="));
        prList.add(new QueryParameter("u.uniStatus", String.valueOf(uniStatus), "="));
        Query query = session.createQuery("select u.uniNationalId,u.uniName,u.typeVal,u.uniStatus,u.uniSubStatus ,max(l.timeStamp) as time,c.name,s.name,u.uniSubSystemCode from University u,UniStatusLog  l inner join City c on c.cityId=u.cityId inner join State s on s.stateId=u.stateId where u.uniNationalId = l.uniNationalId " +
                QueryBuilder.buildWhereQuery(prList, false) + " group by u.uniNationalId order by time desc");
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        List list = query.getResultList();
        List<UniTableRecord> records = new ArrayList<>();
        int size = 0;
        while (size < list.size()) {
            Object[] sub = (Object[]) list.get(size);
            UniTableRecord record = new UniTableRecord();
            University university = new University();
            university.setUniNationalId((Long) sub[0]);
            university.setUniName((String) sub[1]);
            university.setTypeVal((Integer) sub[2]);
            university.setUniStatus((Integer) sub[3]);
            university.setUniSubStatus((Integer) sub[4]);
            university.setUniSubSystemCode((Integer) sub[8]);
            record.setUniversity(university);
            record.setLastLogTimeStamp((Timestamp) sub[5]);
            record.setCityName((String) sub[6]);
            record.setStateName((String) sub[7]);
            records.add(record);
            size++;
        }
        return records;
    }

    public static boolean filterUniversitiesInRangeHaveNextPage(int subCode, long uniNationalId, String uniName, String stateName,
                                                                String cityName, int typeVal, int uniStatus, int startIndex, int count) throws Exception {
        return filterUniversitiesInRange(subCode, uniNationalId, uniName, stateName, cityName, typeVal, uniStatus, startIndex + count, count).size() != 0;
    }

    public static List<UniTableRecord> filterMedUniversitiesInRange(int subCode, long uniNationalId, String uniName, String stateName,
                                                                    String cityName, int typeVal, int uniStatus, int startIndex, int count) throws Exception {
        Session session = SessionUtil.getSession();
        List<QueryParameter> prList = new LinkedList<>();
        prList.add(new QueryParameter("u.uniNationalId", String.valueOf(uniNationalId), "%"));
        prList.add(new QueryParameter("u.uniName", String.valueOf(uniName), "%"));
        prList.add(new QueryParameter("s.name", stateName, "%"));
        prList.add(new QueryParameter("c.name", cityName, "%"));
        prList.add(new QueryParameter("u.uniSubSystemCode", String.valueOf(subCode), "="));
        String otherClause = QueryBuilder.buildWhereQuery(prList, false);
        if (typeVal != -1) {
            otherClause += " and ";
            otherClause += "u.typeVal = " + typeVal;
            otherClause += " and ";
            otherClause += "u.uniStatus=" + subCode;
        } else {
            otherClause += " and ";
            otherClause += "(u.uniStatus=" + SubSystemCode.HOSPITAL.getValue();
            otherClause += " or ";
            otherClause += "(u.uniStatus=" + SubSystemCode.UNIVERSITY.getValue();
            otherClause += " and ";
            otherClause += "u.typeVal = " + UniversityType.MEDICAL_UNIVERSITY.getValue() + ")";
            otherClause += " or ";
            otherClause += "(u.uniStatus=" + SubSystemCode.RESEARCH_CENTER.getValue();
            otherClause += " and ";
            otherClause += "u.typeVal = " + ResearchCenterType.RESEARCH_CENTER_MINIS_HEALTH.getValue() + ")";
            otherClause += ")";
        }
        Query query = session.createQuery("select u.uniNationalId,u.uniName,u.typeVal,u.uniStatus,u.uniSubStatus ,max(l.timeStamp) as time,c.name,s.name,u.uniSubSystemCode from University u,UniStatusLog  l inner join City c on c.cityId=u.cityId inner join State s on s.stateId=u.stateId where u.uniNationalId = l.uniNationalId " +
                otherClause + " group by u.uniNationalId order by time desc");
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        List list = query.getResultList();
        List<UniTableRecord> records = new ArrayList<>();
        int size = 0;
        while (size < list.size()) {
            Object[] sub = (Object[]) list.get(size);
            UniTableRecord record = new UniTableRecord();
            University university = new University();
            university.setUniNationalId((Long) sub[0]);
            university.setUniName((String) sub[1]);
            university.setTypeVal((Integer) sub[2]);
            university.setUniStatus((Integer) sub[3]);
            university.setUniSubStatus((Integer) sub[4]);
            university.setUniSubSystemCode((Integer) sub[8]);
            record.setUniversity(university);
            record.setLastLogTimeStamp((Timestamp) sub[5]);
            record.setCityName((String) sub[6]);
            record.setStateName((String) sub[7]);
            records.add(record);
            size++;
        }
        return records;
    }

    public static List<UniApiRecordInspectors> filterCraApiResponse(int subCode, int typeVal) throws Exception {
        Session session = SessionUtil.getSession();
        List<QueryParameter> prList = new LinkedList<>();
        prList.add(new QueryParameter("u.uniSubSystemCode", String.valueOf(subCode), "="));
        Query query = session.createQuery("select u.uniNationalId,u.uniName,u.typeVal,u.uniSubSystemCode ,max(l.timeStamp) as time,c.name,s.name from University u,UniStatusLog  l inner join City c on c.cityId=u.cityId inner join State s on s.stateId=u.stateId where u.uniNationalId = l.uniNationalId " +
                QueryBuilder.buildWhereQuery(prList, false) + " group by u.uniNationalId order by time desc");
        query.setMaxResults(500);
        List list = query.getResultList();
        List<UniApiRecordInspectors> records = new ArrayList<>();
        int size = 0;
        while (size < list.size()) {
            Object[] sub = (Object[]) list.get(size);
            UniApiRecordInspectors record = new UniApiRecordInspectors();
            record.setUniNationalId((Long) sub[0]);
            record.setUniName((String) sub[1]);
            record.setUniSubCode((Integer) sub[2]);
            record.setUniType((Integer) sub[3]);
            record.setRegisterDate(Util.convertTimeStampToJalali((Timestamp) sub[4]));
            record.setCityName((String) sub[5]);
            record.setStateName((String) sub[6]);
            record.setNumService(ServiceFormRequestDAO.findServiceFormRequestCountByUniId(record.getUniNationalId()));

            records.add(record);
            size++;
        }
        return records;
    }

    public static boolean filterMedUniversitiesInRangeHaveNextPage(int subCode, long uniNationalId, String uniName, String stateName,
                                                                   String cityName, int typeVal, int uniStatus, int startIndex, int count) throws Exception {
        return filterMedUniversitiesInRange(subCode, uniNationalId, uniName, stateName, cityName, typeVal, uniStatus, startIndex + count, count).size() != 0;
    }

    public static List<UniTableRecord> approvingUniversities(long uniId, int startIndex, int count) throws Exception {
        String statement = ApprovingRoleDAO.statementForFindUnis(uniId, false);
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.uniNationalId,u.uniName,u.typeVal,u.uniStatus,u.uniSubStatus ,max(l.timeStamp) as time,c.name,s.name,u.uniSubSystemCode from University u,UniStatusLog  l inner join City c on c.cityId=u.cityId inner join State s on s.stateId=u.stateId where u.uniNationalId = l.uniNationalId and u.uniStatus=:uniStatus " + statement + "group by u.uniNationalId order by time desc");
        query.setParameter("uniStatus", UniStatus.REGISTER_PAGE_VERIFY.getValue());
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        List list = query.getResultList();
        List<UniTableRecord> records = new ArrayList<>();
        int size = 0;
        while (size < list.size()) {
            Object[] sub = (Object[]) list.get(size);
            UniTableRecord record = new UniTableRecord();
            University university = new University();
            university.setUniNationalId((Long) sub[0]);
            university.setUniName((String) sub[1]);
            university.setTypeVal((Integer) sub[2]);
            university.setUniStatus((Integer) sub[3]);
            university.setUniSubStatus((Integer) sub[4]);
            university.setUniSubSystemCode((Integer) sub[8]);
            record.setUniversity(university);
            record.setLastLogTimeStamp((Timestamp) sub[5]);
            record.setCityName((String) sub[6]);
            record.setStateName((String) sub[7]);
            records.add(record);
            size++;
        }
        return records;
    }

    public static boolean doesUniHaveAccessToApproveUni(long approvingUniId, long uniId) throws Exception {
        String statement = ApprovingRoleDAO.statementForFindUnis(approvingUniId, false);
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select count(*) from University au where au.uniNationalId=:uniId and (au) in (select u from University u where u.uniStatus=:uniStatus " + statement + "group by u.uniNationalId)");
        query.setParameter("uniStatus", UniStatus.REGISTER_PAGE_VERIFY.getValue());
        query.setParameter("uniId", uniId);
        return (long) query.uniqueResult() > 0;
    }

    public static boolean checkIfHaveAccessToUni(long roleId, long uniNationalId) throws Exception {
        String statement = ApprovingRoleDAO.statementForFindUnis(roleId, false);
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select count(*) from University u where u.uniNationalId = :uniNationalId " + statement);
        query.setParameter("uniNationalId", uniNationalId);
        return (long) query.uniqueResult() > 0;
    }

    public static boolean approvingUniversitiesHaveNextPage(long roleId, int startIndex, int count) throws Exception {
        return approvingUniversities(roleId, startIndex + count, count).size() != 0;
    }

    public static List<UniTableRecord> majorApprovingUnisList(int subCode, int startIndex, int count) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.uniNationalId,u.uniName,u.typeVal,u.uniStatus,u.uniSubStatus ,max(l.timeStamp) as time,c.name,s.name,u.uniSubSystemCode from University u,UniStatusLog  l inner join City c on c.cityId=u.cityId inner join State s on s.stateId=u.stateId where u.uniNationalId = l.uniNationalId and u.uniStatus=:uniStatus and u.uniSubSystemCode=:uniSubSystemCode group by u.uniNationalId order by time desc");
        query.setParameter("uniStatus", UniStatus.REGISTER_SECOND_RELATED_ORGAN.getValue());
        query.setParameter("uniSubSystemCode", subCode);
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        List list = query.getResultList();
        List<UniTableRecord> records = new ArrayList<>();
        int size = 0;
        while (size < list.size()) {
            Object[] sub = (Object[]) list.get(size);
            UniTableRecord record = new UniTableRecord();
            University university = new University();
            university.setUniNationalId((Long) sub[0]);
            university.setUniName((String) sub[1]);
            university.setTypeVal((Integer) sub[2]);
            university.setUniStatus((Integer) sub[3]);
            university.setUniSubStatus((Integer) sub[4]);
            university.setUniSubSystemCode((Integer) sub[8]);
            record.setUniversity(university);
            record.setLastLogTimeStamp((Timestamp) sub[5]);
            record.setCityName((String) sub[6]);
            record.setStateName((String) sub[7]);
            records.add(record);
            size++;
        }
        return records;
    }

    public static boolean majorApprovingUnisListHaveNextPage(int subCode, int startIndex, int count) throws Exception {
        return majorApprovingUnisList(subCode, startIndex + count, count).size() > 0;
    }

    public static List<UniTableRecord>stateAdminUnisList(int subCode,Long stateId, int startIndex, int count) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.uniNationalId,u.uniName,u.typeVal,u.uniStatus,u.uniSubStatus ,max(l.timeStamp) as time,c.name,s.name,u.uniSubSystemCode from University u,UniStatusLog  l inner join City c on c.cityId=u.cityId inner join State s on s.stateId=u.stateId where u.uniNationalId = l.uniNationalId and u.stateId=:stateId group by u.uniNationalId order by time desc");
        query.setParameter("stateId", stateId);
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        List list = query.getResultList();
        List<UniTableRecord> records = new ArrayList<>();
        int size = 0;
        while (size < list.size()) {
            Object[] sub = (Object[]) list.get(size);
            UniTableRecord record = new UniTableRecord();
            University university = new University();
            university.setUniNationalId((Long) sub[0]);
            university.setUniName((String) sub[1]);
            university.setTypeVal((Integer) sub[2]);
            university.setUniStatus((Integer) sub[3]);
            university.setUniSubStatus((Integer) sub[4]);
            university.setUniSubSystemCode((Integer) sub[8]);
            record.setUniversity(university);
            record.setLastLogTimeStamp((Timestamp) sub[5]);
            record.setCityName((String) sub[6]);
            record.setStateName((String) sub[7]);
            records.add(record);
            size++;
        }
        return records;
    }

    public static boolean stateAdminUnisListHaveNextPage(int subCode,Long stateId, int startIndex, int count) throws Exception {
        return stateAdminUnisList(subCode, stateId,startIndex + count, count).size() > 0;
    }

    public static long getUnisCountBySubCodeAndType(int subCode, int typeVal) throws Exception {
        Session session = SessionUtil.getSession();
        Criteria criteria = session.createCriteria(University.class);
        criteria.setProjection(Projections.rowCount());
        criteria.add(Restrictions.eq("typeVal", typeVal));
        criteria.add(Restrictions.eq("uniSubSystemCode", subCode));
        return (long) criteria.uniqueResult();
    }


    public static long getUnisCountBySubCodeAndTypeAndStateRange(int subCode, int typeVal, int sRange, int eRange) throws Exception {
        Session session = SessionUtil.getSession();
        Criteria criteria = session.createCriteria(University.class);
        criteria.setProjection(Projections.rowCount());
        criteria.add(Restrictions.eq("typeVal", typeVal));
        criteria.add(Restrictions.eq("uniSubSystemCode", subCode));
        criteria.add(Restrictions.between("uniStatus", sRange, eRange - 1));
        return (long) criteria.uniqueResult();
    }

    public static long getUnisCountBySubCodeAndTypeAndState(int subCode, int typeVal, int state) throws Exception {
        Session session = SessionUtil.getSession();
        Criteria criteria = session.createCriteria(University.class);
        criteria.setProjection(Projections.rowCount());
        criteria.add(Restrictions.eq("typeVal", typeVal));
        criteria.add(Restrictions.eq("uniSubSystemCode", subCode));
        criteria.add(Restrictions.eq("uniStatus", state));
        return (long) criteria.uniqueResult();
    }

    public static long getRowCount(int subSystem) throws Exception {

        Session session;

        session = SessionUtil.getSession();
        Criteria criteria = session.createCriteria(University.class);
        criteria.setProjection(Projections.rowCount());
        criteria.add(Restrictions.eq("uniSubSystemCode", subSystem));
        return (long) criteria.uniqueResult();
    }

    public static void delete(long nationalId) throws Exception {
        University university = new University();
        university.setUniNationalId(nationalId);
        new HibernateUtil().delete(university);
    }
}
