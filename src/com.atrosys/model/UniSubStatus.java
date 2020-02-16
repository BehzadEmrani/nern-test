package com.atrosys.model;

import com.google.gson.annotations.SerializedName;

/**
 * field of customer registration form which contains error.
 */

public enum UniSubStatus {
    REGISTER_PAGE_REQUEST_FORM_ERROR(0, "مشکل در فایل درخواست عضویت"),
    REGISTER_PAGE_TOP_MANAGER_ERROR("مشکل در نام بالاترین مقام"),
    REGISTER_PAGE_TEL_ERROR("مشکل در شماره تلفن"),
    REGISTER_PAGE_FAX_ERROR("مشکل در شماره فکس"),
    REGISTER_PAGE_CITY_ERROR("شهر اشتباه"),
    REGISTER_PAGE_STATE_ERROR("استان اشتباه"),
    REGISTER_PAGE_ADDRESS_ERROR("آدرس اشتباه"),
    REGISTER_PAGE_POSTAL_CODE_ERROR("کد پستی اشتباه"),
    REGISTER_PAGE_EMAIL_ERROR("مشکل در پست الکترونیک"),
    REGISTER_PAGE_MAP_ERROR("مکان اشتباه روی نقشه"),
    SUBS_PAGE_SIG_ERROR(1000, "شخص امضاء کننده مجاز به امضاء نبوده"),
    SUBS_PAGE_FORMAT_ERROR("فرمت قرارداد ارسالی مطابقت ندارد");

    @SerializedName("${value}")
    private final int value;
    @SerializedName("${fa}")
    private final String faStr;

    private UniSubStatus(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private UniSubStatus(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static UniSubStatus fromValue(int value) {
        for (UniSubStatus uniStatus : UniSubStatus.values()) {
            if (uniStatus.getValue() == value)
                return uniStatus;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
