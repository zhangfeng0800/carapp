<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="TwicePay.aspx.cs" Inherits="WebApp.TwicePay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="/css/subpage.css" />
    <link href="/css/orderpay.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .payWay { }
    </style>
    <script type="text/javascript">
        function paystyle(str) {
            $(".show_t a").each(function () {
                $(this).removeClass("active");
            });
            $(".payWay").each(function () {
                $(this).hide();
            });
            $("#" + str).addClass("active");
            $("#" + str + "_div").show();
        }
        function showPay() {
            if ($("#showbalance").attr("checked") == "checked") {
                $("#payPasswordDiv").show();
                if (parseFloat($("#currentbalance").text()) >= parseFloat($("#paynum").text())) {
                    $("#bankcontainer").hide();
                    $("#shoudpaymoney").text("账户余额充足，请支付");
                    $("#shoudpaymoney").show();
                    $("#paybyaccount").show();
                } else {
                    $("#bankcontainer").show();
                    $("#shoudpaymoney").show();
                   // $("#shoudpaymoney").html("账户余额不足，请支付<span style=\"font-size:24px; color:red;font-weight:bold;\">" + (Math.abs(parseFloat($("#currentbalance").text()) - parseFloat($("#paynum").text()))).toFixed(2) + "</span>元");
                    $(".gray").html("(账户余额不足，需另付<span style=\"font-size:24px; color:red;font-weight:bold;\">" + (Math.abs(parseFloat($("#currentbalance").text()) - parseFloat($("#paynum").text()))).toFixed(2) + "</span>元)");
                    $("#paybyaccount").hide();
                }
            } else {
                $("#payPasswordDiv").hide();
                $("#paybyaccount").hide();
                $("#bankcontainer").show();
                $("#shoudpaymoney").text("");
                $(".gray").html("");
            }
        }
        $(function () {
            $("#shoudpaymoney").hide();
            $("#paybyaccount").hide();
            $("#yeepaySubmit").val("网上银行付款");
            $("#alipaySubmit").val("支付宝付款");
            $("#showbalance").removeAttr("checked");
        });
     
      
        function HandlePay(paytype) {
            switch (paytype) {
                case "balance":
                    {
                        SetFormValue("balance", "0");
                    }
                    break;
                case "yeepay":
                    {
                        var bankid = $("input[name='pd_FrpId']:checked").val();
                        if (typeof (bankid) == typeof (undefined)) {
                            alert("请选择银行");
                            return;
                        }
                        else {
                            SetFormValue("yeepay", bankid);
                        }
                    }
                    break;
                case "alipay":
                    {
                        SetFormValue("alipay", "0");
                    }
                    break;
                case "unionpay":
                    SetFormValue("unionpay", 0);
                    break;
                default:
            }
            $("#orderForm").submit();
        }
        function checkPayPassword(paytype) {
            if ($("#showbalance").prop("checked") == true) {
                if ($("#payPassword").val() == "") {
                    alert("请输入支付密码！");
                    return;
                }
                if (!$("#payPassword").val().match("\\d{6}")) {
                    alert("支付密码格式不正确！");
                    return;
                }
                $.ajax({
                    url: "api/checkPayPassword.ashx",
                    data: { "userid": "<%=userAccount.Id%>", "password": $("#payPassword").val() },
                    async: false,
                    success: function (data) {
                        if (data == "1") {
                            HandlePay(paytype);
                            return;
                        }
                        if (data == "2") {
                            if (confirm("您还没有修改支付密码！是否去个人中心修改？")) {
                                window.location.href = "/PCenter/AddPayPassword.aspx?orderid=<%=order.orderId%>&type=2";
                            }
                            return;
                        }
                        else {
                            alert("支付密码不正确，请重新输入.");
                            return;
                        }
                    }
                });
            } else {
                HandlePay(paytype);
            }
        }
        function SetFormValue(payType, bankid) {
            $("#orderForm input[name='payType']").val(payType);
            $("#orderForm input[name='bankid']").val(bankid);
            if ($("#showbalance").prop("checked") == true) {
                $("#orderForm input[name='ifbalance']").val("1");
            }
            else {
                $("#orderForm input[name='ifbalance']").val("0");
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="dc-process clearfix">
        <div class="zhifu-info">
            <ul class="text-ul text-ul-ot clearfix">
                <li><strong>订单编号：</strong><%=order.orderId %></li>
                <li><strong>乘车人：</strong><%=order.passengerName %></li>
                <li><strong>乘车人电话：</strong><%=order.passengerPhone %></li>
                <!--li><strong>预付费用：</strong><%=order.orderMoney %></li>
                <li><strong>订单总额：</strong><%=order.totalMoney %></li-->
                <br />
                <li><strong>超时费用：</strong><%=orderExt.overMinutMoney %>元</li>
                <li><strong>超公里费用：</strong><%=orderExt.overKMMoney %>元</li>
                <li><strong>高速费：</strong><%=orderExt.highwayMoney %>元</li>
                <li><strong>停车费：</strong><%=orderExt.carStopMoney %>元</li>
                <li><strong>机场费：</strong><%=orderExt.airportMoney %>元</li>
                <li><strong>空驶费：</strong><%=orderExt.emptyCarMoney %>元</li>
                <li class="price-total"><strong>二次支付总额共计：</strong> <em class="price" id="paynum">
                    <%=order.unpaidMoney %></em>元</li>
            </ul>
        </div>
        <div class="pay-yue" style="margin-bottom: 50px;">
            <input type="checkbox" id="showbalance" onclick="showPay()" />使用余额支付，账户余额 <em class="price"
                id="currentbalance">
                <%=objUser.Balance %></em>元。 <em id="shoudpaymoney">余额不足，请充值</em> <em style="color: Blue;
                    display: none" id="payPasswordDiv">请输入支付密码：<input type="password" id="payPassword" /></em>
            <div class="pay-yue pay-btn" id="paybyaccount">
                <button id="btntwicepay"  type="button"class="yc-btn" onclick="checkPayPassword('balance');">去支付</button>
            </div>
        </div>
        <div class="pay-yue" id="bankcontainer">
            <div class="recharge clearfix">
                <div class="ch_top">
                    <div class="f_l">
                        <span class="bold f16">网银支付</span><span class="gray" style="color:Black"></span></div>
                    <div class="clear">
                    </div>
                </div>
                <div class="ch_bank">
                    <div class="ch_left">
                        <div class="clear">
                        </div>
                        <div class="showpay">
                            <div class="show_t">
                                <%--<span>充值方式</span>--%>
                                <a id="unionpay" onclick='paystyle("unionpay")' class="active">
                                    银联在线支付</a>
                                <a id="yeepay" onclick='paystyle("yeepay")'>网上银行</a>
                                <a id="alipay" onclick='paystyle("alipay")'>支付宝</a>
                            </div>
                        </div>
                        <div id="unionpay_div" class="payWay" >
                            <img src="/images/bank/unionpay.jpg" alt="银联在线支付" /><br />
                            <hr class="dash" style="margin-top: 40px;" />
                            <div class="b_t" style="text-align: center;">
                                <input class="yc-btn" onclick='checkPayPassword("unionpay")' id="unionpaySubmit" style="text-align: center;
                                    cursor: pointer; margin-left: 300px;" value="银联在线支付" />
                            </div>
                        </div>
                        <!--网银暂空-->
                        <div id="yeepay_div" class="payWay" style="display: none;">
                            <ul>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_ICBC-NET-B2C" value="ICBC-NET-B2C" type="radio" />
                                        <img src="/images/bank/gongshang.gif" alt="中国工商银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CMBCHINA-NET-B2C" value="CMBCHINA-NET-B2C" type="radio" /><img
                                            src="/images/bank/zhaohang.gif" alt="招商银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_ABC-NET-B2C" value="ABC-NET-B2C" type="radio" />
                                        <img src="/images/bank/nongye.gif" alt="农业银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CCB-NET-B2C" value="CCB-NET-B2C" type="radio" />
                                        <img src="/images/bank/jianshe.gif" alt="建设银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_BCCB-NET-B2C" value="BCCB-NET-B2C" type="radio" />
                                        <img src="/images/bank/beijing.gif" alt="北京银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_BOCO-NET-B2C" value="BOCO-NET-B2C" type="radio" />
                                        <img src="/images/bank/jiaotong.gif" alt="交通银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CIB-NET-B2C" value="CIB-NET-B2C" type="radio" />
                                        <img src="/images/bank/xingye.gif" alt="兴业银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_NJCB-NET-B2C" value="NJCB-NET-B2C" type="radio" />
                                        <img src="/images/bank/nanjing.gif" alt="南京银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CMBC-NET-B2C" value="CMBC-NET-B2C" type="radio" />
                                        <img src="/images/bank/minsheng.gif" alt="中国民生银

行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CEB-NET-B2C" value="CEB-NET-B2C" type="radio" />
                                        <img src="/images/bank/guangda.gif" alt="广大银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_BOC-NET-B2C" value="BOC-NET-B2C" type="radio" />
                                        <img src="/images/bank/zhongguo.gif" alt="中国银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_PINGANBANK-NET" value="PINGANBANK-NET" type="radio" />
                                        <img src="/images/bank/pingan.gif" alt="平安银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CBHB-NET-B2C" value="CBHB-NET-B2C" type="radio" />
                                        <img src="/images/bank/buohai.gif" alt="渤海银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_HKBEA-NET-B2C" value="HKBEA-NET-B2C" type="radio" />
                                        <img src="/images/bank/dongya.gif" alt="东亚银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_NBCB-NET-B2C" value="NBCB-NET-B2C" type="radio" />
                                        <img src="/images/bank/ningbo.gif" alt="宁波银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_ECITIC-NET-B2C" value="ECITIC-NET-B2C" type="radio" />
                                        <img src="/images/bank/zhongxin.gif" alt="中信银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SDB-NET-B2C" value="SDB-NET-B2C" type="radio" />
                                        <img src="/images/bank/shenfa.gif" alt="深圳发展银行

" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_GDB-NET-B2C" value="GDB-NET-B2C" type="radio" />
                                        <img src="/images/bank/guangfa.gif" alt="广发银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SHB-NET-B2C" value="SHB-NET-B2C" type="radio" />
                                        <img src="/images/bank/shanghaibank.gif" alt="上海银

行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SPDB-NET-B2C" value="SPDB-NET-B2C" type="radio" />
                                        <img src="/images/bank/shangpufa.gif" alt="上海浦东

发展银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_POST-NET-B2C" value="POST-NET-B2C" type="radio" />
                                        <img src="/images/bank/youzheng.gif" alt="中国邮政" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_BJRCB-NET-B2C" value="BJRCB-NET-B2C" type="radio" />
                                        <img src="/images/bank/nongcunshangye.gif" alt="北京

农村商业银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CZ-NET-B2C" value="CZ-NET-B2C" type="radio" />
                                        <img src="/images/bank/zheshang.gif" alt="浙商银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_HZBANK-NET-B2C" value="HZBANK-NET-B2C" type="radio" />
                                        <img src="/images/bank/hangzhou.gif" alt="杭州银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SRCB-NET-B2C" value="SRCB-NET-B2C" type="radio" />
                                        <img src="/images/bank/shangnongshang.jpg" alt="上海

农商银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_NCBBANK-NET-B2C" value="NCBBANK-NET-B2C" type="radio" />
                                        <img src="/images/bank/nanyanbank.gif" alt="南洋商业

银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SCCB-NET-B2C" value="SCCB-NET-B2C" type="radio" />
                                        <img src="/images/bank/hebei.gif" alt="河北银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_ZJTLCB-NET-B2C" value="ZJTLCB-NET-B2C" type="radio" />
                                        <img src="/images/bank/tailong.gif" alt="泰隆银行" /></label></li>
                            </ul>
                            <div style="clear: both;">
                            </div>
                            <hr class="dash" style="margin-top: 20px;" />
                            <div class="b_t" style="margin-top: 40px; text-align: center;">
                                <input class="yc-btn" onclick='checkPayPassword("yeepay")' id="yeepaySubmit" style="margin-left: 300px;
                                    cursor: pointer;" value="网上银行付款" />
                            </div>
                        </div>
                        <div id="alipay_div" class="none payWay">
                            <img src="/images/bank/alipay.jpg" alt="支付宝" width="150px" height="50px" /><br />
                            <hr class="dash" style="margin-top: 40px;" />
                            <div class="b_t" style="text-align: center;">
                                <input class="yc-btn" onclick='checkPayPassword("alipay")' id="alipaySubmit" style="text-align: center;
                                    cursor: pointer; margin-left: 300px;" value="支付宝付款" />
                            </div>
                        </div>
                    </div>
                    <div class="ch_right">
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
        <div class="pay-yue pay-btn">
        </div>
    </div>
    <input type="hidden" id="orderId" value="" />
    <form id="orderForm" action="PC_HandleTwicePay.aspx" method="post">
    <input name="payType" type="hidden" />
    <input name="orderid" type="hidden" value="<%=order.orderId %>" />
    <input name="bankid" type="hidden" />
    <input name="ifbalance" type="hidden" />
    </form>
</asp:Content>
