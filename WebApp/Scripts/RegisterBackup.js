var usernamePass = false;
var compnamePass = false;
var telphonePass = false;
var MobileVerifyCodePass = false;
var emailPass = false;
$(document).ready(function () {
    $("#Select_UserType").change(function () {
        if (GetSelectValue("Select_UserType") == "Company") {
            $("#Span_Company").show();
            $("#Label_CompName").html($("#Label_CompName").html().replace("真实姓名", "集团名称"));
        } else {
            $("#Span_Company").hide();
            $("#Label_CompName").html($("#Label_CompName").html().replace("集团名称", "真实姓名"));
        }
        Check_CompName();
    });
    $("#Text_UserName").blur(function () {
        Check_UserName();
    });
    $("#Text_CompName").blur(function () {
        Check_CompName();
    });
    $("#Text_telphone").blur(function () {
        Check_telphone();
    });
    $("#Button_telphoneVC").click(function () {
        if (Check_telphone() == false)
            return false;
        setTimeout("PostMobileVerifyCode();", 300);
    });
    $("#Text_telphoneVC").blur(function () {
        Check_telphoneVC();
    });
    $("#Password_password").blur(function () {
        Check_password();
    });
    $("#Password_Repassword").blur(function () {
        Check_Repassword();
    });
    $("#Text_email").blur(function () {
        Check_email();
    });
    $("#Text_Contact").blur(function () {
        Check_Contact();
    });
    $("#Text_Tel").blur(function () {
        Check_Tel();
    });
    $("#Text_VerifyCode").blur(function () {
        Check_VerifyCode();
    });
    $("#A_Sutmit").click(function () {
        if (!Check())
            return false;
        setTimeout("Submit();", 1000);
    });
});

function PostMobileVerifyCode() {
    if (telphonePass) {
        $.post("Register.aspx", {
            Action: "PostMobileVerifyCode",
            Value: $("#Text_telphone").val().Trim()
        });
    }
}

function Check(parameters) {//检测所有填写的信息
    if (!Check_UserName())
        return false;

    if (!Check_CompName())
        return false;

    if (!Check_telphone())
        return false;

    if (!Check_telphoneVC())
        return false;

    if (!Check_password())
        return false;

    if (!Check_Repassword())
        return false;

    if (!Check_email())
        return false;

    if (!Check_Contact())
        return false;

    if (!Check_Tel())
        return false;

    if (!Check_VerifyCode())
        return false;

    return true;
}

function Submit() {
    /*alert(usernamePass);
    alert(compnamePass);
    alert(telphonePass);
    alert(emailPass);*/
    if (usernamePass == false || compnamePass == false || telphonePass == false || emailPass == false || MobileVerifyCodePass == false)
        return false;
    if (GetCheckboxValue("Checkbox_Agree") == "") {
        alert("您还没有同意《至尊会员注册协议》！");
        $("input[name='Checkbox_Agree']").focus();
        return false;
    }
    //alert("2");
    if ($("#A_Sutmit").attr("title") == "立即注册") {
        $("#A_Sutmit").attr("title", "提交中…");
        $.post("api/register.ashx", {
            Username: encodeURIComponent($("#Text_UserName").val()),
            Compname: encodeURIComponent($("#Text_CompName").val()),
            Telphone: $("#Text_telphone").val(),
            Password: $("#Password_password").val(),
            email: encodeURIComponent($("#Text_email").val()),
            compuser: (GetSelectValue("Select_UserType") == "Company" ? "1" : "0")
        }, function (data) {
            alert(data.message);
            if (data.message == "注册成功!") {
                window.location.href = "PersonCenter/MyAccount.aspx";
            } else
                $("#A_Sutmit").attr("title", "立即注册");
        });
    }
}

