<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CityList.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.CityList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
   
    <div id="querycontainer" class="container" style="min-width: 700px;">
        <table>
            <tr>
                <td>
                    省份名称：
                </td>
                <td>
                       <input class="adm_21" id="keyword" name="keyword"   />
                </td>
                <td>
                    <a href="javascript:onSearch()" class="easyui-linkbutton" iconcls="icon-search">查询</a>
                </td>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton icon-add" iconcls="icon-add">添加</a>
                </td>
                <td>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>
                </td>
                <td style="display: none">
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的城市" style="width: 500px; height: 240px;">
    </div>
    <div id="editwindow" title="编辑城市信息" style="width: 500px; height: 240px;">
    </div>
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
            $('#gdgrid').treegrid({
                url: "/ProvinceCity/CityHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                animate: true,
                idField: 'CodeId',
                treeField: 'CityName',
                rownumbers: true,
                fitColumns: false,
                singleSelect: true, 
                title: "省市信息维护",
                columns: [[
                { field: 'ck', checkbox: true },
                { field: 'CityName', title: '名称', width: 300 },
                 { field: 'Sort', title: '排序', width: 100 }
            ]]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").treegrid("options").url = "/ProvinceCity/CityHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").treegrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/ProvinceCity/CityAdd.aspx');
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onEdit() {
            var row = $("#gdgrid").treegrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/ProvinceCity/CityEdit.aspx?id=' + row.CodeId);
        }

        function onDelete() {
            var row = $("#gdgrid").treegrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "你确定要执行此操作么？", function (r) {
                if (r) {
                    var d = { "action": "delete", "id": row.CodeId };
                    $.post("/ProvinceCity/CityHandler.ashx", d, function (data) {
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
        }
    </script>
</asp:Content>
