<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="payorder.aspx.cs" Inherits="WebApp.payorder" %>

<%@ Import Namespace="BLL" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>爱易租 租车新生活</title>
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <link rel="stylesheet" type="text/css" href="css/public.css" />
    <link rel="stylesheet" type="text/css" href="css/subpage.css" />
    <link href="css/orderpay.css" rel="stylesheet" type="text/css" />
    <!--[if IE 6]>
  <script type="text/javascript" src="js/png.js"></script>
  <script type="text/javascript" src="js/fixpng.js"></script>
<![endif]-->
    <script type="text/javascript" src="js/jquery-1.8.0.min.js"></script>
    <script type="text/javascript">
        function paystyle(str) {
            var BCpay = document.getElementById("BCpay");
            var alipay = document.getElementById("alipay");
            var unionpay = document.getElementById("unionpay");
            var alipay_div = document.getElementById("alipay_div");
            var yeepay_div = document.getElementById("yeepay_div");
            var unionpay_div = document.getElementById("unionpay_div");
            if (str == "BCpay") {
                BCpay.className = "active";
                alipay_div.style.display = "none";
                alipay.className = "";
                unionpay.className = "";
                unionpay_div.style.display = "none";
                yeepay_div.style.display = "block";
            }
            else if (str == "unionpay") {
                unionpay.className = "active";
                unionpay_div.style.display = "block";
                BCpay.className = "";
                yeepay_div.style.display = "none";
                alipay.className = "";
                alipay_div.style.display = "none";
            }
            else {
                alipay.className = "active";
                alipay_div.style.display = "block";
                BCpay.className = "";
                yeepay_div.style.display = "none";
                unionpay.className = "";
                unionpay_div.style.display = "none";
            }
        }
        function AddFavorite(title, url) {
            try {
                window.external.addFavorite(url, title);
            }
            catch (e) {
                try {
                    window.sidebar.addPanel(title, url, "");
                }
                catch (e) {
                    alert("抱歉，您所使用的浏览器无法完成此操作。\n\n加入收藏失败，请使用Ctrl+D进行添加");
                }
            }
        }
    </script>
    <script type="text/javascript">
        function isInt(str) {
            var result = str.match(/^(0|([1-9]\d*))$/);
            if (result == null) return false;
            return true;
        }
        function SubmittoServer() {
            var data = {
                orderId: $("#orderId").val()
            };
            $.ajax({
                url: "/api/paybyaccount.ashx",
                type: "post",
                data: data,
                success: function (data) {  
                
                    if (data.StatusCode == 0) {
                     
                        if (data.Message == "ap") {
                            alert("此订单已经付款");
                            window.location.href = "/pcenter/myorders.aspx";
                        } else if (data.Message == "noid") {
                            alert("没有此订单号！");
                            return;
                        } else if (data.Message == "expire") {
                            alert("订单无效");
                            return;
                        }else if (data.Message=="statusError") {
                        alert("订单过期！");
                        window.location.href="/pcenter/myorders.aspx";
                        } else {
                            alert("支付失败");
                            return;
                        }
                      
                    } else {
                        alert("支付成功");
                        window.location.href = "/AccountpaySuccess.aspx?orderid=" + data.Data;
                    }
                },
                complete: function() {
                    $("#btngotopay").removeAttr("disabled");
                },
                beforeSend: function() {
                      $("#btngotopay").attr("disabled","disabled");
                }
            });
        }

        function HandlePay(str) {
            $.ajax({
                url: "/api/checkorderstatus.ashx",
                type: "post",
                data: { orderid: $("#orderId").val() },
                beforeSend: function () {
                    if (str == "yeepay") {
                        $("#yeepaySubmit").val("订单提交中");
                        $("#yeepaySubmit").attr("disabled", "disabled");
                    }
                    else if (str == "unionpay") {
                        $("#unionpaySubmit").val("订单提交中");
                        $("#unionpaySubmit").attr("disabled", "disabled");
                    }
                    else {
                        $("#alipaySubmit").val("订单提交中");
                        $("#alipaySubmit").attr("disabled", "disabled");
                    }
                },
                success: function (data) {
                    if (data.CodeId == 0) {
                        alert(data.Message);
                        window.location.href = data.location;
                        return;
                    } else if (data.CodeId == 1) {
                        if (str == "yeepay") {
                            if ($("[name='pd_FrpId']:radio:checked").length == 0) {
                                alert("请先选择银行");
                                return;
                            } else {
                                $("#wgId").val($('input[name="pd_FrpId"]:checked').val());
                            }
                        }
                        $("#payType").val(str);
                        $("#orderpay").val('<%=order %>');
                        if ($("#showbalance").attr("checked") == "checked") {
                            $("#addMo").val("Y");
                        } else {
                            $("#addMo").val("N");
                        }
                        if (str == "yeepay") {
                            $("#yeepaySubmit").val("订单提交成功");
                            $("#yeepaySubmit").removeAttr("disabled");
                        } else {
                            $("#alipaySubmit").val("订单提交成功");
                            $("#alipaySubmit").removeAttr("disabled");
                        }
                        $("#orderForm").submit();
                    } else {
                        alert(data.Message);
                    }
                }, complete: function () {
                    if (str == "yeepay") {
                        $("#yeepaySubmit").val("网上银行付款");
                        $("#yeepaySubmit").removeAttr("disabled");
                    }
                    else if (str == "unionpay") {
                        $("#yeepaySubmit").val("银联在线支付");
                        $("#yeepaySubmit").removeAttr("disabled");
                    }
                    else {
                        $("#alipaySubmit").val("支付宝付款");
                        $("#alipaySubmit").removeAttr("disabled");
                    }
                }
            });

        }
        function checkPayPassword(type) {
            if ($("#showbalance").attr("checked") == "checked") {
                if ($("#payPassword").val() == "") {
                    alert("请输入支付密码！");
                    return false;
                }
                if (!$("#payPassword").val().match("\\d{6}")) {
                    alert("支付密码格式不正确！");
                    return false;
                }
                else {
                    $.ajax({
                        url: "api/checkPayPassword.ashx",
                        data: { "userid": "<%=userAccount.Id%>", "password": $("#payPassword").val() }, 
                        beforeSend: function() {
                            $("#btngotopay").attr("disabled","disabled");
                        },
                        success: function (data) {
                            if (data == "1") {
                                 if (type=="balance") {
                                      SubmittoServer();
                                      
                                   }
                                  else {
                                    HandlePay(type);
                                    $("#btngotopay").removeAttr("disabled");
                                  }
                                return true;
                            }
                            else {
                                if (data == "2") {
                                    if (confirm("您还没有修改支付密码！是否去个人中心设置？")) {
                                        window.location.href = "/PCenter/AddPayPassword.aspx?orderid=<%= Session["orderid"].ToString() %>&type=1";
                                    } else {
                                          $("#btngotopay").removeAttr("disabled");
                                    }
                                }
                                else {
                                    alert("支付密码不正确，请重新输入.");
                                    $("#btngotopay").removeAttr("disabled");
                                }
                                return false;
                            }
                        } 
                    });
                }
            }
            else {
               HandlePay(type);
            }
        }
        function showPay() {
            if ($("#showbalance").attr("checked") == "checked") {
                $("#payPassword_text").show();
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
                $("#payPassword_text").hide();
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
             $("#btngotopay").show();
        });
    </script>
    <script type="text/javascript">
        function loginOut() {
            $.ajax({
                url: "/api/loginout.ashx",
                success: function (data) {
                    window.location.href = data.Location;
                }
            });
        }
    </script>
