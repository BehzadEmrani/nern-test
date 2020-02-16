package com.atrosys.model;

/**
 * Martial Status
 * never used.
 */

public enum Marriage {
    SINGLE(0, "مجرد"),
    MARRIED("متاهل");;
    private final int value;
    private final String faStr;

    private Marriage(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private Marriage(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }


    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }


    public static Marriage fromValue(int value) {
        for (Marriage marriage : Marriage.values()) {
            if (marriage.getValue() == value)
                return marriage;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
