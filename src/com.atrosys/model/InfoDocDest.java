package com.atrosys.model;

public enum InfoDocDest {
    INFO_DOCS(0, "info","شبکه علمی چیست؟"),
    ABOUT_DOCS(1, "about","درباره ما");

    private final int value;
    private final String str;
    private final String faStr;

    private InfoDocDest(int value, String str,String faStr) {
        this.value = value;
        this.str = str;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getStr() {
        return str;
    }

    public String getFAStr() {
        return faStr;
    }

    public static InfoDocDest fromValue(int value) {
        for (InfoDocDest infoDocDest : InfoDocDest.values()) {
            if (infoDocDest.getValue() == value)
                return infoDocDest;
        }
        return null;
    }

    public static InfoDocDest fromStr(String str) {
        for (InfoDocDest infoDocDest : InfoDocDest.values()) {
            if (infoDocDest.getStr().equals(str))
                return infoDocDest;
        }
        return null;
    }
}

