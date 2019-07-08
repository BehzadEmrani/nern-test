package com.atrosys.model;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public enum Validity {
    PERMANT_DEACTIVE(0),
    TEMP_DEACTIVE,
    ACTIVE;
    private final int value;

    private Validity(int value) {
        this.value = value;
        Counter.nextValue = value + 1;
    }

    private Validity() {
        value = Counter.nextValue++;
    }

    public int getValue() {
        return value;
    }

    public static Validity fromValue(int value) {
        for (Validity validity : Validity.values()) {
            if (validity.getValue() == value)
                return validity;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
