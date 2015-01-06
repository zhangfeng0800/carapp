<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemberLeft.aspx.cs" Inherits="WebApp.Frame.MemberLeft" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" href="/css/common.css" rel="stylesheet" />
</head>
<body style="margin:0px; padding:0px;">
 <form id="form1" runat="server">
<div class="left_part">
<div class="left_top">我的爱易租</div>
<div class="left_detail">
<div class="detail_top"><span>个人账户</span><label>管理集团账户</label></div>
<ul>
<li>
<span>&gt;</span><a href="#">我的订单</a>
</li>
<li>
<span>&gt;</span><a href="#">余额和充值</a>
</li>
<li>
<span>&gt;</span><a href="#">信用卡管理</a>
</li>
<li>
<span>&gt;</span><a href="#">我的优惠券</a>
</li>
<li>
<span>&gt;</span><a href="#">我的充值卡</a>
</li>
<li id="mem_li1"></li>
</ul>
<ul>
<li>
<span>&gt;</span><a href="/MemberInfo.aspx">个人资料</a>
</li>
<li>
<span>&gt;</span><a href="/MemberAddress.aspx">常用地址</a>
</li>
<li>
<span>&gt;</span><a href="#">常用乘车人</a>
</li>
<li>
<span>&gt;</span><a href="#">发票信息</a>
</li>
<li>
<span>&gt;</span><a href="#">修改密码</a>
</li>
<li id="mem_li2"></li>
</ul>
<ul>
<li>
<span>&gt;</span><a href="#">服务评价</a>
</li>
<li>
<span>&gt;</span><a href="#">邀请得礼金</a>
</li>
</ul>
</div>
</div>
    </form>
</body>
</html>
