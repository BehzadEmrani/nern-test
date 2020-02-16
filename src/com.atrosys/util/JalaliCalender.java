package com.atrosys.util;

import java.util.Date;

/**
 * JalaliCalender utils.
 */

public class JalaliCalender {


    static private int grgSumOfDays[][] = {{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365}, {0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}};
    static private int hshSumOfDays[][] = {{0, 31, 62, 93, 124, 155, 186, 216, 246, 276, 306, 336, 365}, {0, 31, 62, 93, 124, 155, 186, 216, 246, 276, 306, 336, 366}};

    public static String ToShamsi(int grgYear, int grgMonth, int grgDay, String Format) {
        int hshYear = grgYear - 621;
        int hshMonth = 0, hshDay = 0;

        boolean grgLeap = grgIsLeap(grgYear);
        boolean hshLeap = hshIsLeap(hshYear - 1);

        int hshElapsed;
        int grgElapsed = grgSumOfDays[(grgLeap ? 1 : 0)][grgMonth - 1] + grgDay;

        int XmasToNorooz = (hshLeap && grgLeap) ? 80 : 79;

        if (grgElapsed <= XmasToNorooz) {
            hshElapsed = grgElapsed + 286;
            hshYear--;
            if (hshLeap && !grgLeap)
                hshElapsed++;
        } else {
            hshElapsed = grgElapsed - XmasToNorooz;
            hshLeap = hshIsLeap(hshYear);
        }

        for (int i = 1; i <= 12; i++) {
            if (hshSumOfDays[(hshLeap ? 1 : 0)][i] >= hshElapsed) {
                hshMonth = i;
                hshDay = hshElapsed - hshSumOfDays[(hshLeap ? 1 : 0)][i - 1];
                break;
            }
        }


        if (Format == "Long")
            return hshDayName(hshDayOfWeek(hshYear, hshMonth, hshDay)) + "  " + hshDay + " " + calNames("hf", hshMonth - 1) + " " + hshYear;
        else
            return hshYear + " /" + hshMonth + " /" + hshDay;
    }

    public static boolean grgIsLeap(int Year) {
        return ((Year % 4) == 0 && ((Year % 100) != 0 || (Year % 400) == 0));
    }

    public static boolean hshIsLeap(int Year) {
        Year = (Year - 474) % 128;
        Year = ((Year >= 30) ? 0 : 29) + Year;
        Year = Year - (Year / 33) - 1;
        return ((Year % 4) == 0);
    }

    private static int hshDayOfWeek(int hshYear, int hshMonth, int hshDay) {
        int value;
        value = hshYear - 1376 + hshSumOfDays[0][hshMonth - 1] + hshDay - 1;

        for (int i = 1380; i < hshYear; i++)
            if (hshIsLeap(i)) value++;
        for (int i = hshYear; i < 1380; i++)
            if (hshIsLeap(i)) value--;

        value = value % 7;
        if (value < 0) value = value + 7;

        return (value);
    }

    private static String hshDayName(int DayOfWeek) {
        return calNames("df", DayOfWeek % 7);
    }


    private static String calNames(String calendarName, int monthNo) {

        String[] hShMonths = {"فروردين", "ارديبهشت", "خرداد", "تير", "مرداد", "شهريور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"};
        String[] gMonthsEng = {" January ", " February ", " March ", " April ", " May ", " June ", " July ", " August ", " September ", " October ", " November ", " December "};
        String[] days = {"شنبه", "یک‌شنبه", "دوشنبه", "سه‌شنبه", "چهارشنبه", "پنج‌شنبه", "جمعه"};
        String[] gMonthsFa = {"ژانویه", "فوریه", "مارس", "آوریل", "مه", "ژوثن", "ژوییه", "اوت", "سپتامبر", "اكتبر", "نوامبر", "دسامبر"};
        String[] daysEng = {"Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};

        switch (calendarName) {
            case "hf":
                return hShMonths[monthNo];
            case "ge":
                return gMonthsEng[monthNo];
            case "gf":
                return gMonthsFa[monthNo];
            case "df":
                return days[monthNo];
            case "de":
                return daysEng[monthNo];
        }
        return null;
    }


    public static Date ToGregorian(int hshYear, int hshMonth, int hshDay) {
        int grgYear = hshYear + 621;
        int grgMonth = 0, grgDay = 0;

        boolean hshLeap = hshIsLeap(hshYear);
        boolean grgLeap = grgIsLeap(grgYear);

        int hshElapsed = hshSumOfDays[hshLeap ? 1 : 0][hshMonth - 1] + hshDay;
        int grgElapsed;

        if (hshMonth > 10 || (hshMonth == 10 && hshElapsed > 286 + (grgLeap ? 1 : 0))) {
            grgElapsed = hshElapsed - (286 + (grgLeap ? 1 : 0));
            grgLeap = grgIsLeap(++grgYear);
        } else {
            hshLeap = hshIsLeap(hshYear - 1);
            grgElapsed = hshElapsed + 79 + (hshLeap ? 1 : 0) - (grgIsLeap(grgYear - 1) ? 1 : 0);
        }

        for (int i = 1; i <= 12; i++) {
            if (grgSumOfDays[grgLeap ? 1 : 0][i] >= grgElapsed) {
                grgMonth = i;
                grgDay = grgElapsed - grgSumOfDays[grgLeap ? 1 : 0][i - 1];
                break;
            }

        }

        return new Date(grgYear-1900, grgMonth, grgDay);
    }
}