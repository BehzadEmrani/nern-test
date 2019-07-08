<%@ page import="com.atrosys.dao.UniversityDAO" %>
<%@ page import="com.atrosys.model.SubSystemCode" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>شبکه علمی</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link href="css/index-style.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link rel="icon" type="image/png" href="images/favicon.png"/>
</head>
<body>

<div id="header" style="height: 55px">
    <span class="lanGroup" id="langGP">
    <div class="lanPop">
    <a href="#" onclick="return false;">SP</a>
      <div class="lanPopContent">
       Version en español
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">EN</a>
      <div class="lanPopContent">
       English version
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">CH</a>
      <div class="lanPopContent">
       中文版
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">RU</a>
      <div class="lanPopContent">
       Русская версия
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">AR</a>
      <div class="lanPopContent">
       النسخة العربية
      </div>
    </div>&nbsp;|&nbsp;
    <div class="lanPop">
    <a href="#" onclick="return false;">FR</a>
      <div class="lanPopContent">
       version française
      </div>
    </div>
    </span>

    <a href="javascript:void(0);" onclick="langDropDown()" id="langBtn">Lang</a>
    <div class="topnav" id="topnav">
        <a href="/" id="topLogoAnchor"><img id="topLogo" src="images/logo.png"></a>
        <a href="pages/index.jsp?page=info" id="firstNavItem">شبکه علمی چیست ؟</a>
        <a href="pages/index.jsp?page=about">درباره ي ما</a>
        <a href="pages/index.jsp?page=tariffs">خدمات و تعرفه ها</a>
        <a href="co-operate/index.jsp">همکاری با شعا</a>
        <a href="pages/index.jsp?page=contact-shoa">اطلاعات تماس</a>
        <a href="javascript:void(0);" class="optionsBtn" onclick="dropDown()">گزینه
            ها &nbsp;
            &nbsp;&#9776;</a>
    </div>
