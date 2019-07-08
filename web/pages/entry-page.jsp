<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);

    SubSystemCode subSystemCode = SubSystemCode.fromValue(Integer.valueOf(request.getParameter("sub-code")));
    if (subSystemCode == null) {
        response.sendError(404, "No sub system code!");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link href="../css/style.css" rel="stylesheet">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
</head>
<body>
<div class="formBox" style="text-align: justify">
    <img src="../images/university/info1.png" style="width: 100%;">
    <p style="margin-top:10px ">
        متقاضیان
        <span style="font-weight: bold;font-size: 16px;">
       <%=subSystemCode.getFaStr()%>
        </span>
        جهت اتصال به شبکه علمی کشور می‌بایست براساس چرخه مشخص شده مطابق با نمودار
        بالا ، فرآیند حضور در شبکه علمی را به انجام رسانیده و میهمانان و مشترکین شبکه علمی می‌گردند. نظر به آنکه اپراتور
        شبکه علمی ایران بنا نهاده است که کلیه خدمات خود را به صورت الکترونیکی ارائه نمایند ، متقاضیان می‌بایست مرحله به
        مرحله شرایط اجرائی مربوطه را به انجام رسانیده و به عضویت شبکه نائل گردند. بدیهی است در دوره بهره‌برداری خدمات
        نیز ، کلیه مشترکین مشکلات و درخواست های خود را از طریق سامانه خدمات مشترکین اعلام و براساس زمان‌بندی تعیین شده
        می‌توانند امکانات و رفع خطاهای احتمالی خدمات خود را پیگیری نمایند. سامانه یکپارچه خدمات مشترکین اپراتور شبکه
        علمی ایران به عنوان
        <span style="font-weight: bold;font-size: 16px;">
        نخستین اپراتور تمام الکترونیکی ایران
        </span>
        در تلاش است تا بدون نیاز به ارتباطات انسانی ، کاهش
        خطاهای مربوطه و با امکان رهگیری خدمات درخواستی ، فرآیند راهبری و بهره‌برداری را به نحو احسن و با امکان صحه‌گذاری
        توسط مشترکین ارائه نمایند.<br>
        جهت سهولت حضور متقاضیان ، بخش نخست فرآیند دریافت خدمات که
        <span style="font-weight: bold;font-size: 16px;">
        عضویت
        </span>
        نامیده شده است ، به تشریح تقدیم میگردد :

    </p>
    <ol type="1" start="۱">
        <li>
            متقاضی موظف است نخست نسبت به معرفی
            <span style="font-weight: bold;font-size: 16px;">
            شخصیت حقوقی
            </span>
            دانشگاه و ورود اطلاعات کلی آن اقدام نماید. در این مرحله
            درخواست اولیه اتصال به شبکه علمی با مهر و امضاء بالاترین مقام مسئول توسط متقاضی و براساس نمونه ارائه شده در
            ذیل آیکون
            <img src="../images/get-form.png" style="width: 20px">
            تهیه ، اسکن و تحت فرمت الکترونیکی PDF در سایت بارگذاری می‌گردد. لازم به ذکر است که کلیه اطلاعات
            بارگذاری در سایت ، براساس فرمت PDF بوده و مابقی فرمت ها پوشش داده نمی‌شود.
        </li>
        <li>
            پس از تایید اطلاعات اولیه
            <span style="font-weight: bold;font-size: 16px;">
            شخصیت حقوقی دانشگاه
            </span>
            توسط اپراتور متقاضی به
            <span style="font-weight: bold;font-size: 16px;">
            مشترک موقت
            </span>
            تغییر وضعیت داده ،
            <span style="font-weight: bold;font-size: 16px;">
            قرارداد اشتراک
            </span>
            به صورت الکترونیکی ذیل آیکون
            <img src="../images/get-form.png" style="width: 20px">
            در صفحه مربوطه قابل دانلود شدن ، در اختیار متقاضی قرار می‌گیرد.
            متقاضی محترم می‌بایست ، قرارداد اشتراک را به مهر و امضاء بالاترین مقام محترم مسئول دانشگاه رسانیده ، اسکن و
            تحت فرمت الکترونیکی PDF در سایت بارگذاری نماید. از این لحظه متقاضی محترم به جرگه مشترکین شبکه علمی قرار
            میگیرد. نظر به آنکه هنوز تا حال حاضر ، امضاء الکترونیکی در قوانین کشوری قطعیت حقوقی لازم را بدست نیاورده است
            ، مشترک محترم می‌بایست
            <span style="font-weight: bold;font-size: 16px;">
            سه نسخه
            </span>
            از قرارداد اشتراک مهر و امضاء توسط بالاترین مقام محترم مسئول دانشگاه را به
            آدرس ارائه شده در صفحه مربوطه به نشانی اپراتور شبکه علمی کشور ارسال نماید. بدیهی است ، یک نسخه از سند فوق پس
            از تایید ، مهر و امضاء توسط اپراتور شبکه علمی ایران ، به آدرس مشترک و به صورت پست الکترونیکی عودت می‌گردد.
        </li>
        <li>
            پس از عضویت موقت ، مشترک می‌بایست
            <span style="font-weight: bold;font-size: 16px;">
            اطلاعات نماینده اصلی
            </span>
            خود که به عنوان نقطه تماس مالی و اداری مشترک با
            اپراتور می‌باشد ، به صورت رسمی معرفی نماید. در این مرحله نامه رسمی معرفی نماینده به صورت نمونه ذیل آیکون
            <img src="../images/get-form.png" style="width: 20px">
            در
            صفحه مربوطه ارائه شده که مشترک می‌بایست بر روی سربرگ رسمی ، به مهر و امضاء بالاترین مقام مسئول مشترک رسانیده
            ، اسکن نموده و تحت فرمت الکترونیکی PDF در سایت بارگذاری نماید. ضمن آنکه تصاویر مربوط به کارت ملی و صفحه اول
            شناسنامه نماینده نیز ، به صورت فرمت الکترونیکی PDF باید در سایت بارگذاری گردد. لازم به ذکر است ، نظر به آنکه
            کلیه پرداخت‌های مربوط به خدمات دریافتی از اپراتور به صورت الکترونیکی صورت می‌پذیرد ، نماینده معرفی شده
            می‌بایست از طرف مشترک توانائی پرداخت الکترونیکی خدمات را در اختیار داشته باشد. در پایان این مرحله
            <span style="font-weight: bold;font-size: 16px;">
            اشتراک دائم
            </span>
            برای مشترک صادر گردیده و مشترک می‌بایست از طریق نماینده تام الاختیار خود (در صورت نیاز) ضمن معرفی
            <span style="font-weight: bold;font-size: 16px;">
            مدیران میانی سامانه
            </span>
            خود ،
            <span style="font-weight: bold;font-size: 16px;">
            نقاط دانشگاهی
            </span>
            مورد تقاضا را معرفی نموده و درخواست خدمات خود را به اپراتور اعلام و
            براساس زمان‌بندی اعلامی آنها را به مرور دریافت نماید.
        </li>
    </ol>
</div>
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>
</body>
</html>