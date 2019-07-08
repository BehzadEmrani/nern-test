package com.atrosys.util;

import com.atrosys.dao.AdminAccessLogDAO;
import com.atrosys.entity.Admin;
import com.atrosys.entity.AdminAccessLog;
import com.atrosys.entity.PersonalInfo;
import com.atrosys.model.AdminAccessLogType;
import com.atrosys.model.AdminSessionInfo;
import com.atrosys.model.Constants;
import com.atrosys.model.UserRoleType;

import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.HashMap;

public class SessionListener implements HttpSessionAttributeListener, HttpSessionListener {

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        try {
            AdminSessionInfo adminSessionInfo = new AdminSessionInfo(event.getSession());
            Admin admin = adminSessionInfo.getAdmin();
            PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();

            if (event.getName().equals(Constants.SESSION_USER_ROLES)) {
                Long adminId = ((HashMap<String, Long>) event.getValue()).get(UserRoleType.ADMINS.getRoleSessionKey());
                if (adminId != null) {
                    AdminAccessLog adminAccessLog = new AdminAccessLog();
                    adminAccessLog.setAdminId(adminId);
                    adminAccessLog.setAdminAccessLogTypeVal(AdminAccessLogType.ADMIN_LOGED_IN.getValue());
                    adminAccessLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                    adminAccessLog.setMessage(String.format("\"%s\" وارد بخش مدیریت شد.", personalInfo.combineName()));
                    AdminAccessLogDAO.save(adminAccessLog);
                }
            }
        } catch (Exception e) {
        }
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        try {
            AdminSessionInfo adminSessionInfo = new AdminSessionInfo(event.getSession());
            Admin admin = adminSessionInfo.getAdmin();
            PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();
            if (event.getName().equals(Constants.SESSION_USER_ROLES)) {
                Long adminId = ((HashMap<String, Long>) event.getValue()).get(UserRoleType.ADMINS.getRoleSessionKey());
                if (adminId != null) {
                    AdminAccessLog adminAccessLog = new AdminAccessLog();
                    adminAccessLog.setAdminId(adminId);
                    adminAccessLog.setAdminAccessLogTypeVal(AdminAccessLogType.ADMIN_LOGED_OUT.getValue());
                    adminAccessLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                    adminAccessLog.setMessage(String.format("\"%s\" از بخش مدیریت خارج شد.", personalInfo.combineName()));
                    AdminAccessLogDAO.save(adminAccessLog);
                }
            }
        } catch (Exception e) {
        }
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
    }

    @Override
    public void sessionCreated(HttpSessionEvent httpSessionEvent) {
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        try {
            AdminSessionInfo adminSessionInfo = new AdminSessionInfo(httpSessionEvent.getSession());
            Admin admin = adminSessionInfo.getAdmin();
            PersonalInfo personalInfo = adminSessionInfo.getPersonalInfo();
            if (adminSessionInfo.isAdminLogedIn()) {
                AdminAccessLog adminAccessLog = new AdminAccessLog();
                adminAccessLog.setAdminId(admin.getId());
                adminAccessLog.setAdminAccessLogTypeVal(AdminAccessLogType.ADMIN_SESSION_EXPIRED.getValue());
                adminAccessLog.setTimeStamp(new Timestamp(Calendar.getInstance().getTimeInMillis()));
                adminAccessLog.setMessage(String.format("ورود %s در بخش مدیریت منقضی شد.", personalInfo.combineName()));
                AdminAccessLogDAO.save(adminAccessLog);
            }
        } catch (Exception e) {

        }

    }
}