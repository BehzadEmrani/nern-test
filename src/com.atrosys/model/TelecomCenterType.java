package com.atrosys.model;

public enum TelecomCenterType {
    TELECOM_CENTER(1000, "مرکز مخابراتی"),
    INFRASTRUCTURE_CENTER(2000, "مرکز زیرساخت");

    private final int value;
    private final String faStr;

    private TelecomCenterType(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private TelecomCenterType(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static TelecomCenterType fromValue(int value) {
        for (TelecomCenterType adminAccesses : TelecomCenterType.values()) {
            if (adminAccesses.getValue() == value)
                return adminAccesses;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