function Exist(Action, Value) {
    $.post("Register.aspx", {
        Action: Action,
        Value: Value
    }, function (data) {
        //alert(data.substr(0, 4));
        if (data.substr(0, 4) == "True") {//值已经存在
            switch (Action) {
                case "Exist_Username":
                    usernamePass = false;
                    break;
                case "Exist_Compname":
                    compnamePass = false;
                    break;
                case "Exist_Email":
                    emailPass = false;
                    break;
                case "Exist_Telphone":
                    telphonePass = false;
                    break;
                case "CheckMobileVerifyCode":
                    MobileVerifyCodePass = true; //手机验证码跟其他的相反
                    break;
                default:
                    break;
            }
            //alert(compnamePass);
        } else {
            switch (Action) {
                case "Exist_Username":
                    usernamePass = true;
                    break;
                case "Exist_Compname":
                    compnamePass = true;
                    break;
                case "Exist_Email":
                    emailPass = true;
                    break;
                case "Exist_Telphone":
                    telphonePass = true;
                    break;
                case "CheckMobileVerifyCode":
                    MobileVerifyCodePass = false; //手机验证码跟其他的相反
                    break;
                default:
                    break;
            }
            //alert(compnamePass);
        }
    });
}

//检测用户名Start
function Check_UserName() {
    $("#Text_UserName").val($("#Text_UserName").val().Trim());
    var Hint = $("#Text_UserName").next(".Span_Hint");

    if ($("#Text_UserName").val() == "") {
        ShowHint(Hint, "请输入您的用户名", false);
        return false;
    }

    if ($("#Text_UserName").val().length < 6) {
        ShowHint(Hint, "用户名长度过短", false);
        return false;
    }

    Exist("Exist_Username", $("#Text_UserName").val().Trim());
    setTimeout("Show_UserName_Exist();", 500);
    return true;
}

function Show_UserName_Exist() {
    var Hint = $("#Text_UserName").next(".Span_Hint");
    if (usernamePass)
        ShowHint(Hint, "√", true);
    else
        ShowHint(Hint, "用户名已存在", false);
}
//检测用户名End
//检测真实姓名/公司名Start
function Check_CompName() {
    $("#Text_CompName").val($("#Text_CompName").val().Trim());
    var Hint = $("#Text_CompName").next(".Span_Hint");

    if (GetSelectValue("Select_UserType") == "Personal") {//个人用户
        if ($("#Text_CompName").val() == "") {
            ShowHint(Hint, "请输入您的姓名", false);
            return false;
        }
        if (!isChn($("#Text_CompName").val())) {
            ShowHint(Hint, "请用中文输入姓名", false);
            return false;
        }
        compnamePass = true;
        ShowHint(Hint, "√", true);
        return true;
    } else {//集团用户
        if ($("#Text_CompName").val() == "") {
            ShowHint(Hint, "请输入公司名称", false);
            return false;
        }
        if (!isChn($("#Text_CompName").val())) {
            ShowHint(Hint, "中文输入公司名称", false);
            return false;
        }
        Exist("Exist_Compname", $("#Text_CompName").val().Trim());
        setTimeout("Show_CompName_Exist();", 500);
        return true;
    }
}
function Show_CompName_Exist() {
    var Hint = $("#Text_CompName").next(".Span_Hint");
    if (compnamePass)
        ShowHint(Hint, "√", true);
    else
        ShowHint(Hint, "该公司名称已存在", false);
}
//检测真实姓名/公司名End
//检测手机号码Start
function Check_telphone() {
    $("#Text_telphone").val($("#Text_telphone").val().Trim());
    var Hint = $("#Text_telphone").next(".Span_Hint");

    if ($("#Text_telphone").val() == "") {
        ShowHint(Hint, "请填写您的手机号码", false);
        return false;
    }

    if (!isMobile($("#Text_telphone").val())) {
        ShowHint(Hint, "手机号码格式错误", false);
        return false;
    }
    Exist("Exist_Telphone", $("#Text_telphone").val().Trim());
    setTimeout("Show_telphone_Exist();", 500);
    return true;
}

function Show_telphone_Exist() {
    var Hint = $("#Text_telphone").next(".Span_Hint");
    if (telphonePass)
        ShowHint(Hint, "√", true);
    else
        ShowHint(Hint, "手机号已存在", false);
}
//检测手机号码End
//手机短信验证Start
function Check_telphoneVC() {
    $("#Text_telphoneVC").val($("#Text_telphoneVC").val().Trim());
    var Hint = $("#Text_telphoneVC").next().next(".Span_Hint");

    if ($("#Text_telphoneVC").val() == "") {
        ShowHint(Hint, "请填写手机验证码", false);
        return false;
    }
    Exist("CheckMobileVerifyCode", $("#Text_telphoneVC").val().Trim().toUpperCase());
    setTimeout("Show_telphoneVC_Exist();", 500);
    return true;
}

