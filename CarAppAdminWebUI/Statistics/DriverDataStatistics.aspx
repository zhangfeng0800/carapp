<%@ Page Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="DriverDataStatistics.aspx.cs"
    Inherits="CarAppAdminWebUI.Statistics.DriverDataStatistics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input name="action" type="hidden" value="driverListData" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                查询条件</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省 份</span> <span class="">
                    <select class="adm_21" style="width: 80px;" id="province" name="province">
                    </select>
                </span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="input_blo"><span class="input_text">城
                    市</span> <span class="">
                        <select class="adm_21" id="city" name="city" style="width: 80px;">
                        </select></span> </span>
                        <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                            icon="icon-search">查询</a></span> 
                        <span class="input_blo"><a href="javascript:onDriverDetail()" class="easyui-linkbutton"
                            icon="icon-search">查看司机详细信息</a></span>     
                            <span class="input_blo"><a href="javascript:onExport()"
                                class="easyui-linkbutton" iconcls="icon-remove">导出Excel</a> </span>
            </div>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="w" class="easyui-window" title="司机详细信息统计" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 700px; height: 500px;">
        <span>
            <table id="driverInfo">
            </table>
        </span>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            initProvinceSelectValue("province", "不限", "13");
            initCitySelect("city", "不限", "13", "");
            citySelectChange("province", "city", "town", "不限");

            resizeTable();
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
                url: "/Statistics/DriverData.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: false,
                rownumbers: true,
                singleSelect: true,
                showFooter: true,
                fitColumns: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "司机数据统计",
                columns: [[
                { field: 'proName', title: '省份', width: 50 },
                { field: 'cityName', title: '城市', width: 40, formatter: driverlink },
                { field: 'driverNum', title: '司机人数', width: 50, formatter: GetDriverNum, sortable: true },
                { field: 'totalKm', title: '服务总公里数(Km)', width: 50, formatter: getTotalKm, sortable: true },
                { field: 'totalServerTime', title: '服务总时长', width: 50, formatter: gettimestring, sortable: true },
                { field: 'totalOrderNumber', title: '订单总数', width: 50, sortable: true },
                { field: 'totalOrderMoney', title: '订单总金额(元)', width: 50, sortable: true }
                ]]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Statistics/DriverData.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
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
        function gettimestring(value, row, index) {
            if (!isNaN(value)) {
                return parseInt(value / 60) + "小时" + value % 60 + "分钟";
            }
            else {
                return value;
            }
        }
        function GetDriverNum(value, row, index) {
            if (row.proName == "未知") {
                return "";
            }
            else {
                return value;
            }
        }
        function getTotalKm(value, row, index) {
            if (!isNaN(value)) {
                return value + " Km";
            }
            else {
                return value;
            }
        }
        //导出Excel  action
        function onExport() {
            window.open("/Statistics/DriverToExcel.aspx?" + $("#schForm").serialize());
        }
        //连接地址
        function driverlink(value, row, index) {
            var html = "";
            if (value == "未知") {
                html = "<span>" + value + "</span>";
            }
            else {
                html = "<a title='点击查看城市下所有司机的信息' style=\"text-decoration:underline\" href='javascript:onShowDriver(\"" + row.provinceId + "\",\"" + row.cityId + "\")'>" + value + "</a>";
            }
            return html;
        }
        function onShowDriver(id, cityId) {
            //top.addTab("司机信息管理", "/Car/DriverHandler.ashx?province=" + id + "&city=" + cityId, "icon-nav");
            //绑定数据表格
            $('#driverInfo').datagrid({
                url: "/Car/DriverHandler.ashx?action=list&province=" + id + "&city=" + cityId + "",
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [
                [
                { field: 'jobnumber', title: '工号', width: 50 },
                { field: 'name', title: '司机姓名', width: 60 },
                { field: 'totalKm', title: '服务总里程(公里)', width: 120, sortable: true },
                { field: 'totalServerTime', title: '服务总时长', width: 120, formatter: gettimestringDetail, sortable: true }, //totalServerTime
                {field: 'totalOrderNumber', title: '订单总数量', width: 90, sortable: true }, //totalOrderMoney
                {field: 'totalOrderMoney', title: '订单金额', width: 120, sortable: true }
                ]]
            });
            $("#w").window("open");
        }
        function gettimestringDetail(value, row, index) {
            if (!isNaN(value)) {
                return parseInt(value / 60) + "小时" + value % 60 + "分钟";
            }
            else {
                return value;
            }
        }
        function onDriverDetail() {
            top.addTab("司机信息管理", "/Car/DriverList.aspx", "icon-nav");
        }
    </script>
</asp:Content>
