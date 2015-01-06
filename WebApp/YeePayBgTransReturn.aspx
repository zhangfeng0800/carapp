<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="YeePayBgTransReturn.aspx.cs" Inherits="WebApp.YeePayBgTransReturn" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
 <title>付款成功</title>
  <link rel="stylesheet" type="text/css" href="css/public.css"/>
<link rel="stylesheet" type="text/css" href="css/subpage.css"/>
  <script src="Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
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
			<a href="/PCenter/MyOrders.aspx">我的订单</a>
			<a href="/PCenter/MyAccount.aspx">我的爱易租</a>
			<a href="/article.aspx?id=61&typeid=29">帮助中心</a>
			<a href="javascript:;">点击收藏</a>
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
	<a class="sub-banner-a" href="" style="background:url(images/001_02.jpg) no-repeat 50% 0;">爱易租</a>
</div>
<div class="dc-process clearfix">
	<div class="pay-ok">
		<p class="pay-text">
		<span id="tip" runat="server"></span>
		</p>
		<p>
        <span id="orderTip" runat="server"></span>
		</p>
		<p>
			<span runat="server" id="payType"></span><strong class="order-text"><span runat="server" id="orderNum"></span></strong>
			<em class="em-red"><span id="memCenter" runat="server"></span></em>
		</p>
		<p class="clearfix">
			<%--<a href="" class="sel-order">查看我的订单</a>--%>
			<%--9秒后自动跳到订单详情页面--%>
		</p>
	</div>
</div>
<div class="footer clearfix">
	<div class="footer-con clearfix">
				<div class="footer-menu">
                <%
                    var articleclass = BLL.ArticalBLL.GetArticalList();
                    for (int i = 0; i < articleclass.Count; i++)
                    {
                        if (articleclass[i].Name.Contains("服务特色"))
                        {
                            continue;
                        }
                        if (articleclass[i].Name.Contains("帮助中心"))
                        {
                            continue;
                        }
                        if (articleclass[i].Name.Contains("四个公告"))
                        {
                            continue;
                        }
                        Response.Write("<dl class=\"footer-menu-dl\">");
                        Response.Write("    <dt><strong>" + articleclass[i].Name + "</strong> </dt>");
                        var list = BLL.ArticalContent.GetArticalContent(articleclass[i].ID);
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
				<a href=""><img src="images/qq.jpg" alt="" /></a>
				<a href=""><img src="images/weixin.jpg" alt="" /></a>
				<a href=""><img src="images/tencent.jpg" alt="" /></a>
				<a href=""><img src="images/sina.jpg" alt="" /></a>
			</div>
			<div class="copy-text">
				 备案号：冀ICP备14001107号-1  <br /> 版权所有：河北方润汽车租赁有限公司 
				 <!-- 百度分享 -->
				 <div class="bdsharebuttonbox"><a href="#" class="bds_more" data-cmd="more"></a><a href="#" class="bds_qzone" data-cmd="qzone"></a><a href="#" class="bds_tsina" data-cmd="tsina"></a><a href="#" class="bds_tqq" data-cmd="tqq"></a><a href="#" class="bds_renren" data-cmd="renren"></a><a href="#" class="bds_weixin" data-cmd="weixin"></a></div>
<script>    window._bd_share_config = { "common": { "bdSnsKey": {}, "bdText": "", "bdMini": "2", "bdPic": "", "bdStyle": "0", "bdSize": "16" }, "share": {} }; with (document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];</script>
			</div>
		</div>
	</div>
</div>
<!--[if IE 6]>
  <script type="text/javascript" src="js/png.js"></script>
  <script type="text/javascript" src="js/fixpng.js"></script>
<![endif]-->
<script type="text/javascript" src="Scripts/jquery-1.8.0.min.js"></script>
    </form>
</body>
</html>
