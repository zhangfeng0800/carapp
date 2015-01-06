<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="TypeList.aspx.cs" Inherits="CarAppAdminWebUI.artical.TypeList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a id="add" href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">
                        添加</a>
                </td>
                <td>
                    <a id="upd" href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">
                        编辑</a>
                </td>
                <td>
                    <a id="del" href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">
                        删除</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    <table id="gdgrid">
    </table>
    <div id="editwindow" title="类别名称" style="width: 500px; height: 400px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindWin();
            bindGrid();
        });
        function resizeTable() {
            var height = ($(window).height()-$("#querycontainer").height()-10 );
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
        }
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/artical/ArticalHandler.ashx?action=typelist",
                method: 'post',
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                title: "文章类别管理",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
             
                { field: 'Name', title: '栏目名称', width: 100 },
                { field: 'hasImage', title: '是否有主图', width: 100, formatter: getIsorNot },
                { field: 'indexShow', title: '首页展示', width: 100, formatter: getIsorNot },
                { field: 'sort', title: '排序', width: 100 },
                ]]
            });
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

        function getIsorNot(value, row, index) {
            if (value == 1)
                return "是";
            else
                return "<span style='color:red;'>否</span>";
        }


        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/artical/ArticalHandler.ashx?action=typelist";
            $("#gdgrid").datagrid("load");
        }


        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"];
            $("#editwindow").window("open");
            $("#editwindow").window("refresh", "/artical/TypeMana.aspx?typeID=" + id);
        }

        function onAdd() {
            $("#editwindow").window("open");
            $("#editwindow").window("refresh", "/artical/TypeMana.aspx")
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"] + ",";
            if (confirm("确认要删除吗?")) {
                $.post("../Ajax/ArticlaTypeController.ashx", { 'action': 'DeleteType', 'ids': id }, function (data) {
                    onSearch();
                });
            }
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');

        }

    </script>
</asp:Content>
