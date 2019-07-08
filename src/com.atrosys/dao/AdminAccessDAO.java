package com.atrosys.dao;

import com.atrosys.entity.AdminAccess;
import com.atrosys.util.HibernateUtil;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class AdminAccessDAO {
    public static final String TABLE_NAME = "admin_access";

    public static AdminAccess save(AdminAccess adminAccess) throws Exception {
        return (AdminAccess) new HibernateUtil().save(adminAccess);
    }
}
