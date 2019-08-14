package com.atrosys.model;

public enum AdminAccessType {
    ADMINS_REGISTER(1000, "مدیران سایت : عضویت"),
    ADMINS_REPORT("مدیران سایت : گزارش کارکرد"),
    SEND_FEED_BACK("مدیران سایت : اعلام خطا"),
    ADMIN_APPROVING_ROLES("مدیران سایت : تاییدکنندگان"),
    ADMIN_STATE_LIST_ROLES("مدیران سایت : لیست استان ها"),
    STATES(2000, "اطلاعات اولیه : استان ها"),
    CITIES("اطلاعات اولیه : شهرستان ها"),
    WORLD_NRERN("اطلاعات اولیه : گستره جهانی"),
    PRE_UNI_DATA("اطلاعات اولیه : اطلاعات پیش فرض دانشگاه ها"),
    ADD_CONTRACT_DOC("اطلاعات اولیه : قرارداد ها و مستندات"),
    UNIVERSITY(3000, "مشترکین : دانشگاه ها و مراکز آموزش عالی"),
    SUBS_REPORT("مشترکین : گزارش کمیت مشترکین"),
    RESEARCH_CENTER("مشترکین : مراکز پژوهشی و تحقیقاتی"),
    HOSPITALS("مشترکین : مراکز آموزشی-پزشکی"),
    SEE_REQUESTED_SERVICE_FORMS("خدمات : مشاهده سرویس فرم های درخواست شده"),
    STATE_SUBS("مشترکین : مشترکان استان"),
    MEDICAL_SUBS("مشترکین : مشترکان تحت نظر وزارت بهداشت"),
    SEMINARY("مشترکین: حوزه های علمیه"),
    DOC_INFO(4000, "اسناد مکتوب : شبکه علمی چیست؟"),
    DOC_PUBLIC_PRIVATE("اسناد مکتوب : مشارکت عمومی-خصوصی"),
    MEDIA_NEWS(5000, "سرویس اخبار : در آیینه ی دیگر رسانه ها"),
    STUDIO_SHOA_NEWS("سرویس اخبار : استودیو شعا"),
    MANAGE_PERSONS(6000, "اشخاص : مدیریت اشخاص حقیقی"),
    MANAGE_PERSONS_LEGAL("اشخاص : مدیریت اشخاص حقوقی"),
    ADD_JOB_TITLE(7000, "همکاری با شعا : اضافه کردن حوزه شغل"),
    ADD_JOB_INFO("همکاری با شعا : اضافه کردن شغل"),
    ADD_SUBJOB_TITLE("همکاری با شعا : اضافه کردن عنوان شغل"),
    SHOW_JOB_REQUEST("همکاری با شعا : مشاهده ی افراد"),
    TECH_ERROR_HANDLING(8000, "پشتیبانی : پیگیری خطاها"),
    SERVICES_ADD_SERVICE_FORM(9000, "خدمات : اضافه کردن سرویس فرم"),
    SERVICES_ADD_SERVICE_CATEGORY("خدمات : اضافه کردن دسته‌ی خدمات"),
    SERVICES_ADD_SERVICE("خدمات : اضافه کردن خدمت"),
    SERVICES_ADD_SUB_SERVICE("خدمات : اضافه کردن زیرخدمت"),
    MONITORING_SIMPLE(10000, "مانیتورینگ : مانتورینگ نظارتی"),
    MONITORING_ADVANCE("مانیتورینگ : مانتورینگ داخلی"),
    RELATED_ORGAN_APPROVING_HOSPITAL(11000, "تایید کنندگان : تایید وزارت بهداشت"),
    RELATED_ORGAN_APPROVING_SEMINARY("تایید کنندگان : تایید حوزه های علمیه"),
    TECH_OP_TELECOM_CENTERS(12000,"فنی : مراکز مخابرات و زیرساخت"),
    EQUIPMENT_PARAMETERS("فنی : تعریف پارامتر های تجهیزات"),
    EQUIPMENT_TYPES("فنی : تعریف نوع تجهیزات"),
    EQUIPMENT_DEFINITION("فنی : ثبت تجهیزات"),
    EQUIPMENT_INSTALL("فنی : نصب تجهیزات"),
    CRA_UNIVERSITY(13000,"سازمان تنظیم : دانشگاه ها و مراکز آموزش عالی"),
    CRA_SUBS_REPORT("سازمان تنظیم: گزارش کمیت مشترکین"),
    CRA_RESEARCH_CENTER("سازمان تنظیم: مراکز پژوهشی و تحقیقاتی"),
    CRA_HOSPITALS("سازمان تنظیم: مراکز آموزشی-پزشکی");

    private final int value;
    private final String faStr;

    private AdminAccessType(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private AdminAccessType(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static AdminAccessType fromValue(int value) {
        for (AdminAccessType adminAccesses : AdminAccessType.values()) {
            if (adminAccesses.getValue() == value)
                return adminAccesses;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