</div>
<div id="siteContent" style="top: 55px;bottom: 65px">
    <div class="sliderContainer">
        <div class="container" style="display: table-cell;vertical-align: middle;">
            <div id="myCarousel" class="carousel slide" data-ride="carousel">
                <ol class="carousel-indicators">
                    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                    <!--<li data-target="#myCarousel" data-slide-to="1"></li>-->
                    <!--<li data-target="#myCarousel" data-slide-to="2"></li>-->
                </ol>
                <div class="carousel-inner">
                    <div class="item active">
                        <p style="text-align: center;color: #000;font-size:20pt;margin: 0">بهره برداری از نسل سوم شبکه
                            علمی ایران</p>
                    </div>
                    <!--<div class="item">-->
                    <!--<p style="text-1align: center;color: #ffTesttest</p>-->
                    <!--</div>-->

                    <!--<div class="item">-->
                    <!--<p style="text-align: center;color: #ffTesttest</p>-->
                    <!--</div>-->
                </div>
                <!--  <a class="left carousel-control" href="#myCarousel" data-slide="prev" style="background-image: none;">
                      <img src="images/front-page/next.png"
                           style="float: left;position: absolute;left: 10px;top: -8px;">
                  </a>
                  <a class="right carousel-control" href="#myCarousel" data-slide="next" style="background-image: none;">
                      <img src="images/front-page/previous.png"
                           style="float: right;position: absolute;right: 10px;top: -8px;">
                  </a>-->
            </div>
        </div>
    </div>

    <div class="bottomBox">
        <div class="row" style="margin: 0 50px;height: auto;">
            <a href="pages/index.jsp?sub-code=<%=SubSystemCode.UNIVERSITY.getValue()%>">
                <div class="col-md-2 col-xs-12">
                    <img src="images/front-page/university.png">
                    <p class="sectionName">دانشگاه ها و مراکز آموزش عالی</p>
                    <p style="text-align: center">تعداد اعضای این بخش:</p>
                    <p class="countUp" upTo="<%=UniversityDAO.getRowCount(SubSystemCode.UNIVERSITY.getValue())%>"></p>
                </div>
            </a>
            <a href="pages/index.jsp?sub-code=<%=SubSystemCode.SEMINARY.getValue()%>">
                <div class="col-md-2 col-xs-12">
                    <img src="images/front-page/religion.png">
                    <p class="sectionName">حوزه های علمیه</p>
                    <p style="text-align: center">تعداد اعضای این بخش:</p>
                    <p class="countUp" upTo="<%=UniversityDAO.getRowCount(SubSystemCode.SEMINARY.getValue())%>"></p>
                </div>
            </a>
            <a href="pages/index.jsp?sub-code=<%=SubSystemCode.RESEARCH_CENTER.getValue()%>">
                <div class="col-md-2 col-xs-12">
                    <img src="images/front-page/pajoheshha.png">
                    <p class="sectionName">مراکز پژوهشی و تحقیقاتی</p>
                    <p style="text-align: center">تعداد اعضای این بخش:</p>
                    <p class="countUp"
                       upTo="<%=UniversityDAO.getRowCount(SubSystemCode.RESEARCH_CENTER.getValue())%>"></p>
                </div>
            </a>
            <a href="pages/index.jsp?sub-code=<%=SubSystemCode.HOSPITAL.getValue()%>">
                <div class="col-md-2 col-xs-12">
                    <img src="images/front-page/hospitals.png">
                    <p class="sectionName">مراکز آموزش درمانی</p>
                    <p style="text-align: center">تعداد اعضای این بخش:</p>
                    <p class="countUp" upTo="<%=UniversityDAO.getRowCount(SubSystemCode.HOSPITAL.getValue())%>"></p>
                </div>
            </a>
            <div class="col-md-2 col-xs-12">
                <img src="images/front-page/libs.png">
                <p class="sectionName">کتابخانه ها</p>
            </div>
            <div class="col-md-2 col-xs-12">
                <img src="images/front-page/individual.png">
                <p class="sectionName">اشخاص حقیقی</p>
            </div>
        </div>
    </div>
    <div id="copyRight" style="margin-top: 40px;z-index: 100;">
        <p style="color: #c00;position: absolute;margin-top: -50px;">*تاریخ های بهره برداری هر بخش با رنگ قرمز مشخص شده
            است</p>
        <p>
            کلیه حقوق مادي ومعنوي محتوا و اطلاعات موجود در سایت طبق قوانین حمایت از مولفین و مصنفین و قوانین حق کپی رایت
            ایران و بین المللی متعلق است به:<br>
            <strong>اپراتور شبکه علمی ایران (فاوا یا نفت مسئله این است : 1394 – 1404)</strong><br>
            این نرم افزار توسط شرکت آتیرو سامانه سیمرغ طراحی ، پیاده سازي ، پشتیبانی و راهبري کامل گردیده و حق
            امتیاز
            آن به شرکت آتیرو سامانه سیمرغ تعلق دارد.
        </p>
    </div>
</div>
<div id="footer">
    <p style="color: #c00;position: absolute;top: -20px;">*تاریخ های بهره برداری هر بخش با رنگ قرمز مشخص شده است</p>
    <p>
        کلیه حقوق مادي ومعنوي محتوا و اطلاعات موجود در سایت طبق قوانین حمایت از مولفین و مصنفین و قوانین حق کپی رایت
        ایران و بین المللی متعلق است به
        <strong>اپراتور شبکه علمی ایران (فاوا یا نفت مسئله این است : 1394 – 1404)</strong><br>
        این نرم افزار توسط شرکت آتیرو سامانه سیمرغ طراحی ، پیاده سازي ، پشتیبانی و راهبري کامل گردیده و حق امتیاز
        آن به شرکت آتیرو سامانه سیمرغ تعلق دارد.
    </p>
</div>

<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/front-page.js"></script>
<script src="js/script.js"></script>
</body>
</html>
