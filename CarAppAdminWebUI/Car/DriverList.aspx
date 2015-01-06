<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="DriverList.aspx.cs" Inherits="CarAppAdminWebUI.Car.DriverList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
 <script src="../Static/My97DatePicker/moment.min.js" type="text/javascript"></script>
    <form id="schForm">
    <input name="action" type="hidden" value="list" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省份</span> <span class="">
                    <select class="adm_21" id="province" name="province">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">城市</span> <span class="">
                    <select class="adm_21" id="city" name="city">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">姓名</span> <span class="">
                    <input class="adm_21" id="scarno" style="width: 60px;" name="scarno" />
                </span></span><span class="input_blo"><span class="input_text">工号</span> <span class="">
                    <input class="adm_21" id="jobnumber" style="width: 80px;" name="jobnumber" />
                </span></span><span class="input_blo"><span class="input_text">身份证号</span> <span
                    class="">
                    <input class="adm_21" id="txtid" style="width: 80px;" name="txtid" />
                </span></span><span class="input_blo"><span class="input_text">性别</span> <span class="">
                    <select id="sex" name="sex">
                        <option value="">不限</option>
                        <option value="男">男</option>
                        <option value="女">女</option>
                    </select>
                </span></span><span class="input_blo"><span class="input_text">司机状态</span> <span
                    class="">
                    <select id="driverState" name="driverState">
                        <option value="">不 限</option>
                        <option value="1">已登录</option>
                        <option value="0">未登录</option>
                    </select>
                </span></span><span class="input_blo"><span class="input_text">司机驾龄</span> <span
                    class="">
                    <select id="driverTime" name="driverTime">
                        <option value="">不 限</option>
                        <option value="0">1到3年</option>
                        <option value="1">3到6年</option>
                        <option value="2">6年以上</option>
                    </select>

                </span></span>
                <span class="input_blo"><span class="input_text">是否离职</span> <span
                    class="">
                    <select id="isgo" name="isgo">
                        <option value="">不 限</option>
                        <option value="在职">在职</option>
                        <option value="离职">离职</option>
                    </select>
                </span></span>
                 <span class="input_blo"><span class="input_text">订单日期</span> <span class="">
                    <input class="Wdate" type="text" name="dates" id="dates" style="width: 100px;" value=""
                        onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',skin:'whyGreen',maxDate:'%y-%M-%d'})" />
                    -
                    <input onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',skin:'whyGreen',maxDate:'%y-%M-%d'})" type="text" name="datee" id="datee"
                        style="width: 100px;" value="" class="Wdate" />
                </span></span>
                <span class="input_blo"><span class="input_text">是否绑定微信</span> <span
                    class="">
                    <select id="openID" name="openID">
                        <option value="">不 限</option>
                        <option value="是">是</option>
                        <option value="否">否</option>
                    </select>
                </span></span>

                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
                <span class="input_blo"><a href="javascript:onExport()"
                                class="easyui-linkbutton" iconcls="icon-remove">导出Excel</a> </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">编辑</a>
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                    <a href="javascript:onLogoutDrier()" class="easyui-linkbutton" iconcls="icon-remove">
                        强制司机退出</a>

                    <a href="javascript:onDriverGo()" class="easyui-linkbutton" iconcls="icon-remove">
                        设为离职</a>
                    <div style="margin-left: 50px; float: right; color: Red; margin-top: -20px;">
                        共有司机<%=DriverCount %>名&nbsp;&nbsp;&nbsp;&nbsp; 手机登录中<%=DriverLoginCount %>名
                    </div>


                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的司机" style="width: 600px; height: 550px;">
    </div>
    <div id="editwindow" title="编辑司机信息" style="width: 600px; height: 540px;">
    </div>
    <div id="w" class="easyui-window" title="查看服务里程记录" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 550px; height: 470px;">
        <table id="tbhotline">
        </table>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            initProvinceSelectValue("province", "不限", "13");
            initCitySelect("city", "不限", "13", "");
            citySelectChange("province", "city", "town", "不限");

            resizeTable();
            resizeCarwindow("addwindow");
            resizeCarwindow("editwindow");
            bindGrid();
            bindWin();
        });

        function resizeTable() {
            var height = $(window).height() - $("#querycontainer").height() - 10;
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", $(window).width());
            $("#querycontainer").css("width", $(window).width());
        }
        function resizeCarwindow(obj) {
            var height = ($(window).height());
            var width = $(window).width();
            $("#" + obj).css("height", height);
            $("#" + obj).css("width", width);
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
                url: "/Car/DriverHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                showFooter: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "司机信息管理",
                toolbar: "#toolbar",
                frozenColumns: [
                [
                 { field: 'ck', checkbox: true },
                { field: 'jobnumber', title: '工号', width: 50 },
                  { field: 'name', title: '司机姓名', width: 60, formatter: driverlink }
                ]],
                columns: [
                [
                { field: 'sex', title: '性别', width: 50 },
                { field: 'cardno', title: '驾照', width: 100 },
                { field: 'DriverTime', title: '驾龄', width: 50 },
                { field: 'password', title: '密码', width: 60 },
                { field: 'age', title: '年龄', width: 70 },
                { field: 'ssn', title: '身份证号', width: 150 },
                { field: 'driverPhone', title: '私人电话', width: 100 },
                { field: 'carId', title: '登录状态', width: 80, formatter: getcarinfo },
                { field: 'totalKm', title: '服务总里程(公里)', width: 120, formatter: linkservKm, sortable: true },
                { field: 'totalServerTime', title: '服务总时长', width: 120, formatter: gettimestring, sortable: true }, //totalServerTime
                {field: 'totalOrderNumber', title: '订单总数量', width: 90, sortable: true }, //totalOrderMoney
                {field: 'totalOrderMoney', title: '订单金额', width: 120, sortable: true },
                { field: 'openID', title: '是否绑定微信', width: 100, formatter: isBindwx },
                { field: 'version', title: '最后登录版本号', width: 110, sortable: true },
                     { field: 'state', title: '在职状态', width: 100 },
                { field: 'address', title: '常住地址或者籍贯', width: 150 },
             
                { field: 'other', title: '其他', width: 150 }
                ]]
            });
        }

        function isBindwx(value, row, index) {
            if (value == null || value == "")
                return "<span style='color:red;'>否</span>";
            else {
                //if (!isNaN(value)) {
                if (value == "foot") {
                    //return "<span>" + value + "</span>";
                    return "";
                }
                else {
                    return "<span>是</span>";
                }
            }

        }
        function linkservKm(value, row, index) {
            //return "<a style=\"text-decoration:underline\" href='javascript:onDetail(\"" + row.jobnumber + "\")>"+value+"</a>"
            if (value == 0)
                return "0";
            else {
                if (!isNaN(value)) {
                    return "<a style='text-decoration:underline' href='javascript:onDetail(\"" + row.jobnumber + "\")'>" + value + "</a>";
                }
                else {
                    return value;
                }
            }
        }
        //服务总时长
        function gettimestring(value, row, index) {
            if (value == "") {
                return "";
            }
            else {
                return parseInt(value / 60) + "小时" + value % 60 + "分钟";
            }
        }
        function driverlink(value, row, index) {
            var html = "";
            if (row.jobnumber == "未知") {
                html = "<span>" + value + "</span>";
            }
            else {
                html = "<a title='点击查看司机信息' style=\"text-decoration:underline\" href='javascript:onShowDriver(\"" + row.jobnumber + "\")'>" + value + "</a>";
            }
            return html;
        }
        function onShowDriver(id) {
            top.addTab("司机详细(ID:" + id + ")", "/Car/DriverDetail.aspx?id=" + id, "icon-nav");
        }

        function getcarinfo(value, row, index) {
            if (value == "订单总数量：") {
                return "订单总数量：";
            }
            if (value == "")
                return "否";
            else {
                if (row.mycarNo == "未知")
                    return "未知";
                return "  <a href='javascriot:void(0);' onclick='onShowCarInfo(" + value + ")' style='text-decoration: underline;'>" + row.mycarNo + "</a>"
            }
        }
        function onShowCarInfo(id) {
            top.addTab("车辆详细(ID:" + id + ")", "/Car/CarInfoDetail.aspx?id=" + id, "icon-nav");
        }

        /* formatter */
        function fcarno(value, row, index) {
            if (value == "" || value == "0") {
                return "不限";
            }
            return value;
        }

        function onDetail(value) {
            //绑定数据表格

            $('#tbhotline').datagrid({
                url: "/Car/DriverHandler.ashx?action=orderlist&id=" + value,
                method: 'post',
                pagination: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "",
                columns: [
                    [
                    { field: 'orderId', title: '订单编号', width: 150, formatter: forderid },
                    { field: 'UseKm', title: '里程数(公里)', width: 150 },
                    { field: 'orderDate', title: '下单时间', width: 150, formatter: easyui_formatterdate }
                    ]
                ]
            });
            $("#w").window("open");
        }
        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }
        function forderid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.orderId + "\")'>" + value + "</a>";
            return html;
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/DriverHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Car/DriverAdd.aspx');
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "ID", "/Car/DriverEdit.aspx?id=");
        }

        function onLogoutDrier() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "强制退出前要确认该司机没有登录并且电话联系对应车辆让其退出，确认强制退出吗？", function (r) {
                if (r) {
                    $.post("/Car/DriverHandler.ashx", { "action": "DriverLogout", "carId": row.carId, "driverId": row.ID }, function (data) {
                        if (data == "-1") {
                            $.messager.alert('消息', '该司机并未登录任何车辆', 'error');
                        }
                        else {
                            $.messager.alert('消息', '操作成功！', 'info', function () {
                                onSearch();
                            });
                        }
                    });
                }
            });
        }

        function onDelete() {
            ajaxdelete("driverAccount", "ID", "ID", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        //导出Excel  action
        function onExport() {
            window.open("/Car/DriverHandler.ashx?action=DriverToExcel&province=" + $("#province").val() + "&city=" + $("#city").val() + "&scarno=" + $("#scarno").val() + "&jobnumber=" + $("#jobnumber").val() + "&txtid=" + $("#txtid").val() + "&sex=" + $("#sex").val() + "&driverState=" + $("#driverState").val() + "&driverTime=" + $("#driverTime").val() + "&dates=" + $("#dates").val() + "&datee=" + $("#datee").val());
        }

        function onDriverGo() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "确定设置此司机离职吗？", function (r) {
                if (r) {
                    $.post("/Car/DriverHandler.ashx", { "action": "DriverGo", "driverId": row.ID }, function (data) {
                        if (data == "-1") {
                            $.messager.alert('消息', '设置失败', 'error');
                        }
                        else {
                            $.messager.alert('消息', '操作成功！', 'info', function () {
                                onSearch();
                            });
                        }
                    });
                }
            });

        }
    </script>
</asp:Content>
