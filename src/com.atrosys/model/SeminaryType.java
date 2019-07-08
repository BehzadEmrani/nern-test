package com.atrosys.model;

public enum SeminaryType implements SubSystemsType {
    SEMINARY_GHOM_APPROVED(0, "حوزه‌های علمیه مورد تایید مرکز مدیریت حوزه‌های علمیه قم", true, PreDataType.FROM_ILENC),
    SEMINARY_KHAHARAN_APPROVED( "حوزه‌های علمیه مورد تایید مرکز مدیریت حوزه‌های علمیه خواهران", true, PreDataType.FROM_ILENC),
    SEMINARY_ESFEHAN_APPROVED( "حوزه‌های علمیه مورد تایید مرکز مدیریت حوزه‌های علمیه اصفهان", true, PreDataType.FROM_ILENC),
    SEMINARY_KHORASAN_APPROVED( "حوزه‌های علمیه مورد تایید مرکز مدیریت حوزه‌های علمیه خراسان", true, PreDataType.FROM_ILENC),
    SEMINARY_SONNAT_APPROVED( "حوزه‌های علمیه مورد تایید مرکز مدیریت حوزه‌های علمیه اهل سنت", true, PreDataType.FROM_ILENC);

    private final int value;
    private final boolean isActive;
    private final String faStr;
    private final PreDataType preDataType;

    private SeminaryType(int value, String faStr, boolean isActive, PreDataType preDataType) {
        this.value = value;
        this.faStr = faStr;
        this.isActive = isActive;
        this.preDataType = preDataType;
        Counter.nextValue = value + 1;
    }

    private SeminaryType(String faStr, boolean isActive, PreDataType preDataType) {
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

    public static SeminaryType fromValue(int value) {
        for (SeminaryType researchCenterType : SeminaryType.values()) {
            if (researchCenterType.getValue() == value)
                return researchCenterType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
