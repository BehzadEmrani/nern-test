package com.atrosys.dao;

import com.atrosys.entity.PostalCode;
import com.atrosys.util.HibernateUtil;

/**
 * Created by mehdisabermahani on 6/15/17.
 */
public class PostalCodeDAO {

    public static PostalCode save(PostalCode postalCode) throws Exception {
        return (PostalCode) new HibernateUtil().save(postalCode);
    }

}
