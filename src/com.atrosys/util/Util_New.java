package com.atrosys.util;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;
import com.ibm.icu.util.GregorianCalendar;
import com.ibm.icu.util.PersianCalendar;
import com.ibm.icu.util.ULocale;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.Objects;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
public class Util_New {
    public static byte intToByte(int i) {
        return Byte.valueOf(Integer.toString(i));
    }

    public static String fixNumberlength(long num, long length) {
        String str = String.valueOf(num);
        if (str.length() >length) return null;
        while (str.length() < length)
            str = "0" + str;
        return str;
    }

    public static byte[] getByteFromInputStream(InputStream is) throws Exception {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[1024 * 1024];
        while ((nRead = is.read(data, 0, data.length)) != -1)
            buffer.write(data, 0, nRead);
        buffer.flush();
        return buffer.toByteArray();
    }

    public static boolean isPdf(byte[] data) {
        if (data != null && data.length > 4 &&
                data[0] == 0x25 && // %
                data[1] == 0x50 && // P
                data[2] == 0x44 && // D
                data[3] == 0x46 && // F
                data[4] == 0x2D) { // -

            // version 1.3 file terminator
            if (data[5] == 0x31 && data[6] == 0x2E && data[7] == 0x33 &&
                    data[data.length - 7] == 0x25 && // %
                    data[data.length - 6] == 0x25 && // %
                    data[data.length - 5] == 0x45 && // E
                    data[data.length - 4] == 0x4F && // O
                    data[data.length - 3] == 0x46 && // F
                    data[data.length - 2] == 0x20 && // SPACE
                    data[data.length - 1] == 0x0A) { // EOL
                return true;
            }

            // version 1.3 file terminator
            if (data[5] == 0x31 && data[6] == 0x2E && data[7] == 0x34 &&
                    data[data.length - 6] == 0x25 && // %
                    data[data.length - 5] == 0x25 && // %
                    data[data.length - 4] == 0x45 && // E
                    data[data.length - 3] == 0x4F && // O
                    data[data.length - 2] == 0x46 && // F
                    data[data.length - 1] == 0x0A) { // EOL
                return true;
            }
        }
        return false;
    }

    public static boolean isInputEntryValid(String key, Object valueObj) {
        try {
            if (valueObj != null) {
                String stringValue;
                byte[] byteValue;
                switch (key) {
                    case "uni-national-id":
                        stringValue = (String) valueObj;
                        if (isLong(stringValue))
                            if (stringValue.length() == 11)
                                return true;
                        break;
                    case "domain":
                        stringValue = (String) valueObj;
                        if (!stringValue.isEmpty() && stringValue.length() <= 35)
                            return true;
                        break;
                    case "public-email":
                        stringValue = (String) valueObj;
                        if (!stringValue.isEmpty() && stringValue.length() <= 70)
                            return true;
                        break;
                    case "form":
                        byteValue = (byte[]) valueObj;
                        if (isPdf(byteValue))
                            return true;
                        break;
                    case "fax":
                    case "tel":
                    case "phone-no":
                        stringValue = (String) valueObj;
                        if (isLong(stringValue))
                            if (stringValue.length() == 8)
                                return true;
                        break;
                    case "file-name":
                        stringValue = (String) valueObj;
                        if (isLong(stringValue))
                            if (stringValue.length() <= 100)
                                return true;
                        break;
                }
            }

        } catch (Exception e) {
            return false;
        }
        return false;
    }

    public static boolean isFormValid(HashMap<String, Objects> hashMap) {
        try {
            for (String key : hashMap.keySet())
                if (!isInputEntryValid(key, hashMap.get(key)))
                    return false;
        } catch (Exception e) {
            return false;
        }
        return true;
    }

    public static boolean isLong(String s) {
        try {
            Long.parseLong(s);
        } catch (NumberFormatException e) {
            return false;
        } catch (NullPointerException e) {
            return false;
        }
        return true;
    }

