<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyCouponGet.aspx.cs" Inherits="WebApp.PCenter.MyCouponGet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#A_Submit").click(function () {
                if ($("#Text_SN").val().Trim() == "") {
                    alert("请输入序列号");
                    return;
                }
                $.post("MyCouponGet.aspx", {
                    Action: "Get",
                    SN: $("#Text_SN").val().Trim()
                }, function (data) {
                    if (data.Message == "Complete") {
                        if (confirm("优惠券兑换成功，是否继续兑换？"))
                            $("#Text_SN").val("");
                        else
                            window.location.href = "MyCoupon.aspx";
                    } else {
                        alert(data.Message);
                        $("#Text_SN").val("");
                    }
                });
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server"> 
	<h3 class="per-line-til">
		优惠券
	</h3>
	<div class="per-line-bg">
		<ul class="per-ul">
			<li><span class="per-name-style">序列号</span>
            <input type="text" class="per-input" id="Text_SN" name="rechargeMo"/></li>
			<li class="per-button-padding">
            <input class="yc-btn bank-btn per-button-border"  style="margin-left:90px;" id="A_Submit" type="button" value="兑换"/>
            </li>
		</ul>		
	</div>
</asp:Content>
