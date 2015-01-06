var myTimer;

$(document).ready(function () {
    SetCompInfoShow();
    $("#usertype").change(function () {
        SetCompInfoShow();
    });
    $("#A_PostMobileVC").click(function () {
        if ($("#A_PostMobileVC").text() != "获取验证码" && $("#A_PostMobileVC").text() != "重新获取验证码") {
         
             return false;
        }
           
        if (!isMobile($("#txtmobile").val())) {
            ShowHint("txtmobile", "请输入正确的手机号码");
            return false;
        }
        $("label[for='txtmobile']").text("");
        $.post("register.aspx", {
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

jQuery.validator.addMethod("stringCheck", function (value, element) {
    return this.optional(element) || /^[\u4e00-\u9fa5]+$/.test(value);
}, "必须输入汉字");

//jQuery.validator.addMethod("usernamecheck", function (value, element) {
//    return this.optional(element) || /^[a-zA-Z0-9]+$/.test(value);
//}, "只能包括字母和数字");

jQuery.validator.addMethod("istelphone", function (value, element) {
    var tel = /^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$/;
    return this.optional(element) || tel.test(value);
}, "电话号格式错误");

jQuery.validator.addMethod("usernamecheck", function (value, element) {
    var resultBool = false;
    if (!/[^\u4E00-\u9FA5]/.test(value) && value.length > 1)//昵称是汉字并且大于1位
        resultBool = true;
    if (/^(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]+$/.test(value) && value.length > 5)
        resultBool = true;
    return this.optional(element) || resultBool;
}, "昵称长度6-12位");

jQuery.validator.addMethod("isphone", function (value, element) {
    return this.optional(element) || isMobile(value) || isPhone(value);
}, "联系人电话格式错误");

function SetCompInfoShow() {
    if (GetSelectValue("usertype") == "3") {
        $("#Span_CompName").text("真实姓名");
        $(".Div_CompInfo").hide();
    } else {
        $("#Span_CompName").text("公司名称");
        $(".Div_CompInfo").show();
    }
}
function Register() {
    $("#Span_Phone").remove();
    var validate = $("#form1").validate({
        rules: {
            txtmobile: { required: true, ismobile: true,
                remote: {
                    url: "Register.aspx",
                    type: "post",
                    dataType: "html",
                    data: {
                        Action: "Exist_Telphone"
                    },
                    dataFilter: function (data, type) {
                        if (data.substr(0, 4) == "True")
                            return false;
                        else
                            return true;
                    }
                }
            },
            txtVerify: { required: true,
                remote: {
                    url: "Register.aspx",
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
            username: { required: true, usernamecheck: true, maxlength: 12, minlength: 6,
                remote: {
                    url: "Register.aspx",
                    type: "post",
                    dataType: "html",
                    data: {
                        Action: "Exist_Username"
                    },
                    dataFilter: function (data, type) {
                        if (data.substr(0, 4) == "True")
                            return false;
                        else
                            return true;
                    }
                }
            },
            password: { required: true, minlength: 6, maxlength: 16 },
            repassword: { required: true, equalTo: "#password" },
            txtemail: { required: true, email: true,
                remote: {
                    url: "Register.aspx",
                    type: "post",
                    dataType: "html",
                    data: {
                        Action: "Exist_Email"
                    },
                    dataFilter: function (data, type) {
                        if (data.substr(0, 4) == "True")
                            return false;
                        else
                            return true;
                    }
                }
            },
            txtcompany: { required: true, stringCheck: true },
            txtrealname: { required: true },
            txttelphone: { required: true, isphone: true }
        },
        messages: {
            txtmobile: { required: "手机号码不能为空", ismobile: "手机号格式错误", remote: "该号码已存在" },
            txtVerify: { required: "请填写短信验证码", remote: "验证码不匹配" },
            username: { required: "昵称不能为空", usernamecheck: "昵称长度2-12位", maxlength: "最大长度是12", minlength: "最小长度是2", remote: "该昵称已被使用" },
            password: { required: "密码不能为空", minlength: "密码长度至少是6位", maxlength: "最大长度是16" },
            repassword: { required: "请输入确认密码", equalTo: "两次输入密码不一致" },
            txtemail: { required: "邮箱地址不能为空", email: "邮箱格式错误", remote: "该邮箱已被注册" },
            txtcompany: {
                required: function () {
                    if (GetSelectValue("usertype") == "3")
                        return "用户姓名不能为空";
                    else
                        return "公司名称不能为空";
                },
                stringCheck: "必须输入汉字"
            },
            txtrealname: { required: "联系人姓名不能为空" },
            txttelphone: { required: "联系人电话不能为空", isphone: "联系人电话格式错误" }
        }
    });
    if (validate.form()) {
        if (GetCheckboxValue("xieyi") != "1") {
            alert("您还没有同意《爱易租用户注册协议》！");
            $("#xieyi").focus();
            return false;
        }
        //通过删除
        //        alert(CookieGet("VerifyCodeForMobile"));
        //        alert($("#txtVerify").val());
        //        return false;
        //通过删除
        $.ajax({
            url: "/api/register.ashx",
            data: {
                username: $("#username").val(),
                password: $("#password").val(),
                txtmobile: $("#txtmobile").val(),
                txtVerify: $("#txtVerify").val(),
                txtcompany: $("#txtcompany").val(),
                txtemail: $("#txtemail").val(),
                txtrealname: $("#txtrealname").val(),
                txttelphone: $("#txttelphone").val(),
                usertype: $("#usertype").val(),
                sex: $("input[name='sex']:checked").val()
            },
            type: "post",
            success: function (data) {
                if (data.StatusCode == 1) {
                    window.location.href = "Default.aspx";
                } else {
                    alert(data.Message);
                }
            }
        });
    }
}