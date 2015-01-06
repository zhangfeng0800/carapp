<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ErrorList.aspx.cs" Inherits="CarAppAdminWebUI.SysConfig.ErrorList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script type="text/javascript" src="/Static/easyui/datagrid-detailview.js"></script>
        
    <form id="schForm">
    <input id="action" name="action" value="errorlist" type="hidden" />
 
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
            var height = ($(window).height());
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
                url: "/SysConfig/SystemHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                view: detailview,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title:"系统错误记录",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'Message', title: '描述信息', width: 100 },
                { field: 'ErrorTime', title: '时间', width: 100,formatter:easyui_formatterdate },
                { field: 'Source', title: '错误源', width: 100 },
                { field: 'TargetSite', title: '其他', width: 100 }
                    ]
                ],
                detailFormatter: function (rowIndex, rowData) {
                    return '<table>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px"><b>异常名称：</b></td>'
                     + '</tr>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px">' + rowData.ErrorName + '</td>'
                     + '</tr>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px"><b>堆栈信息：</b></td>'
                     + '</tr>'
                     + '<tr>'
                     + '<td style="border:0;padding:3px">' + rowData.StackTrace + '</td>'
                     + '</tr>'
                     + '</table>';
                }
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
