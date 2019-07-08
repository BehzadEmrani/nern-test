package com.atrosys.dao;

import com.atrosys.entity.PersonalDoc;
import com.atrosys.util.HibernateUtil;

/**
 * Created by mehdisabermahani on 6/16/17.
 */
public class PersonalDocDAO {
    public static final String TABLE_NAME = "personal_doc";

    public static PersonalDoc save(PersonalDoc personalDoc) throws Exception {
        return (PersonalDoc) new HibernateUtil().save(personalDoc);
    }

    public static PersonalDoc update(long nationalId, PersonalDoc personalDoc) throws Exception {
        PersonalDoc ex = new PersonalDoc();
        ex.setNationalId(nationalId);
        new HibernateUtil().delete(ex);
        return (PersonalDoc) new HibernateUtil().save(personalDoc);
    }
}
