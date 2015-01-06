var myTimer;
$(document).ready(function () {
    $("#A_headPic").click(function () {
        $("#Iframe_Upload").contents().find("body").find("[name='File_Img']").click();
    });
    $("#A_PostMobileVC").click(function () {
        if ($("#A_PostMobileVC").text() != "获取验证码" && $("#A_PostMobileVC").text() != "重新获取验证码")
            return false;
        if (!isMobile($("input[name='tel']").val())) {
            alert("请输入正确的手机号码");
            $("#txtmobile").focus();
            return false;
        }
        $.post("MyInfo.aspx", {
            Action: "PostVerifyCode",
            Value: $("input[name='tel']").val()
        }, function (data) {
            if (data.Message != "Complete") {
                alert(data.Message);
                $("#txtmobile").focus();
                return false;
            } else {
                $("#A_ModifyMobile").show();
                $("#A_PostMobileVC").text("60秒后重新获取");
                $("#A_PostMobileVC").css("color", "#ddd");
                $("#A_PostMobileVC").css("cursor", "default");
                BanRegister();
            }
        }, "JSON");
    });

    $("#Button_Submit").click(function () {
        if ($("input[name='username']").val().Trim() == "") {
            alert("请填写您的昵称！");
            return false;
        }
        var resultBool = false;
        var username = $("input[name='username']").val();
        //        if (!/[^\u4E00-\u9FA5]/.test(username) && username.length > 1)//昵称是汉字并且大于1位
        //            resultBool = true;
        //        if (/^(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]+$/.test(username) && username.length > 5)
        //            resultBool = true;
        //        if (!resultBool) {
        //            alert("昵称长度不符（汉字至少2位，包含汉字以外字符的昵称至少6位）");
        //            return false;
        //        }
        if (username.length < 2 && username.length > 12) {
            alert("昵称长度限制为2-12位！");
            return false;
        }
        if ($("input[name='tel']").val().Trim() == "") {
            alert("请填写您的手机号码！");
            return false;
        }
        if (!isMobile($("input[name='tel']").val().Trim())) {
            alert("手机号码格式不正确！");
            return false;
        }
        //        if ($("input[name='email']").val().Trim() == "") {
        //            alert("请填写您的邮箱地址！");
        //            return false;
        //        }
        if ($("input[name='email']").val().Trim() != "" && !isEmail($("input[name='email']").val().Trim())) {
            alert("您的邮箱地址格式不正确！");
            return false;
        }
        //$("#Form_Submit").submit();
        $.post("MyInfo.aspx", {
            Action: "Submit",
            Name: $("input[name='name']").val(),
            Username: $("input[name='username']").val(),
            sex: GetRadioValue("Radio_Sex"),
            headPic: $("#Img_headPic").attr("src").split('?')[0].replace('../', ''),
            Value: $("input[name='tel']").val(),
            VerifyCode: $("input[name='verifycode']").val(),
            email: $("input[name='email']").val()
        }, function (data) {
            if (data.Message) {
                if (data.Message == "Complete") {
                    alert("提交成功！");
                    window.location.href = "/PCenter/MyAccount.aspx";
                }
                else {
                    alert(data.Message);
                }
            }
        }, "JSON");
    });
});

function BanRegister() {
    var BanRegSecore = 60;
    setTimeout(function () {
        $("#A_PostMobileVC").text("重新获取验证码");
        $("#A_PostMobileVC").css("color", "#f90");
        $("#A_PostMobileVC").css("cursor", "pointer");
    },
    60000);
    myTimer = setInterval(function () {
        if (BanRegSecore > 1) {
            $("#A_PostMobileVC").text(--BanRegSecore + "秒后重新获取");
        } else {
            clearInterval(myTimer);
        }
    },
    1000);
}

function SetImgUrl(Url) {
    if (Url == "Error1") {
        alert("文件不存在！");
        return false;
    }
    if (Url == "Error2") {
        alert("文件格式错误(请上传jpg、gif、png等格式的图片)");
        return false;
    }
    if (Url == "Error3") {
        alert("图片大小超过限制(最大不超过256KB)");
        return false;
    }
    var DateStr = new Date;
    $("#Img_headPic").attr("src", "../headPic/" + Url + "?r=" + DateStr.getMilliseconds());
}