<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="ChangePayPassword.aspx.cs" Inherits="WebApp.PCenter.ChangePayPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript">
    $(document).ready(function () {
        $("input[value='提交修改']").click(function () {
            if (!Check())
                return false;
            $.post("ChangePayPassword.aspx", {
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
        if (!isZipcode($("#newPW").val())) {
            alert("支付密码格式错误，必须输入6位数字！");
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
                修改支付密码</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <p class="P_Hint" style="clear:both">
                <em>友情提示：</em>如果您忘记了支付密码，请点击<a href="ResetPayPassword.aspx">这里</a>重新设置支付密码。
                </p>
                <ul class="per-ul">
                    <li>
                        <span class="per-name-style" style="width: 80px;"><span class="Span_Hint">*</span>原支付密码：</span>
                        <input type="password" id="oldPW" />
                    </li>
                    <li>
                        <span class="per-name-style" style="width: 80px;"><span class="Span_Hint">*</span>新支付密码：</span>
                        <input type="password" id="newPW" /><span style="color:#f00">&nbsp;(支付密码必须为6位数字，此密码也为电话订车密码。)</span>
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
