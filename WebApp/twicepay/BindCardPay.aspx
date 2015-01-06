<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BindCardPay.aspx.cs" Inherits="WebApp.twicepay.BindCardPay" %>

<!DOCTYPE html>
<html>
<head>
    <title>爱易租订单支付</title>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no" name="viewport" id="viewport" /><meta name="format-detection" content="telephone=no"/>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
 <script src="../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
 <script type="text/javascript">
     function btnSubmit() {
         $("#noCode").hide();
         $("#codeError").hide();
         if ($("#code").val() == "") {
             $("#noCode").show();
         }
         else {
             $("#submitLoading").show();
             $("#checkCode").val($("#code").val());
             $("#twicepayForm").submit();
         }
     }
 </script>
</head>
<body>
    <form id="form1" runat="server">
            <div class="menu">
        <h3 class="til">
            爱易租订单支付</h3>
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
			未付总额：<span class="price" id="unpaidMo" runat="server"></span>
		</div>
		<div class="jiesu">
			下单人姓名：<span runat="server" id="member"></span>
		</div>
		<div class="jiesu">
			乘车人姓名：<span runat="server" id="passenger"></span>
		</div>
        <div>
        <h2 style="margin-bottom:20px;">请输入短信校验码</h2>
        <input type="text" id="code" style="width:120px; height:30px; border:1px solid #A5A5A5;" />
        </div>
        <div style="margin-top:15px;">
        <label id="noCode" class="price" style="display:none;" >请输入短信校验码</label><br />
        <label id="codeError" class="price" runat="server" style="display:none;">您输入的短信校验码错误，请重新输入！</label>
        </div>
      </div>
    </form>
  <form id="twicepayForm" action="/twicepay/BindCardPay.aspx" method="post">
  <input id="order" name="order" value='<%=order %>' type="hidden"/>
   <input type="hidden" id="checkCode" name="checkCode"/>
  </form>
    <div class="button" style="margin-top:15px;">
                    <span style="border: 1px solid #ccc; padding: 1px 10px; display: none;" id="submitLoading" runat="server">
                    <img width="20" height="20" src="/images/loading_s.gif">
                    系统正在处理订单，请稍候！ </span>
    <input type="button" id="paySubmit"  value="确认支付" class="btn" onclick="btnSubmit()" style="width:100%"/>
    </div>
</body>
</html>
