package com.atrosys.model;

/**
 * University customers types.
 */

public enum UniversityType implements SubSystemsType {
    GOV_UNIVERSITY(0, "دانشگاه‌های دولتی مورد تایید وزارت علوم,تحقیقات و فناوری", true, PreDataType.FROM_ILENC),
    MEDICAL_UNIVERSITY("دانشگاه‌های دولتی مورد تایید وزارت بهداشت و درمان و آموزش پزشکی", true, PreDataType.FROM_ILENC),
    NON_GOV_UNIVERSITY("دانشگاه‌های غیر‌دولتی(غیر انتفاعی)", true, PreDataType.FROM_ILENC),
    AZAD_UNIVERSITY("دانشگاه آزاد اسلامی و واحدهای آن", true, PreDataType.AZAD_ISLAMI),
    PAYAME_NOOR_UNIVERSITY("دانشگاه پیام نور و مراکز و واحدهای آن", false, PreDataType.PAYAME_NOOR),
    OTHER(8, "سایر", true, PreDataType.FROM_ILENC),
    JAME_ELMI_BY_CODE(9, "مراکز و موسسات آموزش علمی و کاربردی با کد مستقل", true, PreDataType.FROM_ILENC),
    JAME_ELMI_SUB_CODE(10, "مراکز و موسسات آموزش علمی و کاربردی با کد مرکز", true, PreDataType.JAME_ELMI);

    private final int value;
    private final boolean isActive;
    private final String faStr;
    private final PreDataType preDataType;

    private UniversityType(int value, String faStr, boolean isActive, PreDataType preDataType) {
        this.value = value;
        this.faStr = faStr;
        this.isActive = isActive;
        this.preDataType = preDataType;
        Counter.nextValue = value + 1;
    }

    private UniversityType(String faStr, boolean isActive, PreDataType preDataType) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
        this.isActive = isActive;
        this.preDataType = preDataType;
    }

    public boolean isActive() {
        return isActive;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public PreDataType getPreDataType() {
        return preDataType;
    }

    public static UniversityType fromValue(int value) {
        for (UniversityType universityType : UniversityType.values()) {
            if (universityType.getValue() == value)
                return universityType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
