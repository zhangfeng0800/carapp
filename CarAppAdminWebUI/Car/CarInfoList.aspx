<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CarInfoList.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarInfoList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;份</span>
                    <span class="">
                        <select class="adm_21" style="width: 80px;" id="province" name="province">
                        </select>
                    </span></span><span class="input_blo"><span class="input_text">城&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;市</span>
                        <span class="">
                            <select class="adm_21" id="city" name="city" style="width: 80px;">
                            </select></span> </span><span class="input_blo"><span class="input_text">区&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;县</span>
                                <span class="">
                                    <select class="adm_21" style="width: 80px;" id="town" name="town">
                                    </select>
                                </span></span><span class="input_blo"><span class="input_text">车辆名称</span> <span
                                    class="">
                                    <select class="adm_21" name="carname" id="carname">
                                        <option value="">不限</option>
                                        <%for (int i = 0; i < dtbrand.Rows.Count; i++)
                                          { %>
                                        <option value='<%=dtbrand.Rows[i]["brandName"] %>'>
                                            <%=dtbrand.Rows[i]["brandName"]%></option>
                                        <%} %>
                                    </select>
                                </span></span><span class="input_blo"><span class="input_text">车辆类型</span> <span
                                    class="">
                                    <select class="adm_21" id="cartype" name="cartype" style="width: 80px;">
                                    </select>
                                </span></span><span class="input_blo"><span class="input_text">目前所在城市</span> <span
                                    class="">
                                    <input class="adm_21" type="text" id="nowcityname" name="nowcityname" style="width: 80px;" />
                                </span></span><span class="input_blo"><span class="input_text">车辆状态</span> <span
                                    class="">
                                    <select class="adm_21" id="carstatus" name="carstatus" style="width: 80px;">
                                        <option value="">不限</option>
                                        <option value="1">工作中</option>
                                        <option value="2">离开或请假</option>
                                        <option value="3">可以接单/空闲中</option>
                                        <option value="4">已出发</option>
                                        <option value="5">已经就位</option>
                                        <option value="6">订单已接取</option>
                                        <option value="8">租出</option>
                                        <option value="9">借出</option>
                                        <option value="7">其它</option>
                                       
                                    </select>
                                </span></span><span class="input_blo"><span class="input_text">电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话</span>
                                    <span class="">
                                        <input class="adm_21" type="text" id="telphone" name="telphone" style="width: 80px;" />
                                    </span></span><span class="input_blo"><span class="input_text">服务类型</span> <span
                                        class="">
                                        <select id="useway" name="useway">
                                            <option value="">不限</option>
                                            <option value="A">热门线路</option>
                                            <option value="B">其他</option>
                                        </select>
                                    </span></span><span class="input_blo"><span class="input_text">车&nbsp;&nbsp;牌&nbsp;&nbsp;号</span>
                                        <span class="">
                                            <input class="adm_21" id="carNo" name="carNo" type="text" style="width: 80px;" />
                                        </span></span><span class="input_blo"><span class="input_text">司机姓名</span> <span
                                            class="">
                                            <input class="adm_21" id="driverName" name="driverName" type="text" style="width: 80px;" />
                                        </span></span><span class="input_blo"><span class="input_text">司机登录状态</span> <span
                                            class="">
                                            <select class="adm_21" id="driverState" name="driverState" type="text">
                                                <option value="">不限</option>
                                                <option value="1">已登录</option>
                                                <option value="0">未登录</option>
                                            </select>
                                        </span></span><span class="input_blo"><span class="input_text">开始时间</span> <span
                                            class="">
                                            <input class="adm_21 Wdate" id="startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                                                name="startDate" type="text" style="width: 100px;" />
                                        </span></span><span class="input_blo"><span class="input_text">结束时间</span> <span
                                            class="">
                                            <input class="adm_21 Wdate" id="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                                                name="endDate" type="text" style="width: 100px;" />
                                        </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                                            iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                 <%if(groupId == 1){
                    %>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">编辑</a>
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove" style="display: none;">删除</a>
                    <% } %>
                    <a href="javascript:onBrandChat()" class="easyui-linkbutton" iconcls="icon-search">查看车型汇总</a>
                    <a href="javascript:getgpsinfo()" class="easyui-linkbutton" iconcls="icon-search">导入车辆GPS信息</a>
                </td>
                <td>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    
    <div id="addwindow" title="添加新的车辆信息" style="width: 600px; height: 340px;">
    </div>
    <div id="editwindow" title="编辑车辆信息" style="width: 600px; height: 370px;">
    </div>
    
    <div id="gpswindow" title="车辆实时位置信息" style="width: 600px; height: 300px;">
    </div>
    <div id="w" class="easyui-window" title="查看服务路线" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 350px; height: 350px;">
        <span>
            <table id="tbhotline">
            </table>
        </span>
    </div>
    <div id="Div1" class="easyui-window" title="车辆公里数和金额" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 600px; height: 500px;">
        <span>
            <table id="kmmoeny">
            </table>
        </span>
    </div>
    <div id="chat" class="easyui-window" title="查看车型汇总" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 1000px; auto; height: 550px;">
        <div id="mychat" style="width: 100%; height: 500px;">
        </div>
    </div>

    <div id="carOrderswindow" class="easyui-window" title="租车订单" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 1000px; height: 550px;">
        
            <table id="carOrders" style=" height:500px;">
            </table>
        
    </div>

    <script src="../Static/scripts/echarts-plain.js" type="text/javascript"></script>
    <script src="../Static/scripts/lodash.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        //初始化
        $(function () {
            initProvinceSelectValue("province", "不限", "13");
            initCitySelect("city", "不限", "13", "1301");
            initCitySelect("town", "不限", "1301", "");

            citySelectChange("province", "city", "town", "不限");
            citySelectChange("city", "town", "", "不限");


            resizeTable();
            bindGrid();
            bindWin();
            initCarType();
        });
        function bindWin() {
            $("[id$=window]").window({
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closed: true
            });
        }
        function resizeTable() {
            var height = $(window).height() - $("#querycontainer").height() - 10;
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }

        function onBrandChat() {
            getBrandData("mychat");
            $("#chat").window("open");
        }
        function getgpsinfo() {
            $.ajax({
                url: "/car/carinfohandler.ashx?action=gps",
                success: function (data) {
                    if (data == 1) {
                        $.messager.alert("提示信息", "操作成功");
                    } else {
                        $.messager.alert("提示信息", "操作失败请重试");
                    }
                }
            });
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Car/CarInfoHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                showFooter: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                toolbar: "#toolbar",
                title: "车辆信息管理",
                frozenColumns: [[
                    { field: 'ck', checkbox: true },
                    { field: 'carNo', title: '车牌号', width: 100 }
                ]],
                columns: [
                    [
                        { field: 'CityName', title: '所属城市', width: 100 },
                        { field: 'telPhone', title: '电话号码', width: 100 },
                        { field: 'brandName', title: '名称', width: 100 },
                        { field: 'CarType', title: '车辆类型', width: 120 },
                        { field: 'CarUseName', title: '服务类型', width: 100 },
                        { field: 'HotLines', title: '服务的热门线路', width: 100, formatter: fhotline },
                        { field: 'CarWorkStatusName', title: '车辆状态', width: 100 },
                                        { field: 'id', title: '行驶轨迹', width: 100, formatter: fcarid },
                        {field: 'vid', title: '目前具体位置', width: 100, formatter: fcurrentLocation },
                //                        { field: 'updateTime', title: '最后更新时间', formatter: formattime },
                        {field: 'drivername', title: '当前司机', width: 100, formatter: driverlink },
                    
                        { field: 'orderNum', title: '租用次数',sortable: true, width: 100 ,formatter:fordernum},
                        { field: 'useKm', title: '车辆公里数(Km)',sortable: true, width: 100, formatter: getDayKm },
                        { field: 'moneys', title: '订单金额(元)',sortable: true, width: 100 }
                  
                     
                     
                    ]
                ]
            });
        }
        function fcarid(value, row, index) {
            return "<a href=\"javascript:showcarRoute('"+value+"');\">查看行驶轨迹</a>";
        }
        function showcarRoute(carid) {
            top.addTab("车辆轨迹查询", "/Car/CarRouteQuery.aspx?id=" + carid, "icon-nav");
        }
        function fordernum(value, row, index) {
        if (value) {
               if (value != 0) {
                return "<a style='text-decoration:underline;cursor:pointer;'   onclick='showOrderList(\"" + row.carNo + "\")'>" + value + "</a>";
            }
        }
         
        }
        function showOrderList(carNo) {
            $('#carOrderswindow').window('open');
            $('#carOrders').datagrid({
                url: "/Car/CarInfoHandler.ashx?action=aboutOrder&carNo=" + carNo + "&startdate=" + $("#startDate").val() + "&enddate=" + $("#endDate").val(),
                method: 'post',
                title: "相关订单记录",
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                frozenColumns: [[
                   { field: 'orderId', title: '订单编号', formatter: forderid }
                ]],
                columns: [[
                { field: 'orderDate', title: '下单时间', width: 200, formatter: easyui_formatterdate },
                { field: 'caruseway', title: '租车类型', width: 100 },
                { field: 'orderMoney', title: '订单额（元）', width: 100 },
                { field: "unpaidMoney", title: "二次付款金额（元）" },
                { field: "totalMoney", title: "订单总额（元）" },
                { field: 'passengerName', title: '乘车人', width: 100 }
            ]]
            });
        }
        function forderid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.orderId + "\")'>" + value + "</a>";
            return html;
        }
        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }
        function fcurrentLocation(value, row, index) {
            if (value == "") {
                return "";
            }
            return "<a style=\"text-decoration:underline\" href=\"javascript:ongpsvid(" + value + ");\">查看当前位置</a>";
        }

        function ongpsvid(value) {
            $('#gpswindow').window('open');
            $('#gpswindow').window('refresh', '/Car/Carcurrentlocation.aspx?vid=' + value);
        }
        function driverlink(value, row, index) {
            if (value != "司机未登录") {
                var html = "<a title='点击查看司机信息' style=\"text-decoration:underline\" href='javascript:onShowDriver(\"" + row.jobnumber + "\")'>" + value + "</a>";
                return html;
            }
            return value;
        }
        //查看每天里程和订单金额
        function getDayKm(value, row, rowindex) {
            if (value == '') {
                return "";
            }
            if (isNaN(value)) {
                return value;
            }
            return "<a style=\"text-decoration:underline\" href='javascript:getKmMoney(\"" + row.id + "\",\"" + row.carNo + "\")'>" + value + "</a>";
        }
        function getKmMoney(id, carNo) {
            var stardate = $("#startDate").val();
            var enddate = $("#endDate").val();
            //绑定数据表格
            $('#kmmoeny').datagrid({
                url: "/Car/CarInfoHandler.ashx?action=kmmoney&Id=" + id + "&startDate=" + stardate + "&endDate=" + enddate + "",
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: carNo,
                columns: [
                    [
                        { field: 'useKm', title: '公里数(Km)', width: 150 },
                        { field: 'orderMoney', title: '预付款(元)', width: 150 },
                        { field: 'unpaidMoney', title: '二次付款(元)', width: 150 }
                    ]
                ]
            });
            $("#Div1").window("open");
        }


        function onShowDriver(id) {
            top.addTab("司机详细(ID:" + id + ")", "/Car/DriverDetail.aspx?id=" + id, "icon-nav");
        }

        function fhotline(value, rowdata, rowindex) {
            if (value == '') {
                return "";
            }
            return "<a  style=\"text-decoration:underline\" href=\"javascript:onDetail('" + value + "')\">点击查看</a>";
        }
        function formattime(value, row, index) {
            if (value != "" && value != null) {
                return easyui_formatterdate(value, null, null);
            } else {
                return "";
            }
        }

        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/CarInfoHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Car/CarInfoAdd.aspx');
        }
        function onDetail(value) {
            //绑定数据表格

            $('#tbhotline').datagrid({
                url: "/Car/CarInfoHandler.ashx?action=hotlinelist&value=" + value,
                method: 'post',
                pagination: false,

                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "",
                columns: [
                    [
                        { field: 'cityName', title: '出发城市', width: 150 },
                        { field: 'hotlineName', title: '热门线路名称', width: 150 }
                    ]
                ]
            });
            $("#w").window("open");
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Car/CarInfoEdit.aspx?id=' + row.id);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "此项操作会删除此信息,并且此操作不可恢复，你确定要执行此操作么？", function (r) {
                if (r) {
                    $.post("/Car/CarInfoHandler.ashx", { "action": "delete", "id": row.id }, function (data) {
                        if (data.IsSuccess) {
                            $.messager.alert('消息', '操作成功！', 'info', function () {
                                onSearch();
                            });
                        } else {
                            $.messager.alert('消息', data.Message, 'error');
                        }
                    }, "json");
                }
            });
        }

        function initCarType() {
            $.get("/Ajax/GetCarType.ashx", null, function (data) {
                $("#cartype").empty();
                var pro = "";
                pro += '<option value="">不限</option>';
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].id + '>';
                    pro += data[i].typeName;
                    pro += '</option>';
                }
                $("#cartype").append(pro);
            }, "json");
        }
        function selectChange1(ind) {
            var pid = $("#addprovenceID" + ind).val();
            if (pid != "") {
                $.get("/Ajax/GetCitys.ashx", { "pid": pid }, function (data) {
                    $("#addcityID1" + ind).empty();
                    $("#addcityID1" + ind).append('<option value="">请选择</option>');
                    $("#addcityID" + ind).empty();
                    $("#addcityID" + ind).append('<option value="">请选择</option>');
                    $("#addhotline" + ind).empty();
                    $("#addhotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].codeid + '>';
                        pro += data[i].cityname;
                        pro += '</option>';
                    }
                    $("#addcityID1" + ind).append(pro);
                }, "json");
            } else {
                $("#addcityID1" + ind).empty();
                $("#addcityID1" + ind).append('<option value="">请选择</option>');
                $("#addcityID" + ind).empty();
                $("#addcityID" + ind).append('<option value="">请选择</option>');
                $("#addhotline" + ind).empty();
                $("#addhotline" + ind).append('<option value="">请选择</option>');
            }
        }

        function selectChange2(ind) {
            var pid = $("#addcityID1" + ind).val();
            if (pid != "") {
                $.get("/Ajax/GetCitys.ashx", { "pid": pid }, function (data) {
                    $("#addcityID" + ind).empty();
                    $("#addcityID" + ind).append('<option value="">请选择</option>');
                    $("#addhotline" + ind).empty();
                    $("#addhotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].codeid + '>';
                        pro += data[i].cityname;
                        pro += '</option>';
                    }
                    $("#addcityID" + ind).append(pro);
                }, "json");
            } else {
                $("#addcityID" + ind).empty();
                $("#addcityID" + ind).append('<option value="">请选择</option>');
                $("#addhotline" + ind).empty();
                $("#addhotline" + ind).append('<option value="">请选择</option>');
            }
        }

        function selectChange3(ind) {
            var pid = $("#addcityID" + ind).val();
            if (pid != "") {
                $.get("/Car/CarInfoHandler.ashx?action=servicecitylist", { "pid": pid }, function (data) {
                    $("#addhotline" + ind).empty();
                    $("#addhotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].id + '>';
                        pro += data[i].cityName + "-" + data[i].HotlineName;
                        pro += '</option>';
                    }
                    $("#addhotline" + ind).append(pro);
                }, "json");
            } else {
                $("#addhotline" + ind).empty();
                $("#addhotline" + ind).append('<option value="">请选择</option>');
            }
        }

        function getBrandData(container) {
            $.ajax({
                url: "/car/CarInfoHandler.ashx",
                data: { action: "carBrandChat" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    var datas = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.brandName);
                        ydata.push(val.num);
                        datas.push({ value: val.num, name: val.brandName });
                    });
                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}：{c}辆"
                        },
                        toolbox: {
                            show: true,
                            feature: {
                                dataView: { show: true, readOnly: false, lang: ['数据视图', '关闭', '刷新'] },
                                restore: { show: true, title: "刷新" },
                                saveAsImage: { show: true }
                            }
                        },
                        title: {
                            text: "车型汇总",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: xdata
                        },
                        series: [
                            {
                                "type": "pie",
                                "data": datas,
                                radius: '55%',
                                center: ['50%', 200],
                                itemStyle: {
                                    normal: {
                                        label: {
                                            position: 'outer',
                                            formatter: function (a, b, c, d) { return b + "：" + c + "辆(" + (d - 0).toFixed(2) + '%)'; }
                                        },
                                        labelLine: {
                                            show: false
                                        }
                                    },
                                    emphasis: {
                                        label: {
                                            show: true,
                                            formatter: function (a, b, c, d) { return b + "：" + c + "辆(" + (d - 0).toFixed(2) + '%)'; }
                                        }
                                    }

                                }
                            }
                        ]
                    };
                    myChart.setOption(option);
                }
            });
        }
    </script>
</asp:Content>
