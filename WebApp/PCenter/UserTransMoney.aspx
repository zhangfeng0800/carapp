<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="UserTransMoney.aspx.cs" Inherits="WebApp.PCenter.UserTransMoney" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="per-order-til">
        用户转账</h3>
     <div class="person-tab-order" style=" height:170px;">
       	<ul class="per-ul">
        	<li><span class="per-name-style">账户手机</span><input class="per-input" type="text" id="telphone" name="telphone" onblur="changeTel()" />&nbsp;&nbsp;<span  id="stip"></span></li>
            <li><span class="per-name-style">金额</span>  <input class="per-input" type="text" id="money" name="money" onkeyup="clearNoNum(this)" maxlength="8" /></li>
            <li><span class="per-name-style">支付密码</span> <input class="per-input" type="password" id="paypwd" name="paypwd"  /></li>
</ul>
        <input class="yc-btn bank-btn per-button-border"  style="margin-left:90px; margin-top:10px;" id="A_Submit" type="button" value="确认转账"/>
       
    </div>

    <script type="text/javascript">
        function changeTel() {
            if ($("#telphone").val().trim() == "") {
                alert("账户不能为空");
                return;
            }
            $.post("api/TransHandler.ashx", { "action": "usertransmoney", "telphone": $("#telphone").val() }, function (data) {
                if (data.StatusCode == 1) {
                    $("#stip").html("真实姓名：" + data.Data);
                }
                else {
                    $("#stip").html(data.Message);
                }
            }, "json");
        }
        function clearNoNum(obj) {
            if (/^\d+\.?\d{0,2}$/.test(obj.value)) {
                obj.value = obj.value;
            }
            else {
                obj.value = obj.value.substring(0, obj.value.length - 1);
            }
        }
        $(function () {
            $("#A_Submit").click(function () {
                if ($("#telphone").val().trim() == "") {
                    alert("账户不能为空");
                    return;
                }
                if ($("#money").val().trim() == "") {
                    alert("金额不能为空");
                    return;
                }
                if ($("#paypwd").val().trim() == "") {
                    alert("支付密码不能为空");
                    return;
                }
                $.post("api/TransHandler.ashx", { "action": "transmoney", "telphone": $("#telphone").val(), "money": $("#money").val(), "paypwd": $("#paypwd").val() }, function (data) {
                    if (data.StatusCode == 1) {
                        alert("恭喜，转账成功");
                        window.location.href = "MyAccount.aspx";
                    }
                    else {
                        alert(data.Message);
                    }
                }, "json");
            });
        });
    </script>
</asp:Content>
