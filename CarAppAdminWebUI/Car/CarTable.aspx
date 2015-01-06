<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="CarTable.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarTable" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <table id="gdgrid">
    </table>
    <script type="text/javascript">
        //初始化
        $(function () {
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
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: '/Order/OrderHandler.ashx?action=cartablelist&id=<%=Request.QueryString["id"] %>',
                method: 'post',
                height: 500,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                columns: [[
                   { field: 'carNo', title: '车牌号', width: 80 },
                { field: 'carusewayname', title: '用车方式', width: 60 },
                { field: 'startTime', title: '开始时间', width: 140,formatter:easyui_formatterdate },
                { field: 'overTime', title: '结束时间', width: 140,formatter:easyui_formatterdate },
                { field: 'startCity', title: '出发城市', width: 170 },
                { field: 'overCity', title: '到达城市', width: 170 }
            ]]
            });
        }
    </script>
</asp:Content>
