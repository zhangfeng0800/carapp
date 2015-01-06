<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="recharge.aspx.cs" Inherits="WebApp.recharge" %>
<%@ Import Namespace="BLL" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>爱易租账户充值</title>
    <link href="css/subpage.css" rel="stylesheet" type="text/css" />
    <link href="css/public.css" rel="stylesheet" type="text/css" />
    <link href="css/orderpay.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <style type="text/css">
        #yeepay_div ul li img
        {
            width: 154px;
            height: 33px;
        }
    </style>
    <script type="text/javascript">
        function HandlePay(str) {
            $("#style").val('recharge');
            switch (str) {
                case "alipay":
                    {
                        $("#payType").val(str);
                        break;
                    }
                case "yeepay":
                    {
                        if ($("[name='pd_FrpId']:radio:checked").length == 0) {
                            alert("请先选择银行");
                            return;
                        }
                        else {
                            $("#wgId").val($('input[name="pd_FrpId"]:checked').val());
                            $("#payType").val(str);
                        }
                        break;
                    }
                case "unionpay":
                    {
                        $("#payType").val(str);
                        break;
                    }
            }
            $("#rechargeForm").submit();
        }
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
    <script type="text/javascript">
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
        function paystyle(str) {
            var BCpay = document.getElementById("BCpay");
            var alipay = document.getElementById("alipay");
            var alipay_div = document.getElementById("alipay_div");
            var yeepay_div = document.getElementById("yeepay_div");
            if (str == "BCpay") {
                unionpay.className = "";
                unionpay_div.style.display = "none";
                BCpay.className = "active";
                alipay_div.style.display = "none";
                alipay.className = "";
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
                unionpay.className = "";
                unionpay_div.style.display = "none";
                alipay.className = "active";
                alipay_div.style.display = "block";
                BCpay.className = "";
                yeepay_div.style.display = "none";
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="headbar">
        <div class="headbar_con clearfix">
            <div class="bar-left">
                您好&nbsp;<a href="/PCenter/MyAccount.aspx"><%=Username %></a>&nbsp;，欢迎光临爱易租！
                <%
                    Response.Write(IsLogined == 0 ? "<a href=\"/Login.aspx\" id=\"login\">请登录</a> <a id=\"register\" href=\"/Register.aspx\">免费注册</a>" : "<a style=\"cursor:pointer\" herf=\"javascript:void(0);\" onclick=\"loginOut()\">退出</a>");
                %>
                <%--        <a href="/Login.aspx" id="login">请登录</a> <a id="register" href="/Register.aspx">免费注册</a>--%>
            </div>
            <div class="bar-right">
                <a href="/PCenter/MyOrders.aspx">我的订单</a> <a href="/PCenter/MyAccount.aspx">我的爱易租</a>
                <a href="/article.aspx?id=61&typeid=29">帮助中心</a> <a href="javascript:;">点击收藏</a>
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
                </ul>
            </div>
        </div>
    </div>
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="content clearfix">
        <div class="rec-suc">
            您申请充值账户余额充值，请立即支付<br />
            <span>充值单号：<span runat="server" id="rechargeNum"></span>&nbsp;&nbsp;&nbsp;&nbsp;应付金额：<em
                class="price-num" runat="server" id="rechargeMoney"></em></span>
        </div>
        <div class="bank-show">
            <div class="showpay">
                <div class="show_t">
                    <%-- <span>充值方式</span>--%>
                    <a  id="unionpay" onclick='paystyle("unionpay")' class="active" >银联在线支付</a> 
                    <a id="BCpay" onclick='paystyle("BCpay")' >网上银行</a> <a id="alipay"
                        onclick='paystyle("alipay")'>支付宝</a>
                </div>
            </div>

                <div id="unionpay_div">
                        <img src="/images/bank/unionpay.jpg" alt="银联在线支付" /><br />
                        <hr class="dash" style="margin-top: 40px;" />
                        <div class="b_t" style="text-align:center;">
                        <input class="yc-btn" onclick='HandlePay("unionpay")' id="unionpaySubmit" style="text-align:center;cursor: pointer; margin-left: 300px;" value="银联在线支付" />
                        </div>
                        </div>
            <div id="yeepay_div"  style="display: none;">
                <ul>
                    <li>
                        <label>
                            <input name="pd_FrpId" id="PD_ICBC-NET-B2C" value="ICBC-NET-B2C" type="radio" /><img
                                src="/images/bank/gongshang.gif" alt="中国工商银行" /></label></li>
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
                                src="/images/bank/minsheng.gif" alt="中国民生银行" /></label></li>
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
                                src="/images/bank/shenfa.gif" alt="深圳发展银行" /></label></li>
                    <li>
                        <label>
                            <input name="pd_FrpId" id="PD_GDB-NET-B2C" value="GDB-NET-B2C" type="radio" /><img
                                src="/images/bank/guangfa.gif" alt="广发银行" /></label></li>
                    <li>
                        <label>
                            <input name="pd_FrpId" id="PD_SHB-NET-B2C" value="SHB-NET-B2C" type="radio" /><img
                                src="/images/bank/shanghaibank.gif" alt="上海银行" /></label></li>
                    <li>
                        <label>
                            <input name="pd_FrpId" id="PD_SPDB-NET-B2C" value="SPDB-NET-B2C" type="radio" /><img
                                src="/images/bank/shangpufa.gif" alt="上海浦东发展银行" /></label></li>
                    <li>
                        <label>
                            <input name="pd_FrpId" id="PD_POST-NET-B2C" value="POST-NET-B2C" type="radio" /><img
                                src="/images/bank/youzheng.gif" alt="中国邮政" /></label></li>
                    <li>
                        <label>
                            <input name="pd_FrpId" id="PD_BJRCB-NET-B2C" value="BJRCB-NET-B2C" type="radio" /><img
                                src="/images/bank/nongcunshangye.gif" alt="北京农村商业银行" /></label></li>
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
                                src="/images/bank/shangnongshang.jpg" alt="上海农商银行" /></label></li>
                    <!--li>
                        <label>
                            <input name="pd_FrpId" id="PD_NCBBANK-NET-B2C" value="NCBBANK-NET-B2C" type="radio" /><img
                                src="/images/bank/nanyanbank.gif" alt="南洋商业银行" /></label></li>
                    <li>
                        <label>
                            <input name="pd_FrpId" id="PD_SCCB-NET-B2C" value="SCCB-NET-B2C" type="radio" /><img
                                src="/images/bank/hebei.gif" alt="河北银行" /></label></li>
                    <li>
                        <label>
                            <input name="pd_FrpId" id="PD_ZJTLCB-NET-B2C" value="ZJTLCB-NET-B2C" type="radio" /><img
                                src="/images/bank/tailong.gif" alt="泰隆银行" /></label></li-->
                    <%--    <li><label><input name="pd_FrpId" id="PD_1000000-NET" value="1000000-NET" type="radio" /><img src="/images/bank/yeepay.jpg" alt="易宝会员" /></label></li>--%>
                </ul>
                <div style="clear: both;">
                </div>
                <hr class="dash" style="margin-top: 20px;" />
                <div class="b_t" style="margin-top: 40px;">
                    <a class="yc-btn" href="javascript:;" onclick='HandlePay("yeepay")' id="yeepaySubmit"
                        style="margin-left: 300px;">网上银行充值</a>
                </div>
            </div>
            <div id="alipay_div" style="display: none;">
                <img src="/images/bank/alipay.jpg" alt="支付宝" width="150px" height="50px" /><br />
                <hr class="dash" style="margin-top: 40px;" />
                <div class="b_t">
                    <a class="yc-btn" href="javascript:;" onclick='HandlePay("alipay")' id="alipaySubmit"
                        style="text-align: center; margin-left: 300px;">支付宝充值</a>
                </div>
            </div>
        </div>
    </div>
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
    <!--[if IE 6]>
  <script type="text/javascript" src="js/png.js"></script>
  <script type="text/javascript" src="js/fixpng.js"></script>
<![endif]-->
    </form>
    <form id="rechargeForm" action="/HandleOrderPay.aspx" method="post">
    <input id="payType" type="hidden" runat="server" />
    <input id="orderpay" type="hidden" runat="server" />
    <input id="addMo" type="hidden" runat="server" />
    <input id="wgId" type="hidden" runat="server" />
    <input id="style" type="hidden" runat="server" />
    </form>
</body>
</html>