</head>
<body>
    <div class="headbar">
        <div class="headbar_con clearfix">
            <div class="bar-left">
                您好&nbsp;<a href="/PCenter/MyAccount.aspx"><%=Username %></a>&nbsp;，欢迎光临爱易租！
                <%
                    Response.Write(IsLogined == 0 ? "<a href=\"/Login.aspx\" id=\"login\">请登录</a> <a id=\"register\" href=\"/Register.aspx\">免费注册</a>" : "<a style=\"cursor:pointer\" herf=\"javascript:void(0);\" onclick=\"loginOut()\">退出</a>");
                %>
            </div>
            <div class="bar-right">
                <a href="/PCenter/MyOrders.aspx">我的订单</a> <a href="/PCenter/MyAccount.aspx">我的爱易租</a>
                <a href="/article.aspx?id=61&typeid=29">帮助中心</a> <a href="javascript:;" onclick="AddFavorite('爱易租',location.href)">
                    收藏本站</a> <a href="http://m.iezu.cn">手机版</a> <a href="http://www.iezu.cn/app/iezu_android.apk">
                        安卓客户端</a>
            </div>
        </div>
    </div>
    <div class="head">
        <div class="head-con">
            <h1 class="logo">
                <a href="/">
                    <img src="images/logo.jpg" alt="爱易租——返回首页" title="爱易租——返回首页" /></a>
            </h1>
            <div class="nav">
                <ul>
                    <li><a href="/Default.aspx">首页</a></li>
                    <li><a href="/SelectWay.aspx">在线订车</a></li>
                    <li><a href="/DailyRent.aspx?wayid=1">接机</a></li>
                    <li><a href="/DailyRent.aspx?wayid=2">送机</a></li>
                    <li><a href="/DailyRent.aspx?wayid=3">时租</a></li>
                    <li><a href="/DailyRent.aspx?wayid=4">日租</a></li>
                    <li><a href="/DailyRent.aspx?wayid=5">半日租</a></li>
                    <li><a href="/hotline.aspx">热门线路</a></li>
                    <li><a href="/travel.aspx">爱旅游</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 

