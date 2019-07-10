package com.atrosys.dao;

import com.atrosys.entity.Agent;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/16/17.
 */
public class AgentDAO {
    public static final String TABLE_NAME = "agent";

    public static Agent save(Agent agent) throws Exception {
        return (Agent) new HibernateUtil().save(agent);
    }

    public static String updateUniNationalId(Long uniNationalIdOld, Long uniNationalIdNew) throws Exception {
        List<Agent> agentList = findAgentByUniId(uniNationalIdOld);
        if (agentList.size()<1) {
            throw new Exception("No Records Found");
        }
        if (uniNationalIdNew==null || uniNationalIdNew==0){
            throw new Exception("UniNationallId Can't be empty");
        }
        for (Agent agent: agentList) {
            agent.setUniNationalId(uniNationalIdNew);
            new HibernateUtil().save(agent);
        }
        return "OK";
    }

    public static long findAgentIdByNationalId(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.id from Agent u where u.nationalId= :nationalId");
        query.setParameter("nationalId", nationalId);
        return (Long) query.uniqueResult();
    }

    public static Agent findAgentByNationalId(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Agent u where u.nationalId= :nationalId");
        query.setParameter("nationalId", nationalId);
        return (Agent) query.uniqueResult();
    }

    public static Agent findAgentById(long id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Agent u where u.id= :id");
        query.setParameter("id", id);
        return (Agent) query.uniqueResult();
    }

    public static List<Agent> findAgentByUniId(long uniNationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Agent u where u.uniNationalId= :uniNationalId");
        query.setParameter("uniNationalId", uniNationalId);
        return (List<Agent>) query.getResultList();
    }

    public static Agent findUniPrimaryAgentByUniId(long uniNationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Agent u where u.uniNationalId= :uniNationalId and primary=true");
        query.setParameter("uniNationalId", uniNationalId);
        return (Agent) query.uniqueResult();
    }

    public static Agent findAgentByRoleId(long roleId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from Agent u where u.roleId= :roleId");
        query.setParameter("roleId", roleId);
        return (Agent) query.uniqueResult();
    }

    public static void delete(long id) throws Exception {
        Agent agent = new Agent();
        agent.setAgentId(id);
        new HibernateUtil().delete(agent);
    }
}
