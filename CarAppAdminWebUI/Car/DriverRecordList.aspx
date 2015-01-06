<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="DriverRecordList.aspx.cs" Inherits="CarAppAdminWebUI.Car.DriverRecordList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
 <script src="../Static/My97DatePicker/moment.min.js" type="text/javascript"></script>
    <form id="schForm">
    <input name="action" type="hidden" value="list" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">司机工号：</span> <span class="">
                    <input class="adm_21" id="jobnumber" style="width: 80px;" name="jobnumber" />
                </span></span><span class="input_blo"><span class="input_text">司机姓名：</span> <span
                    class="">
                    <input class="adm_21" id="driverName" style="width: 80px;" name="driverName" />
                </span></span><span class="input_blo"><span class="input_text">登录日期</span> <span class="">
                    <input class="Wdate" type="text" name="dates" id="dates" style="width: 100px;" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>"
                        onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
                    -
                    <input onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" name="datee" id="datee"
                        style="width: 100px;" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" class="Wdate" />
                </span></span><span class="input_blo"><span class="input_text">
                    <select id="timesel" onchange="search()">
                        <option value="">不限</option>
                        <option value="day">本日</option>
                        <option value="month">本月</option>
                        <option value="year">本年</option>
                    </select>
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
                <span class="input_blo"><a href="javascript:onExport()"
                                class="easyui-linkbutton" iconcls="icon-remove">导出Excel</a> </span>
            </div>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();

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
                url: "/Car/DriverHandler.ashx?action=recordlist&id=" + $("#jobnumber").val() + "&driverName=" + $("#driverName").val() + "&dates=" + $("#dates").val() + "&datee=" + $("#datee").val(),
                method: 'post',
                title: "司机登录记录",

                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                showFooter: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [[
                 { field: 'jobNumber', title: '工号', width: 100 },
                { field: 'name', title: '司机姓名', width: 100, formatter: driverlink },
                { field: 'loginTime', title: '登录时间', width: 200, sortable: true },
                { field: 'logoutTime', title: '退出时间', width: 200, sortable: true },
                { field: 'logoutType', title: '退出方式', width: 100 },
                { field: 'onlinetime', title: '本次登录时长（分）', width: 200, formatter: gettimestring, sortable: true }
            ]]
            });
        }
        function gettimestring(value, row, index) {
            return parseInt(value / 60) + "小时" + value % 60 + "分钟";
        }

        function search() {
            var day = moment().format("YYYY-MM-DD");
            if ($("#timesel").val() == "day") {
                $("#dates").val(day);
                $("#datee").val(day);
                onSearch();
            } else if ($("#timesel").val() == "month") {
                $("#dates").val(moment().format("YYYY-MM-01"));
                $("#datee").val(day);
                onSearch();
            }
            else if ($("#timesel").val() == "year") {

                $("#dates").val(moment().format("YYYY-01-01"));
                $("#datee").val(day);
                onSearch();
            }

        }

        function driverlink(value, row, index) {

            var html = "<a title='点击查看司机信息' style=\"text-decoration:underline\" href='javascript:onShowDriver(\"" + row.jobNumber + "\")'>" + value + "</a>";
            return html;
        }
        function onShowDriver(id) {
            top.addTab("司机详细(ID:" + id + ")", "/Car/DriverDetail.aspx?id=" + id, "icon-nav");
        }

        //搜索
        function onSearch() {
            var dates = $("#dates").val();
            var datee = $("#datee").val();
            if (dates != "" && datee == "") {
                alert("结束时间不能为空！");
                return;
            }
            if (dates == "" && datee != "") {
                alert("开始时间不能为空！");
                return;
            }
            $("#gdgrid").datagrid("options").url = "/Car/DriverHandler.ashx?action=recordlist&id=" + $("#jobnumber").val() + "&driverName=" + $("#driverName").val() + "&dates=" + $("#dates").val() + "&datee=" + $("#datee").val();
            $("#gdgrid").datagrid("load");
        }

        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }

        //导出Excel  action
        function onExport() {
            window.open("/Car/DriverHandler.ashx?action=ToExcel&id=" + $("#jobnumber").val() + "&driverName=" + $("#driverName").val() + "&dates=" + $("#dates").val() + "&datee=" + $("#datee").val());
        }
    </script>
</asp:Content>
