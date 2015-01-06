<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="AccountpaySuccess.aspx.cs" Inherits="WebApp.AccountpaySuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>爱易租 租车新生活</title>
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <link rel="stylesheet" type="text/css" href="css/public.css" />
    <link rel="stylesheet" type="text/css" href="css/subpage.css" />
    <link href="css/orderpay.css" rel="stylesheet" type="text/css" />
    <!--[if IE 6]>
  <script type="text/javascript" src="js/png.js"></script>
  <script type="text/javascript" src="js/fixpng.js"></script>
<![endif]-->
    <script type="text/javascript" src="js/jquery-1.8.0.min.js"></script>
   
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="dc-process clearfix">
        <div class="pay-ok">
            <p class="pay-text">
                订单提交成功！
            </p>
            <p>
                感谢您选择爱易租，我们将尽快确定您的订单
            </p>
            <p>
                您的订单号是：<strong class="order-text" id="orderidcontainer"><%=Request.QueryString["orderid"]??"" %></strong> <em
                    class="em-red">我们将以短信形式发送到您的手机，如果长时间未收到短信，请致电我们。电话：0311-85119999</em>
            </p>
            <%--  <p class="clearfix">
                <a href="" class="sel-order">查看我的订单</a> 9秒后自动跳到订单详情页面
            </p>--%>
        </div>
    </div>
</asp:Content>
