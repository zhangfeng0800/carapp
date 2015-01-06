<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CarDistance.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarDistance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="distanceinfo" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">开始时间</span> <span class="">
                    <input class="adm_21 Wdate" id="starttime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                        value="<%=DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") %>" name="starttime"
                        type="text" style="width: 100px;" />
                </span></span><span class="input_blo"><span class="input_text">结束时间</span> <span
                    class="">
                    <input class="adm_21 Wdate" id="endtime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                        value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" name="endtime" type="text"
                        style="width: 100px;" />
                </span></span>
               
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
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
        function bindWin() {
            $("[id$=window]").window({
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closed: true
            });
        }

        function fcarid(value, row, index) {
            return "<a href=\"javascript:showcarRoute('" + row.carid + "');\">查看行驶轨迹</a>";
        }
        function showcarRoute(id) {
            top.addTab("车辆轨迹查询", "/Car/CarRouteQuery.aspx?id=" + id, "icon-nav");
        }
        function resizeTable() {
            var height = $(window).height() - $("#querycontainer").height() - 10;
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Car/CarLocationHandler.ashx?" + $("#schForm").serialize(),
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
                     { field: 'carid', title: '查看轨迹', width: 100, formatter: fcarid },
                       { field: 'carno', title: '车牌号', width: 100}
                 
                ]],
                columns: [
                    [

                        { field: 'totaldistance', title: '总行驶里程', width: 100, sortable: true },
                        { field: 'servicedistance', title: '服务里程', width: 100, sortable: true },
                        { field: 'emptydistance', title: '接单空驶里程', width: 120, sortable: true },
                      { field: 'otherdistance', title: '订单外空驶里程', width: 120, sortable: true }



                    ]
                ]
            });
        }
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/car/carlocationhandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
     
    </script>
</asp:Content>
