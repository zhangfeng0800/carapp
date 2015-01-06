<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="forgetpwd.aspx.cs" Inherits="WebApp.forgetpwd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="css/public.css" />
    <link rel="stylesheet" type="text/css" href="css/subpage.css" />
    <!--[if IE 6]>
  <script type="text/javascript" src="js/png.js"></script>
  <script type="text/javascript" src="js/fixpng.js"></script>
<![endif]-->
    <script type="text/javascript" src="js/jquery-1.8.0.min.js"></script>
    <script src="Scripts/MySite.js" type="text/javascript"></script>
    <script src="Scripts/jquery.validate.js" type="text/javascript"></script>    <script src="Scripts/forgetpwd.js" type="text/javascript"></script>
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
            找回密码
        </h3>
        <form id="form1">
            <div class="f-lh">
                <span class="reg-name">手机号码</span>
                <input class="in-border" type="text" id="txtmobile" name="txtmobile" /><span class="Span_Must">&nbsp;*</span>
            </div>
            <div class="f-lh">
                <span class="reg-name">短信验证码</span>
                <input class="in-border" type="text" id="txtVerify" name="txtVerify" /><span class="Span_Must">&nbsp;*</span>
                &nbsp;<a id="A_PostMobileVC" href="javascript:;" style="font: 12px '宋体','Verdana'; color: #f90; text-decoration: none;" title="点击发送验证码">获取验证码</a>
            </div>
            <div class="f-lh">
                <span class="reg-name">输入新密码</span>
                <input class="in-border" type="password" name="password" id="password" maxlength="16" />
                <span class="Span_Must">&nbsp;*</span>
            </div>
            <div class="f-lh">
                <span class="reg-name">确认新密码</span>
                <input class="in-border" type="password" name="repassword" id="repassword" maxlength="16" />
                <span class="Span_Must">&nbsp;*</span>
            </div>
            <div class="f-lh xieyi-margin">
                <input class="login-btn" style="cursor: pointer;" type="button" value="提交修改" onclick="ChangePwd()" />
            </div>
        </form>
    </div>
</asp:Content>
