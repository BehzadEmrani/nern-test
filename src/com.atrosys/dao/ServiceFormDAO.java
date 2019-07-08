package com.atrosys.dao;

import com.atrosys.entity.Service;
import com.atrosys.entity.ServiceForm;
import com.atrosys.entity.ServiceFormParameter;
import com.atrosys.entity.SubService;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.QueryBuilder;
import com.atrosys.util.SessionUtil;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class ServiceFormDAO {
    public static List<ServiceForm> findAllServiceForms() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from ServiceForm");
        return (List<ServiceForm>) query.getResultList();
    }


    public static ServiceForm findServiceFormById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from ServiceForm c where c.id=:id");
        query.setParameter("id", id);
        return (ServiceForm) query.uniqueResult();
    }

    public static List<ServiceForm> filterServiceFormsInRange(long subServiceId, int payTypeVal, int payPeriod,
                                                              int subsDuration, int startIndex, int count) throws Exception {
        Session session = SessionUtil.getSession();
        List<String[]> prList = new LinkedList<>();
        prList.add(new String[]{"u.subServiceId", String.valueOf(subServiceId)});
        prList.add(new String[]{"u.payTypeVal", String.valueOf(payTypeVal)});
        prList.add(new String[]{"u.payPeriod", String.valueOf(payPeriod)});
        prList.add(new String[]{"u.subsDuration", String.valueOf(subsDuration)});
        Query query = session.createQuery("SELECT u FROM ServiceForm u " + QueryBuilder.buildWhereEQQuery(prList));
        query.setFirstResult(startIndex);
        query.setMaxResults(count);
        return (List<ServiceForm>) query.getResultList();
    }

    public static long getRowCount() throws Exception {
        Session session = SessionUtil.getSession();
        Criteria criteria = session.createCriteria(ServiceForm.class);
        criteria.setProjection(Projections.rowCount());
        return (long) criteria.uniqueResult();
    }

    public static boolean checkIfThereIsServiceFormForCat(long catId) throws Exception {
        List<SubService> subServices = new LinkedList<>();
        for (Service service : ServiceDAO.findServicesByCatId(catId))
            subServices.addAll(SubServiceDAO.findSubServiceByServiceId(service.getId()));
        if (subServices.size() > 0) {
            Session session = SessionUtil.getSession();
            String qStr = "select c.id from ServiceForm c where";
            for (SubService subService : subServices)
                qStr += " c.subServiceId=" + subService.getId() + (subServices.size() > subServices.indexOf(subService) + 1 ? " or" : "");
            qStr+=" and c.active=true";
            Query query = session.createQuery(qStr);
            return query.getResultList().size() > 0;
        } else
            return false;
    }

    public static List<Integer> findExistForPayTypesBySubServiceId(long subServiceId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select c.payTypeVal from ServiceForm c where c.subServiceId=:subServiceId and c.active=true group by c.payTypeVal");
        query.setParameter("subServiceId", subServiceId);
        return (List<Integer>) query.getResultList();
    }


    public static List<Integer> findExistForSubDurationsBySubServiceIdAndPayType
            (long subServiceId, int payTypeVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select c.subsDuration from ServiceForm c where c.subServiceId=:subServiceId" +
                        " and c.payTypeVal=:payTypeVal and c.active=true group by c.subsDuration");
        query.setParameter("subServiceId", subServiceId);
        query.setParameter("payTypeVal", payTypeVal);
        return (List<Integer>) query.getResultList();
    }

    public static List<Integer> findExistForPayPeriodBySubServiceIdAndPayTypeAndSubsDuration
            (long subServiceId, int payTypeVal, int subsDuration) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select c.payPeriod from ServiceForm c where c.subServiceId=:subServiceId" +
                        " and c.payTypeVal=:payTypeVal and c.subsDuration=:subsDuration and c.active=true group by c.payPeriod");
        query.setParameter("subServiceId", subServiceId);
        query.setParameter("payTypeVal", payTypeVal);
        query.setParameter("subsDuration", subsDuration);
        return (List<Integer>) query.getResultList();
    }

    public static List<Integer> findExistSlaTypesBySubServiceIdAndPayTypeAndSubsDurationAndPayPeriod
            (long subServiceId, int payTypeVal, int subsDuration, int payPeriod) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select c.slaVal from ServiceForm c where c.subServiceId=:subServiceId" +
                        " and c.payTypeVal=:payTypeVal and c.subsDuration=:subsDuration " +
                        "and c.payPeriod=:payPeriod and c.active=true group by c.slaVal");
        query.setParameter("subServiceId", subServiceId);
        query.setParameter("payTypeVal", payTypeVal);
        query.setParameter("subsDuration", subsDuration);
        query.setParameter("payPeriod", payPeriod);
        return (List<Integer>) query.getResultList();
    }


    public static List<ServiceFormParameter> findServiceFormParametersByConditions
            (long subServiceId, int payTypeVal, int subsDuration, int payPeriod, int slaVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select c.id from ServiceForm c where c.subServiceId=:subServiceId" +
                        " and c.payTypeVal=:payTypeVal and c.subsDuration=:subsDuration " +
                        "and c.payPeriod=:payPeriod and c.slaVal=:slaVal and c.active=true");
        query.setParameter("subServiceId", subServiceId);
        query.setParameter("payTypeVal", payTypeVal);
        query.setParameter("subsDuration", subsDuration);
        query.setParameter("payPeriod", payPeriod);
        query.setParameter("slaVal", slaVal);
        long serviceFormId = (long) query.uniqueResult();
        return ServiceFormParameterDAO.findServiceFormParameterByServiceFormId(serviceFormId);
    }

    public static String findServiceFormTermsByConditions
            (long subServiceId, int payTypeVal, int subsDuration, int payPeriod, int slaVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select c.otherTerms from ServiceForm c where c.subServiceId=:subServiceId" +
                        " and c.payTypeVal=:payTypeVal and c.subsDuration=:subsDuration " +
                        "and c.payPeriod=:payPeriod and c.slaVal=:slaVal and c.active=true");
        query.setParameter("subServiceId", subServiceId);
        query.setParameter("payTypeVal", payTypeVal);
        query.setParameter("subsDuration", subsDuration);
        query.setParameter("payPeriod", payPeriod);
        query.setParameter("slaVal", slaVal);
        return (String) query.uniqueResult();
    }

    public static ServiceForm findServiceFormByConditions
            (long subServiceId, int payTypeVal, int subsDuration, int payPeriod, int slaVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select c from ServiceForm c where c.subServiceId=:subServiceId" +
                        " and c.payTypeVal=:payTypeVal and c.subsDuration=:subsDuration " +
                        "and c.payPeriod=:payPeriod and c.slaVal=:slaVal and c.active=true");
        query.setParameter("subServiceId", subServiceId);
        query.setParameter("payTypeVal", payTypeVal);
        query.setParameter("subsDuration", subsDuration);
        query.setParameter("payPeriod", payPeriod);
        query.setParameter("slaVal", slaVal);
        return (ServiceForm) query.uniqueResult();
    }

    public static String findServiceFormCombinedNameByConditions
            (long subServiceId, int payTypeVal, int subsDuration, int payPeriod, int slaVal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery(
                "select c from ServiceForm c where c.subServiceId=:subServiceId" +
                        " and c.payTypeVal=:payTypeVal and c.subsDuration=:subsDuration " +
                        "and c.payPeriod=:payPeriod and c.slaVal=:slaVal and c.active=true");
        query.setParameter("subServiceId", subServiceId);
        query.setParameter("payTypeVal", payTypeVal);
        query.setParameter("subsDuration", subsDuration);
        query.setParameter("payPeriod", payPeriod);
        query.setParameter("slaVal", slaVal);
        return ((ServiceForm) query.uniqueResult()).combine();
    }

    public static void delete(long id) throws Exception {
        ServiceForm serviceForm = new ServiceForm();
        serviceForm.setId(id);
        new HibernateUtil().delete(serviceForm);
    }

    public static ServiceForm save(ServiceForm serviceForm) throws Exception {
        return (ServiceForm) new HibernateUtil().save(serviceForm);
    }

}
