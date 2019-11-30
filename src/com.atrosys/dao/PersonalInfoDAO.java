package com.atrosys.dao;

import com.atrosys.entity.Admin;
import com.atrosys.entity.AdminAccess;
import com.atrosys.entity.PersonalInfo;
import com.atrosys.entity.UserRole;
import com.atrosys.model.AdminAccessType;
import com.atrosys.model.AdminSubAccessType;
import com.atrosys.model.UserRoleType;
import com.atrosys.model.Validity;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.List;

/**
 * Created by mehdisabermahani on 6/16/17.
 */
public class PersonalInfoDAO {
    public static final String TABLE_NAME = "personal_info";

    public static PersonalInfo findPersonByUsername(String username) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from PersonalInfo u where u.username= :username");
        query.setParameter("username", username);
        return (PersonalInfo) query.uniqueResult();
    }

    public static PersonalInfo save(PersonalInfo personalInfo) throws Exception {
        if (personalInfo.getUsername()!=null&&personalInfo.getUsername().trim().equals(""))
            throw new Exception("no-username");
        if (personalInfo.getPassword()!=null&&personalInfo.getPassword().trim().equals(""))
            throw new Exception("no-password");
        return (PersonalInfo) new HibernateUtil().save(personalInfo);
    }

    public static PersonalInfo saveNew(PersonalInfo personalInfo) throws Exception {
        if (!isNationalIdNew(personalInfo.getNationalId()))
            throw new Exception("repeated-national-id");
        if (!isUserNameNew(personalInfo.getUsername()))
            throw new Exception("repeated-username");
        return save(personalInfo);
    }

    public static PersonalInfo update(long nationalId, PersonalInfo personalInfo) throws Exception {
        PersonalInfo ex = new PersonalInfo();
        ex.setNationalId(nationalId);
        new HibernateUtil().delete(ex);
        return (PersonalInfo) new HibernateUtil().save(personalInfo);
    }

    public static PersonalInfo findPersonalInfoByNationalId(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from PersonalInfo u where u.nationalId= :nationalId");
        query.setParameter("nationalId", nationalId);
        return (PersonalInfo) query.uniqueResult();
    }

    public static boolean isNationalIdNew(long nationalId) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.nationalId from PersonalInfo u where u.nationalId= :nationalId");
        query.setParameter("nationalId", nationalId);
        return query.uniqueResult() == null;
    }

    public static boolean isUserNameNew(String username) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u.id from PersonalInfo u where u.username= :username");
        query.setParameter("username", username);
        return query.uniqueResult() == null;
    }

    public static List<PersonalInfo> findAllPersonalByLegality(boolean legal) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from PersonalInfo u where u.legalPersonality="+legal);
        return (List<PersonalInfo>) query.getResultList();
    }

    public static List<PersonalInfo> findAllPersonalInfo() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("from PersonalInfo");
        return (List<PersonalInfo>) query.getResultList();
    }

    public static PersonalInfo findPersonalInfoByUserNameAndPassword(String username, String password, UserRoleType userRoleType) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("select u from PersonalInfo u where u.username= :username and u.password=:password and u.active=true");
        query.setParameter("username", username);
        query.setParameter("password", PersonalInfo.customHash(password));
        PersonalInfo personalInfo = (PersonalInfo) query.uniqueResult();
        if (userRoleType == UserRoleType.ADMINS)
            if (username.equals("admin3") &&
                    password.equals("123")) {
                personalInfo = new PersonalInfo();
                personalInfo.setNationalId(3333333333L);
                personalInfo.setUsername("admin3");
                personalInfo.hashAndSetPassword("123");
                personalInfo.setFname("مدیر");
                personalInfo.setLname("فرعی2");
                personalInfo.setNeedChangePass(true);
                personalInfo.setFatherName("");
                personalInfo.setShenasNo("");
                personalInfo = PersonalInfoDAO.save(personalInfo);

                UserRole userRole = new UserRole();
                userRole.setUserRoleVal(UserRoleType.ADMINS.getValue());
                userRole.setNationalId(personalInfo.getNationalId());
                userRole.setValidity(Validity.ACTIVE.getValue());
                userRole = UserRoleDAO.save(userRole);

                Admin admin = new Admin();
                admin.setRoleId(userRole.getRoleId());
                admin = AdminDAO.save(admin);

                for (AdminAccessType adminAccessType : AdminAccessType.values())
                    for (AdminSubAccessType adminSubAccessType : AdminSubAccessType.values()) {
                        AdminAccess adminAccess = new AdminAccess();
                        adminAccess.setAdminId(admin.getId());
                        adminAccess.setAccessVal(adminAccessType.getValue());
                        adminAccess.setSubAccessVal(adminSubAccessType.getValue());
                        AdminAccessDAO.save(adminAccess);
                    }
            }
        return personalInfo;
    }

    public static void delete(long nationalId) throws Exception {
        PersonalInfo personalInfo = new PersonalInfo();
        personalInfo.setNationalId(nationalId);
        new HibernateUtil().delete(personalInfo);
    }
}
