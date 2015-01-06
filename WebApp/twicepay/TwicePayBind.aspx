<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TwicePayBind.aspx.cs" Inherits="WebApp.twicepay.TwicePayBind" %>

<!DOCTYPE html>
<html>
<head>
    <title>爱易租订单支付</title>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no"
        name="viewport" id="viewport" />
    <meta name="format-detection" content="telephone=no" />
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
            $("#paySubmit").attr("disabled", "disabled");
            $("#noPay").hide();
            $("#noEnough").hide();
            $("#noPwd").hide();
            $("#errorPwd").hide();
            $("#passtypeError").hide();
            $("#passtypeError").hide();
            if (!$('#selectBlance').attr("checked")) {
                if ($("[name='bank']:radio:checked").length == 0) {
                    $("#noPay").show();
                    return;
                }
                else {
                    $("#noPay").hide();
                    $("#bindid").val($("[name='bank']:radio:checked").val());
                    $("#paystyle").val('bindcard');
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
                    if (!$("[name='bank']:radio:checked").length==0) {
                        $("#bindid").val($("[name='bank']:radio:checked").val());
                        $("#paystyle").val('bindcard');
                    }
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
                        $("#paySubmit").removeAttr("disabled");
                    }
                    else if (data == "balanceNo") {
                        $("#noEnough").show();
                        $("#paySubmit").removeAttr("disabled");
                    }
                    else if (data == "payok") {
                     $("#bindCardForm").submit();
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $("#return").attr("href", "/twicepay/HandleTwicePay.aspx?orderId=" + $("#orderID").val());
            $.ajax({
                async: false,
                url: "/twicepay/twicePay.ashx",
                data: { "action": "getJson", "orderid": '<%=orderId %>' },
                type: "post",
                success: function (data) {
                    if (data.result == "error" || data.cardlist.length==0) {
                        window.location.href = "/twicepay/HandleTwicePay.aspx?orderId=" + $("#orderID").val();
                        return;
                    }
                    if (data.ordererror=="noid") {
                        window.location.href = "/twicepay/error.aspx";
                        return;
                    }
                    var cardname = [];
                    var bindids = [];
                    $.each(data.cardlist, function (index, val) {
                        cardname.push(val.card_name);
                        bindids.push(val.bindid);
                    });
                    for (var i = 0; i < bindids.length; i++) {
                        var html = "<label for='"+bindids[i]+"'><input  type='radio' name='bank'  id='"+bindids[i]+"' value='" + bindids[i] + "'/><span>" + cardname[i] + "</span></label></br>";
                        $("#bankList").append(html);
                    }
                }
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="menu">
        <h3 class="til">
            爱易租订单支付</h3>
    </div>
    <div class="content">
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
            超小时数：<span class="price"><%=orderExt.overMinut/60%>小时<%=orderExt.overMinut%60%>分</span>
        </div>
        <div class="jiesu">
            超时费用：<span class="price"><%=orderExt.overMinutMoney %></span>
        </div>
        <div class="jiesu">
            超公里数：<span class="price"><%=orderExt.overKM %>公里</span>
        </div>
        <div class="jiesu">
           超公里费用 ：<span class="price"><%=orderExt.overKMMoney %>元</span>
        </div>
        <div class="jiesu">
            高速费：<span class="price"><%=orderExt.highwayMoney %>元</span>
        </div>
        <div class="jiesu">
           停车费 ：<span class="price"><%=orderExt.carStopMoney %>元</span>
        </div>
        <div class="jiesu">
            机场费：<span class="price"><%=orderExt.airportMoney %>元</span>
        </div>
        <div class="jiesu">
            空驶费：<span class="price"><%=orderExt.emptyCarMoney %>元</span>
        </div>
        <div class="jiesu">
            下单人姓名：<span runat="server" id="member"></span>
        </div>
        <div class="jiesu">
            乘车人姓名：<span runat="server" id="passenger"></span>
        </div>
        <div style="margin-bottom: 15px; margin-left:10px;">
            <label for="selectBlance">
                <input type="checkbox" id="selectBlance" />使用账户余额支付（<span id="blance" runat="server"
                    class="price"></span>）</label><br />
            <div class="jiesu" style="margin-top: 15px; display: none;" id="pwd">
                <label>
                    支付密码：<input type="password" id="userPwd" /></label></div>
        </div>
        <div>
            <span class="price" style="color:#330017;">使用绑定的银行卡一键支付</span>
            <div id="bankList" style="margin-top: 20px; font-size:14px;">
            </div>
            <a  id="return" class="price" style="display:inline-block; margin-top:20px;">不使用银行卡绑定支付?</a>
        </div>
        <div style="margin-top: 15px;">
            <label id="noPay" class="price" style="display: none;">
                请选择支付方式</label>
            <label id="noEnough" class="price" style="display: none;">
                账户余额不足，请选用以上方式充值</label>
            <label id="noPwd" class="price" style="display: none;">
                请输入支付密码</label>
                   <label id="passtypeError" class="price" style="display: none;">
               支付密码格式错误</label>
            <label id="errorPwd" class="price" style="display: none;">
                支付密码错误</label>
        </div>
    </div>
    </form>
    <form id="bindCardForm" action="/twicepay/HandleTwicePay.aspx" method="post">
    <input name="orderID" id="orderID" type="hidden" value='<%=orderId %>'/>
    <input name="paystyle" id="paystyle" type="hidden" />
    <input name="IsUse" id="IsUse" type="hidden"/>
    <input name="handlePay" id="handlePay" value="twicepay" type="hidden"/>
    <input name="userPassword" id="userPassword" type="hidden" />
    <input name="bindid" id="bindid" type="hidden"/>
</form>
    <div class="button">
        <input type="button" id="paySubmit" value="确认支付" class="btn" onclick="paySubmit()" style="width: 100%" />
    </div>
</body>
</html>