50% 0;">爱易租</a>
    </div>
    <div class="dc-process clearfix">
        <div class="zhifu-info">
            <ul class="text-ul text-ul-ot clearfix">
                <li><strong>用车方式：</strong>
                    <%=useway %></li>
                <li><strong>用车地点：</strong>
                    <%=startplace %></li>
                <li><strong>用车时间：</strong>
                    <%=startDate %></li>
                <li><strong>到达地点：</strong>
                    <%=endplace %></li>
                <li class="price-total"><strong>订单费用：</strong> <em class="price" id="paynum">
                    <%=Math.Round(double.Parse(startprice),2) %></em>元</li>
            </ul>
        </div>
        <div class="pay-yue" style="margin-bottom: 50px;">
            <input type="checkbox" id="showbalance" onclick="showPay()" />使用余额支付，账户余额 <em class="price"
                id="currentbalance">
                <%=Math.Round(double.Parse(balance), 2)%></em>元。
            <%--<em id="shoudpaymoney">余额不足，请充值</em>--%>
            <em id="payPassword_text" style="color: red; display: none">请输入六位账户支付密码:<input type="password"
                id="payPassword" /></em>
            <div class="pay-yue pay-btn" id="paybyaccount">
                <input class="yc-btn" href="javascript:;" onclick="checkPayPassword('balance')" type="button"
                    value="去支付" id="btngotopay" />
            </div>
        </div>
        <div class="pay-yue" id="bankcontainer">
            <div class="recharge clearfix">
                <div class="ch_top">
                    <div class="f_l">
                        <span class="bold f16">网银支付&nbsp;&nbsp;&nbsp;</span><span class="gray" style="color: Black"></span></div>
                    <div class="clear">
                    </div>
                </div>
                <div class="ch_bank">
                    <div class="ch_left">
                        <%--  <span class="tip none" id="userNone" runat="server">您的账户没有可 支付余额，请使用以下其他方式充值</span>
                        <span class="tip none" id="companyNone" runat="server">您的集团账户 没有可支付余额，请使用以下其他方式充值</span>--%>
                        <%--   <label id="lblAccount" runat="server" class="none">
                            <input type="checkbox" id="useAccount" />使用账户余额（可支付金 额<span id="accountMo" runat="server"></span></label><span
                                class="tip none" style="margin-left: 8px;" id="userNotenough" runat="server">您的账户余额已不足支付本订单，请选择以下方式充值
                            </span><span class="tip none" style="margin-left: 8px;" id="comNotenough" runat="server">
                                您的集团账户余额已不足支付本订单，请选择以下方式充值 </span>--%>
                        <div class="clear">
                        </div>
                        <div class="showpay">
                            <div class="show_t">
                                <%--<span>充值方式</span>--%>
                                <a id="unionpay" onclick='paystyle("unionpay")' class="active">银联在线支付</a> <a id="BCpay"
                                    onclick='paystyle("BCpay")'>网上银行</a> <a id="alipay" onclick='paystyle("alipay")'>支付宝</a>
                            </div>
                        </div>
                        <div id="unionpay_div">
                            <img src="/images/bank/unionpay.jpg" alt="银联在线支付" /><br />
                            <hr class="dash" style="margin-top: 40px;" />
                            <div class="b_t" style="text-align: center;">
                                <input class="yc-btn" onclick='checkPayPassword("unionpay")' id="unionpaySubmit"
                                    style="text-align: center; cursor: pointer; margin-left: 300px;" value="银联在线支付" />
                            </div>
                        </div>
                        <!--网银暂空-->
                        <div id="yeepay_div" style="display: none;">
                            <ul>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_ICBC-NET-B2C" value="ICBC-NET-B2C" type="radio" />
                                        <img src="/images/bank/gongshang.gif" alt="中国工商

