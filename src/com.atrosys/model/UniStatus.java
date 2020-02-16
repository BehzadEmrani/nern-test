package com.atrosys.model;

/**
 * customer registration request stage.
 */

public enum UniStatus {
    REGISTER_PAGE_VERIFY(1, "انتظار برای تایید درخواست عضویت"),
    REGISTER_PAGE_ERROR("اصلاح خطا در فرم درخواست عضویت"),
    REGISTER_SECOND_RELATED_ORGAN("انتظار برای تایید درخواست توسط دستگاه مربوطه"),
    SUBSCRIBE_PAGE(1000, "ارسال قرارداد اشتراک جهت امضاء متقاضی"),
    SUBSCRIBE_PAGE_VERIFY("انتظار تایید اشتراک توسط اپراتور"),
    SUBSCRIBE_PAGE_ERROR("اصلاح خطا در فرم درخواست اشتراک"),
    NEXT_PHASE("انتظار برای بررسی  در فاز بعد"),
    PRIMARY_AGENT_REGISTER(2000, "ثبت نام مسئول اصلی"),
    REGISTER_COMPLETED(3000, "ثبت قرارداد"),
    UNI_EDIT_VERIFY("تایید ویرایش دانشگاه ها"),
    AGENT_EDIT_VERIFY("تایید ویرایش مسئول اصلی"),
    UNI_CANCEL_REQUEST_VERIFY("انتظار برای تایید درخواست لغو عضویت"),
    UNI_CANCEL_REQUEST_CONFIRM("تایید نهایی لغو عضویت"),
    UNI_SUBSCRIPTION_CANCELLED("تایید ویرایش دانشگاه ها"),
    REGISTER_SERVICE_FORM("ثبت سرویس فرم");


    private final int value;
    private final String faStr;

    private UniStatus(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private UniStatus(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static UniStatus fromValue(int value) {
        for (UniStatus uniStatus : UniStatus.values()) {
            if (uniStatus.getValue() == value)
                return uniStatus;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
