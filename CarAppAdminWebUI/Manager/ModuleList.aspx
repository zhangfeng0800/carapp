<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ModuleList.aspx.cs" Inherits="CarAppAdminWebUI.Manager.ModuleList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script type="text/javascript" src="/Static/easyui/datagrid-detailview.js"></script>
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>
                </td>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">添加</a>
                </td>
                <td>
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid" class="easyui-tree">
    </table>
    <div id="addwindow" title="添加模块信息" style="width: 600px; height: 300px;">
    </div>
    <div id="editwindow" title="编辑订单信息" style="width: 600px; height: 500px;">
    </div>
    <script type="text/javascript">
        $(function () {
            resizeTable();
            showList();
            bindWin();
            $.ajax({
                url: "/manager/modulehandler.ashx?action=path",
                success: function (data) {
                    console.log(data);
                }
            });
        });
        function resizeTable() {
            var height = $(window).height();
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
        function showList() {
            $("#gdgrid").treegrid({
                url: "/manager/modulehandler.ashx?" + $("#schForm").serialize(),
                method: "post",
                idField: "ModuleID",
                treeField: "ModuleName",
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                title: "模块管理",
                toolbar: "#toolbar",
                columns: [[
                    { field: "ck", checkbox: true },
                    { title: "模块名称", field: "ModuleName", width: 200 },
                    { title: "链接地址", field: "LinkUrl", width: 200,formatter:formatterRootModule },
                    { title: "排序", field: "ModuleSort", width: 100 },
                    { title: "是否可用", field: "ModuleVisible", width: 100, formatter: visibleformatter }
                ]]

            });
        }

        function  formatterRootModule(value,row,index) {
            if (row.ParentId == "0") {
                return "顶级模块无链接";
            } else {
                return value;
            }
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Manager/moduleadd.aspx');
        }


        function onEdit() {
            var row = $("#gdgrid").treegrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Manager/ModuleEdit.aspx?id=' + row.ModuleID);
        }
        function visibleformatter(value, row, index) {
            if (value == "0") {
                return "不可用";
            } else {
                return "可用";
            }
        }
        function onSearch() {
            $("#gdgrid").treegrid("options").url = "/manager/modulehandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").treegrid("load");
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onDelete() {
            var row = $("#gdgrid").treegrid("getSelected");
            if (!row) {
                $.messager.alert("提示信息", "请选择数据");
                return;
            } else {
                $.messager.confirm("提示信息", "确定要删除吗？", function (result) {
                    if (result) {
                        var id = row.ModuleID;
                        var pid = row.ParentId;
                        $.ajax({
                            url: "/manager/modulehandler.ashx",
                            data: { moduleId: id, parentId: pid, action: "delete" },
                            type: "post",
                            success: function (data) {
                                if (data.IsSuccess == false) {
                                    $.messager.alert("提示信息", data.Message);
                                } else {
                                    $.messager.alert("提示信息", data.Message);
                                    onClose();
                                }
                            }
                        });
                    }
                });
            }
        }
    </script>
</asp:Content>
