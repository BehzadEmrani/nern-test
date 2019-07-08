package com.atrosys.model;

public enum HospitalType implements SubSystemsType {
    MEDICAL_GOV(0, "مراکز آموزشی و درمانی دولتی", true, PreDataType.FROM_ILENC),
    MEDICAL_NON_GOV( "مراکز آموزشی و درمانی غیردولتی", true, PreDataType.FROM_ILENC);

    private final int value;
    private final boolean isActive;
    private final String faStr;
    private final PreDataType preDataType;

    private HospitalType(int value, String faStr, boolean isActive, PreDataType preDataType) {
        this.value = value;
        this.faStr = faStr;
        this.isActive = isActive;
        this.preDataType = preDataType;
        Counter.nextValue = value + 1;
    }

    private HospitalType(String faStr, boolean isActive, PreDataType preDataType) {
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

    public static HospitalType fromValue(int value) {
        for (HospitalType researchCenterType : HospitalType.values()) {
            if (researchCenterType.getValue() == value)
                return researchCenterType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
