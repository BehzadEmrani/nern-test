package com.atrosys.model;

/**
 * Created by met on 12/14/17.
 */
public enum EquipmentElectronicSource {
    AC(1000, "منبع مستقیم", "AC"),
    DC(2000,"منبع متناوب", "DC");

    private final int value;
    private final String faStr;
    private final String abbreStr;

    private EquipmentElectronicSource(int value, String faStr, String abbreStr) {
        this.value = value;
        this.faStr = faStr;
        this.abbreStr = abbreStr;
        Counter.nextValue = value + 1;
    }

    private EquipmentElectronicSource(String faStr, String abbreStr) {
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

    public static EquipmentElectronicSource fromValue(int value) {
        for (EquipmentElectronicSource unit : EquipmentElectronicSource.values()) {
            if (unit.getValue() == value)
                return unit;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
