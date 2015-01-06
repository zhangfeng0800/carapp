<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="MenuManage.aspx.cs" Inherits="CarAppAdminWebUI.Weixin.MenuManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <link href="../Static/styles/WXNews.css" rel="stylesheet" type="text/css" />
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：自定义微信按钮
            </td>
        </tr>
    </table>
    <div style="padding: 5px; height: 35px;" id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a id="add" href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">
                        添加</a>
                </td>
                <td>
                    <a id="upd" href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">
                        编辑</a>
                </td>
                <td>
                    <a id="del" href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">
                        删除</a>
                </td>
                <td>
                    <a id="A1" href="javascript:void(0)" onclick="upweixin()" class="easyui-linkbutton"
                        iconcls="icon-remove">更新到微信</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>

     <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的按钮" style="width: 500px; height: 250px;">
    </div>
    <div id="editwindow" title="编辑按钮信息" style="width: 500px; height: 250px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindWin();
            bindGrid();
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
        function bindGrid() {
            $('#gdgrid').treegrid({
                url: "/Weixin/MenuHandler.ashx",
                method: 'post',
                idField: 'ID',
                treeField: 'Name',
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                toolbar: "#toolbar",
                title: "自定义微信按钮",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'Name', title: '按钮名称', width: 120 },

                { field: 'Type', title: '响应类型', width: 120 },
                { field: 'Url', title: '响应地址', width: 200 },
                ]]
            });
        }

        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Weixin/MenuAdd.aspx');
        }

        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Weixin/MenuAdd.aspx?id=' + row.ID);
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            if (confirm("确认要删除吗？")) {
                $.ajax({
                    url: "weixinHandler.ashx",
                    data: { action: "del", id: row.ID },
                    type: "post",
                    success: function (data) {
                        if (data == "0")
                            alert("失败!");
                        else {
                            $('#gdgrid').treegrid("load");
                            alert("成功!");
                        }
                    }
                })
            }
        }

        function initCheck() {
            $("[type='checkbox']").each(function () {
                $(this).prop("checked", false);
            })
        }

        function upweixin() {
            if (confirm("确认更新吗?")) {
                $.ajax({
                    url: "weixinHandler.ashx",
                    data: { action: "upweixin" },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.errcode == "0")
                            alert("成功！");
                    }
                })
            }
        }
        function ck(obj) {
            if ($(obj).find("input[type='checkbox']").prop("checked"))
                $(obj).find("input[type='checkbox']").prop("checked", false);
            else {
                $("[type='checkbox']").each(function () {
                    $(this).prop("checked", false);
                })
                $(obj).find("input[type='checkbox']").prop("checked", true);
            }
        }

        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
           
        }
        function reload() {
            location.reload();
        }

    </script>
</asp:Content>
