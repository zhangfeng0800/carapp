<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="KefuOrderList.aspx.cs" Inherits="CarAppAdminWebUI.Order.KefuOrderList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
  <%--  <script type="text/javascript" src="/Static/easyui/datagrid-detailview.js"></script>--%>
    <form id="schForm">
    <input id="action" name="action" value="kefuorder" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">客服名称</span>
                    <span class="">
                        <input class="adm_21" id="username" name="username" style="width:80px;" value="<%=username %>" />
                    </span></span>
                     <span class="input_blo"><span class="input_text">坐席号</span>
                    <span class="">
                        <input class="adm_21" id="exten" name="exten" style="width:80px;" value="<%=exten %>" />
                    </span></span>
                    <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                            iconcls="icon-search">查询</a></span>
                            <span class="input_blo"><a href="javascript:onReset()" class="easyui-linkbutton"
                            iconcls="icon-search">返回</a></span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar" style="display: none;">
        <table>
            <tr>
                <td colspan="12">
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>
                    <a href="javascript:onSentCar()" class="easyui-linkbutton" iconcls="icon-remove">派车</a>
                    <a href="javascript:onCancelOrder()" class="easyui-linkbutton" iconcls="icon-remove">
                        取消订单</a> <a href="javascript:onReSentCar()" class="easyui-linkbutton" iconcls="icon-remove">
                            更改派遣车辆</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="carwindow" title="派车(车辆信息仅供参考,请以实际情况为准)">
    </div>
    <div id="editwindow" title="编辑订单信息" style="width: 600px; height: 315px;">
    </div>
    <div id="recarwindow" title="更改派遣车辆">
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
                url: "/Order/OrderHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                singleSelect: true,
                fitColumns: true,
              
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "订单管理",
                frozenColumns: [[
                { field: 'ck', checkbox: true, width: 50 },
                { field: 'OrderId', title: '订单号', width: 250, formatter: forderid }
                ]],
                columns: [
                [
                { field: 'UserName', title: '客服名称', width: 100, formatter: forderName },
                 { field: 'Exten', title: '坐席号', width: 150, formatter: forderExten },
                { field: 'OrderDate', title: '下订单时间', width: 150 ,formatter:formatterdate}
                    ]
                ] 
            });
        }

        function toFloat(value, row, index) {
            if (value == "") {
                return "";
            } else {
                if (parseFloat(value)) {
                    return parseFloat(value).toFixed(2);
                } else {
                    return 0;
                }
            }
        }
        function getUserName(value, row, index) {
            var html = "<a title='点击查看用户信息' style=\"text-decoration:underline\" href='javascript:onShowUser(\"" + row.userID + "\")'>" + value + "</a>";

            return html;
        }
        function forderName(value, row, index) {
            return "<a style=\"text-decoration:underline\" href=\"javascript:$('#username').val('" + value + "');onSearch();\" >" + value + "</a>";
        }
        function forderExten(value, row, index) {
            return "<a style=\"text-decoration:underline\" href=\"javascript:$('#exten').val('" + value + "');onSearch();\" >" + value + "</a>";
        }


        /*formatter*/
        function forderStatusID(value, row, index) {
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
            if (value == 0) {
                return "";
            }
            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.OrderId + "\")'>" + value + "</a>";
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
        function onReset() {
            $("#username").val("");
            $("#exten").val("");
            $("#gdgrid").datagrid("options").url = "/Order/OrderHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
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
    </script>
</asp:Content>
