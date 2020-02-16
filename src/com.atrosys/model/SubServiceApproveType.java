package com.atrosys.model;

/**
 * Service form composer types.
 */

public enum SubServiceApproveType {
    REGULATORY(1,"کمیسیون تنظیم مقررات"),
    BOARD("هیأت مدیره اپراتور");
    private final int value;
    private final String faStr;

    private SubServiceApproveType(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private SubServiceApproveType(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }
    public String getFaStr() {
        return faStr;
    }

    public static SubServiceApproveType fromValue(int value) {
        for (SubServiceApproveType uniStatus : SubServiceApproveType.values()) {
            if (uniStatus.getValue() == value)
                return uniStatus;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
