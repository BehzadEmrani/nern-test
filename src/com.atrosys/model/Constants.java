package com.atrosys.model;

import com.atrosys.util.OSValidator;

import javax.swing.filechooser.FileSystemView;

/**
 * Project level constants and settings.
 */

public class Constants {
    public static final boolean IS_UNIVERCITY_SECTION_ACTIVE = true;
    //    public static final String WEB_APP_ROOT = "/Test/";
    public static final String WEB_APP_ROOT = "/";
    public static final String CO_OPERATE_WEB_APP_ROOT = "/co-operate";

    public static String MYSQL_DUMP_PATH;
    public static String MYSQL_BACKUP_PATH;

    static {
        if (OSValidator.isMac()) {
            MYSQL_DUMP_PATH = "/applications/MAMP/library/bin/mysqldump";
            MYSQL_BACKUP_PATH = FileSystemView.getFileSystemView().getHomeDirectory() + "/Desktop/ShoaBackUP/";
        } else if (OSValidator.isWindows()) {
            MYSQL_DUMP_PATH = "C:\\Program Files\\MySQL\\MySQL Server 5.7\\bin\\mysqldump.exe";
            MYSQL_BACKUP_PATH = "C:\\NERNBackup\\";
        }
    }

    public static final int INFO_DOC_PER_PAGE = 10;
    public static final int CONTRACT_DOC_PER_PAGE = 10;
    public static final int INFO_NEWS_PER_PAGE = 10;
    public static final int ADMIN_SERVICE_FORM_PER_PAGE = 10;
    public static final int SUBS_PER_PAGE = 10;

    public static final int DAYS_FOR_BACKUP_KEEPING = 30;
    public static final int[] DAY_HOURS_FOR_BACKUP = new int[]{18};

    public static final String SESSION_TEMP_UNI = "SESSION_TEMP_UNI";
    public static final String SESSION_TEMP_PERSON = "SESSION_TEMP_PERSON";
    public static final String SESSION_TEMP_AGENT = "SESSION_TEMP_AGENT";
    public static final String SESSION_TEMP_REGISTER_UPLOAD_FIELD = "SESSION_TEMP_REGISTER_UPLOAD_FIELD";
    public static final String SESSION_TEMP_STATE = "SESSION_TEMP_STATE";
    public static final String SESSION_TEMP_PRE_UNI_DATA = "SESSION_TEMP_PRE_UNI_DATA" +
            "";

    public static final String SESSION_USER_NATIONAL_ID = "SESSION_USER_NATIONAL_ID";
    public static final String SESSION_USER_ROLES = "SESSION_USER_ROLES";

    public static final String SESSION_INITIAL_ADMIN_USERNAME = "admin";
    public static final String SESSION_INITIAL_ADMIN_PASSWORD = "123456";

    public static final String ERROR_500_MESSAGE = "خطای نامشخص!";
    public static final String ERROR_400_MESSAGE = "موردی یافت نشد!";

}
