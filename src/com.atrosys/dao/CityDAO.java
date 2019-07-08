package com.atrosys.dao;

import com.atrosys.entity.City;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class CityDAO {
    public static List<City> findAllCities() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from City c order by c.name");
        return (List<City>) query.getResultList();
    }

    public static List<City> findCitiesByStateId(long stateId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from City c where c.stateId=:stateId order by c.name");
        query.setParameter("stateId", stateId);
        return (List<City>) query.getResultList();
    }


    public static City findCityById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c from City c where c.id=:id");
        query.setParameter("id", id);
        return (City) query.uniqueResult();
    }

    public static Long findIdByCityName(String name) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c.id from City c where c.name=:name");
        query.setParameter("name", name);
        return (Long) query.uniqueResult() ;
    }

    public static String findCityNameById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c.name from City c where c.id=:id");
        query.setParameter("id", id);
        return (String) query.uniqueResult();
    }

    public static boolean isCityNameNew(String name) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select c.id from City c where c.name=:name");
        query.setParameter("name", name);
        return query.getResultList().size() == 0;
    }

    public static City save(City city) throws Exception {
        if (city.getName() != null) {
            if (city.getName().trim().isEmpty())
                throw new Exception("no-name");
            else if (!isCityNameNew(city.getName()))
                throw new Exception("repeated-name");
        } else
            throw new Exception("null-name");

        return (City) new HibernateUtil().save(city);
    }

}