银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CMBCHINA-NET-B2C" value="CMBCHINA-NET-B2C" type="radio" /><img
                                            src="/images/bank/zhaohang.gif" alt="招商银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_ABC-NET-B2C" value="ABC-NET-B2C" type="radio" /><img
                                            src="/images/bank/nongye.gif" alt="农业银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CCB-NET-B2C" value="CCB-NET-B2C" type="radio" /><img
                                            src="/images/bank/jianshe.gif" alt="建设银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_BCCB-NET-B2C" value="BCCB-NET-B2C" type="radio" /><img
                                            src="/images/bank/beijing.gif" alt="北京银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_BOCO-NET-B2C" value="BOCO-NET-B2C" type="radio" /><img
                                            src="/images/bank/jiaotong.gif" alt="交通银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CIB-NET-B2C" value="CIB-NET-B2C" type="radio" /><img
                                            src="/images/bank/xingye.gif" alt="兴业银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_NJCB-NET-B2C" value="NJCB-NET-B2C" type="radio" /><img
                                            src="/images/bank/nanjing.gif" alt="南京银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CMBC-NET-B2C" value="CMBC-NET-B2C" type="radio" /><img
                                            src="/images/bank/minsheng.gif" alt="中国民生银

行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CEB-NET-B2C" value="CEB-NET-B2C" type="radio" /><img
                                            src="/images/bank/guangda.gif" alt="广大银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_BOC-NET-B2C" value="BOC-NET-B2C" type="radio" /><img
                                            src="/images/bank/zhongguo.gif" alt="中国银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_PINGANBANK-NET" value="PINGANBANK-NET" type="radio" /><img
                                            src="/images/bank/pingan.gif" alt="平安银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CBHB-NET-B2C" value="CBHB-NET-B2C" type="radio" /><img
                                            src="/images/bank/buohai.gif" alt="渤海银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_HKBEA-NET-B2C" value="HKBEA-NET-B2C" type="radio" /><img
                                            src="/images/bank/dongya.gif" alt="东亚银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_NBCB-NET-B2C" value="NBCB-NET-B2C" type="radio" /><img
                                            src="/images/bank/ningbo.gif" alt="宁波银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_ECITIC-NET-B2C" value="ECITIC-NET-B2C" type="radio" /><img
                                            src="/images/bank/zhongxin.gif" alt="中信银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SDB-NET-B2C" value="SDB-NET-B2C" type="radio" /><img
                                            src="/images/bank/shenfa.gif" alt="深圳发展银行

" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_GDB-NET-B2C" value="GDB-NET-B2C" type="radio" /><img
                                            src="/images/bank/guangfa.gif" alt="广发银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SHB-NET-B2C" value="SHB-NET-B2C" type="radio" /><img
                                            src="/images/bank/shanghaibank.gif" alt="上海银

行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SPDB-NET-B2C" value="SPDB-NET-B2C" type="radio" /><img
                                            src="/images/bank/shangpufa.gif" alt="上海浦东

发展银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_POST-NET-B2C" value="POST-NET-B2C" type="radio" /><img
                                            src="/images/bank/youzheng.gif" alt="中国邮政" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_BJRCB-NET-B2C" value="BJRCB-NET-B2C" type="radio" /><img
                                            src="/images/bank/nongcunshangye.gif" alt="北京

农村商业银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_CZ-NET-B2C" value="CZ-NET-B2C" type="radio" /><img
                                            src="/images/bank/zheshang.gif" alt="浙商银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_HZBANK-NET-B2C" value="HZBANK-NET-B2C" type="radio" /><img
                                            src="/images/bank/hangzhou.gif" alt="杭州银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SRCB-NET-B2C" value="SRCB-NET-B2C" type="radio" /><img
                                            src="/images/bank/shangnongshang.jpg" alt="上海

