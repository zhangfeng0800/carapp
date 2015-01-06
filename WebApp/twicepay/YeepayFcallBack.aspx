<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="YeepayFcallBack.aspx.cs" Inherits="WebApp.twicepay.YeepayFcallBack" %>

<!DOCTYPE html>
<html>
<head>
    <title>爱易租订单支付成功</title>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no" name="viewport" id="viewport" /><meta name="format-detection" content="telephone=no"/>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
 <script src="../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
                <div class="menu">
        <h3 class="til">
            爱易租订单支付成功</h3>
    </div>
    <div class="content">
	<%--	<h3 class="til">订单支付</h3>--%>
		<div class="jiesu">
			付款状态：<span id="payStatus" runat="server"></span>
		</div>
		<div class="jiesu">
			订单总额：<span class="price" runat="server" id="totalFee"></span>
		</div>
		<div class="jiesu">
			下单人姓名：<span runat="server" id="member"></span>
		</div>
		<div class="jiesu">
			乘车人姓名：<span runat="server" id="passenger"></span>
		</div>
		<div class="pay-end">
			支付成功！
            <p style="margin-top:10px;">谢谢乘车，本次服务完成！</p>
		</div>

	</div>
    </form>
</body>
</html>
