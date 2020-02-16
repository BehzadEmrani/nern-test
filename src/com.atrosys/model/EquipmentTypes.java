package com.atrosys.model;

/**
 * Network equipments main type options.
 */

public enum EquipmentTypes {
    PASSIVE(1000, "پسیو"),
    ACTIVE(3000, "اکتیو"),
    CONNECTOR(4000, "کانکتور"),
    CONSUMABLE(5000, "مصرفی");

    private final int value;
    private final String faStr;

    private EquipmentTypes(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private EquipmentTypes(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static EquipmentTypes fromValue(int value) {
        for (EquipmentTypes adminAccesses : EquipmentTypes.values()) {
            if (adminAccesses.getValue() == value)
                return adminAccesses;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
