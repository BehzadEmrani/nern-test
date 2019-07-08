package com.atrosys.model;

public enum FeedBackStatus {
    WORKING_ON(1000,"در حال برطرف کردن مشکل"),
    CORRECTED(2000,"مشکل برطرف شده");

    private final int value;
    private final String faStr;

    private FeedBackStatus(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private FeedBackStatus(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static FeedBackStatus fromValue(int value) {
        for (FeedBackStatus adminAccesses : FeedBackStatus.values()) {
            if (adminAccesses.getValue() == value)
                return adminAccesses;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}

