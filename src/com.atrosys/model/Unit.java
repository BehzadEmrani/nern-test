package com.atrosys.model;

/**
 * Created by met on 12/14/17.
 * measure units mostly used in service contract.
 */

public enum Unit {
    TIME_H(1000, "ساعت", "h"),
    TIME_M("دقیقه", "m"),
    TIME_S("ثانیه", "s"),
    TIME_MS("میلی ثانیه", "ms"),
    PERCENT(2000, "درصد", "%"),
    OHM_PER_KM(3000, "اهم در کیلومتر", "Ω/km"),
    WORK_HOUR(4000, "ساعت کاری", "wh");

    private final int value;
    private final String faStr;
    private final String abbreStr;

    private Unit(int value, String faStr, String abbreStr) {
        this.value = value;
        this.faStr = faStr;
        this.abbreStr = abbreStr;
        Counter.nextValue = value + 1;
    }

    private Unit(String faStr, String abbreStr) {
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

    public static Unit fromValue(int value) {
        for (Unit unit : Unit.values()) {
            if (unit.getValue() == value)
                return unit;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
