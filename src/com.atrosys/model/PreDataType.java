package com.atrosys.model;

/**
 * There's some pre-defined data about azad university and etc which used in registration page,
 * this enum shows data is for which uni type.
 */

public enum PreDataType {
    FROM_ILENC(0, 11111111111l, "سامانه ی اشخاص حقوقی"),
    AZAD_ISLAMI(10100190358l, "دانشگاه آزاد اسلامی"),
    PAYAME_NOOR(14002921527l, "دانشگاه پیام نور"),
    FANI_HERFEE(14002830431l, "دانشگاه فنی حرفه ای"),
    JAME_ELMI(14002811828l, "دانشگاه جامع علمی و کاربردی"),
    FARHANGIAN(14002366030l, "دانشگاه فرهنگیان"),
    RESEARCH_AGRICULTURE(14002909870l, "سازمان تحقیقات،آموزش و ترویج کشاورزی");

    private final int value;
    private final long nationalId;
    private final String faStr;

    private PreDataType(int value, long nationalId, String faStr) {
        this.value = value;
        this.faStr = faStr;
        this.nationalId = nationalId;
        Counter.nextValue = value + 1;
    }

    private PreDataType(long nationalId, String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
        this.nationalId = nationalId;
    }

    public int getValue() {
        return value;
    }

    public long getNationalId() {
        return nationalId;
    }

    public String getFaStr() {
        return faStr;
    }


    public static PreDataType fromValue(int value) {
        for (PreDataType preDataType : PreDataType.values()) {
            if (preDataType.getValue() == value)
                return preDataType;
        }
        return null;
    }

    public static  PreDataType formFaStr(String faStr) {
        for (PreDataType preDataType : PreDataType.values()) {
            if (preDataType.getFaStr().matches(faStr.trim()))
                return  preDataType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }
}
