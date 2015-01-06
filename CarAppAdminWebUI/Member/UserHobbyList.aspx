<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="UserHobbyList.aspx.cs" Inherits="CarAppAdminWebUI.Member.UserHobbyList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">

    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                    <span class="input_blo">
                          <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">新增</a>
                    </span>
                      <span class="input_blo">
                          <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">修改</a>
                    </span>
                    <span class="input_blo">
                              <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                    </span>
            </div>
        </div>
    </div>
    <table id="gdgrid">
    </table>
     <div id="addwindow" title="新增喜好" style="width: 1000px; height: 660px;">
    </div>
      <div id="editwindow" title="编辑喜好" style="width: 1000px; height: 660px;">
    </div>
    </form>

     <script type="text/javascript">
         //初始化
         $(function () {
             resizeTable();
             bindGrid();
             bindWin();
         });

         function resizeTable() {
             var height = ($(window).height() - $("#querycontainer").height() - 10);
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
                 url: "/Member/UserHobbyHandler.ashx?" + $("#schForm").serialize(),
                 method: 'post',
                 pagination: false,
                 rownumbers: true,
                 fitColumns: false,
                 singleSelect: true,
                 remoteSort: true,
                 title: "用户喜好管理",
                 frozenColumns: [[
                 { field: 'ck', checkbox: true }
                ]],
                 columns: [
                [
                 { field: 'Id', title: '编号', width: 100, width: 100 },
                { field: 'Name', title: '名称', width: 100, width: 100 },

                { field: 'Image', title: '对应图标', width: 100, formatter: setImg },
                { field: 'Sort', title: '排序', width: 100 }
                    ]
                ]
             });
         }
         function setImg(value, row, index) {
             return "<img src='" + value + "' style='width:50px; height:50px;'>";
         }

         function onAdd() {
             $('#addwindow').window('open');
             $('#addwindow').window('refresh', '/Member/UserHobbyAdd.aspx');
         }
         function onEdit() {
             var row = $("#gdgrid").datagrid("getSelected");
             if (!row) {
                 $.messager.alert('消息', '你没有选择数据', 'error');
                 return;
             }
             var id = row["Id"];
             $('#editwindow').window('open');
             $('#editwindow').window('refresh', '/Member/UserHobbyEdit.aspx?id=' + id);
         }

         function onDelete() {
             var row = $("#gdgrid").datagrid("getSelected");
             if (!row) {
                 $.messager.alert('消息', '你没有选择数据', 'error');
                 return;
             }
             var id = row["Id"];
             if (confirm("确认要删除吗?")) {
                 $.post("/Member/UserHobbyHandler.ashx", { 'action': 'DeleteHobby', 'id': id }, function (data) {
                     if (data == 1) {
                         onSearch();
                     } else {
                         alert("该数据已经使用，不能删除")
                     }
                 });
             }
         }
         //搜索
         function onSearch() {
             $("#gdgrid").datagrid("options").url = "/Member/UserHobbyHandler.ashx?" + $("#schForm").serialize();
             $("#gdgrid").datagrid("load");
         }
         //关闭弹窗
         function onClose() {
             $('[id$=window]').window('close');
             onSearch();
         }

  </script>
</asp:Content>
