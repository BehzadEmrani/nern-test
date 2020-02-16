package com.atrosys.model;

/**
 * type of customer error.
 */

public enum UniErrors {
    REGISTER_PAGE_NATIONAL_CODE_ERRPOR(0, "خطا در شناسه ملی"),
    REGISTER_PAGE_VERIFY("انتظار برای تایید درخواست عضویت"),
    SUBSCRIBE_PAGE(1000, "ارسال قرارداد جهت امضاء متقاضی");
    private final int value;
    private final String faStr;

    private UniErrors(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private UniErrors(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public static UniErrors fromValue(int value) {
        for (UniErrors uniStatus : UniErrors.values()) {
            if (uniStatus.getValue() == value)
                return uniStatus;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
