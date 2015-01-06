<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="UserDoubtList.aspx.cs" Inherits="CarAppAdminWebUI.Member.UserDoubtList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
       <%-- <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">

            </div>
        </div>--%>
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
                 url: "/Member/UserDoubtHandler.ashx?" + $("#schForm").serialize(),
                 method: 'post',
                 pagination: true,
                 rownumbers: true,
                 fitColumns: false,
                 singleSelect: true,
                 remoteSort: true,
                 pageList: [15, 30, 45, 60],
                 pageSize: 15,
                 title: "用户疑义管理",
                 frozenColumns: [[
                 { field: 'ck', checkbox: true }
                ]],
                 columns: [
                [
                 { field: 'Content', title: '疑义内容', width: 300 },
                { field: 'OrderId', title: '对应单号', width: 150,formatter:SetOrder },
                { field: 'UserId', title: '用户', width: 100, formatter: getUserName },
                 { field: 'CreTime', title: '创建时间', width: 150, formatter: easyui_formatterdate }
                    ]
                ]
             });
         }
         function setImg(value, row, index) {
             return "<img src='" + value + "' style='width:50px; height:50px;'>";
         }
         function SetOrder(value, row, index) {
             if (value == 0) {
                 return "";
             }
             var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + value + "\")'>" + value + "</a>";
             return html;
         }
         function getUserName(value, row, index) {
             var html = "";
             $.ajax({
                 url: "/Member/CouponHandler.ashx",
                 data: { action: "username", userid: value },
                 type: "post",
                 async: false,
                 success: function (data) {

                     html = "<a title='点击查看用户信息' style=\"text-decoration:underline\" href='javascript:onShowUser(\"" + value + "\")'>" + data + "</a>";

                 }, error: function () {
                     return "";
                 }
             });
             return html;

         }
         function onShowOrder(id) {
             top.addTab("订单详情(ID:" + id + ")", "../Order/OrderDetail.aspx?id=" + id, "icon-nav");
         }
         function onShowUser(id) {
             top.addTab("用户详情(ID:" + id + ")", "../Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
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
                     onSearch();
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
