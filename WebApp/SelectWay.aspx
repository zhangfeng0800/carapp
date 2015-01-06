<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="SelectWay.aspx.cs" Inherits="WebApp.SelectWay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>爱易租 租车新生活</title>
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <link rel="stylesheet" type="text/css" href="css/public.css" />
    <link rel="stylesheet" type="text/css" href="css/subpage.css" />
    <!--[if IE 6]>
  <script type="text/javascript" src="js/png.js"></script>
  <script type="text/javascript" src="js/fixpng.js"></script>
<![endif]-->
    <script src="Scripts/app.js" type="text/javascript"></script>
    <script>
        function redirectToSelectCar() {
            if ($("#input_province").val() == "0" || $("#input_city").val() == "0" || $("#input_town").val() == "0") {
                alert("请选择用车城市");
                return;
            }
            var cityid = $("#input_town").val();
            var usewayid = $("input[name='zcType']:checked").val();
            if (!usewayid) {
                alert("请选择服务方式");
            }
            if (usewayid == 6) {
                if ($("#hotlinename").val() == 0) {
                    alert("请选择热门线路");
                    return;
                }
                if ($("#onePath").text() == "" && $("#twoPath").text() == "") {
                    alert("此路线暂无可用车辆");
                    return;
                } 
            }
            if (usewayid == 6) {
                 
                    window.location.href = "/ChooseCar.aspx?cityid=" + cityid + "&carusewayid=" + usewayid + "&hotlineId=" + $("#hotlinename").val() + "&lineType=" + $('input:radio[name="is_round"]:checked').val();
                }
             else {
                window.location.href = "/ChooseCar.aspx?cityid=" + cityid + "&carusewayid=" + usewayid;
            }

        }
        $(function () {
            getProvinceName("#input_province", 0);

            $("#input_province").change(function () {
                getCityListByPro($(this).val(), "#input_city", 0);
            });
            $("#input_city").change(function () {
                getTownByCity($(this).val(), "#input_town", 0);
            });
            $("#input_town").change(function () {
                getServiceByCity($(this).val(), "#carusewaycontainer");
            });
            $("#nextstep").click(function () {
                redirectToSelectCar();
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="dc-process">
        <div class="step">
            <ul class="dc-step">
                <li class="step-one step-one-orange">1、选择用车方式</li>
                <li class="step-gray">2、选择车型</li>
                <li class="step-gray">3、填写联系人</li>
                <li class="step-gray-end">4、提交订单</li>
            </ul>
        </div>
        <div class="dc-info clearfix">
            <div class="dc-main">
                <p class="yc-type">
                    <span class="yongche-til">用车城市：</span>
                    <select id="input_province">
                        <option value="0">请选择</option>
                    </select>
                    <select id="input_city">
                        <option value="0">请选择</option>
                    </select>
                    <select id="input_town">
                        <option value="0">请选择</option>
                    </select>
                </p>
                <p class="yc-type">
                    <span class="yongche-til">用车方式：</span>
                    <ul class="yongche-fs" id="carusewaycontainer">
                        <li class="clearfix">
                            <input class="choose-radio" type="radio" name="zcType" checked="checked" />
                            <em class="yc-ico">
                                <img src="images/songji.jpg" alt="" />送机 <span class="yc-gray">(24小时准时出发，安心开启旅程)</span></em>
                        </li>
                        <li class="clearfix">
                            <input class="choose-radio" type="radio" name="zcType" />
                            <em class="yc-ico">
                                <img src="images/jieji.jpg" alt="" />接机 <span class="yc-gray">(自动跟踪航班动态，飞机晚点免费等待)</span></em>
                        </li>
                        <li class="clearfix">
                            <input class="choose-radio" type="radio" name="zcType" />
                            <em class="yc-ico">
                                <img src="images/shizu.jpg" alt="" />时租 <span class="yc-gray">(随需而用，小时租车更便捷)</span></em>
                        </li>
                        <li class="clearfix">
                            <input class="choose-radio" type="radio" name="zcType" />
                            <em class="yc-ico">
                                <img src="images/rizu.jpg" alt="" />日租 <span class="yc-gray">(8小时租车，一天为您护航)</span></em>
                        </li>
                        <li class="clearfix">
                            <input class="choose-radio" type="radio" name="zcType" />
                            <em class="yc-ico">
                                <img src="images/banrizu.jpg" alt="" />半日租 <span class="yc-gray">(4小时租车，打包更划算)</span></em>
                        </li>
                        <li class="clearfix">
                            <input class="choose-radio" type="radio" name="zcType" />
                            <em class="yc-ico">
                                <img src="images/xianlu.jpg" alt="" />热门线路 <span class="yc-gray">(长途用车，安心且优惠)</span></em>
                        </li>
                    </ul>
                </p>
                <p class="yc-type">
                    <a class="yc-btn" href="javascript:;" id="nextstep">下一步，去选择车型</a>
                </p>
            </div>
            <div class="dc-side">
                <h3 class="per-ser">
                    我的快捷服务</h3>
                <div class="ser-info">
                    <a href="/pcenter/fastcarlist.aspx" class="short-btn">我的一键订车</a>
                </div>
                <img class="ser-tel" src="images/serTel.png" alt="" />
            </div>
        </div>
    </div>
</asp:Content>
