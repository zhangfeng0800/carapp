<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CarAppAdminWebUI.Login" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统登陆</title>
    <link href="/Static/login/css/style.css" rel="stylesheet" type="text/css" />
    <script src="Static/scripts/jquery.min.js" type="text/javascript"></script>
    <script>
        function switchRole(val) {
            if (val == "callcenter") {
                $("#myselect").show();
                $("#myselect").val("请选择...");
            } else if (val == "manager") {
                $("#myselect").hide();
            }
        }
        function refreshImg() {
            $("#checkcodeImg").attr("src", '/ajax/VerifyCode.ashx?m='+<%=DateTime.Now.ToString("yyyyMMddHHmmssffffff") %>);
        }
        function RefreshImg(TagID){
        var DateStr = new Date;
        $(TagID).attr("src", QSRBU('r', DateStr.getMilliseconds(), $(TagID).attr("src")));
        }
        function QSRBU(Sort, NewValue, URL){
    var QueryStr = URL;
    var NewQueryStr = "";
    if (QueryStr.indexOf(Sort + "=") != -1) {
        var StrStart = QueryStr.indexOf(Sort + "=") + Sort.length + 1;
        var SortLength = QueryStr.substring(StrStart).indexOf('&') == -1 ? QueryStr.substring(StrStart).length : QueryStr.substring(StrStart).indexOf('&');
        NewQueryStr = QueryStr.substring(0, StrStart) + NewValue + QueryStr.substring(StrStart + SortLength);
    }
    else {
        if (QueryStr.indexOf("?") != -1)
            NewQueryStr = QueryStr + "&" + Sort + "=" + NewValue;
        else
            NewQueryStr = QueryStr + "?" + Sort + "=" + NewValue;
    }
    return NewQueryStr;
}
    </script>
</head>
<body>
    <h1 class="admin_til">
        客服管理系统</h1>
    <div class="logon_box">
        <form id="form1" runat="server">
        <div class="form_items_one">
            <span>
                <input style=" display:none;" type="radio" id="service" name="login" checked="True" value="callcenter" runat="server"
              /> <label for="service">
                    </label>
                    <a style="text-decoration:none;  float:right; color:Blue; font-size:12px;" href="AdminLogin.aspx">管理员登陆</a>
            </span>
            <span class="admin">
                <input style=" display:none;" type="radio" id="admin" name="login" value="manager"
                    runat="server" />
                <label for="admin">
                    </label>
            </span>
        </div>
        <div class="form_items">
            <script type="text/javascript">
                $(document).ready(function () {

                    document.onkeydown = keyDown;

                    $("#service").attr("checked", "checked");
                    $(".select_box input").click(function () {
                        var thisinput = $(this);
                        var thisul = $(this).parent().find("ul");
                        if (thisul.css("display") == "none") {
                            if (thisul.height() > 200) {
                                thisul.css({ height: "200" + "px", "overflow-y": "scroll" });
                            };
                            thisul.fadeIn("100");
                            thisul.hover(function() {}, function() { thisul.fadeOut("100"); });
                            thisul.find("li").click(function () {
                                thisinput.val($(this).text());
                                thisul.fadeOut("100");
                            }).hover(function () { $(this).addClass("hover"); }, function () { $(this).removeClass("hover"); });
                        } else {
                            thisul.fadeOut("fast");
                        }
                    });
                });
                function keyDown(e) {
                    if (e.keyCode == "13") {
                        Login();
                    }
                }
                function Login() {
                    var type = $("#service").prop("checked");

                    var adminName = $("#AdminName").val();
                    var adminPwd = $("#AdminPassword").val();
                    var checkcode = $("#txt_verifycode").val();
                    var myselect = $("#myselect").val();
                    if (adminName == "") {
                        alert("账号不能为空");
                        return;
                    } else if (adminPwd == "") {
                        alert("密码不能为空");
                        return;
                    }
                    else if (checkcode == "验证码") {
                        alert("请输入验证码");
                        return;
                    }
                    $.ajax({
                        url: "/Ajax/LoginHandler.ashx",
                        type: "post",
                        data: { "AdminName": adminName, "AdminPassword": adminPwd, "txt_verifycode": checkcode, "type": type, "myselect": myselect },
                        success: function (data) {
                            if (data.ResultCode != 0) {
                                window.location.href = "Default.aspx";
                            }
                            else {
                                alert(data.Msg);
                            }
                        },
                        error: function (data) {
                            alert(data.Msg);
                        },
                        dataType:"json"

                    });
//                    $.post("/Ajax/LoginHa多大的n33dler.ashx", { "AdminName": adminName, "AdminPassword": adminPwd, "txt_verifycode": checkcode,"type": type, "myselect": myselect}, function (data) {
//                        alert("ssss");
//                        if (data.ResultCode != 0) {
//                            window.location.href = "Default.aspx";
//                        }
//                        else {
//                            alert(data.Msg);
//                        }
//                    });
                }

                function checkCode(obj) {
                    var thecode = $(obj).val();
                    if (thecode.length == 4) {
                        $.post("/Ajax/LoginHandler.ashx", { "action": "checkCode", "code": thecode }, function (data) {
                            if (data == "Success") {
                                $("#theTip").attr("src", "Images/weixinNews/right.png");
                                $("#theTip").css('display', 'initial'); //隐藏  
                            } else {
                                $("#theTip").attr("src", "Images/weixinNews/error.png");
                                $("#theTip").css('display', 'initial'); //隐藏 
                            }
                        });
                    } else if ($(obj).val().length > 4) {
                        $("#theTip").attr("src", "Images/weixinNews/error.png");
                        $("#theTip").css('display', 'initial'); //隐藏 
                    }
                }
            </script>
            <div class="select_box">
                <input id="myselect" type="text" value="请选择..." readonly="readonly" runat="server" />
                <ul class="select_ul" id="extenlist">
                        <%
                            foreach (var dr in GetList())
                        {%>
                            <li><%=dr.Exten %></li>
                        <%}
                         %> 
                </ul>
            </div>
        </div>
        <div class="form_items">
            <input class="input_style" type="text"   onfocus="this.value=''" onblur="if(!value){value=defaultValue;}" id="AdminName"  runat="server"/>
        </div>
        <div class="form_items">
            <input class="input_style input_pwd" type="password" onfocus="this.value=''" runat="server" id="AdminPassword"
                onblur="if(!value){value=defaultValue;}" />
        </div>
        <div class="form_items">
            <input class="input_style input_check" type="text" value="验证码" onfocus="this.value=''" id="txt_verifycode" runat="server" onkeyup="checkCode(this)"
                onblur="if(!value){value=defaultValue;}" />
            <span><a href="javascript:;" onclick="RefreshImg('#checkcodeImg')">
                <img id="checkcodeImg" title="看不清，点击刷新验证码" src="ajax/VerifyCode.ashx?m=<%=DateTime.Now.ToString("yyyyMMddHHmmssffffff") %>"
                    height="30" width="60" /></a> </span><img id="theTip" alt="提示" src="#" style="width:25px; height:25px; display:none; " />
        </div>
        <div class="form_items">
          <%--  <asp:Button class="form_btn" Text="登 录" runat="server" ID="btnsubmit" />--%>
            
           <a id="mylogin" class="form_btn" href="javascript:;"  onclick="Login()">登 录</a>
        </div>
         
        </form>
    </div>
</body>
</html>