农商银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_NCBBANK-NET-B2C" value="NCBBANK-NET-B2C" type="radio" /><img
                                            src="/images/bank/nanyanbank.gif" alt="南洋商业

银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_SCCB-NET-B2C" value="SCCB-NET-B2C" type="radio" /><img
                                            src="/images/bank/hebei.gif" alt="河北银行" /></label></li>
                                <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_ZJTLCB-NET-B2C" value="ZJTLCB-NET-B2C" type="radio" /><img
                                            src="/images/bank/tailong.gif" alt="泰隆银行" /></label></li>
                                <%--        <li>
                                    <label>
                                        <input name="pd_FrpId" id="PD_1000000-NET" value="1000000-NET" type="radio" /><img
                                            src="/images/bank/yeepay.jpg" alt="易宝会员" /></label></li>--%>
                            </ul>
                            <div style="clear: both;">
                            </div>
                            <hr class="dash" style="margin-top: 20px;" />
                            <div class="b_t" style="margin-top: 40px; text-align: center;">
                                <input class="yc-btn" onclick='checkPayPassword("yeepay")' id="yeepaySubmit" style="margin-left: 300px;
                                    cursor: pointer;" value="网上银行付款" />
                            </div>
                        </div>
                        <div id="alipay_div" class="none">
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
    <input type="hidden" id="orderId" value="<%=order %>" />
    <form id="orderForm" action="/HandleOrderPay.aspx" method="post">
    <input id="payType" type="hidden" runat="server" />
    <input id="orderpay" type="hidden" runat="server" />
    <input id="addMo" type="hidden" runat="server" />
    <input id="wgId" type="hidden" runat="server" />
    <input id="style" type="hidden" runat="server" value="order" />
    </form>
    <div class="footer clearfix">
        <div class="footer-con clearfix">
            <div class="footer-menu">
                <%
                    var articleclass = ArticalBLL.GetArticalList().Where(p => p.indexShow == 1).OrderByDescending(p => p.sort).ThenByDescending(p => p.ID).Take(4).ToList();
                    for (int i = 0; i < articleclass.Count; i++)
                    {
                        Response.Write("<dl class=\"footer-menu-dl\">");
                        Response.Write("    <dt><strong>" + articleclass[i].Name + "</strong> </dt>");
                        var list = ArticalContent.GetArticalContent(articleclass[i].ID).Where(s => s.isPublish == 1).OrderByDescending(p => p.orderNumber).ThenByDescending(p => p.ID).ToList();
                        for (int j = 0; j < list.Count; j++)
                        {
                            Response.Write(" <dd><a href=\"/article.aspx?id=" + list[j].ID + "&typeid=" + list[j].articalID + "\">" + list[j].title + "</a></dd>");
                        }
                        Response.Write("    </dl>");
                    }
                %>
            </div>
            <div class="copy">
                <div class="share">
                    <a href="">
                        <img src="images/qq.jpg" alt="" /></a> <a href="">
                            <img src="images/weixin.jpg" alt="" /></a> <a href="">
                                <img src="images/tencent.jpg" alt="" /></a> <a href="">
                                    <img src="images/sina.jpg" alt="" /></a>
                </div>
                <div class="copy-text">
                    备案号：冀ICP备14001107号-1
                    <br />
                    版权所有：河北方润汽车租赁有限公司
                    <!-- 百度分享 -->
                    <div class="bdsharebuttonbox">
                        <a href="#" class="bds_more" data-cmd="more"></a><a href="#" class="bds_qzone" data-cmd="qzone">
                        </a><a href="#" class="bds_tsina" data-cmd="tsina"></a><a href="#" class="bds_tqq"
                            data-cmd="tqq"></a><a href="#" class="bds_renren" data-cmd="renren"></a><a href="#"
                                class="bds_weixin" data-cmd="weixin"></a>
                    </div>
                    <script>                        window._bd_share_config = { "common": { "bdSnsKey": {}, "bdText": "", "bdMini": "2", "bdPic": "", "bdStyle": "0", "bdSize": "16" }, "share": {} }; with (document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];</script>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
