<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="ChooseCar.aspx.cs" Inherits="WebApp.ChooseCar" %>

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
    <script type="text/javascript" src="js/jquery-1.8.0.min.js"></script>
    <script src="Scripts/app.js" type="text/javascript"></script>
    <script>
        $(function() {
            var search = window.location.search.substring(1);
            var searcharray = search.split("&");
            if (searcharray.length == 2) {
                GetCars(searcharray[0].split("=")[1], searcharray[1].split("=")[1], "#carContainer");
            } else if (searcharray.length == 4) {
                GetCars(searcharray[0].split("=")[1], searcharray[1].split("=")[1], "#carContainer", searcharray[2].split("=")[1], searcharray[3].split("=")[1]);
            }
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
                <li class="step-one">1、选择用车方式</li>
                <li class="step-gray step-orange">2、选择车型</li>
                <li class="step-gray">3、填写联系人</li>
                <li class="step-gray-end">4、提交订单</li>
            </ul>
        </div>
        <div class="dc-info clearfix">
            <div class="dc-main" id="carContainer">
            </div>
            <div class="dc-side">
                <h3 class="per-ser per-ser-til">
                    <a href="SelectWay.aspx">返回修改</a>
                </h3>
                <div class="ser-info car-side-mar">
                    <ul class="car-zuche-con">
                        <li>
                            <%=CarUseName %></li>
                        <li>
                            <%=CityName %></li>
                    </ul>
                </div>
                <img class="ser-tel" src="images/serTel.png" alt="" />
            </div>
        </div>
    </div>
</asp:Content>
