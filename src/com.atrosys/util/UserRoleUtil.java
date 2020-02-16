package com.atrosys.util;

import com.atrosys.dao.UserRoleDAO;
import com.atrosys.entity.UserRole;
import com.atrosys.model.Constants;
import com.atrosys.model.UserRoleType;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;

/**
 * updates user permissions from DB.
 */

public class UserRoleUtil {
    public static void updateUserRolesFromDb(HttpSession session, Long nationalId) throws Exception {
        List<UserRole> userRoles = UserRoleDAO.findUserRolesByNationalId(nationalId);
        HashMap<String, Long> userRolesHash = new HashMap<>();
        for (UserRole userRole : userRoles)
            userRolesHash.put(UserRoleType.fromValue(userRole.getUserRoleVal()).getRoleSessionKey(),
                    userRole.getRoleId());
        session.setAttribute(Constants.SESSION_USER_ROLES, userRolesHash);

        ServletContext jobContext = session.getServletContext().getContext("/co-operate");
        session.setAttribute(Constants.SESSION_USER_ROLES, userRolesHash);
    }
}