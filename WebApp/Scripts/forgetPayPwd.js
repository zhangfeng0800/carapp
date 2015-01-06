var myTimer;

$(document).ready(function () {
    $("#A_PostMobileVC").click(function () {
        if ($("#A_PostMobileVC").text() != "获取验证码" && $("#A_PostMobileVC").text() != "重新获取验证码")
            return false;
        $.post("ResetPayPassword.aspx", {
            Action: "PostVerifyCode",
            Value: $("#txtmobile").val()
        }, function (data) {
            if (data.Message != "Complete") {
                ShowHint("txtmobile", data.Message);
            } else {
                $("#A_PostMobileVC").text("60秒后重新获取");
                $("#A_PostMobileVC").css("color", "#ddd");
                $("#A_PostMobileVC").css("cursor", "default");
                BanRegister();
            }
        }, "JSON");
    });
    $("#Button_Submit").click(function () {
        if ($("#newPW").val().Trim() == "") {
            alert("请填写支付密码！");
            return false;
        }
        if (!isZipcode($("#newPW").val())) {
            alert("支付密码格式错误，必须输入6位数字！");
            return false;
        }
        if ($("#confirmPW").val() == "") {
            alert("请确认支付密码！");
            return false;
        }
        if ($("#confirmPW").val() != $("#newPW").val()) {
            alert("两次输入的密码不一致！");
            return false;
        }
        if ($("#txtVerify").val() == "") {
            alert("请填写短信验证码！");
            return false;
        }
        ChangePwd();
    });
});

function BanRegister() {
    var BanRegSecore = 60;
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

function ChangePwd() {
    $.post("ResetPayPassword.aspx",
    {
        action: "ChangePwd",
        payPassword: $("#newPW").val(),
        txtVerify: $("#txtVerify").val()
    }, function(data) {
        if (data.Message == "Complete") {
            alert("修改成功！");
            window.location.href = "/PCenter/MyAccount.aspx";
        } else {
            alert(data.Message);
        }
    }, "json");
}