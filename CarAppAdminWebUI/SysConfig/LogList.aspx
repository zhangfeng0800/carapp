<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="LogList.aspx.cs" Inherits="CarAppAdminWebUI.SysConfig.LogList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
       
    <form id="schForm">
    <input id="action" name="action" value="loglist" type="hidden" />
    
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
        function resizeTable() {
            var height = ($(window).height());
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/SysConfig/SystemHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title:"系统日志记录",
                columns: [
                [
                { field: 'ck', checkbox: true },
               
                { field: 'OperationTime', title: '时间', width: 150,formatter:easyui_formatterdate },
                { field: 'OperationContent', title: '内容', width: 100 },
            
                { field: 'Username', title: '用户名', width: 100 },
                { field: 'Result', title: '结果', width: 100 }
                    ]
                ]
            });
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/SysConfig/SystemHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }

        function onDelete() {
            ajaxdelete("errorlog", "id", "Id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
