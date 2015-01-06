<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarRouteQuery.aspx.cs"
    Inherits="CarAppAdminWebUI.Car.CarRouteQuery" %>

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
    <script type="text/javascript" src="/Static/My97DatePicker/WdatePicker.js"></script>
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
            margin-right: 500px;
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
            width: 480px;
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
    <script src="/Static/scripts/jquery-ui.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1">
    <div id="allmap">
    </div>
    <!--左侧列表-->
    <div id="result" style="overflow-y: scroll;">
        <dl>
            <dt>车辆轨迹查询</dt>
            <dd>
                <input id="action" value="routeinfo" style="display: none;" name="action" />
                开始时间：<input type="text" readonly="readonly" name="starttime" style="width: 200px;"
                    id="starttime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                    value="<%=DateTime.Now.AddHours(-2).ToString("yyyy-MM-dd HH:mm:ss") %>" /><br />
                <br />
                结束时间：<input id="endtime" readonly="readonly" name="endtime" style="width: 200px;"
                    value="<%=DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") %>" type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                    onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" /><br />
                <br />
                车牌号码：
                <input type="text" name="carno" id="carno" style="width: 200px;" value="<%=carno %>" />
                <br />
                <br />
                <button type="button" onclick="showCarRoute()" style="margin-left: 150px;">
                    查询</button>
            </dd>
        </dl>
        <dl id="queryResult" style="overflow-y: scroll; height: 200px; display: none;">
        </dl>
        <dl>
            <dt>轨迹信息</dt>
            <dd>
                <ul id="orderinfo">
                    <li></li>
                </ul>
            </dd>
        </dl>
    </div>
    </form>
</body>
</html>
<script type="text/javascript">

    var map = new BMap.Map("allmap");
    //中心点默认石家庄
    map.centerAndZoom(new BMap.Point(114.521363, 38.050322), 14);
    map.addControl(new BMap.NavigationControl());
    map.enableScrollWheelZoom();
    $(function () {
        $("#carno").autocomplete({ source: "/car/CarInfoHandler.ashx?action=carno&carno=" + $("#carno").val() }); //由ashx取得资料
        showCarRoute();
    });
    function showCarRoute() {
        $.ajax({
            url: "/car/CarLocationHandler.ashx?" + $("#form1").serialize(),
            success: function (data) {
                map.clearOverlays();

                if (data.resultcode == 1 && data.data.length > 0) {
                    var pts = [];
                    map.centerAndZoom(new BMap.Point(data.data[0].lng, data.data[0].lat), 15);
                    var date = data.data;
                    var routeInfo = "";
                    for (var i = 0; i < date.length; i++) {
                        pts.push(new BMap.Point(date[i].lng, date[i].lat));
                        if (date[i].position) {
                            routeInfo += "<li>【" + date[i].gpstime + "】" + date[i].position + "</li>";
                        } else {
                            routeInfo += "<li>" + "【" + date[i].gpstime + "】定位位置未知</li>";
                        }
                    }
                    var polyline = new BMap.Polyline(pts, { strokeColor: "blue", strokeWeight: 6, strokeOpacity: 0.5 }); //把坐标点用折线划到地图上
                    map.addOverlay(polyline);
                    var myIcon = new BMap.Icon("/Static/images/icon_st.png", new BMap.Size(23, 25), {});
                    var carMk = new BMap.Marker(pts[0], { title: "起点", icon: myIcon });
                    map.addOverlay(carMk);


                    var myIcon = new BMap.Icon("/Static/images/icon_en.png", new BMap.Size(23, 25), {
                        offset: new BMap.Size(10, 25)
                    });
                    var carMk = new BMap.Marker(pts[pts.length - 1], { title: "终点", icon: myIcon });
                    map.addOverlay(carMk);
                    if (pts.length > 1) {
                        for (var i = 1; i < pts.length - 1; i++) {
                            var carMk = new BMap.Marker(pts[i], { title: date[i].position });
                            map.addOverlay(carMk);
                        }
                    }
                    $("#orderinfo").html(routeInfo);
                } else {
                    if (data.resultcode == 0) {
                        $.messager.alert("提示信息", data.msg, function() {
                            map.centerAndZoom(new BMap.Point(114.54731, 38.030315), 15);
                        });
                    } else {
                        $.messager.alert("提示信息",'暂无数据', function () {
                            map.centerAndZoom(new BMap.Point(114.54731, 38.030315), 15);
                        });
                    }


                }
            }
        });
    } 
</script>
