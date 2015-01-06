<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="OrderHotspot.aspx.cs" Inherits="CarAppAdminWebUI.Statistics.OrderHotspot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=P0IuySP2OeqbIxwu0H5qjfR6"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/library/Heatmap/2.0/src/Heatmap_min.js"></script>
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">时间</span> <span class="">
                    <input class="adm_21" id="startDate" name="startDate" style="width: 70px;"
                        onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<%=DateTime.Now.ToString("yyyy-MM-01") %>' />至
                    <input class="adm_21" id="endDate" name="endDate" style="width: 70px;" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                         value='<%=DateTime.Now.ToString("yyyy-MM-dd") %>' />
                </span></span><span class="input_blo"><span class="input_text">服务方式</span> <span
                    class="">
                    <select id="caruseway" name="caruseway" style="width: 70px;">
                        <option value="">不限</option>
                        <option value="1">接机</option>
                        <option value="2">送机</option>
                        <option value="4">日租</option>
                        <option value="3">时租</option>
                        <option value="5">半日租</option>
                        <option value="6">热门路线</option>
                        <option value="7">随叫随到</option>
                    </select>
                </span></span><span class="input_blo"><span class="input_text">车辆类型</span> <span
                    class="">
                    <select id="cartype" name="cartype" style="width: 80px;">
                        <option value="">不限</option>
                        <%
                            if (CarType == null)
                            {%>
                        <option value="">请选择</option>
                        <%}
                                        else
                                        {
                                            for (int i = 0; i < CarType.Rows.Count; i++)
                                            {%>
                        <option value="<%=CarType.Rows[i]["id"] %>">
                            <%=CarType.Rows[i]["typename"] %></option>
                        <% }
                                        } %>
                    </select>
                </span></span>
                
                <span class="input_blo"><span class="input_text">车辆类型</span> <span
                    class="">
                    <select id="pointtype" name="pointtype" style="width: 80px;">
                        <option value="up">上车地址</option>
                       <option value="down">下车地址</option>
                    </select>
                </span></span>
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
                    <span class="input_blo"><a href="javascript:onSearchHot()" class="easyui-linkbutton"
                    iconcls="icon-search">查询分布</a></span>
            </div>
        </div>
    </div>
    <div id="baiduMap" style="height: 500px;">
    </div>
    <script type="text/javascript">
        $(function () {

            var height = ($(window).height() - $("#querycontainer").height() - 10);
            $("#baiduMap").css("height", height);
        });

        function onSearch() {
            $.post("HotspotHandler.ashx", { action: "Hotspot", startDate: $("#startDate").val(), endDate: $("#endDate").val(), caruseway: $("#caruseway").val(),
                cartype: $("#cartype").val(), pointtype: $("#pointtype").val()
            }, function (data) {

                if (data.length > 0) {
                    var map = new BMap.Map("baiduMap");          // 创建地图实例

                    var point = new BMap.Point(114.55055, 38.046808);
                    map.centerAndZoom(point, 14);             // 初始化地图，设置中心点坐标和地图级别
                    map.enableScrollWheelZoom(); // 允许滚轮缩放
                    map.addControl(new BMap.NavigationControl());

                    var points = [];  // 添加海量点数据

                    for (i = 0; i < data.length; i++) {
                        points.push(new BMap.Point(data[i].lng, data[i].lat));
                    }
                    var options = {
                        size: BMAP_POINT_SIZE_NORMAL,
                        shape: BMAP_POINT_SHAPE_WATERDROP,
                        color: '#d340c3'
                    }
                    var pointCollection = new BMap.PointCollection(points, options);
                    map.addOverlay(pointCollection);
                }
            }, "json");
        }
        
        function onSearchHot() {
            $.post("HotspotHandler.ashx", { action: "Hotspot", startDate: $("#startDate").val(), endDate: $("#endDate").val(), caruseway: $("#caruseway").val(), cartype: $("#cartype").val() }, function (data) {

                if (data.length > 0) {
                    var map = new BMap.Map("baiduMap");          // 创建地图实例

                    var point = new BMap.Point(114.55055, 38.046808);
                    map.centerAndZoom(point, 14);             // 初始化地图，设置中心点坐标和地图级别
                    map.enableScrollWheelZoom(); // 允许滚轮缩放
                    map.addControl(new BMap.NavigationControl());

                    var points = [];

                    for (i = 0; i < data.length; i++) {
                        points.push({ "lng": data[i].lng, "lat": data[i].lat });
                    }

                    //详细的参数,可以查看heatmap.js的文档 https://github.com/pa7/heatmap.js/blob/master/README.md
                    //参数说明如下:
                    /* visible 热力图是否显示,默认为true
                    * opacity 热力的透明度,1-100
                    * radius 势力图的每个点的半径大小   
                    * gradient  {JSON} 热力图的渐变区间 . gradient如下所示
                    *	{
                    .2:'rgb(0, 255, 255)',
                    .5:'rgb(0, 110, 255)',
                    .8:'rgb(100, 0, 255)'
                    }
                    其中 key 表示插值的位置, 0~1. 
                    value 为颜色值. 
                    */
                    heatmapOverlay = new BMapLib.HeatmapOverlay({ "radius": 30 });
                    map.addOverlay(heatmapOverlay);
                    heatmapOverlay.setDataSet({ data: points, max: 100 }); 
                }
            }, "json");
        }
        function setGradient() {
            /*格式如下所示:
            {
            0:'rgb(102, 255, 0)',
            .5:'rgb(255, 170, 0)',
            1:'rgb(255, 0, 0)'
            }*/
            var gradient = {};
            var colors = document.querySelectorAll("input[type='color']");
            colors = [].slice.call(colors, 0);
            colors.forEach(function (ele) {
                gradient[ele.getAttribute("data-key")] = ele.value;
            });
            heatmapOverlay.setOptions({ "gradient": gradient });
        }
       
    </script>
</asp:Content>
