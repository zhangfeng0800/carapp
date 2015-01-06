<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="RechargeActivityList.aspx.cs" Inherits="CarAppAdminWebUI.Activity.RechargeActivityList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
  
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">活动名称</span> <span class="">
                    <input class="adm_21" id="Text1" name="Keyword" type="text" value="" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
            </div>
        </div>
    </div>
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
    <div id="addwindow" title="添加新的活动" style="width: 500px; height: 280px;">
    </div>
    <div id="editwindow" title="编辑活动信息" style="width: 500px; height: 280px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();
        });
        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
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
                url: "/Activity/RechargeActivityHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "充值活动管理",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'id', title: '编号', width: 100 },
                { field: 'name', title: '名称', width: 100 },
                {
                    field: 'startDate',
                    title: '开始时间',
                    width: 100,
                    formatter: mydate
                },
                {
                    field: 'deadline',
                    title: '结束时间',
                    width: 100,
                    formatter: mydate
                },
                { field: 'minMoney', title: '充值金额（元）', width: 100 },
                { field: 'money', title: '赠送金额（元）', width: 100 }
                    ]
                ]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Activity/RechargeActivityHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Activity/RechargeActivityAdd.aspx');
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "id", "/Activity/RechargeActivityEdit.aspx?id=");
        }
        function mydate(value, row, index) {
            return value.substring(0,10);
        }
        function onDelete() {
            ajaxdelete("GiveMoney", "id", "id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
