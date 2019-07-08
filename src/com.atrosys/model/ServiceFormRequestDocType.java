package com.atrosys.model;

public enum ServiceFormRequestDocType {
    LETTER("نامه روکش"),
    POST_RECEIPT("رسید پستی"),
    SIGNED_FORM("فرم تک امضا"),
    FINAL_SIGNED_FORM("فرم دو امضا"),
    SUBS_LETTER("روکش فرم اشتراک"),
    SUBS_POST_RECEIPT("رسید پستی فرم اشتراک"),
    SUBS_SIGNED("فرم اشتراک تک امضا"),
    SUBS_FINAL("فرم اشتراک دو امضا");

    private final int value;
    private final String faStr;

    ServiceFormRequestDocType(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    ServiceFormRequestDocType(String faStr) {
        this.faStr = faStr;
        this.value = Counter.nextValue++;
    }


    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static ServiceFormRequestDocType fromValue(int value) {
        for (ServiceFormRequestDocType serviceFormRequestDocType : ServiceFormRequestDocType.values()) {
            if (serviceFormRequestDocType.getValue() == value)
                return serviceFormRequestDocType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
