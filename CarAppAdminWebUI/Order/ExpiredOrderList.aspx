<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ExpiredOrderList.aspx.cs" Inherits="CarAppAdminWebUI.Order.ExpiredOrderList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script type="text/javascript" src="/Static/easyui/datagrid-detailview.js"></script>
     
    <form id="schForm">
    <input id="action" name="action" value="ExpiredList" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">订单编号</span> <span class="">
                    <input class="adm_21" id="orderid" name="orderid" type="text" value="" />
                </span></span><span class="input_blo"><span class="input_text">订单状态</span> <span
                    class="">
                    <select class="adm_21" id="orderStatusID" name="orderStatusID">
                        <option value="">不限</option>
                        <option value="8" selected="selected">等待派车</option>
                    </select>
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">编辑</a>
                </td>
                <td>
                    <a href="javascript:onCancelOrder()" class="easyui-linkbutton" iconcls="icon-remove">
                        取消订单</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="editwindow" title="编辑订单信息" style="width: 600px; height: 320px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            initProvinceSelect("provenceID", "不限");
            bindGrid();
            bindWin();
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
            var width = $(window).width();
            var height = $(window).height() -$("#querycontainer").height()-10;
            $("#gdgrid").css("width", width);
            $("#gdgrid").css("height", height);
            $("#querycontainer").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Order/OrderHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                view: detailview,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "过期订单列表",
                toolbar: "#toolbar",
                frozenColumns: [[
                   { field: 'ck', checkbox: true },
                { field: 'orderId', title: '订单号', width: 150, formatter: forderid }
                ]],
                columns: [
                [

                { field: 'orderDate', title: '下订单时间', width: 150, formatter: easyui_formatterdate },
                { field: 'passengerName', title: '乘车人', width: 100 },
                { field: 'passengerPhone', title: '电话', width: 140 },
                { field: 'departureCity', title: '出发城市', width: 100 },
                { field: 'targetCity', title: '目的城市', width: 100 },
                { field: 'CarType', title: '车辆类型', width: 100 },
                { field: 'CarUseWay', title: '租车方式', width: 100 },
                { field: 'AirPort', title: '机场', width: 100 },
                { field: 'UserType', title: '客户类型', width: 100, formatter: fusertype },
                { field: 'passengerNum', title: '乘车人数', width: 100 },
                { field: 'orderMoney', title: '预付款', width: 100 },
                { field: 'totalMoney', title: '总额', width: 100 },
                { field: 'orderStatusID', title: '订单状态', width: 100, formatter: forderStatusID },
                { field: 'paystatus', title: '付款状态', width: 100, formatter: fpaystatus },
                { field: 'carId', title: '服务车辆', width: 100 },
                { field: 'userID', title: '会员信息', width: 100, formatter: fuserID }
                    ]
                ],
                detailFormatter: function (rowIndex, rowData) {
                    return '<table>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px"><b>上车地址:</b> ' + getstring(rowData.startAddress) + '</td>'
                     + '<td style="border:0;padding:3px"><b>下车地址: </b>' + getstring(rowData.arriveAddress) + '</td>'
                     + '<td style="border:0;padding:3px"><b>订单留言: </b>' + getstring(rowData.orderMessage) + '</td>'
                     + '</tr>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px"><b>预约时间: </b>' + formatterdate(rowData.departureTime) + '</td>'
                     + '<td style="border:0;padding:3px"><b>接机时间:</b> ' + formatterdate(rowData.pickupTime) + '</td>'
                     + '<td style="border:0;padding:3px"><b>机场编号: </b>' + getstring(rowData.airportID) + '</td>'
                     + '</tr>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px"><b>额外服务费用: </b>' + rowData.extraFee + '</td>'
                     + '<td style="border:0;padding:3px"><b>数据库编号: </b>' + getstring(rowData.id) + '</td>'
                     + '<td style="border:0;padding:3px"><b>备注: </b>' + getstring(rowData.remarks) + '</td>'
                     + '</tr>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px"><b>用车时长: </b>' + getstring(rowData.useHour) + '</td>'
                     + '<td style="border:0;padding:3px"><b>发票: </b>' + getstring(rowData.invoiceID) + '</td>'
                     + '<td style="border:0;padding:3px"><b>未付金额: </b>' + getstring(rowData.unpaidMoney) + '</td>'
                     + '</tr>'
                     + '</table>';
                }
            });
        }

        /*formatter*/
        function forderStatusID(value, row, index) {
            var status = new Array("等待付款", "等待服务", "服务中", "服务结束", "服务取消", "订单完成", "司机等待", "<span style='color:red;'>等待派车</span>", "二次付款中");
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
            if (value == 0) {
                return "";
            }
            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.orderId + "\")'>" + value + "</a>";
            return html;
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
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Order/OrderHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "orderId", "/Order/OrderEdit.aspx?id=");
        }

        /* 取消订单 8 */
        function onCancelOrder() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            if (row.orderStatusID == 8) {
                $.messager.confirm("提示", "你确定要取消此订单么？", function (r) {
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
            } else {
                $.messager.alert('消息', '你不能取消此类订单', 'error');
                return;
            }
        }

        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
