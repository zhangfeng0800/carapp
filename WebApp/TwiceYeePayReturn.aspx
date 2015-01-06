<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true" CodeBehind="TwiceYeePayReturn.aspx.cs" Inherits="WebApp.TwiceYeePayReturn" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 <link rel="stylesheet" type="text/css" href="css/public.css"/>
<link rel="stylesheet" type="text/css" href="css/subpage.css"/>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="sub-banner">
	<a class="sub-banner-a" href="" style="background:url(images/001_02.jpg) no-repeat 50% 0;">爱易租</a>
</div>
<div class="dc-process clearfix">
	<div class="pay-ok">
		<p class="pay-text">
		<span id="tip">订单二次付款成功！</span>
		</p>
		<p>
        <span id="orderTip">支付成功！</span>
		</p>
		<p>
			<span id="payType"></span><strong class="order-text"><span runat="server" id="orderNum">订单号：<%=orderID%></span></strong>
		</p>
        <p style="color:Olive"><a href="PCenter/MyAccount.aspx">返回个人中心</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="Default.aspx">返回首页</a></p>
		<p class="clearfix">
		</p>
	</div>
</div>
</asp:Content>
