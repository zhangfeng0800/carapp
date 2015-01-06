<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="AddPayPassword.aspx.cs" Inherits="WebApp.PCenter.AddPayPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript">
    $(document).ready(function () {
        $("input[value='提交']").click(function () {
            if (!Check())
                return false;
            var orderid = GetQueryString("orderid");
            if (orderid != "0") {
                $("a").attr("href","#");
            }
            $.post("AddPayPassword.aspx", {
                action: "SubmitNewPW",
                newPW: $("#newPW").val(),
                confirmPW: $("#confirmPW").val()
            }, function (data) {
                if (data.Message == "Success") {
                    alert("支付密码设置成功！");
                    var type = GetQueryString("type");
                    if (orderid == "0") {
                        window.location.href = 'MyAccount.aspx';
                    }
                    else {
                        if (type == "1") {
                            $("#Form_GoToPay").submit();
                        }
                        else {
                            window.location.href = "twicepay.aspx?orderid=" + $("input[name='orderId']").val();
                        }
                    }
                }
                else
                    alert(data.Message);
            }, "json");
        });
    });
    function Check() {
        if ($("#newPW").val() == "") {
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
                设置支付密码</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <%if (Request.QueryString["orderid"] != null){ %>
                <p class="P_Hint" style="clear:both">
                <em>友情提示：</em>如果您正在支付过程中，请直接设置密码，然后点击“提交”按钮，即可继续支付。
                </p>
                <form id="Form_GoToPay" action="../payorder.aspx" method="post">
                <input type="hidden" name="orderId" value="<%=Request.QueryString["orderid"] %>" />
                </form>
                <%}else{ %>
                <p class="P_Hint" style="clear:both; font-size:12px;">
                <em>友情提示：</em>系统检测到您没有设置账户支付密码，请您务必先设置支付密码，方可进行其他操作。支付密码必须为6位数字，此密码也为电话订车密码。
                </p>
                <%} %>
                <ul class="per-ul">
                    <li>
                        <span class="per-name-style" style="width: 100px;"><span class="Span_Hint">*</span>设置支付密码：</span>
                        <input type="password" id="newPW" /><span style="color:#f00">&nbsp;(支付密码必须为6位数字，此密码也为电话订车密码。)</span>
                    </li>
                    <li>
                        <span class="per-name-style" style="width: 100px;"><span class="Span_Hint">*</span>确认支付密码：</span>
                        <input type="password" id="confirmPW" />
                    </li>
                    <li class="per-button-padding">
                        <input class="yc-btn bank-btn per-button-border" type="button" value="提交"/>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>
