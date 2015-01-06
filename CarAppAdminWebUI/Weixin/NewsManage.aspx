<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="NewsManage.aspx.cs" Inherits="CarAppAdminWebUI.Weixin.NewsManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
     
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a id="add" href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">添加</a>
                </td>
                <td>
                    <a id="upd" href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">
                        编辑</a>
                </td>
                <td>
                    <a id="del" href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">
                        删除</a>
                </td>
                <td>每月可群发4条，本月还可发送<span style="color:Red;"><%=unsendNum %></span>条。超出条数后再推送用户将不会收到</td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    <table id="gdgrid">
    </table>
    <div id="editwindow" title="编辑微信图文" style="width: 1200px; height: 800px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindWin();
            bindGrid();
        });
        function resizeTable() {
            var height = ($(window).height());
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width); 
        }
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Weixin/NewsList.ashx?action=list&type=not",
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "微信图文管理",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                 { field: 'ID', title: '自动编号', width: 60 },
                { field: 'Type', title: '图文类型', width: 100 },

                { field: 'CreateTime', title: '创建时间', width: 120, formatter: easyui_formatterdate },
                { field: 'SendTime', title: '发送时间', width: 120, formatter: easyui_formatterdate },
                { field: 'State', title: '发送状态', width: 100 },

                { field: 'ReturnInfo', title: '微信返回信息', width: 100 }
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
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Weixin/NewsList.ashx?action=list&type=not";
            $("#gdgrid").datagrid("load");
        }

        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"]; 
            top.addTab("编辑图文(ID:" + id + ")", "WeiXin/NewsOpera.aspx?wxNewsID=" + id, "icon-nav");
        }

        function onAdd() {
            $.ajax({
                url: "NewsList.ashx",
                data: { action: "add" },
                type: 'post',
                success: function (data) {
                    if (data != "0") {
                        onSearch();
                        setTimeout(function () {
                            top.addTab("编辑图文(ID:" + data + ")", "WeiXin/NewsOpera.aspx?wxNewsID=" + data, "icon-nav");
                        }, 100);

                    }
                }
            })
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }

            var id = row["ID"];
            if (confirm("确认要删除吗?")) {
                $.ajax({
                    url: "NewsList.ashx",
                    type: 'post',
                    data: { action: "del", ID: id },
                    success: function (data) {
                        if (data != "0") {
                            $.messager.alert('消息', '删除成功！', 'info', function () {
                                $("#gdgrid").datagrid("load");
                            })
                        }
                    }
                })
            }
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');

        }

    </script>
</asp:Content>
