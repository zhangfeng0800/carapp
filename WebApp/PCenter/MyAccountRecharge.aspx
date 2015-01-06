<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyAccountRecharge.aspx.cs" Inherits="WebApp.PCenter.MyAccountRecharge" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function submitForm() {
            if (!Check())
                return false;
            $.ajax({
                url: "/api/generaterechargenum.ashx",
                type: "post",
                data: {
                    rechargeMo: $("#rechargeMo").val()
                },
                success: function (data) {
                    if (data.CodeId == 0) {
                        alert("充值单号生成失败，请重试！");
                        return;
                    }
                    $("#txtRechargeId").val(data.RechargeId);
                    $("#rechargeForm").submit();
                }
            });
        }
        function Check() {
            if ($("input[name='rechargeMo']").val().Trim() == "") {
                alert("请输入要充值的金额！");
                $("input[name='rechargeMo']").focus();
                return false;
            }
            if (parseInt($("input[name='rechargeMo']").val().Trim()) < 1) {
                alert("充值数不可小于1元！");
                $("input[name='rechargeMo']").focus();
                return false;
            }
            if (isNaN($("input[name='rechargeMo']").val().Trim())) {
                alert("请用数字输入要充值的金额！");
                $("input[name='rechargeMo']").val("");
                $("input[name='rechargeMo']").focus();
                return false;
            }
            if ($("input[name='rechargeMo']").val().Trim().length > 8) {
                alert("请输入正确的金额！");
                $("input[name='rechargeMo']").val("");
                $("input[name='rechargeMo']").focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">    
	<h3 class="per-line-til">
		在线充值
	</h3>
	<div class="per-line-bg">
        <form action="/recharge.aspx" method="post" id="rechargeForm">
		<ul class="per-ul">
			<li><span class="per-name-style">充值金额</span>
            <input type="text" class="per-input" name="rechargeMo" value="" onkeyup="value=value.replace(/\D/g,'')" id="rechargeMo" /><input type="hidden" value="<%=userAccount.Id %>" name="userId" />
             <input type="hidden" name="txtRechargeId" id="txtRechargeId" /></li>
			<li class="per-button-padding"><input class="yc-btn bank-btn per-button-border" id="Submit_Recharge" onclick="submitForm()" type="button" value="充值"/></li>
		</ul>
        </form>			
	</div>
</asp:Content>
