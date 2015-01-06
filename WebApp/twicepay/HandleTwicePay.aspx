<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HandleTwicePay.aspx.cs" Inherits="WebApp.twicepay.HandleTwicePay" %>
<!DOCTYPE html>
<html>
<head>
<title>爱易租订单支付</title>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no" name="viewport" id="viewport" /><meta name="format-detection" content="telephone=no"/>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
 <script src="../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        var useBalance;
        $(function () {
            $("#selectBlance").attr("checked", false);
            $('#selectBlance').click(function () {
                if ($('#selectBlance').attr("checked")) {
                    $("#pwd").show();
                }
                else {
                    $("#pwd").hide();
                }
            });
        });
        function paySubmit() {
            $("#noPay").hide();
            $("#noEnough").hide();
            $("#noPwd").hide();
            $("#errorPwd").hide();
            $("#passtypeError").hide();
            if (!$('#selectBlance').attr("checked")) {
                if ($("[name='pay']:radio:checked").length == 0) {
                    $("#noPay").show();
                    return;
                }
                else {
                    $("#noPay").hide();
                    $("#paystyle").val($("[name='pay']:radio:checked").val());
                    useBalance = "notuse";
                }
            }
            else {
                if ($("#userPwd").val() == "") {
                    $("#noPwd").show();
                    $("#paySubmit").removeAttr("disabled");
                    return;
                }
                if (!$("#userPwd").val().match("\\d{6}")) {
                    $("#passtypeError").show();
                    $("#paySubmit").removeAttr("disabled");
                    return;
                }
                else {
                    useBalance = "use";
                    $("#paystyle").val($("[name='pay']:radio:checked").val());
                }
            }
            $("#IsUse").val(useBalance);
            $("#userPassword").val($("#userPwd").val());
            $.ajax({
                url: "/twicepay/bindCards.ashx",
                type: "post",
                data: { handlePay: "twicepay", IsUse: useBalance, userPwd: $("#userPwd").val(), orderId: $("#orderID").val(), paystyle: $("#paystyle").val() },
                success: function (data) {
                    if (data == "pwdError") {
                        $("#errorPwd").show();
                    }
                    else if (data == "balanceNo") {
                        $("#noEnough").show();
                    }
                    else {
                        $("#twicepayForm").submit();
                    }
                }
            });
        }
    </script>
</head>
<body>

    <form id="form1" runat="server">
            <div class="menu">
        <h3 class="til">
            爱易租订单支付</h3>
    </div>
    <div class="content" style="padding-left:10px;">
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
        <div style="margin-bottom:15px;">
        <label for="selectBlance"><input type="checkbox" id="selectBlance"/>使用账户余额支付（<span id="blance" runat="server" class="price"></span>）</label><br />
        <div class="jiesu" style="margin-top:15px; display:none;" id="pwd">
        <label>支付密码：<input type="password" id="userPwd"/></label></div>  
        </div>
        <div class="jiesu" style=" height:auto; padding:8px 0;">
        <label for="alipay"><input style=" width:15px;"  type="radio" value="alipay" name="pay" id="alipay"/><span class="alipay">支付宝</span></label>&nbsp;<span style="color:Red;font-size:12px;">包含信用卡和储蓄卡支付</span>
        </div>
        <div class="jiesu" style=" height:auto; padding:8px 0;">
       <label for="upmpay"><input  style=" width:15px;" type="radio" value="upmpay" name="pay" id="upmpay" /><span class="alipay Unionpay">银联支付</span></label><span style="color:Red;font-size:12px;">需要下载支付控件，支付更安全！</span>
        </div>
        <div class="jiesu" style=" height:auto; padding:8px 0;">
       <label for="creditpay"><input style=" width:15px;"  type="radio" value="creditpay" name="pay" id="creditpay" /><span class="alipay credit">信用卡</span></label>&nbsp;<span style="color:Red;font-size: 12px;">暂不支持农行、交行</span>
        </div>
        <div class="jiesu" style=" height:auto; padding:8px 0;">
       <label for="debitpay"><input  style=" width:15px;" type="radio" value="debitpay" name="pay" id="debitpay" /><span class="alipay Unionpay">储蓄卡</span></label>&nbsp;<span style="color:Red;font-size: 12px;">暂不支持工行、邮政、交行限广东</span>
        </div>
        
        <%--<div class="zhifubao">
        <div class="paytype"><img src="/images/bank/alipay.jpg" alt="支付宝"  width="180px" height="55px"/><br /><input type="radio" value="alipay" name="pay" /></div>
        <div class="paytype"><img src="" alt="信用卡支付" /><br /><input type="radio" value="creditpay" name="pay" /></div>	
        <div class="paytype"><img src="" alt="储蓄卡支付" /><br /><input type="radio" value="debitpay" name="pay" /></div>
		</div>--%>
        <div style="margin-top:15px;">
        <label id="noPay" class="price" style="display:none;" >请选择支付方式</label>
        <label id="noEnough" class="price" style="display:none;">账户余额不足，请选用以上方式充值</label>
        <label id="noPwd" class="price" style="display:none;">请输入支付密码</label>
            <label id="passtypeError" class="price" style="display: none;">
               支付密码格式错误</label>
        <label id="errorPwd" class="price" style="display:none;">支付密码错误</label>
        </div>
	</div>
  </form>
  <form id="twicepayForm" action="/twicepay/HandleTwicePay.aspx" method="post">
      <input name="orderID" id="orderID"  type="hidden" value='<%=orderId %>'/>
      <input name="paystyle" id="paystyle" type="hidden" />
      <input name="IsUse" id="IsUse" type="hidden" />
      <input name="handlePay" id="handlePay" value="twicepay" type="hidden" />
      <input name="userPassword" id="userPassword" type="hidden" />
  </form>
    <div class="button">
    <input type="button" id="paySubmit"  value="确认支付" class="btn" onclick="paySubmit()" style="width:100%"/>
    </div>


</body>
</html>
