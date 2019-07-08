package com.atrosys.model;

public enum UserRoleType {
    UNIVERSITY(1000, "دانشگاه ها و مراکز آموزش عالی",
            "SESSION_UNIVERSITY_USER_ROLE_ID",
            "pages/index.jsp?sub-code=" + SubSystemCode.UNIVERSITY.getValue()),
        SEMINARY("حوزه های علمیه",
            "SESSION_SEMINARY_USER_ROLE_ID",
            "pages/index.jsp?sub-code=" + SubSystemCode.SEMINARY.getValue()),
    RESEARCH_CENTER("مراکز پژوهشی و تحقیقاتی",
            "SESSION_RESEARCH_CENTER_USER_ROLE_ID",
            "pages/index.jsp?sub-code=" + SubSystemCode.RESEARCH_CENTER.getValue()),
    HOSPITALS("مراکز آموزش درمانی",
            "SESSION_HOSPITAL_USER_ROLE_ID",
            "pages/index.jsp?sub-code=" + SubSystemCode.HOSPITAL.getValue()),
    ADMINS(2000, "مدیریت سایت",
            "SESSION_ADMIN_USER_ROLE_ID",
            "admin/index.jsp?page=welcome"),
    JOB_SEEKER(3000 , "متقاضی شغل" ,
                       "SESSION_JOB_SEEKER" ,
                       "co-operate/index.jsp") ;

    private final int value;
    private final String faStr;
    private final String redirectPage;

    private final String roleSessionKey;

    private UserRoleType(int value, String faStr, String roleSessionKey, String redirectPage) {
        this.value = value;
        this.faStr = faStr;
        this.redirectPage = redirectPage;
        this.roleSessionKey = roleSessionKey;
        Counter.nextValue = value + 1;
    }

    private UserRoleType(String faStr, String roleSessionKey, String redirectPage) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
        this.redirectPage = redirectPage;
        this.roleSessionKey = roleSessionKey;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public String getRedirectPage() {
        return redirectPage;
    }

    public String getRoleSessionKey() {
        return roleSessionKey;
    }

    public static UserRoleType fromValue(int value) {
        for (UserRoleType adminAccesses : UserRoleType.values()) {
            if (adminAccesses.getValue() == value)
                return adminAccesses;
        }
        return null;
    }

    public static UserRoleType fromSubSystemCode(SubSystemCode subSystemCode) {
        switch (subSystemCode) {
            case UNIVERSITY:
                return UNIVERSITY;
            case RESEARCH_CENTER:
                return RESEARCH_CENTER;
            case HOSPITAL:
                return HOSPITALS;
            case SEMINARY:
                return SEMINARY;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
