package com.atrosys.dao;

import com.atrosys.entity.Country;
import com.atrosys.util.HibernateUtil;
import com.atrosys.util.SessionUtil;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.ArrayList;

/**
 * Created by mehdisabermahani on 6/16/17.
 */
public class CountryDAO {
    public static final String TABLE_NAME = "Country";
    private static final String[] COUNTRIES_ID = {
            "AE", "AF", "AL", "AM", "AO", "AR", "AT", "AU", "AZ", "BA", "BD", "BE", "BF", "BG", "BI", "BJ", "BN", "BO",
            "BR", "BS", "BT", "BW", "BY", "BZ", "CA", "CD", "CF", "CG", "CH", "CI", "CL", "CM", "CN", "CO", "CR", "CU",
            "CY", "CZ", "DE", "DJ", "DK", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FK", "FI", "FJ", "FR",
            "GA", "GB", "GE", "GF", "GH", "GL", "GM", "GN", "GQ", "GR", "GT", "GW", "GY", "HN", "HR", "HT", "HU", "ID",
            "IE", "IL", "IN", "IQ", "IR", "IS", "IT", "JM", "JO", "JP", "KE", "KG", "KH", "KP", "KR", "XK", "KW", "KZ",
            "LA", "LB", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MD", "ME", "MG", "MK", "ML", "MM", "MN", "MR",
            "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NG", "NI", "NL", "NO", "NP", "NZ", "OM", "PA", "PE", "PG", "PH",
            "PL", "PK", "PR", "PS", "PT", "PY", "QA", "RO", "RS", "RU", "RW", "SA", "SB", "SD", "SE", "SI", "SJ", "SK",
            "SL", "SN", "SO", "SR", "SS", "SV", "SY", "SZ", "TD", "TF", "TG", "TH", "TJ", "TL", "TM", "TN", "TR", "TT",
            "TW", "TZ", "UA", "UG", "US", "UY", "UZ", "VE", "VN", "VU", "YE", "ZA", "ZM", "ZW"};
    private static final String[] COUNTRIES_EN_NAME = {
            "United Arab Emirates", "Afghanistan", "Albania", "Armenia", "Angola", "Argentina", "Austria", "Australia",
            "Azerbaijan", "Bosnia and Herzegovina", "Bangladesh", "Belgium", "Burkina Faso", "Bulgaria", "Burundi",
            "Benin", "Brunei Darussalam", "Bolivia", "Brazil", "Bahamas", "Bhutan", "Botswana", "Belarus",
            "Belize", "Canada", "Democratic Republic of Congo", "Central African Republic", "Republic of Congo",
            "Switzerland", "Côte d'Ivoire", "Chile", "Cameroon", "China", "Colombia", "Costa Rica", "Cuba", "Cyprus",
            "Czech Republic", "Germany", "Djibouti", "Denmark", "Dominican Republic", "Algeria", "Ecuador", "Estonia",
            "Egypt", "Western Sahara", "Eritrea", "Spain", "Ethiopia", "Falkland Islands", "Finland", "Fiji",
            "France", "Gabon", "United Kingdom", "Georgia", "French Guiana", "Ghana", "Greenland", "Gambia", "Guinea",
            "Equatorial Guinea", "Greece", "Guatemala", "Guinea-Bissau", "Guyana", "Honduras", "Croatia", "Haiti",
            "Hungary", "Indonesia", "Ireland", "Palestine", "India", "Iraq", "Iran", "Iceland", "Italy", "Jamaica",
            "Jordan", "Japan", "Kenya", "Kyrgyzstan", "Cambodia", "North Korea", "South Korea", "Kosovo", "Kuwait",
            "Kazakhstan", "Lao People's Democratic Republic", "Lebanon", "Sri Lanka", "Liberia", "Lesotho",
            "Lithuania", "Luxembourg", "Latvia", "Libya", "Morocco", "Moldova", "Montenegro", "Madagascar", "Macedonia",
            "Mali", "Myanmar", "Mongolia", "Mauritania", "Malawi", "Mexico", "Malaysia", "Mozambique", "Namibia",
            "New Caledonia", "Niger", "Nigeria", "Nicaragua", "Netherlands", "Norway", "Nepal", "New Zealand", "Oman",
            "Panama", "Peru", "Papua New Guinea", "Philippines", "Poland", "Pakistan", "Puerto Rico",
            "Palestinian Territories", "Portugal", "Paraguay", "Qatar", "Romania", "Serbia", "Russia", "Rwanda",
            "Saudi Arabia", "Solomon Islands", "Sudan", "Sweden", "Slovenia", "Svalbard and Jan Mayen", "Slovakia",
            "Sierra Leone", "Senegal", "Somalia", "Suriname", "South Sudan", "El Salvador", "Syria", "Swaziland",
            "Chad", "French Southern and Antarctic Lands", "Togo", "Thailand", "Tajikistan", "Timor-Leste",
            "Turkmenistan", "Tunisia", "Turkey", "Trinidad and Tobago", "Taiwan", "Tanzania", "Ukraine", "Uganda",
            "United States", "Uruguay", "Uzbekistan", "Venezuela", "Vietnam", "Vanuatu", "Yemen", "South Africa",
            "Zambia", "Zimbabwe"};
    private static final String[] COUNTRIES_FA_NAME = {
            "ایالات متحده عربی", "افغانستان", "آلبانی", "ارمنستان", "آنگولا", "آرژانتین", "اتریش", "استرالیا",
            "آذربایجان", "بوسنی و هرزگووین", "بنگلادش", "بلژیک", "بورکینافاسو", "بلغارستان", "جمهوری بوروندی", "بنین",
            "برونئی", "بولیوی", "برزیل", "باهاما", "بوتان", "جمهوری بوتسوانا", "بلاروس", "بلیز", "کانادا",
            "جمهوری دمکراتیک کنگو", "جمهوری آفریقای مرکزی", "کنگو", "سوئیس", "ساحل عاج", "شیلی", "کامرون", "چین",
            "کلمبیا", "کاستاریکا", "کوبا", "قبرس", "جمهوری چک", "آلمان", "جیبوتی", "دانمارک", "جمهوری دومنیک",
            "الجزایر", "اکوادور", "استونی", "مصر", "صحرای غربی", "اریتره", "اسپانیا", "اتیوپی", "جزایر فالکلند",
            "فنلاند", "فیجی", "فرانسه", "گابون", "انگلیس", "گرجستان", "گویان فرانسه", "غنا", "گرینلند", "گامبیا", "گینه",
            "گینه استوایی", "یونان", "گواتمالا", "گینه بیسائو", "گویان", "هندوراس", "کرواسی", "هاییتی", "مجارستان",
            "اندونزی", "ایرلند", "فلسطین اشغالی", "هند", "عراق", "ایران", "ایسلند", "ایتالیا", "جامائیکا", "اردن", "ژاپن", "کنیا",
            "قرقیزستان", "کامبوج", "کره شمالی", "کره جنوبی", "کوزوو", "کویت", "قزاقستان", "جمهوری دمکراتیک لائو",
            "لبنان", "سریلانکا", "لیبریا", "لسوتو", "لیتوانی", "لوکزامبورگ", "لتونی", "لیبی", "مراکش", "مولداوی",
            "مونته نگرو", "ماداگاسکار", "مقدونیه", "مالی", "میانمار", "مغولستان", "موریتانی", "مالاوی", "مکزیک", "مالزی",
            "موزامبیک", "نامبیا", "کالدونیا جدید", "نیجر", "نیجریه", "نیکاراگوئه", "هلند", "نروژ", "نپال", "نیوزلند",
            "عمان", "پاناما", "پرو", "پاپوآ گینه نو", "فیلیپین", "لهستان", "پاکستان", "پورتو ریکو", "فلسطین", "پرتغال",
            "پاراگوئه", "قطر", "رومانی", "صربستان", "روسیه", "رواندا", "عربستان سعودی", "جزایر سالومون", "سودان",
            "سوئد", "اسلوونی", "سوالبارد و یان ماین", "اسلواکی", "سیرالئون", "سنگال", "سومالی", "سورینام",
            "سودان جنوبی", "السالوادور", "سوریه", "سوازیلند", "چاد", "سرزمین های جنوبی و جنوبگانی فرانسه", "توگو",
            "تایلند", "تاجیکستان", "تیمور شرقی", "ترکمنستان", "تونس", "ترکیه", "ترینیداد و توباگو", "تایوان",
            "تانزانیا", "اوکراین", "اوگاندا", "ایالات متحده آمریکا", "اروگوئه", "ازبکستان", "ونزوئلا", "ویتنام",
            "وانوآتو", "یمن", "آفریقای جنوبی", "زامبیا", "زیمبابوه"};

    public static Country save(Country country) throws Exception {
        return (Country) new HibernateUtil().save(country);
    }


    public static ArrayList<Country> findAllCountries() throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT u FROM Country u order by faName");
        ArrayList<Country> countries = null;
        try {
            countries = (ArrayList<Country>) query.getResultList();
        } catch (Exception e) {
        }
        if (countries != null)
            if (countries.isEmpty()) {
                for (int i = 0; i < COUNTRIES_ID.length; i++) {
                    Country country = new Country();
                    country.setCountryId(COUNTRIES_ID[i]);
                    country.setEnName(COUNTRIES_EN_NAME[i]);
                    country.setFaName(COUNTRIES_FA_NAME[i]);
                    country.setNumberCode(0);
                    CountryDAO.save(country);
                }
            }
        return countries;
    }

    public static Country findCountryByID(String id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT u FROM Country u where u.countryId=:id");
        query.setParameter("id", id);
        return (Country) query.uniqueResult();
    }

    public static String findCountryFANameByID(String id) throws Exception {
        Session session = SessionUtil.getSession();
        Query query = session.createQuery("SELECT u.faName FROM Country u where u.countryId=:id");
        query.setParameter("id", id);
        return (String) query.uniqueResult();
    }


}
