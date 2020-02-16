package com.atrosys.model;

/**
 * News section titles,
 * pages was deprecated.
 */

public enum NewsDest {
    ABOUT_MEDIA(0, "media","در آیینه ی دیگر رسانه ها"),
    ABOUT_OPERATOR(10, "operator","استودیو شعا");

    private final int value;
    private final String str;
    private final String faStr;

    private NewsDest(int value, String str, String faStr) {
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

    public static NewsDest fromValue(int value) {
        for (NewsDest infoDocDest : NewsDest.values()) {
            if (infoDocDest.getValue() == value)
                return infoDocDest;
        }
        return null;
    }

    public static NewsDest fromStr(String str) {
        for (NewsDest infoDocDest : NewsDest.values()) {
            if (infoDocDest.getStr().equals(str))
                return infoDocDest;
        }
        return null;
    }
}

