<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="CarAppAdminWebUI.Main" %>

<%@ Import Namespace="System.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="/Static/bootstrap/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/Static/bootstrap/dist/css/bootstrap-theme.min.css" />
    <script type="text/javascript">
        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "../Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }
        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "../Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }
    </script>
</head>
<body style="padding: 0 30px; min-width:800px;">
    <form id="form1" runat="server">
    <div class="page-header">
        <h3>
            <strong>欢迎您登陆管理系统</strong><small> 系统版本V1.0</small></h3>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-primary" style="height:250px;">
                <!-- Default panel contents -->
                <div class="panel-heading">
                    <strong>会员注册信息</strong></div>
                <!-- List group -->
                <ul class="list-group" style="width:50%; float:left;">
                    <li class="list-group-item" style=" height:42px;">今日注册会员：<%=DefaultData.Rows[0]["todayUser"]%></li>
                    <li class="list-group-item">本周注册会员：<%=DefaultData.Rows[0]["theweekUser"]%></li>
                    <li class="list-group-item">本月注册会员：<%=DefaultData.Rows[0]["themonthUser"]%></li>
                    <li class="list-group-item">本年注册会员：<%=DefaultData.Rows[0]["theyearUser"]%></li>
                    <li class="list-group-item"><span class="badge"><%=DefaultData.Rows[0]["allUser"]%></span>系统共有会员</li>
                </ul>
                  <ul class="list-group" style="width:50%; float:right;">
                    <li class="list-group-item">昨日注册会员：<%=DefaultData.Rows[0]["yestoday"]%></li>
                    <li class="list-group-item">上周注册会员：<%=DefaultData.Rows[0]["preweekUser"]%></li>
                    <li class="list-group-item">上月注册会员：<%=DefaultData.Rows[0]["premonthUser"]%></li>
                    <li class="list-group-item">上年注册会员：<%=DefaultData.Rows[0]["preyearUser"]%></li>
                    <li class="list-group-item" style=" height:42px;"></li>
                </ul>
            </div>
        </div>
        <div class="col-md-6">
            <div class="panel panel-primary"  style="height:250px;">
                <!-- Default panel contents -->
                <div class="panel-heading">
                    <strong>新增订单信息（下单时间统计）</strong></div>
                <!-- List group -->
                 <ul class="list-group" style="width:50%; float:left;">
                    <li class="list-group-item" style=" height:42px;">今日新增订单：<%=DefaultData.Rows[0]["todayOrder"]%></li>
                    <li class="list-group-item">本周新增订单：<%=DefaultData.Rows[0]["theweekOrder"]%></li>
                    <li class="list-group-item">本月新增订单：<%=DefaultData.Rows[0]["themonthOrder"]%></li>
                    <li class="list-group-item">本年新增订单：<%=DefaultData.Rows[0]["theyearOrder"]%></li>
                    <li class="list-group-item"><span class="badge"><%=DefaultData.Rows[0]["allOrder"]%></span>系统共有订单</li>
                </ul>
                  <ul class="list-group" style="width:50%; float:right;">
                    <li class="list-group-item">昨日新增订单：<%=DefaultData.Rows[0]["yestodayOrder"]%></li>
                    <li class="list-group-item">上周新增订单：<%=DefaultData.Rows[0]["preweekOrder"]%></li>
                    <li class="list-group-item">上月新增订单：<%=DefaultData.Rows[0]["premonthOrder"]%></li>
                    <li class="list-group-item">上年新增订单：<%=DefaultData.Rows[0]["preyearOrder"]%></li>
                    <li class="list-group-item" style=" height:42px;"></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-primary" style="height:207px;">
                <!-- Default panel contents -->
                <div class="panel-heading">
                    <strong>充值信息</strong></div>
              
                 <ul class="list-group" style="width:50%; float:left;">
                    <li class="list-group-item" style=" height:42px;">今日会员充值：<%=DefaultData.Rows[0]["totayCharge"]%> 元</li>
                    <li class="list-group-item">本周会员充值：<%=DefaultData.Rows[0]["theweekCharge"]%> 元</li>
                    <li class="list-group-item">本月会员充值：<%=DefaultData.Rows[0]["themonthCharge"]%> 元</li>
                    <li class="list-group-item">本年会员充值：<%=DefaultData.Rows[0]["theyearCharge"]%> 元</li>
                   
                </ul>
                  <ul class="list-group" style="width:50%; float:right;">
                    <li class="list-group-item" style=" height:42px;">今日赠送金额：<%=DefaultData.Rows[0]["todayGift"]%> 元（含摇奖和充值赠费）</li>
                    <li class="list-group-item">本周赠送金额：<%=DefaultData.Rows[0]["theweekGift"]%> 元</li>
                    <li class="list-group-item">本月赠送金额：<%=DefaultData.Rows[0]["themonthGift"]%> 元</li>
                    <li class="list-group-item">本年赠送金额：<%=DefaultData.Rows[0]["theyearGift"]%> 元</li>
                </ul>
            </div>
        </div>
        <div class="col-md-6">
            <div class="panel panel-primary" style="height:207px;">
                <!-- Default panel contents -->
                <div class="panel-heading" >
                    <strong>完成订单信息（完成时间统计）</strong></div>
                <!-- Table -->
                 <ul class="list-group" style="width:50%; float:left;">
                    <li class="list-group-item" style=" height:42px;">今日完成订单：<%=DefaultData.Rows[0]["todaycomplete"]%></li>
                    <li class="list-group-item">本周完成订单：<%=DefaultData.Rows[0]["theweekcomplete"]%></li>
                    <li class="list-group-item">本月完成订单：<%=DefaultData.Rows[0]["themonthcomplete"]%></li>
                    <li class="list-group-item">本年完成订单：<%=DefaultData.Rows[0]["theyearcomplete"]%></li>
                   
                </ul>

                 <ul class="list-group" style="width:50%; float:right;">
                    <li class="list-group-item" style=" height:42px;">订单总额：<%=DefaultData.Rows[0]["todayMoney"]%> 元</li>
                    <li class="list-group-item">订单总额：<%=DefaultData.Rows[0]["theweekMoney"]%> 元</li>
                    <li class="list-group-item">订单总额：<%=DefaultData.Rows[0]["themonthMoney"]%> 元</li>
                    <li class="list-group-item">订单总额：<%=DefaultData.Rows[0]["theyearMoney"]%> 元</li>
                </ul>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-primary" style="height:207px;">
                <!-- Default panel contents -->
                <div class="panel-heading">
                    <strong>车辆信息</strong></div>
              
                 <ul class="list-group" style="width:50%; float:left;">
                    <li class="list-group-item" style=" height:42px;">车辆总计：<%=DefaultData.Rows[0]["carnum"]%> 辆</li>
                    <li class="list-group-item">租用次数：<%=DefaultData.Rows[0]["carusenum"]%> 次</li>
                    <li class="list-group-item">总里程：<%=DefaultData.Rows[0]["usekm"]%> 公里</li>
                    <li class="list-group-item">总金额：<%=DefaultData.Rows[0]["usemoney"]%> 元</li>
                </ul>
                 
                  <ul class="list-group" style="width:50%; float:right;">
                    <li class="list-group-item" style=" height:42px;">当前空闲可接单：<%=DefaultData.Rows[0]["canusecar"]%> 辆</li>
                    <li class="list-group-item"  style=" height:42px;">已接单：<%=DefaultData.Rows[0]["orderPickedUp"]%> 辆&nbsp;&nbsp;&nbsp;&nbsp;
                    
                    已出发：<%=DefaultData.Rows[0]["hasBeenSetOut"]%> 辆</li>
                    <li class="list-group-item"  style=" height:42px;">已就位：<%=DefaultData.Rows[0]["AlreadyInPlace"]%> 辆&nbsp;&nbsp;&nbsp;&nbsp;工作中：<%=DefaultData.Rows[0]["workcar"]%> 辆</li>
                     <li class="list-group-item"  >离开或请假：<%=DefaultData.Rows[0]["leave"]%> 辆&nbsp;&nbsp;&nbsp;&nbsp;租出：<%=DefaultData.Rows[0]["rentout"]%> 辆
                     &nbsp;&nbsp;&nbsp;&nbsp;借出：<%=DefaultData.Rows[0]["lendout"]%> 辆
                     </li>
                </ul>

            </div>
        </div>
        <div class="col-md-6">
            <div class="panel panel-primary" style="height:207px;">
                <!-- Default panel contents -->
                <div class="panel-heading" >
                    <strong>司机信息</strong></div>
                <!-- Table -->
                 <ul class="list-group" style="width:50%; float:left;">
                    <li class="list-group-item" style=" height:42px;">在职司机人数：<%=DefaultData.Rows[0]["drivernum"]%> 人</li>
                    <li class="list-group-item">订单总数：<%=DefaultData.Rows[0]["carusenum"]%></li>
                     <li class="list-group-item">总里程：<%=DefaultData.Rows[0]["usekm"]%> 公里</li>
                    <li class="list-group-item">订单总金额：<%=DefaultData.Rows[0]["usemoney"]%> 元</li>
                </ul>
                <ul class="list-group" style="width:50%; float:right;">
                    <li class="list-group-item" style=" height:42px;">当前登陆司机：<%=DefaultData.Rows[0]["nowdrivernum"]%> 人</li>
                    <li class="list-group-item"  style=" height:42px;"></li>
                    <li class="list-group-item"  style=" height:42px;"></li>
                    <li class="list-group-item"  ></li>
                </ul>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
