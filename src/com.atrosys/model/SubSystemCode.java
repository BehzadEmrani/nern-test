package com.atrosys.model;

public enum SubSystemCode {
    UNIVERSITY(0, "دانشگاه ها و مراکز آموزش عالی",
            "اطلاعات کلی دانشگاه و مرکز آموزش عالی",
            "request-template.docx",
            "university.png",false),
    SEMINARY("حوزه های علمیه",
            "اطلاعات کلی حوزه علمیه",
            "request-template.docx",
            "religion.png",true),
    RESEARCH_CENTER("مراکز پژوهشی و تحقیقاتی",
            "اطلاعات کلی مرکز پژوهشی",
            "request-template.docx",
            "pajoheshha.png",false),
    HOSPITAL("مراکز آموزشی - درمانی",
            "اطلاعات کلی مرکز آموزشی-درمانی",
            "request-template.docx",
            "hospitals.png",true);
    private final int value;
    private final String faStr;
    private final String registerTopTitle;
    private final String imageURL;
    private final String requestFormURL;
    private final boolean haveApprovingSystem;

    private SubSystemCode(int value, String faStr, String registerTopTitle, String requestFormURL, String imageURL,boolean haveApprovingSystem) {
        this.value = value;
        this.faStr = faStr;
        this.imageURL = imageURL;
        this.registerTopTitle = registerTopTitle;
        this.requestFormURL = requestFormURL;
        this.haveApprovingSystem=haveApprovingSystem;
        Counter.nextValue = value + 1;
    }

    private SubSystemCode(String faStr, String registerTopTitle, String requestFormURL, String imageURL,boolean haveApprovingSystem) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
        this.imageURL = imageURL;
        this.registerTopTitle = registerTopTitle;
        this.requestFormURL = requestFormURL;
        this.haveApprovingSystem=haveApprovingSystem;
    }

    public String getRequestFormURL() {
        return requestFormURL;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public String getImageURL() {
        return imageURL;
    }

    public String getRegisterTopTitle() {
        return registerTopTitle;
    }

    public static SubSystemCode fromValue(int value) {
        for (SubSystemCode subSystemCode : SubSystemCode.values()) {
            if (subSystemCode.getValue() == value)
                return subSystemCode;
        }
        return null;
    }

    public boolean isHaveApprovingSystem() {
        return haveApprovingSystem;
    }

    public static SubSystemsType[] subSystemsTypeFromSubCode(SubSystemCode subSystemCode) {
        switch (subSystemCode) {
            case UNIVERSITY:
                return UniversityType.values();
            case RESEARCH_CENTER:
                return ResearchCenterType.values();
            case SEMINARY:
                return SeminaryType.values();
            case HOSPITAL:
                return HospitalType.values();
        }
        return null;
    }

    public static SubSystemsType subSystemsTypeFromValue(SubSystemCode subSystemCode, int value) {
        switch (subSystemCode) {
            case UNIVERSITY:
                return UniversityType.fromValue(value);
            case RESEARCH_CENTER:
                return ResearchCenterType.fromValue(value);
            case SEMINARY:
                return SeminaryType.fromValue(value);
            case HOSPITAL:
                return HospitalType.fromValue(value);
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
