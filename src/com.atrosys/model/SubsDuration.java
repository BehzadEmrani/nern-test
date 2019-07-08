package com.atrosys.model;

/**
 * Created by met on 12/14/17.
 */
public enum SubsDuration {
    MONTH_01(1, "یک ماهه", "01"),
    MONTH_03(3, "سه ماهه", "03"),
    MONTH_06(6, "شش ماهه", "06"),
    MONTH_12(12, "یک ساله", "12"),
    MONTH_24(24, "دو ساله", "24"),
    MONTH_36(36, "سه ساله", "36"),
    END(99, "تا زمان دریافت خدمات شعا", "99");

    private final int value;
    private final String faStr;
    private final String abbreStr;

    private SubsDuration(int value, String faStr, String abbreStr) {
        this.value = value;
        this.faStr = faStr;
        this.abbreStr = abbreStr;
        Counter.nextValue = value + 1;
    }

    private SubsDuration(String faStr, String abbreStr) {
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

    public static SubsDuration fromValue(int value) {
        for (SubsDuration subsDuration : SubsDuration.values()) {
            if (subsDuration.getValue() == value)
                return subsDuration;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
