package com.atrosys.model;

public enum ResearchCenterType implements SubSystemsType {
    RESEARCH_CENTER_MINIS_SCI(0, "مراکز پژوهشی مورد تایید وزارت علوم,تحقیقات و فناوری", true, PreDataType.FROM_ILENC),
    RESEARCH_CENTER_MINIS_HEALTH("مراکز پژوهشی مورد تایید وزارت بهداشت و درمان و آموزش پزشکی", true, PreDataType.FROM_ILENC),
    RESEARCH_CENTER_SEMINARY("مراکز پژوهشی مورد تایید مرکز مدیریت حوزه های علمیه", true, PreDataType.FROM_ILENC);

    private final int value;
    private final boolean isActive;
    private final String faStr;
    private final PreDataType preDataType;

    private ResearchCenterType(int value, String faStr, boolean isActive, PreDataType preDataType) {
        this.value = value;
        this.faStr = faStr;
        this.isActive = isActive;
        this.preDataType = preDataType;
        Counter.nextValue = value + 1;
    }

    private ResearchCenterType(String faStr, boolean isActive, PreDataType preDataType) {
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

    public static ResearchCenterType fromValue(int value) {
        for (ResearchCenterType researchCenterType : ResearchCenterType.values()) {
            if (researchCenterType.getValue() == value)
                return researchCenterType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
