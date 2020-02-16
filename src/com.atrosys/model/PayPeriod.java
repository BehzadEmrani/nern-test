package com.atrosys.model;

/**
 * Created by met on 12/14/17.
 * Service form contracts pay period.
 */

public enum PayPeriod {
    MONTH_01(1, "یک ماهه", "01"),
    MONTH_03(3, "سه ماهه", "03"),
    MONTH_06(6, "شش ماهه", "06"),
    MONTH_12(12, "یک ساله", "12"),
    ONCE_00(0,"یک بار پس از آزمایش و تحویل","00");

    private final int value;
    private final String faStr;
    private final String abbreStr;

    private PayPeriod(int value, String faStr, String abbreStr) {
        this.value = value;
        this.faStr = faStr;
        this.abbreStr = abbreStr;
        Counter.nextValue = value + 1;
    }

    private PayPeriod(String faStr, String abbreStr) {
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

    public static PayPeriod fromValue(int value) {
        for (PayPeriod payPeriod : PayPeriod.values()) {
            if (payPeriod.getValue() == value)
                return payPeriod;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
