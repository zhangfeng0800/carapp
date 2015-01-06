<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="PCenter.aspx.cs" Inherits="WebApp.PCenter.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript">
    $(document).ready(function () {
        $("input[value='提交修改']").click(function () {
            if (!Check())
                return false;
            $.post("ChangePassword.aspx", {
                action: "SubmitNewPW",
                oldPW: $("#oldPW").val(),
                newPW: $("#newPW").val(),
                confirmPW: $("#confirmPW").val()
            }, function (data) {
                if (data.Message == "Success") {
                    alert("密码修改成功！");
                    window.location.href = "/PCenter/MyAccount.aspx";
                }
                else
                    alert(data.Message);
            }, "json");
        });
    });
    function Check() {
        if ($("#oldPW").val() == "") {
            alert("请填写原密码！");
            return false;
        }
        if ($("#newPW").val() == "") {
            alert("请填写新密码！");
            return false;
        }
        if ($("#newPW").val().length < 6) {
            alert("新密码长度过短(至少6位)");
            return false;
        }
        if ($("#confirmPW").val() == "") {
            alert("请确认新密码！");
            return false;
        }
        if ($("#confirmPW").val() != $("#newPW").val()) {
            alert("两次输入的密码不一致！");
            return false;
        }
        return true;
    }
</script>
<style type="text/css">
.Span_Hint
{
    color:#f00;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <h3 class="per-order-til">
                修改登录密码</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <ul class="per-ul">
                    <li>
                        <span class="per-name-style" style="width: 80px;"><span class="Span_Hint">*</span>原密码：</span>
                        <input type="password" id="oldPW" />
                    </li>
                    <li>
                        <span class="per-name-style" style="width: 80px;"><span class="Span_Hint">*</span>新密码：</span>
                        <input type="password" id="newPW" />
                    </li>
                    <li>
                        <span class="per-name-style" style="width: 80px;"><span class="Span_Hint">*</span>确认新密码：</span>
                        <input type="password" id="confirmPW" />
                    </li>
                    <li class="per-button-padding">
                        <input class="yc-btn bank-btn per-button-border" type="button" value="提交修改"/>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>
