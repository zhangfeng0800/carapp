var myTimer;

$(document).ready(function () {
    $("#A_PostMobileVC").click(function () {
        if ($("#A_PostMobileVC").text() != "获取验证码" && $("#A_PostMobileVC").text() != "重新获取验证码")
            return false;
        if (!isMobile($("#txtmobile").val())) {
            ShowHint("txtmobile", "请输入6-16位正确的手机号码");
            return false;
        }
        $("label[for='txtmobile']").text("");
        $.post("forgetpwd.aspx", {
            Action: "PostVerifyCode",
            Value: $("#txtmobile").val()
        }, function (data) {
            if (data.Message != "Complete") {
                ShowHint("txtmobile", data.Message);
            } else {
                $("#A_PostMobileVC").text("60秒后重新获取");
                $("#A_PostMobileVC").css("color", "#ddd");
                $("#A_PostMobileVC").css("cursor", "default");
                $("label[for='txtmobile']").remove();
                BanRegister();
            }
        }, "JSON");
    });
});

function BanRegister() {
    var BanRegSecore = 60;
    /*setTimeout(function() {
    $("#A_PostMobileVC").text("重新获取验证码");
    $("#A_PostMobileVC").css("color", "#f90");
    $("#A_PostMobileVC").css("cursor", "pointer");
    },
    60000);*/
    myTimer = setInterval(function () {
        if (BanRegSecore > 1) {
            $("#A_PostMobileVC").text(--BanRegSecore + "秒后重新获取");
        } else {
            $("#A_PostMobileVC").text("重新获取验证码");
            $("#A_PostMobileVC").css("color", "#f90");
            $("#A_PostMobileVC").css("cursor", "pointer");
            clearInterval(myTimer);
        }
    },
        1000);
}

function ShowHint(tagName, hintStr) {
    $("#Span_Phone").remove();
    if ($("#" + tagName).next("label[for='" + tagName + "']").length > 0)
        $("label[for='" + tagName + "']").text(hintStr);
    else
        $("#" + tagName).after("<label for=\"" + tagName + "\" class=\"error\">" + hintStr + "</label>");
}

jQuery.validator.addMethod("ismobile", function (value, element) {
    var length = value.length;
    var mobile = /^1(3|5|8)\d{9}$/;
    return this.optional(element) || (length == 11 && mobile.test(value));
}, "手机号码格式错误");

function ChangePwd() {
    $("#Span_Phone").remove();
    var validate = $("#form1").validate({
        rules: {
            txtmobile: { required: true, ismobile: true,
                remote: {
                    url: "forgetpwd.aspx",
                    type: "post",
                    dataType: "html",
                    data: {
                        Action: "Exist_Telphone"
                    },
                    dataFilter: function (data, type) {
                        if (data.substr(0, 4) == "True")
                            return true;
                        else
                            return false;
                    }
                }
            },//
            txtVerify: { required: true,
                remote: {
                    url: "forgetpwd.aspx",
                    type: "post",
                    dataType: "html",
                    data: {
                        Action: "CheckVerifyCode",
                        txtmobile: function () { return $("#txtmobile").val(); }
                    },
                    dataFilter: function (data, type) {
                        //alert(data.substr(0, 4));
                        if (data.substr(0, 4) == "Fals")
                            return false;
                        else
                            return true;
                    }
                }
            },
            password: { required: true, minlength: 6, maxlength: 16 },
            repassword: { required: true, equalTo: "#password" }
        },
        messages: {
            txtmobile: { required: "手机号码不能为空", ismobile: "手机号格式错误", remote: "该号码不存在" },
            txtVerify: { required: "请填写短信验证码", remote: "验证码不匹配" },
            password: { required: "密码不能为空", minlength: "密码长度至少是6位", maxlength: "最大长度是16" },
            repassword: { required: "请输入确认密码", equalTo: "两次输入密码不一致" }
        }
    });
    if (validate.form()) {
        //通过删除
        //        alert(CookieGet("VerifyCodeForMobile"));
        //        alert($("#txtVerify").val());
        //        return false;
        //通过删除
        $.post("forgetpwd.aspx",
        {
            action: "ChangePwd",
            password: $("#password").val(),
            txtmobile: $("#txtmobile").val(),
            txtVerify: $("#txtVerify").val()
        }, function(data) {
            if (data.Message == "Complete") {
                alert("修改成功，请登录！");
                window.location.href = "Login.aspx";
            } else {
                alert(data.Message);
            }
        }, "json");
    }
}