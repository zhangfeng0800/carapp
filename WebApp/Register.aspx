<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/SiteBase.Master"
    CodeBehind="Register.aspx.cs" Inherits="WebApp.Register" %>

<%@ Import Namespace="Common" %>
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
    <script src="Scripts/MySite.js" type="text/javascript"></script>
    <script src="Scripts/jquery.validate.js" type="text/javascript"></script>
    <script src="Scripts/Register.js" type="text/javascript"></script>
    <style type="text/css">
        label.error
        {
            color: Red;
            font-size: 13px;
            margin-left: 5px;
            padding-left: 16px;
            background: url("images/error.png") left no-repeat;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <style type="text/css">
        .Span_Must
        {
            color: #f00;
            font: 12px 'Verdana' , '宋体';
        }
    </style>
    <div class="main-box reg-bg clearfix">
        <h3 class="reg-til clearfix">
            注册爱易租 <span class="login-link">我已经是爱易租注册会员，请<a href="/Login.aspx">登录</a></span>
        </h3>
        <form id="form1">
        <div class="f-lh" style="display: none;">
            <span class="reg-name">用户类型</span>
            <select class="in-border" id="usertype">
                <option value="3">个人用户</option>
                <option value="0">集团用户</option>
            </select>
        </div>
        <div class="f-lh">
            <span class="reg-name">手机号码</span>
            <input class="in-border" type="text" id="txtmobile" name="txtmobile" />
            <span class="Span_Must">&nbsp;*</span>&nbsp; <span id="Span_Phone">(唯一登录方式)</span>
            &nbsp;
        </div>
        <div class="f-lh">
            <span class="reg-name">短信验证码</span>
            <input class="in-border" type="text" id="txtVerify" name="txtVerify" />
            <span class="Span_Must">&nbsp;*</span>&nbsp; <a id="A_PostMobileVC" href="javascript:;"
                style="font: 12px '宋体','Verdana'; color: #f90; text-decoration: none;" title="点击发送验证码">获取验证码</a>
        </div>
        <div class="f-lh">
            <span class="reg-name">昵称</span>
            <input class="in-border" type="text" id="username" name="username" maxlength="12" /><span
                class="Span_Must">&nbsp;*</span>
        </div>
        <div class="f-lh">
            <span class="reg-name">性别</span>
            <input type="radio" name="sex" id="man" value="true" checked="checked" />男
            <input type="radio" name="sex" id="woman" value="false" />女
            <%--<input class="in-border" type="text" id="Text1" name="username" maxlength="12" /><span
                class="Span_Must">&nbsp;*</span>--%>
        </div>
        <div class="f-lh">
            <span class="reg-name">密码</span>
            <input class="in-border" type="password" name="password" id="password" maxlength="16" /><span
                class="Span_Must">&nbsp;*</span>
        </div>
        <div class="f-lh">
            <span class="reg-name">确认密码</span>
            <input class="in-border" type="password" name="repassword" id="repassword" maxlength="16" /><span
                class="Span_Must">&nbsp;*</span>
        </div>
        <div class="f-lh">
            <span class="reg-name">邮箱</span>
            <input class="in-border" type="text" id="txtemail" name="txtemail" /><span class="Span_Must">&nbsp;*</span>
        </div>
        <div class="f-lh">
            <span class="reg-name" id="Span_CompName">公司名称</span>
            <input class="in-border" type="text" id="txtcompany" name="txtcompany" /><span class="Span_Must">&nbsp;*</span>
        </div>
        <div class="Div_CompInfo">
            <div class="f-lh">
                <span class="reg-name">联系人姓名</span>
                <input class="in-border" type="text" id="txtrealname" name="txtrealname" /><span
                    class="Span_Must">&nbsp;*</span>
            </div>
            <div class="f-lh">
                <span class="reg-name">联系人电话</span>
                <input class="in-border" type="text" id="txttelphone" name="txttelphone" /><span
                    class="Span_Must">&nbsp;*</span>
            </div>
        </div>
        <div class="f-lh xieyi-margin">
            <input type="checkbox" id="xieyi" name="xieyi" value="1" />
            <span class="xieyi">我已阅读《<a href="article.aspx?id=61&typeid=29" style="text-decoration: underline"
                target="_blank">爱易租用户注册协议</a>》</span>
        </div>
        <div class="f-lh xieyi-margin">
            <input class="login-btn" style="cursor: pointer;" type="button" value="注册" onclick="Register()" />
        </div>
        </form>
    </div>
</asp:Content>
