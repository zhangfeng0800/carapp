<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="FundRulesList.aspx.cs" Inherits="CarAppAdminWebUI.Activity.FundRulesList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">

<form id="schForm">
    <input id="action" name="action" value="ruleslist" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">规则名称</span> <span class="">
                    <input class="adm_21" id="Name" name="Name" type="text" value="" />
                </span></span>
                <span class="input_blo"><span class="input_text">状态</span> <span class="">
                    <select id="Status" name="Status">
                    <option value="">全部</option>
                     <option value="正常">正常</option>
                      <option value="已删除">已删除</option>
                    </select>
                </span></span>
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
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
                  <td>
                    <a href="javascript:onRecovery()" class="easyui-linkbutton" iconcls="icon-remove">恢复</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的规则" style="width: 500px; height: 280px;">
    </div>
    <div id="editwindow" title="编辑活动规则" style="width: 500px; height: 280px;">
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
                url: "/Activity/FundingHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "业务规则管理",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'Id', title: '编号', width: 100 },
                { field: 'Name', title: '名称', width: 100 },
               
                { field: 'Cost', title: '单券面值(元)', width: 100 },
                { field: 'Num', title: '每月返券数', width: 100 },
                { field: 'ReferencePrice', title: '建议金额（元）', width: 100 },
                { field: 'CreateTime', title: '创建时间', width: 100, formatter: easyui_formatterdate },
                { field: 'Status', title: '状态', width: 100 ,formatter:fostate}
                    ]
                ]
            });
        }
        function fostate(value, row, index) {
            if (value == "已删除") {
                return "<span style='color:red'>已删除</span>";
            }
            else
                return value;
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Activity/FundingHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Activity/FundRulesAdd.aspx');
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            } 
              var id = row["Id"];
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Activity/FundRulesEdit.aspx?id=' + id);
        }
        function mydate(value, row, index) {
            return value.substring(0, 10);
        }
        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            } else if (row["Status"] == '已删除') {
                $.messager.alert('消息', '不能重复删除', 'error');
                return;
            }
            var id = row["Id"];
            if (confirm("确认要删除吗?")) {
                $.post("/Activity/FundingHandler.ashx", { 'action': 'deleteRules', 'id': id }, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', "删除成功");
                        onSearch();
                    } else {
                        $.messager.alert('消息', data.Message);
                    }
                },"json");
            }
        }
        function onRecovery() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            } else if (row["Status"] == '正常') {
                $.messager.alert('消息', '不能重复恢复', 'error');
                return;
            }
            var id = row["Id"];
            if (confirm("确认要恢复吗?")) {
                $.post("/Activity/FundingHandler.ashx", { 'action': 'recoveryRules', 'id': id }, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', "恢复成功");
                        onSearch();
                    } else {
                        $.messager.alert('消息', data.Message);
                    }
                }, "json");
            }
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>

</asp:Content>
