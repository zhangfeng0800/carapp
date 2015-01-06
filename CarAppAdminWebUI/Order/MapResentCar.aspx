﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MapResentCar.aspx.cs" Inherits="CarAppAdminWebUI.Order.MapResentCar" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="/Static/scripts/jquery.min.js"></script>
    <!--   EasyUI Start-->
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Static/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="/Static/easyui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="/Static/artDialog/jquery.artDialog.js?skin=blue"></script>
    <!--   EasyUI End-->
    <style type="text/css">
        td input
        {
            margin-left: 0 !important;
        }
        /* 因为admin.css 里的 td input 样式会使 combogrid 下拉框错位 所以加下面的样式 */
        .combobox-item
        {
            height: 20px;
        }
        /*EassyUI 下拉框第一项为空时,撑开第一项 */
        .ke-dialog-body .tabs
        {
            height: 0px;
            border: 0px;
        }
        /*KindEdit 的图片上传选择框和EasyUI样式冲突 */
        .datagrid-cell
        {
            white-space: normal !important;
        }
        /*easyui列自动换行*/
        .datagrid-row-selected
        {
            background: #E9F9F9 !important;
        }
        .field-validation-valid
        {
            color: Red;
        }
    </style>
    <style type="text/css">
        body
        {
            width: 100%;
            height: 100%;
            margin: 0;
        }
        html, body, form
        {
            width: 100%;
            height: 100%;
            overflow: hidden;
            margin: 0;
        }
        #allmap
        {
            margin-right: 305px;
            height: 100%;
            overflow: hidden;
        }
        .cityList
        {
            height: 320px;
            width: 372px;
            overflow-y: auto;
        }
        .sel_container
        {
            z-index: 99;
            font-size: 12px;
            position: absolute;
            right: 0px;
            top: 0px;
            width: 140px;
            background: rgba(255,255,255,0.8);
            height: 30px;
            line-height: 30px;
            padding: 5px;
        }
        .map_popup
        {
            position: absolute;
            z-index: 200000;
            width: 382px;
            height: 344px;
            right: 30px;
            top: 30px;
        }
        .map_popup .popup_main
        {
            background: #fff;
            border: 1px solid #8BA4D8;
            height: 100%;
            overflow: hidden;
            position: absolute;
            width: 100%;
            z-index: 2;
        }
        .map_popup .title
        {
            background: url("http://map.baidu.com/img/popup_title.gif") repeat scroll 0 0 transparent;
            color: #6688CC;
            font-size: 12px;
            font-weight: bold;
            height: 24px;
            line-height: 25px;
            padding-left: 7px;
        }
        .map_popup button
        {
            background: url("http://map.baidu.com/img/popup_close.gif") no-repeat scroll 0 0 transparent;
            border: 0 none;
            cursor: pointer;
            height: 12px;
            position: absolute;
            right: 4px;
            top: 6px;
            width: 12px;
        }
        ul, li
        {
            margin: 0px;
            padding: 0px;
            font-size: 12px;
            line-height: 23px;
            font-family: "宋体";
        }
        .ptitle
        {
            margin: 0px;
            padding: 0px;
            font-size: 14px;
            margin-bottom: 3px;
            font-family: "宋体";
        }
        #result
        {
            border-left: 1px dotted #999;
            height: 100%;
            width: 300px;
            position: absolute;
            top: 0px;
            right: 0px;
            font-size: 12px;
        }
        dl, dt, dd, ul, li
        {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        dt
        {
            font-size: 14px;
            font-family: "微软雅黑";
            font-weight: bold;
            border-bottom: 1px dotted #000;
            padding: 5px 0 5px 5px;
            margin: 5px 0;
        }
        dd
        {
            padding: 5px 0 0 5px;
        }
        li
        {
            line-height: 23px;
        }
    </style>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=P0IuySP2OeqbIxwu0H5qjfR6"></script>
    <!-- 加载百度地图样式信息窗口 -->
    <script type="text/javascript" src="http://api.map.baidu.com/library/SearchInfoWindow/1.5/src/SearchInfoWindow_min.js"></script>
    <link rel="stylesheet" href="http://api.map.baidu.com/library/SearchInfoWindow/1.5/src/SearchInfoWindow_min.css" />
    <!-- 加载城市列表 -->
    <script type="text/javascript" src="http://api.map.baidu.com/library/CityList/1.2/src/CityList_min.js"></script>
    <script type="text/javascript" src="/Static/scripts/easyui.formatter.expend.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="allmap">
    </div>
    <!--左侧列表-->
    <div id="result" style="overflow-y: scroll;">
        <dl>
            <dt>任务信息<img src="/Static/images/refresh.png" width="16" height="16" style="cursor: pointer;"
                title="点击刷新" onclick="setMapMarker()" /></dt>
            <dd>
                <ul>
                   <li>车辆位置来源[<%=source %>]<a href="javascript:updateGpsSource();">点击切换</a></li>
                  
                </ul>
            </dd>
        </dl>
      
        <dl id="queryResult" style="overflow-y: scroll; height: 200px; display: none;">
        </dl>
        <dl>
            <dt>订单基本信息</dt>
            <dd>
                <ul id="orderinfo">
                    <li>订单加载中...</li>
                </ul>
            </dd>
        </dl>
    
    </div>
    <!--城市列表-->
   
    </form>
</body>
</html>
<script type="text/javascript">
    var orderId = "";
    var map = new BMap.Map("allmap");
    //中心点默认石家庄
    map.centerAndZoom(new BMap.Point(114.521363, 38.050322), 14);
    map.addControl(new BMap.NavigationControl());
    map.enableScrollWheelZoom();
    setMapMarker();
    //    setInterval(setMapMarker, 600000);
    //         setMapMarkerListShow();

    function openInfo(content, e) {
        var p = e.target;
        var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
        var infoWindow = new BMap.InfoWindow(content, opts);  // 创建信息窗口对象 
        map.openInfoWindow(infoWindow, point); //开启信息窗口
    }
    var opts = {
        width: 250,     // 信息窗口宽度
        height: 350,     // 信息窗口高度
        title: "车辆信息", // 信息窗口标题
        enableMessage: false//设置允许信息窗发送短息
    };
    function setMapMarker(orderid) {
        deleteNowOrder();
        var carNo = $("#carNodisplay").val();
        map.clearOverlays();
        map.enableScrollWheelZoom();
        map.enableContinuousZoom();
        document.getElementById("orderinfo").innerHTML = "暂无订单";
        var data_info = [];
        $.get("/Car/CarLocationHandler.ashx", { "action": "list", "r": Math.random(), carNo: carNo, Online: "online", timestamp: new Date().getTime() }, function (date) {
            for (var i = 0; i < date.length; i++) {
                var point = new BMap.Point(date[i].longitude, date[i].latitude);
                var path = "";
                var carUseWay = "B";
                if (date[i].CarUseWay != null && date[i].CarUseWay != "") {
                    carUseWay = date[i].CarUseWay;
                }
                if (date[i].carWorkStatus == 3) {
                    path = "/Static/map/idle_" + carUseWay + ".png";
                } else {
                    path = "/Static/map/busy.png";
                }

                var carIcon = new BMap.Icon(path, new BMap.Size(20, 25));
                var title = date[i].CarNo + " " + date[i].CarType + " " + date[i].DriverName + " " + date[i].WorkStatusName + "#" + date[i].Id;

                var info = "";
                info += "<ul><li><b>相关操作：</b><a href='javascript:void(0);' onclick='onRerentCar(\"" + date[i].Id + "\")'>派车</a> <a href='javascript:void(0);' onclick='onCarTable(\"" + date[i].Id + "\")'>查看行程</a>";
                info += "<li><b>车辆类型：</b>" + date[i].CarType + "</li>";
                info += "<li><b>用车类型：</b>" + date[i].CarUseWay + "(A-热门线路 B-其他)</li>";
                info += "<li><b>车牌号码：</b>" + date[i].CarNo + "</li>";
                info += "<li><b>车辆电话：</b>" + date[i].telPhone + "</li>";
                info += "<li><b>司机姓名：</b>" + date[i].DriverName + "</li>";
                info += "<li><b>司机电话：</b>" + date[i].DriverPhone + "</li>";
                info += "<li><b>当前速度：</b>" + date[i].speed + "</li>";
                info += "<li><b>当前位置：</b>" + date[i].currentPosition + "</li>";
                info += "<li><b>数据时间：</b>" + easyui_formatterdate(date[i].updateTime, null, null) + "</li></ul>";
                data_info.push([date[i].longitude, date[i].latitude, info]);
                var label = new BMap.Label(date[i].CarNo, { offset: new BMap.Size(20, -10) });
                label.setStyle({ color: "black", fontSize: "10px" });
                label.setOffset(new BMap.Size(-14, -15));
                var marker = new BMap.Marker(new BMap.Point(data_info[i][0], data_info[i][1]), { icon: carIcon, title: title });  // 创建标注
                marker.setLabel(label);
                var content = data_info[i][2];
                map.addOverlay(marker);               // 将标注添加到地图中
                marker.addEventListener("click", openInfo.bind(null, content));
                label.addEventListener("click", openInfo.bind(null, content));
            }
        }, "json");
        $.get("/order/orderHandler.ashx", { "action": "mapresendcar", orderid: "<%=orderid %>", timestamp: new Date().getTime() }, function (date) {
            $("#queryResult").html("");
            $("#queryResult").append("<dt>查询结果 <a style='color:blue;font-size:12px;font-weight:normal; cursor:pointer;' onclick=\"javascript:$(this).parent().parent().fadeOut()\">关闭结果</a></dt>");
           
            var flags = 0;
            if (date.data.length > 0) {
                var order = date.data[flags];
                orderId = order.orderId;
                var orderInfo = "";
                orderInfo += "<li><b>订单详情：</b><a href='javascript:onShowOrder(\"" + orderId + "\");'>[点击查看]</a></li>";
                orderInfo += "<li><b>下单人：</b>" + order.username + "</li>";
                orderInfo += "<li><b>乘车人：</b>" + order.passengerName + "</li>";
                orderInfo += "<li><b>订单时间：</b>" + easyui_formatterdate(order.orderdate, null, null) + "</li>";
                orderInfo += "<li><b>预约时间：</b>" + easyui_formatterdate(order.departuretime, null, null) + "</li>";
                orderInfo += "<li><b>车辆类型：</b>" + order.typeName + "</li>";
                if (order.CarUseWay == '热门线路') {
                    orderInfo += "<li><b>用车方式：</b>" + '热门线路（' + order.isoneway + '）' + "</li>";
                } else {
                    orderInfo += "<li><b>用车方式：</b>" + order.name + "</li>";
                }
                orderInfo += "<li><b>出发城市：</b>" + order.provincename + order.cityname + order.townname + "</li>";
                orderInfo += "<li><b>出发地点：</b>" + order.startaddress + "</li>";
                orderInfo += "<li><b>目的城市：</b>" + order.endcityname + "</li>";
                orderInfo += "<li><b>目的地点：</b>" + order.arriveAddress + "</li>";
                orderInfo += "<li><b>联系方式：</b>" + order.passengerPhone + "</li>";
                orderInfo += "<li><b>备注信息：</b>" + order.remarks + "</li>";
 
                orderInfo += "</li>";


                if (!order.mapPoint == "") {
                    var arr = order.mapPoint.split(",");
                    var point = new BMap.Point(arr[0], arr[1]);

                    var orderPath = "";
                    if (order.CarUseWay != null && order.CarUseWay != "" && order.CarUseWay == "热门线路") {
                        orderPath = "/Static/map/hotline.gif";
                    } else {
                        orderPath = "/Static/map/people.gif";
                    }
                    var orderIcon = new BMap.Icon(orderPath, new BMap.Size(24, 48));
                    var ordermarker = new BMap.Marker(point, { icon: orderIcon, title: "当前订单" });
                    map.addOverlay(ordermarker);
                    map.addOverlay(ordermarker); // 将标注添加到地图中
                    map.centerAndZoom(point, map.getZoom());
                    var opts = {
                        width: 200, // 信息窗口宽度
                        height: 400, // 信息窗口高度
                        title: "订单信息", // 信息窗口标题
                        enableMessage: false
                    }
                    var infoWindow = new BMap.InfoWindow(orderInfo, opts); // 创建信息窗口对象 
                    ordermarker.addEventListener("click", function () {
                        map.openInfoWindow(infoWindow, point); //开启信息窗口
                    });
                    var point = new BMap.Point(order.carlng, order.carlat);
//                    map.centerAndZoom(point, 15);
                    var opts = {
                        position: point,    // 指定文本标注所在的地理位置
                        offset: new BMap.Size(-35, 5)    //设置文本偏移量
                    }
                    var label = new BMap.Label("已派车辆位置", opts);  // 创建文本标注对象
                    label.setStyle({
                        color: "red",
                        fontSize: "10px",
                        height: "20px",
                        lineHeight: "20px",
                        fontFamily: "微软雅黑"
                    });
                    map.addOverlay(label);   
                } else {
                    orderInfo += "<li style='color:red;'><b>订单位置定位失败</b>";
                }

                document.getElementById("orderinfo").innerHTML = orderInfo;
            }

        }, "json");
    }
    function onShowOrder(id) {
        top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
    }
    function setCarno(obj) {
        $("#carNodisplay").val($(obj).attr("theno"));
        //$(obj).parent().parent().fadeOut();
        getCarInfo($(obj).attr("theid"));
        setMapMarker();
    }
    function updateGpsSource() {
        $.messager.confirm("提示信息", "确认切换GPS来源吗？", function (r) {
            if (r) {

                $.ajax({
                    url: "/car/carlocationhandler.ashx?action=gpssource",
                    success: function (data) {
                        if (data == 1) {
                            window.location.reload();
                        } else {
                            $.messager.alert("提示信息", "切换失败", 'error');
                        }
                    }
                });
            }
        });
    }
    function deleteNowOrder() {
        var allOverlay = map.getOverlays();
        for (var z = 0; z < allOverlay.length; z++) {
            if (allOverlay[z].getTitle() == "当前订单") {
                map.removeOverlay(allOverlay[z]);
                return false;
            }
        }
    }
    function onShowClickOrder(orderid) {
        setMapMarker(orderid);
    }
    function setMapMarkerListShow() {

        $("#carNodisplay").val("");
        map.clearOverlays();

        var carNo = $("#carNo").val();
        var telPhone = $("#telPhone").val();
        var driverName = $("#driverName").val();
        var carbrand = $("#carbrand").val();
        var city = $("#curCity").html();
        $.get("/Car/CarLocationHandler.ashx", { "action": "list", carNo: carNo, telPhone: telPhone, driverName: driverName, carbrand: carbrand, city: city, Online: 0 }, function (date) {
            for (var i = 0; i < date.length; i++) {
                var point = new BMap.Point(date[i].longitude, date[i].latitude);
                var path = "";
                var carUseWay = "B";
                if (date[i].CarUseWay != null && date[i].CarUseWay != "") {
                    carUseWay = date[i].CarUseWay;
                }
                if (date[i].carWorkStatus == 3) {
                    path = "/Static/map/idle_" + carUseWay + ".png";
                } else if (date[i].carWorkStatus == 2) {
                    path = "/Static/map/leave.png";
                } else {
                    path = "/Static/map/busy.png";
                }

                var carIcon = new BMap.Icon(path, new BMap.Size(20, 48));
                var title = date[i].CarNo + " " + date[i].CarType + " " + date[i].DriverName + " " + date[i].WorkStatusName + "#" + date[i].Id;

                var carmarker = new BMap.Marker(point, { icon: carIcon, title: title });

                carmarker.addEventListener("click", function () {
                    getCarInfo(this.getTitle().split('#')[1]);
                });
                map.addOverlay(carmarker);
            }

            $("#queryResult").html("");

            $("#queryResult").append("<dt>查询结果 <a style='color:blue;font-size:12px;font-weight:normal; cursor:pointer;' onclick=\"javascript:$(this).parent().parent().fadeOut()\">关闭结果</a></dt>");
            for (var i = 0; i < date.length; i++) {
                $("#queryResult").append("<dd>" + date[i].CarNo + ">" + date[i].Name + ">" + date[i].telPhone + ">" + date[i].DriverName + ">" + date[i].WorkStatusName + "<a style='cursor:pointer; color:blue'  onclick='setCarno(this)' theno='" + date[i].CarNo + "' theid='" + date[i].Id + "' >查看</a></dd>");
            }
            $("#queryResult").fadeIn();
        }, "json");

        $.get("/Car/CarLocationHandler.ashx", { "action": "orderlist" }, function (date) {
            for (var j = 0; j < date.orders.length; j++) {
                var order = date.orders[j];
                orderId = order.orderId;
                var orderInfo = "";
                orderInfo += "<li><b>订单编号：</b>" + order.orderId + "</li>";
                orderInfo += "<li><b>订单时间：</b>" + easyui_formatterdate(order.orderDate, null, null) + "</li>";
                orderInfo += "<li><b>预约时间：</b>" + easyui_formatterdate(order.departureTime, null, null) + "</li>";
                orderInfo += "<li><b>出发城市：</b>" + order.departureCity + "</li>";
                orderInfo += "<li><b>出发地点：</b>" + order.startAddress + "</li>";
                orderInfo += "<li><b>目的城市：</b>" + order.targetCity + "</li>";
                orderInfo += "<li><b>目的地点：</b>" + order.arriveAddress + "</li>";
                orderInfo += "<li><b>车辆类型：</b>" + order.CarType + "</li>";
                orderInfo += "<li><b>用车方式：</b>" + order.CarUseWay + "</li>";
                orderInfo += "<li><b>联系方式：</b>" + order.passengerPhone + "</li>";

                orderInfo += "<li><b>匹配车辆：</b></li><li>";
                if (date.cars.length == 0) {
                    orderInfo += "<li>未找到推荐车辆</li>";
                } else {
                    for (var k = 0; k < date.cars.length; k++) {
                        orderInfo += "<a href='javascript:void(0);' onclick='getCarInfo(\"" + date.cars[k].Id + "\")'>" + date.cars[k].CarNo + "</a> ";
                    }
                }
                orderInfo += "</li>";

                if (!order.mapPoint == "") {
                    var arr = order.mapPoint.split(",");
                    var point = new BMap.Point(arr[0], arr[1]);
                    map.centerAndZoom(point, map.getZoom());
                    var orderPath = "";
                    if (order.CarUseWay != null && order.CarUseWay != "" && order.CarUseWay == "热门线路") {
                        orderPath = "/Static/map/order_A.png";
                    } else {
                        orderPath = "/Static/map/order_B.png";
                    }
                    var orderIcon = new BMap.Icon(orderPath, new BMap.Size(20, 48));
                    var ordermarker = new BMap.Marker(point, { icon: orderIcon });
                    map.addOverlay(ordermarker);
                } else {
                    orderInfo += "<li style='color:red;'><b>订单位置定位失败</b>";
                }
                document.getElementById("orderinfo").innerHTML = orderInfo;
            }
        }, "json");
    }

    /*获取车辆的信息*/
    function getCarInfo(id) {
        $.get("/Car/CarLocationHandler.ashx", { "action": "newmodel", "id": id }, function (result) {
            var info = "";
            if (result) {
                if (result.longitude && result.latitude && result.longitude > 0 && result.latitude > 0) {
                    var point = new BMap.Point(result.longitude, result.latitude);
                    map.centerAndZoom(point, map.getZoom());
                } else {
                    $.messager.alert("提示信息", "定位失败");
                }
            }

        }, "json");
    }

    function getQueryList() {
        var cityname = $("#curCity").text();
        var carno = $("#carNo").val();
        var cartelphone = $("#telPhone").val();
        var driverName = $("#driverName").val();
        var brandId = $("#carbrand").val();
        var data_info = [];
        var allOverlay = map.getOverlays();
        for (var z = 0; z < allOverlay.length; z++) {
            if (allOverlay[z].getTitle() != "当前订单") {
                map.removeOverlay(allOverlay[z]);
            }
        }
        $.post("/car/carlocationhandler.ashx", { action: "list", carNo: carno, city: cityname, telPhone: cartelphone, driverName: driverName, carbrand: brandId, Online: "online" }, function (date) {
            var carlist = "";
            if (date.length == 0) {
                carlist = "暂无匹配车辆";
                return;
            }
            for (var i = 0; i < date.length; i++) {
                var point = new BMap.Point(date[i].longitude, date[i].latitude);
                var path = "";
                var carUseWay = "B";
                if (date[i].CarUseWay != null && date[i].CarUseWay != "") {
                    carUseWay = date[i].CarUseWay;
                }
                if (date[i].carWorkStatus == 3) {
                    path = "/Static/map/idle_" + carUseWay + ".png";
                } else {
                    path = "/Static/map/busy.png";
                }

                var carIcon = new BMap.Icon(path, new BMap.Size(20, 48));
                var title = date[i].CarNo + " " + date[i].CarType + " " + date[i].DriverName + " " + date[i].WorkStatusName + "#" + date[i].Id;

                var info = "";
                info += "<ul><li><b>相关操作：</b><a href='javascript:void(0);' onclick='onRentCar(\"" + date[i].Id + "\")'>派车</a> <a href='javascript:void(0);' onclick='onCarTable(\"" + date[i].Id + "\")'>查看行程</a>";
                info += "<li><b>车辆类型：</b>" + date[i].CarType + "</li>";
                info += "<li><b>用车类型：</b>" + date[i].CarUseWay + "(A-热门线路 B-其他)</li>";
                info += "<li><b>车牌号码：</b>" + date[i].CarNo + "</li>";
                info += "<li><b>车辆电话：</b>" + date[i].telPhone + "</li>";
                info += "<li><b>司机姓名：</b>" + date[i].DriverName + "</li>";
                info += "<li><b>司机电话：</b>" + date[i].DriverPhone + "</li>";
                info += "<li><b>当前速度：</b>" + date[i].speed + "</li>";
                info += "<li><b>当前位置：</b>" + date[i].currentPosition + "</li>";
                info += "<li><b>数据时间：</b>" + easyui_formatterdate(date[i].updateTime, null, null) + "</li></ul>";
                data_info.push([date[i].longitude, date[i].latitude, info]);

                var label = new BMap.Label(date[i].CarNo, { offset: new BMap.Size(20, -10) });
                label.setStyle({ color: "black", fontSize: "10px" });
                label.setOffset(new BMap.Size(-14, -15));
                var marker = new BMap.Marker(new BMap.Point(data_info[i][0], data_info[i][1]), { icon: carIcon, title: title });  // 创建标注
                marker.setLabel(label);

                var content = data_info[i][2];
                map.addOverlay(marker);               // 将标注添加到地图中
                marker.addEventListener("click", openInfo.bind(null, content));
                carlist += "<a href='javascript:void(0);' onclick='getCarInfo(\"" + date[i].Id + "\")'>" + date[i].CarNo + "</a> ";
            }
            $("#carlists").html(carlist);
        }, "json");

    }
    /* 派车按钮 */
    function onRerentCar(carid) {
        if (orderId == "") {
            $.messager.alert('消息', '订单信息错误', 'error');
            return;
        }
        if (carid == "") {
            $.messager.alert('消息', '车辆信息错误', 'error');
            return;
        }
        $.messager.confirm("提示", "你确定派遣此车么？", function (r) {
            if (r) {
                var d = { "action": "resentcar", "id": orderId, "carid": carid };
                $.post("/Order/OrderHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', "车辆派遣成功", 'info', function () {
                            setMapMarker();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        });
    }

    /* 车辆行程 */
    function onCarTable(id) {
        art.dialog({
            width: '500px',
            title: '车辆行程信息(从现在开始)',
            content: ' <iframe style="border:0px;width:850px; height:500px;" frameborder="0" src="/Car/CarTable.aspx?id=' + id + '"></iframe>',
            padding: 0
        });
    }

    /* 切换城市列表 */
    var myCl = new BMapLib.CityList({ container: "citylist_container", map: map });
    myCl.addEventListener("cityclick", function (e) {
        document.getElementById("curCity").innerHTML = e.name;
        document.getElementById("cityList").style.display = "none";
    });
 
</script>