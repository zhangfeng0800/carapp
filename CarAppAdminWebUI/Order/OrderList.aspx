<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="OrderList.aspx.cs" Inherits="CarAppAdminWebUI.Order.OrderList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script type="text/javascript" src="/Static/easyui/datagrid-detailview.js"></script>
    <script src="/Static/center/Scripts/jquery.signalR-1.1.4.min.js" type="text/javascript"></script>
    <script src="/Signalr/Hubs"></script>
    <script src="/Static/center/Scripts/artDialog4.1.7/jquery.artDialog.source.js?skin=default"
        type="text/javascript"></script>
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">时间</span> <span class="">
                    <input class="adm_21" id="startDate" name="startDate" style="width: 70px;" readonly="readonly"
                        onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />至
                    <input class="adm_21" id="endDate" name="endDate" style="width: 70px;" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                        readonly="readonly" />
                </span></span><span class="input_blo"><span class="input_text">下&nbsp;&nbsp;单&nbsp;&nbsp;人</span>
                    <span class="">
                        <input class="adm_21" id="username" name="username" style="width: 55px;" />
                    </span></span><span class="input_blo"><span class="input_text">乘&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客</span>
                        <span class="">
                            <input class="adm_21" id="sname" name="sname" type="text" value="" style="width: 55px;" />
                        </span></span><span class="input_blo"><span class="input_text">会员电话</span> <span
                            class="">
                            <input class="adm_21" id="usertel" name="usertel" type="text" value="" style="width: 55px;" />
                        </span></span><span class="input_blo"><span class="input_text">乘客电话</span> <span
                            class="">
                            <input class="adm_21" id="passenagertel" name="passenagertel" type="text" value=""
                                style="width: 55px;" />
                        </span></span><span class="input_blo" style="display: none;"><span class="input_text">
                            出发城市</span> <span class="">
                                <input class="adm_21" id="startaddress" name="startaddress" type="text" value=""
                                    style="width: 55px;" />
                            </span></span><span class="input_blo" style="display: none;"><span class="input_text">
                                目的城市</span> <span class="">
                                    <input class="adm_21" id="targetaddress" name="targetaddress" type="text" value=""
                                        style="width: 55px;" />
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
                                        <option value="8">顺风车</option>
                                    </select>
                                </span></span><span class="input_blo" style="display: none;"><span class="input_text">
                                    付款状态</span> <span class="">
                                        <select id="payStatus" name="payStatus" style="width: 80px;">
                                            <option value="">不限</option>
                                            <option value="0">未支付</option>
                                            <option value="1">已支付</option>
                                            <option value="2">现金支付给司机</option>
                                            <option value="3">现金支付完成</option>
                                        </select>
                                    </span></span><span class="input_blo"><span class="input_text">订单状态</span> <span
                                        class="">
                                        <select class="adm_21" id="orderStatusID" name="orderStatusID" style="width: 80px;">
                                            <option value="">不限</option>
                                            <option value="1">等待付款</option>
                                            <option value="2">等待服务</option>
                                            <option value="3">服务中</option>
                                            <option value="4">服务结束</option>
                                            <option value="5">服务取消</option>
                                            <option value="6">订单完成</option>
                                            <%--   <option value="7">司机等待</option>--%>
                                            <option value="8" selected="selected">等待派车</option>
                                            <option value="9">二次付款</option>
                                            <option value="10">司机已经出发</option>
                                            <option value="11">司机已经就位</option>
                                            <option value="12">订单已经接取</option>
                                            <option value="99">订单过期</option>
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
                                    </span></span><span class="input_blo" style="display: none;"><span class="input_text">
                                        客户类型</span> <span class="">
                                            <select id="usertypename" name="usertypename" style="width: 60px;">
                                                <option value="-1">不限</option>
                                                <option value="0">集团管理员</option>
                                                <option value="1">部门经理</option>
                                                <option value="2">部门员工</option>
                                                <option value="3">普通用户</option>
                                            </select>
                                        </span></span><span class="input_blo"><span class="input_text">订单编号</span> <span
                                            class="">
                                            <input class="adm_21" id="orderid" name="orderid" type="text" value="" style="width: 60px;" />
                                        </span></span><span class="input_blo"><span class="input_text">车牌号</span> <span class="">
                                            <input class="adm_21" id="carNo" name="carNo" type="text" value="" style="width: 60px;" />
                                        </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                                            iconcls="icon-search">查询</a></span> <span class="input_blo"><a href="javascript:$('#orderStatusID').val('2');onSearch(2,'#unAcessNum')"
                                                class="easyui-linkbutton" iconcls="icon-search">已经派车未接取订单<span id="unAcessNum"></span></a></span>
                <span class="input_blo"><a href="javascript:$('#orderStatusID').val('8');onSearch(8,'#waitsendcar')"
                    class="easyui-linkbutton" iconcls="icon-search">等待派车订单<span id="waitsendcar"></span></a></span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td colspan="12">
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>
                    <a href="javascript:onSentCar()" class="easyui-linkbutton" iconcls="icon-remove">派车</a>
                    <a href="javascript:onMapSentCar()" class="easyui-linkbutton" iconcls="icon-remove">
                        地图派车</a> <a href="javascript:onCancelOrderU()" class="easyui-linkbutton" iconcls="icon-remove">
                            取消订单(替客户取消)</a> <a href="javascript:onCancelOrder()" class="easyui-linkbutton" iconcls="icon-remove">
                                取消订单(全额退款)</a> <a href="javascript:onReSentCar()" class="easyui-linkbutton" iconcls="icon-remove">
                                    更改派遣车辆</a> <a href="javascript:onMapReSentCar()" class="easyui-linkbutton" iconcls="icon-remove">
                                        订单地图改派</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="carwindow" title="派车(车辆信息仅供参考,请以实际情况为准)" style="width: 900px; height: 500px;">
    </div>
    <div id="editwindow" title="编辑订单信息" style="width: 600px; height: 400px;">
    </div>
    <div id="recarwindow" title="更改派遣车辆">
    </div>
    <div id="w" class="easyui-window" title="当前司机信息" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 250px; height: 250px;">
        <table id="tbhotline" style="width: 100%; border: 1px solid #95B8E7;">
        </table>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            resizeCarWindow();
            resizeReSendCarWindow();
            initProvinceSelect("provenceID", "不限");
            bindGrid();
            bindWin();

            //更新派车未接单状态订单数量
            $.post("/Order/OrderHandler.ashx", { "action": "list", "orderStatusID": "2", "page": "1", "rows": "1", "username": "", "usertypename": "-1" }, function (data) {
                $("#unAcessNum").html("(" + data.total + ")");
            }, "json");
            setInterval(bindGrid, 30000);
        });
        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
        }
        function bindWin() {
            $("[id$=window]").window({
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closed: true
            });
        }
        //绑定数据表格
        function bindGrid() {

            $('#gdgrid').datagrid({
                url: "/Order/OrderHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                singleSelect: true,
                fitColumns: false,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "订单管理",
                toolbar: "#toolbar",
                showFooter: false,
                frozenColumns: [[
                { field: 'ck', checkbox: true, width: 50 },
                { field: 'orderId', title: '查看详情', width: 100, formatter: forderid },
                { field: 'passengerName', title: '乘车人', width: 70 },
                { field: 'passengerPhone', title: '乘车人电话', width: 120, formatter: fpassengerphone }
                ]],
                columns: [
                [
                 { field: 'departureTime', title: '预约出发时间', width: 130, formatter: easyui_formatterdate, sortable: true },
                  { field: 'caruseway', title: '服务方式', width: 70, formatter: onShowTimelyFormatter },
                  { field: 'typeName', title: '车辆类型', width: 100 },
                { field: 'username', title: '订单人', width: 70, formatter: getUserName },
                { field: "telphone", title: "下单人电话", width: 85, formatter: fusertelphone },
                { field: 'orderDate', title: '下订单时间', width: 130, formatter: easyui_formatterdate, sortable: true },
                //                { field: 'cityname', title: '出发城市', width: 80 },
                //                { field: 'targetCity', title: '目的城市', width: 80 },
                {field: 'jobnumber', title: '司机信息', width: 60, formatter: driverContact },
                //                { field: 'usertype', title: '客户类型', width: 100 },
                {field: 'passengerNum', title: '乘车人数', width: 60 },
                { field: 'orderMoney', title: '预付款（元）', width: 90, formatter: toFloat },
                { field: 'totalMoney', title: '总额（元）', width: 80, formatter: totalMoneyToFloat },
                { field: 'orderStatusID', title: '订单状态', width: 80, formatter: forderStatusID },
                { field: 'smsreceiver', title: '查看轨迹', width: 60, formatter: forderroute }
                    ]
                ]
                //                ,
                //                detailFormatter: function (rowIndex, rowData) {
                //                    return '<table>'
                //                     + '<tr>'
                //                     + '<td style="border:0;padding:3px"><b>上车地址:</b> ' + getstring(rowData.startAddress) + '</td>'
                //                     + '<td style="border:0;padding:3px"><b>下车地址: </b>' + getstring(rowData.arriveAddress) + '</td>'
                //                     + '<td style="border:0;padding:3px"><b>订单留言: </b>' + getstring(rowData.orderMessage) + '</td>'
                //                     + '</tr>'
                //                     + '<tr>'
                //                     + '<td style="border:0;padding:3px"><b>预约时间: </b>' + formatterdate(rowData.departureTime) + '</td>'
                //                     + '<td style="border:0;padding:3px;display:none"><b>接机时间:</b> ' + formatterdate(rowData.pickupTime) + '</td>'
                //                     + '<td style="border:0;padding:3px"><b>机场编号: </b>' + getstring(rowData.airportID) + '</td>'
                //                     + '</tr>'
                //                     + '<tr>'
                //                     + '<td style="border:0;padding:3px"><b>额外服务费用: </b>' + rowData.extraFee + '</td>'
                //                     + '<td style="border:0;padding:3px"><b>数据库编号: </b>' + getstring(rowData.id) + '</td>'
                //                     + '<td style="border:0;padding:3px"><b>备注: </b>' + getstring(rowData.remarks) + '</td>'
                //                     + '</tr>'
                //                     + '<tr>'
                //                     + '<td style="border:0;padding:3px"><b>用车时长: </b>' + getstring(rowData.useHour) + '</td>'
                //                     + '<td style="border:0;padding:3px"><b>发票: </b>' + getstring(rowData.invoiceID) + '</td>'
                //                     + '<td style="border:0;padding:3px"><b>未付金额: </b>' + toFloat(getstring(rowData.unpaidMoney)) + '元</td>'
                //                     + '</tr>'

                //                     + '</table>';
                //                }
            });
        }
        function totalMoneyToFloat(value, row, index) {
            if (value == "total") {
                return "";
            }
            if (row.orderStatusID != 6 && row.orderStatusID != 5) {
                return 0;
            }
            if (value == "total") {
                return "";
            }
            if (value == "") {
                return "0";
            } else {
                if (parseFloat(value)) {
                    return parseFloat(value).toFixed(2);
                } else {
                    return 0;
                }
            }
        }
        function toFloat(value, row, index) {

            if (value == "total") {
                return "";
            }
            if (value == "") {
                return "0";
            } else {
                if (parseFloat(value)) {
                    return parseFloat(value).toFixed(2);
                } else {
                    return 0;
                }
            }
        }
        ///得到司机联系方式
        function driverContact(value, row, index) {
            if (value) {
                return "<a  style=\"text-decoration:underline\" href=\"javascript:onDetail('" + row.orderId + "')\">点击查看</a>";
            }
        }
        function onDetail(orderId) {
            //绑定数据表格
            var html = "";
            $.post("/Order/OrderHandler.ashx", { "action": "driverContact", "value": orderId }, function (data) {
                html += "<tr><td style='border-right:1px dashed #ccc; border-bottom:1px dashed #ccc; width:50%;'>司机姓名</td><td style='border-bottom:1px dashed #ccc; width:50%;'>" + data.driverName + "</td></tr>";

                html += "<tr><td  style='border-right:1px dashed #ccc; border-bottom:1px dashed #ccc; width:50%;'>车辆手机</td><td style='border-bottom:1px dashed #ccc; width:50%;'>" + data.carPhone + "</td></tr>";

                html += "<tr><td  style='border-right:1px dashed #ccc; width:50%;'>私人手机</td><td style='width:50%;'>" + data.driverPhone + "</td ></tr>";
                $("#tbhotline").html(html);
                $("#w").window("open");
            }, "json");
        }

        function getUserName(value, row, index) {
            if (value) {
                var html = "<a title='点击查看用户信息' style=\"text-decoration:underline\" href='javascript:onShowUser(\"" + row.userID + "\")'>" + value + "</a>";

                return html;
            } else {
                return '';
            }


        }
        function onShowTimelyFormatter(value, row, index) {
            if (value == "随叫随到") {
                return "<span style='color:red;'>" + value + "</span>";
            } else {
                return value;
            }
        }
        function formatterMoney(value, row, index) {
            if (index == 0 && row.caruseway == '') {
                return '';
            } else {
                return value;
            }
        }
        /*formatter*/
        function forderStatusID(value, row, index) {
            if (value == 99) {
                return '订单过期';
            }
            var status = new Array("等待付款", "等待服务", "服务中", "服务结束", "服务取消", "订单完成", "司机等待", "<span style='color:red;'>等待派车</span>", "二次付款中", '司机已经出发', '司机已经就位', "订单已经接取");
            return status[value - 1];

        }
        function fpaystatus(value, row, index) {
            var status = new Array("<span style='color:red;'>未支付</span>", "已支付", "现金支付给司机", "现金支付完成");
            return status[value];
        }
        function fusertype(value, row, index) {
            var status = new Array("集团管理员", "部门经理", "部门员工", "个人用户");
            return status[value];
        }

        function fuserID(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a href='javascript:onShowUser(" + value + ")'>查看</a>";
            return html;
        }

        function forderid(value, row, index) {
            if (value.indexOf("订单总数") > -1) {
                return value;
            }

            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.orderId + "\")'>查看</a>";
            return html;
        }
        function forderroute(value, row, index) {

            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowRoute(\"" + row.orderId + "\",\"" + row.orderStatusID + "\")'>查看</a>";
            return html;


        }
        function onShowRoute(id, statusid) {
            top.addTab("订单路径(ID:" + id + ")", "/car/carroute.aspx?orderid=" + id + "&statusid=" + statusid, "icon-nav");
        }
        function fusertelphone(value, row, index) {
            if (!value) {
                return "";
            }
            if ("<%=Exten %>" != "") {
                return "<a style=\"text-decoration:underline\" title=\"点击回拨\" href='javascript:callback(\"" + value + "\")'>" + value + "【点击回拨】</a>";
            } else {
                return value;
            }
        }

        function fpassengerphone(value, row, index) {
            if (value.indexOf('元') > 0) {
                return value;
            }
            if ("<%=Exten %>" != "") {
                return "<a style=\"text-decoration:underline\" title=\"点击回拨\" href='javascript:callback(\"" + value + "\")'>" + value + "【点击回拨】</a>";
            } else {
                return value;
            }
        }
        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }

        function formatterdate(val) {
            return easyui_formatterdate(val, null, null);
        }

        function getstring(value) {
            if (value == null || value == "") {
                return "暂无";
            }
            return value;
        }

        function onShowUser(id) {
            top.addTab("会员详细(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }

        //搜索
        function onSearch(val, control) {
            $("#gdgrid").datagrid("options").url = "/Order/OrderHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
            //更新派车未接单状态订单数量

            if (val && control) {
                $.post("/Order/OrderHandler.ashx", { "action": "list", "orderStatusID": val, "page": "1", "rows": "1", "username": "", "usertypename": "-1" }, function (data) {
                    $(control).html("(" + data.total + ")");
                }, "json");
            }

        }
        function onEdit() {
            edit("gdgrid", "editwindow", "orderId", "/Order/OrderEdit.aspx?id=");
        }

        /* 派车 */
        function onSentCar() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            if (row.orderStatusID != 8) {
                $.messager.alert('消息', '只有等待派车的订单才能进行派车操作', 'error');
                return;
            }
            /* 窗口最大化 */
            //$('#carwindow').window({ "maximized": true }); 

            $('#carwindow').window('open');

            $('#carwindow').window('refresh', '/Order/OrderSentCar.aspx?id=' + row.orderId + "&rentcarid=" + row.rentCarID);
        }

        function onMapSentCar() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            if (row.orderStatusID != 8) {
                $.messager.alert('消息', '只有等待派车的订单才能进行派车操作', 'error');
                return;
            }
            /* 窗口最大化 */
            //$('#carwindow').window({ "maximized": true }); 
            top.addTab("新订单地图派车" + row.orderId, "/order/MapRentCar.aspx?orderid=" + row.orderId, "icon-nav");
        }
        function resizeCarWindow() {
            var height = $(window).height();

            var width = $(window).width();
            $("#carwindow").css("width", width);
            $("#carwindow").css("height", height);
        }
        function resizeReSendCarWindow() {
            var height = $(window).height() - 20;

            var width = $(window).width() - 50;
            $("#recarwindow").css("width", width);
            $("#recarwindow").css("height", height);
        }
        /* 更改派车信息 */
        function onReSentCar() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            if (row.orderStatusID != 2) {
                $.messager.alert('消息', '只有等待服务的车辆订单才能进行更改车辆', 'error');
                return;
            }
            /* 窗口最大化 */
            //$('#carwindow').window({ "maximized": true });
            $('#recarwindow').window('open');
            $('#recarwindow').window('refresh', '/Order/OrderReSentCar.aspx?id=' + row.orderId + "&rentcarid=" + row.rentCarID);
        }
        function onMapReSentCar() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            if (row.orderStatusID != 2) {
                $.messager.alert('消息', '只有等待服务的车辆订单才能进行更改车辆', 'error');
                return;
            }
            top.addTab("新订单地图派车" + row.orderId, "/order/MapResentCar.aspx?orderid=" + row.orderId, "icon-nav");
        }
        /* 取消订单 8 */
        function onCancelOrder() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "你确定要取消此订单么？注意：此处取消会全额给客户退款", function (r) {
                if (r) {
                    $.post("/Order/OrderHandler.ashx", { "action": "cancelorder", "id": row.orderId }, function (data) {
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
        /* 取消订单 8 */
        function onCancelOrderU() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }

            $.messager.confirm("提示", "你确定要取消此订单么？此处取消会按照扣款规则扣除部分费用", function (r) {
                if (r) {
                    $.post("/Order/OrderHandler.ashx", { "action": "cancelorderU", "id": row.orderId }, function (data) {
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



        function onDelete() {
            ajaxdelete("rentCar", "id", "id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onShowUser(id) {
            top.addTab("会员详细(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }
        function callback(telphone) {
            $.ajax({
                url: "/ajax/callback.ashx?callee=" + telphone + "&caller=<%=Exten %>&timestamp=" + Date.parse(new Date()),
                success: function (data) {
                    if (data.resultcode == 0) {
                        alert("回呼失败");
                    } else {
                        alert("操作成功");
                    }
                }
            });
        }
        artDialog.notice = function (options) {
            var opt = options || {},
                api, aConfig, hide, wrap, top,
                duration = 800;

            var config = {
                id: 'Notice',
                left: '100%',
                top: '100%',
                fixed: true,
                drag: true,
                resize: false,
                follow: null,
                lock: false,
                init: function (here) {
                    api = this;
                    aConfig = api.config;
                    wrap = api.DOM.wrap;
                    top = parseInt(wrap[0].style.top);
                    hide = top + wrap[0].offsetHeight;

                    wrap.css('top', hide + 'px')
                        .animate({ top: top + 'px' }, duration, function () {
                            opt.init && opt.init.call(api, here);
                        });
                },
                close: function (here) {
                    wrap.animate({ top: hide + 'px' }, duration, function () {
                        opt.close && opt.close.call(this, here);
                        aConfig.close = $.noop;
                        api.close();
                    });

                    return false;
                }
            };

            for (var i in opt) {
                if (config[i] === undefined) config[i] = opt[i];
            };

            return artDialog(config);
        };

        var ordermsgHub = $.connection.orderMsgHub;
        ordermsgHub.client.notice = function (message) {
            $("#gdgrid").datagrid("options").url = "/Order/OrderHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
            console.log(message);
//            var msg = message;
//            art.dialog.notice({
//                title: '提示信息',
//                width: 250, // 必须指定一个像素宽度值或者百分比，否则浏览器窗口改变可能导致artDialog收缩
//                content: msg,
//                height: 35,
//                time: 15
//            }); 
        }
        $.connection.hub.start();
    </script>
</asp:Content>
