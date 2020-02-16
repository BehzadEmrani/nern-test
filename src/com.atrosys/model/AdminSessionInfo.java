package com.atrosys.model;

import com.atrosys.dao.AdminDAO;
import com.atrosys.dao.PersonalInfoDAO;
import com.atrosys.dao.UserRoleDAO;
import com.atrosys.entity.Admin;
import com.atrosys.entity.PersonalInfo;
import com.atrosys.entity.UserRole;

import javax.servlet.http.HttpSession;
import java.util.HashMap;


/**
 * Created by mehdisabermahani on 6/15/17.
 * Data which relate to every cookie,
 * states which admin is using this cookie.
 */

public class AdminSessionInfo {
    private UserRole userRole;
    private Admin admin;
    private PersonalInfo personalInfo;
    private boolean adminLogedIn = false;
    private boolean logedIn = false;

    public AdminSessionInfo(HttpSession session) throws Exception {
        Long userNationalId = (Long) session.getAttribute(Constants.SESSION_USER_NATIONAL_ID);
        HashMap<String, Long> userRoleList = (HashMap<String, Long>) session.getAttribute(Constants.SESSION_USER_ROLES);
        Long userRoleId = null;
        if (userRoleList != null)
            userRoleId = userRoleList.get(UserRoleType.ADMINS.getRoleSessionKey());
        init(userRoleId, userNationalId);
    }

    public AdminSessionInfo(Long userRoleId, Long userNationalId) throws Exception {
        init(userRoleId, userNationalId);
    }

    private void init(Long userRoleId, Long userNationalId) throws Exception {
        if (userNationalId != null)
            logedIn = true;
        if (userRoleId != null) {
            userRole = UserRoleDAO.findUserRoleById(userRoleId);
            admin = AdminDAO.findAdminByRoleId(userRoleId);
            personalInfo = PersonalInfoDAO.findPersonalInfoByNationalId(userRole.getNationalId());
            if (admin != null)
                adminLogedIn = true;
        }
    }

    public UserRole getUserRole() {
        return userRole;
    }

    public Admin getAdmin() {
        return admin;
    }

    public boolean isAdminLogedIn() {
        return adminLogedIn;
    }

    public PersonalInfo getPersonalInfo() {
        return personalInfo;
    }

    public boolean isLogedIn() {
        return logedIn;
    }
}