function Show_telphoneVC_Exist() {
    var Hint = $("#Text_telphoneVC").next().next(".Span_Hint");
    if (MobileVerifyCodePass)
        ShowHint(Hint, "√", true);
    else
        ShowHint(Hint, "验证码错误", false);
}
//手机短信验证End
//检测密码Start
function Check_password() {
    var Hint = $("#Password_password").next(".Span_Hint");

    if ($("#Password_password").val() == "") {
        ShowHint(Hint, "请填写您的登陆密码", false);
        return false;
    }
    if ($("#Password_password").val().length < 6) {
        ShowHint(Hint, "密码长度过短", false);
        return false;
    }
    ShowHint(Hint, "√", true);
    return true;
}
//检测密码End
//检测确认密码Start
function Check_Repassword() {
    var Hint = $("#Password_Repassword").next(".Span_Hint");

    if ($("#Password_Repassword").val() == "") {
        ShowHint(Hint, "请确认您的登陆密码", false);
        return false;
    }
    if ($("#Password_Repassword").val() != $("#Password_password").val()) {
        ShowHint(Hint, "两次输入的密码不同", false);
        return false;
    }
    ShowHint(Hint, "√", true);
    return true;
}
//检测确认密码End
//检测邮箱Start
function Check_email() {
    $("#Text_email").val($("#Text_email").val().Trim());
    var Hint = $("#Text_email").next(".Span_Hint");

    if ($("#Text_email").val() == "") {
        ShowHint(Hint, "请输入您的邮箱地址", false);
        return false;
    }
    if (!isEmail($("#Text_email").val())) {
        ShowHint(Hint, "邮箱地址格式不正确", false);
        return false;
    }
    Exist("Exist_Email", $("#Text_email").val().Trim());
    setTimeout("Show_Email_Exist();", 500);
    return true;
}

function Show_Email_Exist() {
    var Hint = $("#Text_email").next(".Span_Hint");
    if (emailPass)
        ShowHint(Hint, "√", true);
    else
        ShowHint(Hint, "该邮箱地址已存在", false);
}
//检测邮箱End
//检测联系人Start
function Check_Contact() {
    if (GetSelectValue("Select_UserType") == "Personal") //个人用户，不检测
        return true;

    $("#Text_Contact").val($("#Text_Contact").val().Trim());

    var Hint = $("#Text_Contact").next(".Span_Hint");

    if ($("#Text_Contact").val() == "") {
        ShowHint(Hint, "请输入联系人姓名", false);
        return false;
    }

    ShowHint(Hint, "√", true);
    return true;
}
//检测联系人End
//检测固定电话Start
function Check_Tel() {
    if (GetSelectValue("Select_UserType") == "Personal")//个人用户，不检测
        return true;

    $("#Text_Tel").val($("#Text_Tel").val().Trim());

    var Hint = $("#Text_Tel").next(".Span_Hint");

    if ($("#Text_Tel").val().Trim() != "" && !isPhone($("#Text_Tel").val().Trim())) {
        ShowHint(Hint, "固定电话格式错误", false);
        return false;
    }

    ShowHint(Hint, "√", true);
    return true;
}
//检测固定电话End
//检测验证码Start
function Check_VerifyCode() {
    var Hint = $("#Text_VerifyCode").next().next(".Span_Hint");

    if ($("#Text_VerifyCode").val().Trim() == "") {
        ShowHint(Hint, "请输入验证码", false);
        return false;
    }

    if ($("#Text_VerifyCode").val().toUpperCase() != CookieGet("VerifyCode")) {
        ShowHint(Hint, "验证码错误！", false);
        return false;
    }

    ShowHint(Hint, "√", true);
    return true;
}
//检测验证码End
function ShowHint(obj, HintText, Verify) {
    obj.css("color", (Verify ? "#67c147" : "#f00"));
    obj.text(HintText);
    obj.show();
}