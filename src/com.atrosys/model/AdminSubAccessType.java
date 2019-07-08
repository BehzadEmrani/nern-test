package com.atrosys.model;

public enum AdminSubAccessType {
    READ(0, "مشاهده"),
    ADD("افزودن"),
    EDIT("ویرایش"),
    DELETE("حذف");

    private final int value;
    private final String faStr;

    private AdminSubAccessType(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private AdminSubAccessType(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static AdminSubAccessType fromValue(int value) {
        for (AdminSubAccessType adminAccesses : AdminSubAccessType.values()) {
            if (adminAccesses.getValue() == value)
                return adminAccesses;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}

