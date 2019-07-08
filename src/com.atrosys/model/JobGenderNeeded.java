package com.atrosys.model;

public enum JobGenderNeeded {
    MAN(0, "مج"),
    WOMAN("زن"),
    BOTH("هردو");
    private final int value;
    private final String faStr;

    private JobGenderNeeded(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private JobGenderNeeded(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }


    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }


    public static JobGenderNeeded fromValue(int value) {
        for (JobGenderNeeded marriage : JobGenderNeeded.values()) {
            if (marriage.getValue() == value)
                return marriage;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
