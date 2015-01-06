<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="SalesManList.aspx.cs" Inherits="CarAppAdminWebUI.Member.SalesManList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">

 <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
               <span class="input_blo"><span class="input_text">用户名</span> <span
                        class="">
                      <input name="username" id="username" />
                    </span></span>
                      <span class="input_blo"><span class="input_text">状态</span> <span
                        class="">
                      <select id="state" name="state">
                      <option value="正常">正常</option>
                      <option value="已删除">已删除</option>
                      </select>
                    </span></span>
                    
                    <span class="input_blo">
                          <a href="javascript:onSearch()" class="easyui-linkbutton" iconcls="icon-search">查询</a>
                    </span>
            </div>
        </div>
    </div>
     <div  id="toolbar" class="datagrid-toolbar">
        <table>
           
            
            <tr>
                <td> 
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">编辑</a>
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                     <a href="javascript:onReset()" class="easyui-linkbutton" iconcls="icon-remove">恢复</a>
                
                </td>
               
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
     <div id="addwindow" title="添加领卡人" style="width: 500px; height: 300px;">
    </div>
     <div id="editwindow" title="编辑领卡人" style="width: 500px; height: 300px;">
    </div>
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
            var height = ($(window).height() - $("#querycontainer").height()-10);
            var width = $(window).width - 100;
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
                url: "/Member/SalesManHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "领卡人管理",
                frozenColumns: [[
                { field: 'ck', checkbox: true }
                ]]
                ,
                columns: [
                [
                { field: 'name', title: '名称', width: 100 },
                { field: "sort", title: "排序", width: 100 },
                { field: 'createman', title: '创建人', width: 100 },
                { field: 'createtime', title: '创建时间', formatter: easyui_formatterdate, width: 150 },
                  { field: 'state', title: '状态', formatter: getstate, width: 100 },
                ]
                ]
            });
        }
        function getstate(value, row, index) {
            if (value == "已删除")
                return "<span style='color:red'>" + value + "</span>";
            else
                return value;
        }

        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/SalesManHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Member/SalesManAdd.aspx');
        }
        function onEdit() {
            var ids = getSelectIds();
            if (ids == "") {
                $.messager.alert('消息', '你没有选择任何数据', 'error');
                return;
            }
            if (ids.indexOf(',') != -1) {
                $.messager.alert('消息', '只能选择一条数据', 'error');
                return;
            }
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Member/SalesManEdit.aspx?Id=' + ids);
        }

        function onDelete() {
            var ids = getSelectIds();
            if (ids == "") {
                $.messager.alert('消息', '你没有选择任何数据', 'error');
            }
            $.messager.confirm("提示", "你确定要执行此操作么？", function (r) {
                if (r) {
                    var d = { "action": "delete", "ids": ids };
                    $.post("/Member/SalesManHandler.ashx", d, function (data) {
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
        function getSelectIds() {
            var items = $("#gdgrid").datagrid("getSelections");
            var ids = "";
            for (var i = 0; i < items.length; i++) {
                if (i == items.length - 1) {
                    ids += items[i].id;
                } else {
                    ids += items[i].id + ",";
                }
            }
            return ids;
        }
        function onReset() {
            var ids = getSelectIds();
            if (ids == "") {
                $.messager.alert('消息', '你没有选择任何数据', 'error');
                return;
            }
            if (ids.indexOf(',') != -1) {
                $.messager.alert('消息', '只能选择一条数据', 'error');
                return;
            }
            $.post("/Member/SalesManHandler.ashx", { "action": "reset", "Id": ids }, function (data) {
                if (data.IsSuccess) {
                    $.messager.alert('消息', '操作成功！', 'info', function () {
                        onSearch();
                    });
                } else {
                    $.messager.alert('消息', data.Message, 'error');
                }
            },"json");
        }

        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        </script>

</asp:Content>
