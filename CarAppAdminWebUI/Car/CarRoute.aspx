<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarRoute.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarRoute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="/Static/scripts/jquery.min.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=P0IuySP2OeqbIxwu0H5qjfR6"></script>
    <style type="text/css">
        html
        {
            height: 100%;
        }
        body
        {
            height: 100%;
            margin: 0px;
            padding: 0px;
        }
        #controller
        {
            width: 100%;
            border-bottom: 3px outset;
            height: 30px;
            filter: alpha(Opacity=100);
            -moz-opacity: 1;
            opacity: 1;
            z-index: 10000;
            background-color: lightblue;
        }
        #allmap
        {
            height: 100%;
        }
    </style>
</head>
<body>
    <div id="controller" align="center">
    </div>
    <div id="allmap">
    </div>
    <script type="text/javascript">

        $(function () {
            carrouteList();
        });
        function carrouteList() {
            $.get("/Car/CarLocationHandler.ashx", { "action": "carroute", "r": Math.random(), orderid: "<%=orderid %>", statusid: "<%=statusid %>" }, function (data) {
                var map = new BMap.Map("allmap");
                map.enableScrollWheelZoom();
                map.addControl(new BMap.NavigationControl());
                if (data.resultcode == 0 && data.carlat && data.carlng && data.carposition && data.orderstartlng && data.orderstartlat) {
                    var p1 = new BMap.Point(data.carlng, data.carlat);
                    var p2 = new BMap.Point(data.orderstartlng, data.orderstartlat);

                    var driving = new BMap.DrivingRoute(map, {
                        onSearchComplete: function (results) {
                            if (driving.getStatus() == BMAP_STATUS_SUCCESS) {
                                // 地图覆盖物
                                addOverlays(map, results);
                                var plan = results.getPlan(0);
                                var output = "预计时间是：";
                                output += plan.getDuration(true) + "\n";                //获取时间
                                output += "总路程为：";
                                output += plan.getDistance(true) + "\n";
                                $("#controller").html(output);
                            }
                        }
                    });
                    var point = new BMap.Point(data.carlng, data.carlat);
                    map.centerAndZoom(point, 15);
                    var opts = {
                        position: point,    // 指定文本标注所在的地理位置
                        offset: new BMap.Size(30, -30)    //设置文本偏移量
                    }
                    var label = new BMap.Label("车辆当前位置", opts);  // 创建文本标注对象
                    label.setStyle({
                        color: "red",
                        fontSize: "12px",
                        height: "20px",
                        lineHeight: "20px",
                        fontFamily: "微软雅黑"
                    });
                    map.addOverlay(label);
                    var point = new BMap.Point(data.orderstartlng, data.orderstartlat);
                    var opts = {
                        position: point,    // 指定文本标注所在的地理位置
                        offset: new BMap.Size(30, -30)    //设置文本偏移量
                    }
                    var label = new BMap.Label("乘客预约上车地址", opts);  // 创建文本标注对象
                    label.setStyle({
                        color: "red",
                        fontSize: "12px",
                        height: "20px",
                        lineHeight: "20px",
                        fontFamily: "微软雅黑"
                    });
                    map.addOverlay(label);
                    driving.search(p1, p2);
                    return;
                }
                if (data.showBeforeRoute == 1 && data.resultcode == 0 && data.gpsdata.length>0) {
                    var beforeserviceData = data.gpsdata;
                    var beforeservicepts = [];
                    for (var i = 0; i < beforeserviceData.length; i++) {
                        beforeservicepts.push(new BMap.Point(beforeserviceData[i].lng, beforeserviceData[i].lat));
                    }
                    var beforePolyline = new BMap.Polyline(beforeservicepts, { strokeColor: "green", strokeWeight: 6, strokeOpacity: 0.5 });
                    map.addOverlay(beforePolyline);
                    var myIcon = new BMap.Icon("/Static/map/sendcar.png", new BMap.Size(50, 25), {
                        offset: new BMap.Size(10, 25)
                    });
                    var carMk = new BMap.Marker(beforeservicepts[0], { title: "派车地点", icon: myIcon });
                    map.addOverlay(carMk);
                }
                if (data.resultcode == 0 && data.data.length > 0) {
                    var pts = [];
                    map.centerAndZoom(new BMap.Point(data.startlng, data.startlat), 15);
                    var date = data.data;
                    for (var i = 0; i < date.length; i++) {
                        pts.push(new BMap.Point(date[i].lng, date[i].lat));
                    }
                    var polyline = new BMap.Polyline(pts, { strokeColor: "blue", strokeWeight: 6, strokeOpacity: 0.5 }); //把坐标点用折线划到地图上
                    map.addOverlay(polyline);
                    var myIcon = new BMap.Icon("/Static/images/icon_st.png", new BMap.Size(23, 25), {});
                    var carMk = new BMap.Marker(pts[0], { title: "开始服务地点", icon: myIcon });
                    map.addOverlay(carMk);
                    var myIcon = new BMap.Icon("/Static/images/icon_en.png", new BMap.Size(23, 25), {
                        offset: new BMap.Size(10, 25)
                    });
                    var carMk = new BMap.Marker(pts[pts.length - 1], { title: "服务结束地点", icon: myIcon });
                    map.addOverlay(carMk);
                    if (pts.length > 1) {
                        for (var i = 1; i < pts.length - 1; i++) {
                            var carMk = new BMap.Marker(pts[i]);
                            map.addOverlay(carMk);
                        }
                    }

                  

                } else {
                    map.centerAndZoom(new BMap.Point(114.54731, 38.030315), 15);
                }

            }, "json");

        }

        // 添加覆盖物并设置视野
        function addOverlays(map, results) {
            // 自行添加起点和终点
            var start = results.getStart();
            var end = results.getEnd();
            addStart(map, start.point, start.title);
            addEnd(map, end.point, end.title);
            var viewPoints = [start.point, end.point];
            // 获取方案
            var plan = results.getPlan(0);
            // 获取方案中包含的路线
            for (var i = 0; i < plan.getNumRoutes(); i++) {
                addRoute(map, plan.getRoute(i).getPath());
                viewPoints.concat(plan.getRoute(i).getPath());
            }
            // 设置地图视野
            map.setViewport(viewPoints, {
                margins: [40, 10, 10, 10]
            });
        }


        // 添加起点覆盖物
        function addStart(map, point, title) {
            map.addOverlay(new BMap.Marker(point, {
                title: title,
                icon: new BMap.Icon('/static/map/d-4.png', new BMap.Size(38, 41), {
                    anchor: new BMap.Size(4, 36)
                })
            }));
        }

        // 添加终点覆盖物
        function addEnd(map, point, title) {
            map.addOverlay(new BMap.Marker(point, {
                title: title,
                icon: new BMap.Icon('/static/map/d-2.png', new BMap.Size(38, 41), {
                    anchor: new BMap.Size(4, 36)
                })
            }));
        }

        // 添加路线
        function addRoute(map, path) {
            map.addOverlay(new BMap.Polyline(path, {
                strokeColor: '#00FF00',
                enableClicking: false
            }));
        }
    </script>
</body>
</html>
