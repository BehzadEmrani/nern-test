package com.atrosys.model;

/**
 * Created by met on 12/14/17.
 * Equipment's port type.
 */

public enum PortUnit {
    NM(1000, "نانومتر", "nm"),
    TBPS(2000,"ترابایت در ثانیه", "Tbps"),
    GBPS("گیگابایت در ثانیه", "Gbps"),
    MBPS("مگابایت در ثانیه", "Mbps");

    private final int value;
    private final String faStr;
    private final String abbreStr;

    private PortUnit(int value, String faStr, String abbreStr) {
        this.value = value;
        this.faStr = faStr;
        this.abbreStr = abbreStr;
        Counter.nextValue = value + 1;
    }

    private PortUnit(String faStr, String abbreStr) {
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

    public static PortUnit fromValue(int value) {
        for (PortUnit portUnit : PortUnit.values()) {
            if (portUnit.getValue() == value)
                return portUnit;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
