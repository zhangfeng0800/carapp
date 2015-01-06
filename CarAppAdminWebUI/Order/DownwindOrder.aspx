<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="DownwindOrder.aspx.cs" Inherits="CarAppAdminWebUI.Order.DownwindOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <!--顺风车列表-->
    <script type="text/javascript" src="/Static/easyui/datagrid-detailview.js"></script>
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
                </span></span><span class="input_blo"><span class="input_text">创&nbsp;&nbsp;建&nbsp;&nbsp;人</span>
                    <span class="">
                        <input class="adm_21" id="username" name="username" style="width: 55px;" />
                    </span></span>
                    <span class="input_blo" style="display: none;"><span class="input_text">
                        出发城市</span> <span class="">
                            <input class="adm_21" id="startaddress" name="startaddress" type="text" value=""
                                style="width: 55px;" />
                        </span></span>
                        <span class="input_blo" style="display: none;"><span class="input_text">
                            目的城市</span> <span class="">
                                <input class="adm_21" id="targetaddress" name="targetaddress" type="text" value=""
                                    style="width: 55px;" />
                            </span></span><span class="input_blo"><span class="input_text">订单状态</span> <span
                                class="">
                                <select class="adm_21" id="orderStatusID" name="orderStatusID" style="width: 80px;">
                                    <option value="">不限</option>
                                    <option value="2">等待服务</option>
                                    <option value="3">服务中</option>
                                    <option value="4">服务结束</option>
                                    <option value="5">服务取消</option>
                                    <option value="6">订单完成</option>
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
                            </span></span>
                            <span class="input_blo"><span class="input_text">订单编号</span> <span
                                    class="">
                                    <input class="adm_21" id="orderid" name="orderid" type="text" value="" style="width: 60px;" />
                                </span></span>
                                <span class="input_blo"><span class="input_text">车牌号</span> <span class="">
                                    <input class="adm_21" id="carNo" name="carNo" type="text" value="" style="width: 60px;" />
                                </span></span>
                                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
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
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-edit">添加顺风车</a>
                   <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑顺风车</a>
                    <a href="javascript:onSentCar()" class="easyui-linkbutton" iconcls="icon-remove">派车</a>
                    <a href="javascript:onMapSentCar()" class="easyui-linkbutton" iconcls="icon-remove">
                        地图派车</a> <a href="javascript:onCancelOrder()" class="easyui-linkbutton" iconcls="icon-remove">
                                取消订单</a> <a href="javascript:onReSentCar()" class="easyui-linkbutton" iconcls="icon-remove">
                                    更改派遣车辆</a> <a href="javascript:onMapReSentCar()" class="easyui-linkbutton" iconcls="icon-remove">
                                        订单地图改派</a>
                                        <a href="javascript:onShowTime()" class="easyui-linkbutton" iconcls="icon-remove">
                                        顺风车展示时间设置</a>
                         <a href="javascript:onDeduct()" class="easyui-linkbutton" iconcls="icon-remove">
                                        顺风车取消比例设置</a>
                                          <a href="javascript:onSetTip()" class="easyui-linkbutton" iconcls="icon-remove">
                                        设置提醒</a>
                    &nbsp; &nbsp;<span style="color:Red;">顺风车订单派车后会在手机app端展示，派车前请认真核对信息</span>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="新增顺风车" style="width:  1200px; height: 500px;">
    </div>
    <div id="editwindow" title="编辑顺风车" style="width:  1200px; height: 500px;">
    </div>

    <div id="showtimewindow" title="顺风车展示时间设置" style="width:  350px; height: 200px;">
    </div>

     <div id="deductionwindow" title="设置取消扣费比例" style="width:  350px; height: 200px;">
    </div>

         <div id="tipwindow" title="设置提醒" style="width:  400px; height: 300px;">
    </div>

    <div id="carwindow" title="派车(车辆信息仅供参考,请以实际情况为准)" style="width: 900px; height: 500px;">
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

        });

        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width;
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
                url: "/Order/DownwindHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                singleSelect: true,
                fitColumns: false,
                view: detailview,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "订单管理",


                toolbar: "#toolbar",
                showFooter: true,
                frozenColumns: [[
                { field: 'ck', checkbox: true, width: 50 },
                { field: 'orderId', title: '查看详情', width: 100, formatter: forderid },
                ]],
                columns: [
                [
                { field: 'departureTime', title: '预定出发时间', width: 130, formatter: easyui_formatterdate },
                { field: 'typeName', title: '车辆类型', width: 100 },
                { field: 'orderDate', title: '创建时间', width: 130, formatter: easyui_formatterdate },
                { field: 'startcityName', title: '出发城市', width: 100 },
                { field: 'endcityName', title: '目的城市', width: 100 },
                { field: 'windPrice', title: '座位单价', width: 60 },
                { field: 'passengerNum', title: '总座位数', width: 60 },
                { field: 'payNum', title: '已定座位', width: 60, formatter: fred },
                { field: 'orderMoney', title: '预付费用', width: 100 },
                { field: 'totalMoney', title: '总金额', width: 100 },
                { field: 'orderStatusID', title: '订单状态', width: 80, formatter: forderStatusID },
                { field: 'smsreceiver', title: '查看轨迹', width: 60, formatter: forderroute },
                { field: 'jobnumber', title: '司机信息', width: 60, formatter: driverContact },
                { field: 'adminName', title: '创建人', width: 60 }
                ]
                ],
                detailFormatter: function (rowIndex, rowData) {
                    return '<table>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px"><b>上车地址: </b> ' + getstring(rowData.startAddress) + '</td>'
                     + '<td style="border:0;padding:3px"><b>下车地址: </b>' + getstring(rowData.arriveAddress) + '</td>'
                     + '<td style="border:0;padding:3px"><b>订单留言: </b>' + getstring(rowData.orderMessage) + '</td>'
                     + '</tr>'
                     + '</table>';
                }
            });
        }
        function fred(value, row, index) {
            if (value == null || value == "")
                return "<span style='color:red;'>0</span>";
            return "<span style='color:red;'>" + value + "</span>";
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
        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }
        function forderid(value, row, index) {
            if (value.indexOf("订单总数") > -1) {
                return value;
            }

            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.orderId + "\")'>查看</a>";
            return html;
        }
        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }
        function forderroute(value, row, index) {
            if (value) {
                var html = "<a style=\"text-decoration:underline\" href='javascript:onShowRoute(\"" + row.orderId + "\",\"" + row.orderStatusID + "\")'>查看</a>";
                return html;
            } else {
                return "";
            }

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

        function forderStatusID(value, row, index) {
            if (value == 99) {
                return '订单过期';
            }
            var status = new Array("等待付款", "等待服务", "服务中", "服务结束", "服务取消", "订单完成", "司机等待", "<span style='color:red;'>等待派车</span>", "二次付款中", '司机已经出发', '司机已经就位', "订单已经接取");
            return status[value - 1];

        }
        function driverContact(value, row, index) {
            if (value) {
                return "<a  style=\"text-decoration:underline\" href=\"javascript:onDetail('" + row.orderId + "')\">点击查看</a>";
            }
        }
        function getstring(value) {
            if (value == null || value == "") {
                return "暂无";
            }
            return value;
        }
        //搜索
        function onSearch(val, control) {
            $("#gdgrid").datagrid("options").url = "/Order/DownwindHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Order/DownwindAdd.aspx');
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }


            edit("gdgrid", "editwindow", "orderId", "/Order/DownwindEdit.aspx?id=");
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
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
        /* 地图派车 */
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

        /* 取消订单 */
        function onCancelOrder() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "你确定要取消此订单么？", function (r) {
                if (r) {
                    $.post("/Order/DownwindHandler.ashx", { "action": "cancelorder", "id": row.orderId }, function (data) {
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

        function onShowTime() {
            $('#showtimewindow').window('open');
            $('#showtimewindow').window('refresh', '/Order/DownwindShowTime.aspx');
        }

        function onDeduct() {
            $('#deductionwindow').window('open');
            $('#deductionwindow').window('refresh', '/Order/DownwindDeduction.aspx');
        }

        function onSetTip() {
            $('#tipwindow').window('open');
            $('#tipwindow').window('refresh', '/Order/DownwindTip.aspx');
        }

    </script>
</asp:Content>
