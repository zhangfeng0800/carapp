<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="WebApp.Login" %>

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
    <script src="Scripts/jquery.validate.js" type="text/javascript"></script>
    <script src="Scripts/MySite.js" type="text/javascript"></script>
    <style>
        .login_detail label
        {
            width: 20px;
            margin: 0px;
            color: red;
            font-size: 10px;
        }
    </style>
    <script type="text/javascript">
        function Login(name, pwd, code, url) {
            var validate = $("#form1").validate({
                rules: {
                    username: { required: true },
                    password: { required: true },
                    verifycode: { required: true }
                },
                messages: {
                    username: { required: "*" },
                    password: { required: "*" },
                    verifycode: { required: "*" }
                },
                debug: true,
                onfocusout: false
            });

            if (validate.form()) {
                $.ajax({
                    url: "/api/login.ashx",
                    data: {
                        username: name,
                        password: pwd,
                        verifycode: code,
                        url: url
                    },
                    type: "post",
                    success: function (data) {
                        if (data.StatusCode == 1) {
                            if (data.location.length > 0) {
                                window.location.href = data.location;
                            } else {
                                window.location.href = "/";
                            }
                        } else {
                            alert(data.Message);
                            RefreshImg('#Img_VC');
                        }
                    }
                });
            }
        }

        $(function () {
            $("#btnlogin").click(function () {
                LoginSubmit();
            });
            $(document).keypress(function (event) {
                if (event.which == 13)
                    LoginSubmit();
            });
        });

        function LoginSubmit() {
            if (!isMobile($("#username").val())) {
                alert("请使用手机号码登录！");
                return false;
            }
            Login($("#username").val(), $("#password").val(), $("#verifycode").val(), window.location.href);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="main-box clearfix">
        <div class="login-left">
            <img src="images/denglu.jpg" alt="" />
        </div>
        <div class="login-right">
            <h3 class="login-name">
                爱易租用户登录  </h3>
            <form action="" name="form1" id="form1">
            <p class="login-p">
                <strong id="Strong_LoginWay">手机号</strong>
                <input class="input-style" type="text" id="username" name="username" />
            </p>
            <p class="login-p">
                <strong>密&nbsp;&nbsp;&nbsp;&nbsp;码</strong>
                <input class="input-style" type="password" id="password" name="password" />
            </p>
            <p class="login-p">
                <strong>验证码</strong>
                <input type="text" id="verifycode" style="width: 50px;" name="verifycode" class="input-style" />
                <a class="A_VC" href="javascript:RefreshImg('#Img_VC')">
                    <img id="Img_VC" alt="" title="看不清，点击刷新验证码" src="/api/VerifyCode.ashx?r=<%=DateTime.Now.Millisecond.ToString() %>" /></a>
                <!--/a-->
            </p>
            <p class="login-p">
                <input class="login-btn" type="button" value="登 录" id="btnlogin" />
            </p>
            <p class="login-p zhuce">
                <a href="Register.aspx" title="还没注册？马上注册成为爱易租会员">免费注册</a> <a href="forgetpwd.aspx"
                    title="忘了密码？点击这里重置登录密码">忘记密码</a></p>
            </form>
        </div>
    </div>
</asp:Content>
