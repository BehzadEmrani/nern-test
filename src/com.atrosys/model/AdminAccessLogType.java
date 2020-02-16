package com.atrosys.model;

/**
 * Types of log for admin
 */

public enum AdminAccessLogType {
    ADMIN_LOGED_IN(1000,"ورود به بخش مدیریت سایت"),
    ADMIN_LOGED_OUT("خروج از بخش مدیریت سایت"),
    ADMIN_SESSION_EXPIRED(2000,"انقضای ورود کاربر"),
    ADMIN_ACCESS_TO_PAGE(3000,"دسترسی به صفحات مدیریتی");


    private final int value;
    private final String faStr;

    private AdminAccessLogType(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private AdminAccessLogType(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static AdminAccessLogType fromValue(int value) {
        for (AdminAccessLogType adminAccessLogType : AdminAccessLogType.values()) {
            if (adminAccessLogType.getValue() == value)
                return adminAccessLogType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
