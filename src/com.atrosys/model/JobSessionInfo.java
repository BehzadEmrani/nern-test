package com.atrosys.model;

import com.atrosys.dao.PersonalInfoDAO;
import com.atrosys.dao.UserRoleDAO;
import com.atrosys.entity.PersonalInfo;
import com.atrosys.entity.UserRole;

import javax.servlet.http.HttpSession;
import java.util.HashMap;


/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class JobSessionInfo {
    private UserRole userRole;
    private PersonalInfo personalInfo;
    private boolean loggedIn = false;

    public JobSessionInfo(HttpSession session) throws Exception {
        Long userNationalId = (Long) session.getAttribute(Constants.SESSION_USER_NATIONAL_ID);
        personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(userNationalId);
        if (personalInfo != null)
            loggedIn = true;
        HashMap<String, Long> userRoleList = (HashMap<String, Long>) session.getAttribute(Constants.SESSION_USER_ROLES);
        if (userRoleList != null) {
            Long userRoleId = userRoleList.get(UserRoleType.JOB_SEEKER.getRoleSessionKey());
            if (userRoleId != null)
                userRole = UserRoleDAO.findUserRoleById(userRoleId);
        }
    }

    public UserRole getUserRole() {
        return userRole;
    }

    public boolean isLoggedIn() {
        return loggedIn;
    }

    public PersonalInfo getPersonalInfo() {
        return personalInfo;
    }
}
