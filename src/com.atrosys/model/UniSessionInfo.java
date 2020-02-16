package com.atrosys.model;

import com.atrosys.dao.AgentDAO;
import com.atrosys.dao.PersonalInfoDAO;
import com.atrosys.dao.UniversityDAO;
import com.atrosys.dao.UserRoleDAO;
import com.atrosys.entity.Agent;
import com.atrosys.entity.PersonalInfo;
import com.atrosys.entity.University;
import com.atrosys.entity.UserRole;

import javax.servlet.http.HttpSession;
import java.util.HashMap;


/**
 * Created by mehdisabermahani on 6/15/17.
 * Data which relate to every cookie,
 * states which customer is using this cookie.
 */

public class UniSessionInfo {
    private UserRole userRole;
    private Agent agent;
    private University university;
    private PersonalInfo personalInfo;
    private boolean subSystemLoggedIn = false;
    private boolean loggedIn = false;

    public UniSessionInfo(HttpSession session, UserRoleType userRoleType) throws Exception {
        Long userNationalId = (Long) session.getAttribute(Constants.SESSION_USER_NATIONAL_ID);
        if (userNationalId != null)
            loggedIn = true;
        HashMap<String, Long> userRoleList = (HashMap<String, Long>) session.getAttribute(Constants.SESSION_USER_ROLES);
        if (userRoleList != null) {
            Long userRoleId = userRoleList.get(userRoleType.getRoleSessionKey());
            if (userRoleId != null) {
                userRole = UserRoleDAO.findUserRoleById(userRoleId);
                agent = AgentDAO.findAgentByRoleId(userRoleId);
                personalInfo= PersonalInfoDAO.findPersonalInfoByNationalId(agent.getNationalId());
                university = UniversityDAO.findUniByUniNationalId(agent.getUniNationalId());
                if (university != null)
                    subSystemLoggedIn = true;
            }
        }
    }

    public PersonalInfo getPersonalInfo() {
        return personalInfo;
    }

    public UserRole getUserRole() {
        return userRole;
    }

    public Agent getAgent() {
        return agent;
    }

    public University getUniversity() {
        return university;
    }

    public boolean isSubSystemLoggedIn() {
        return subSystemLoggedIn;
    }

    public boolean isLoggedIn() {
        return loggedIn;
    }

}
