package com.atrosys.dao;

import com.atrosys.entity.State;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class StateDAO {
    public static List<State> findAllStates() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select s from State s order by s.name");
        return (List<State>) query.getResultList();
    }

    public static State findStateById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from State u where u.id= :id");
        query.setParameter("id", id);
        return (State) query.uniqueResult();
    }

    public static String findStateNameById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.name from State u where u.id= :id");
        query.setParameter("id", id);
        return (String) query.uniqueResult();
    }

    public static boolean isStateNameNew(String name) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.id from State u where u.name= :name");
        query.setParameter("name", name);
        return query.getResultList().size() == 0;
    }

    public static boolean isStatePhoneCodeNew(int code) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.id from State u where u.phoneCode= :code");
        query.setParameter("code", code);
        return query.getResultList().size() == 0;
    }

    public static State save(State state) throws Exception {
        if (state.getName() != null) {
            if (state.getName().trim().isEmpty())
                throw new Exception("no-name");
            else if (!isStateNameNew(state.getName()))
                throw new Exception("repeated-name");
        } else
            throw new Exception("null-name");

        if (state.getPhoneCode() != null) {
            if (!isStatePhoneCodeNew(state.getPhoneCode()))
                throw new Exception("repeated-code");
        } else
            throw new Exception("null-code");

        return (State) new HibernateUtil().save(state);
    }
}