    //    private static String[] monthName = {
//            "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور",
//            "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"};
//
//    private static String[] weekDayName = {"جمعه", "شنبه", "یکشنبه", "دوشنبه", "چهارشنبه", "پنجشنبه"};
//
//    public static String convertGregorianToJalali(Date date) throws ParseException {
//        PersianCalendar persianCalendar = new PersianCalendar(date);
//        String str = weekDayName[persianCalendar.get(Calendar.DAY_OF_WEEK)] + " , ";
//        str += persianCalendar.get(Calendar.DAY_OF_MONTH) + " ";
//        str += monthName[persianCalendar.get(Calendar.MONTH)] + " ";
//        str += persianCalendar.get(Calendar.YEAR);
//        return str;
//    }
//
//    public static java.sql.Date convertJalaliToGregorian(String jalaliDate) throws ParseException {
//        ULocale locale = new ULocale("fa_IR@calendar=persian");
//        PersianDateFormat persianDateFormat = new PersianDateFormat("yyyy/MM/dd",locale);
//        Date date = persianDateFormat.parse(jalaliDate);
//        PersianCalendar persianCalendar = new PersianCalendar(date);
//        int year = persianCalendar.get(Calendar.YEAR);
//        int month = persianCalendar.get(Calendar.MONTH) + 1;
//        int day = persianCalendar.get(Calendar.DAY_OF_MONTH);
//        return new java.sql.Date(year, month, day);
//    }
    public static String convertGregorianToJalali(Date date) {
        ULocale locale = new ULocale("fa_IR@calendar=persian");
        Calendar calendar = Calendar.getInstance();
        calendar.set(date.getYear() + 1900, date.getMonth(), date.getDate());
        SimpleDateFormat df = new SimpleDateFormat(SimpleDateFormat.WEEKDAY, locale);
        String str = df.format(calendar) + " ,";
        df = new SimpleDateFormat(SimpleDateFormat.DAY, locale);
        str += " " + df.format(calendar);
        df = new SimpleDateFormat(SimpleDateFormat.MONTH, locale);
        str += " " + df.format(calendar);
        df = new SimpleDateFormat(SimpleDateFormat.YEAR, locale);
        str += " " + df.format(calendar);
        return str;
    }

    public static java.sql.Date convertJalaliToGregorian(String jalaliDate) {
        GregorianCalendar gregorianCalendar = new GregorianCalendar();
        int jYear = Integer.valueOf(jalaliDate.substring(0, jalaliDate.indexOf('/')));
        int jMonth = Integer.valueOf(jalaliDate.substring(jalaliDate.indexOf('/') + 1, jalaliDate.lastIndexOf('/')));
        int jDay = Integer.valueOf(jalaliDate.substring(jalaliDate.lastIndexOf('/') + 1, jalaliDate.length()));
        PersianCalendar persianCalendar = new PersianCalendar(jYear, jMonth - 1, jDay);
        gregorianCalendar.setTime(persianCalendar.getTime());

        int year = gregorianCalendar.get(Calendar.YEAR) - 1900;
        int month = gregorianCalendar.get(Calendar.MONTH);
        int day = gregorianCalendar.get(Calendar.DAY_OF_MONTH);
        return new java.sql.Date(year, month, day);
    }

    public static boolean isYearLeap(Integer year) {
        double a = 0.025;
        double b = 266;
        double leapDays0, leapDays1;
        int frac0, frac1;
        if (year > 0) {
            leapDays0 = ((year + 38) % 2820) * 0.24219 + a;
            leapDays1 = ((year + 39) % 2820) * 0.24219 + a;
        } else if (year < 0) {
            leapDays0 = ((year + 39) % 2820) * 0.24219 + a;
            leapDays1 = ((year + 40) % 2820) * 0.24219 + a;
        } else return false;
        frac0 = (int) ((leapDays0 - (int) leapDays0) * 1000);
        frac1 = (int) ((leapDays1 - (int) leapDays1) * 1000);

        if (frac0 <= b && frac1 > b)
            return true;
        else
            return false;
    }

    public static String deleteSpaces(String item){
        String[] items = item.split(" ");
        String res = "";
        for (String ss : items)
            res += ss;
        return res;
    }

    public static String convertJalaliToJalali(String date){
        String finalDate = "";
        String[] dateFirst = date.split(",");
        String[] dateSec = dateFirst[1].trim().split(" ");
        String year = dateSec[0];
        String month = "";
        String day = dateSec[2];
        switch (dateSec[1]){
            case "فروردین":
                month += "01";
                break;
            case "اردیبهشت":
                month += "02";
                break;
            case "خرداد":
                month += "03";
                break;
            case "تیر":
                month += "04";
                break;
            case "مرداد":
                month += "05";
                break;
            case "شهریور":
                month += "06";
                break;
            case "مهر":
                month += "07";
                break;
            case "آبان":
                month += "08";
                break;
            case "آذر":
                month += "09";
                break;
            case "دی":
                month += "10";
                break;
            case "بهمن":
                month += "11";
                break;
            case "اسفند":
                month += "12";
                break;
        }
        finalDate = day +"/" + month + "/" + year;
        return finalDate;
    }

}
