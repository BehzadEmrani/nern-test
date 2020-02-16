package com.atrosys.model;

/**
 * Created by met on 12/14/17.
 * Service SLA standard.
 */

public enum SLAType {
    BRONZE(1,"برنز", "B"),
    SILVER("نقره", "S"),
    GOLD("طلا", "G"),
    DIAMOND("الماس", "D");

    private final int value;
    private final String faStr;
    private final String abbrStr;

    private SLAType(int value, String faStr, String abbrStr) {
        this.value = value;
        this.faStr = faStr;
        this.abbrStr = abbrStr;
        Counter.nextValue = value + 1;
    }

    private SLAType(String faStr, String abbrStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
        this.abbrStr = abbrStr;
    }

    public int getValue() {
        return value;
    }

    public String combinedFaStr() {
        return faStr + "(" + abbrStr + ")";
    }

    public String getFaStr() {
        return faStr;
    }

    public String getAbbrStr() {
        return abbrStr;
    }

    public static SLAType fromValue(int value) {
        for (SLAType slaType : SLAType.values()) {
            if (slaType.getValue() == value)
                return slaType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
