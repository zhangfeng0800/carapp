<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CarRemarkList.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarRemarkList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input class="adm_21" id="action" name="action" type="hidden" value="list" />
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">添加</a>
                </td>
                <td>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>
                </td>
                  <td>
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-edit">删除</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的品牌">
    </div>
    <div id="editwindow" title="编辑品牌信息">
    </div>
    <div id="w" class="easyui-window" title="查看图片" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 350px; height: 350px;">
        <span>
            <img src="" id="imgcontainer" style="margin: 0 auto;" /></span>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            resizeCarWindow("addwindow");
            resizeCarWindow("editwindow");
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
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        function resizeCarWindow(name) {
            var height = $(window).height() - 50;

            var width = $(window).width() - 20;
            $("#" + name).css("width", width);
            $("#" + name).css("height", height);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Car/remarkhandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "车辆备注信息",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true, width: 50 },
                {
                    field: 'content',
                    title: '备注内容',
                    width: 300
                },
                { field: 'createtime', title: '创建时间', width: 150,formatter:easyui_formatterdate },
                { field: 'sortorder', title: '排序' }
                    ]
                ]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/remarkhandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Car/CarRemarkAdd.aspx');
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "id", "/Car/CarRemarkEdit.aspx?id=");
        }

        function onDelete() {
            ajaxdelete("carremark", "id", "id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
