package com.atrosys.model;

/**
 * Created by met on 12/14/17.
 */
public enum PayType {
    TIME_H(1000, "پیش پرداخت", "PR"),
    PERCENT(2000, "پس پرداخت", "PO");

    private final int value;
    private final String faStr;
    private final String abbreStr;

    PayType(int value, String faStr, String abbreStr) {
        this.value = value;
        this.faStr = faStr;
        this.abbreStr = abbreStr;
        Counter.nextValue = value + 1;
    }

    PayType(String faStr, String abbreStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
        this.abbreStr = abbreStr;
    }

    public int getValue() {
        return value;
    }

    public String combinedFaStr() {
        return faStr + "(" + abbreStr + ")";
    }

    public String getFaStr() {
        return faStr;
    }

    public String getAbbreStr() {
        return abbreStr;
    }

    public static PayType fromValue(int value) {
        for (PayType payType : PayType.values()) {
            if (payType.getValue() == value)
                return payType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
