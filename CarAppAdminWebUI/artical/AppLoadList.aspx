<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="AppLoadList.aspx.cs" Inherits="CarAppAdminWebUI.artical.AppLoadList" %>
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
                              <a href="javascript:onEditState()" class="easyui-linkbutton" iconcls="icon-edit">更改显示状态</a>
                    </span>
                    <span class="input_blo" style="display:none;">
                              <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                    </span>
            </div>
        </div>
    </div>
    <table id="gdgrid">
    </table>
     <div id="addwindow" title="新增Loading图" style="width: 1000px; height: 660px;">
    </div>
      <div id="editwindow" title="编辑Loading 图" style="width: 1000px; height: 660px;">
    </div>

      <div id="show" style="display: none; position:absolute; left:100px; top:10px; z-index:1000;">  
        <div id="photo" style="height: 640px;">  
            <img style="height:640px; width:360px;"/>  
            <div id="info">单击关闭</div>
        </div>  
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
                 url: "/artical/AppLoadHandler.ashx?" + $("#schForm").serialize(),
                 method: 'post',
                 pagination: true,
                 rownumbers: true,
                 fitColumns: false,
                 singleSelect: true,
                 remoteSort: true,
                 pageList: [15, 30, 45, 60],
                 pageSize: 15,
                 title: "Loading 图管理",
                 frozenColumns: [[
                 { field: 'ck', checkbox: true }
                ]],
                 columns: [
                [
                 { field: 'Id', title: '编号', width: 50, width: 100 },
                { field: 'State', title: '状态', width: 80, width: 100 },

                { field: 'ImageUrl', title: '对应图', width: 100, formatter: setImg },
                { field: 'Version', title: '版本号', width: 80, width: 100 },
                { field: 'CreateTime', title: '创建时间', width: 180, formatter: easyui_formatterdate }
                    ]
                ]
             });
         }
         function setImg(value, row, index) {
             return "<img onclick='showImg(this)' src='" + value + "' style='width:50px; height:80px;cursor:pointer;'>";
         }
         function showImg(obj) {
             var photo_url = $(obj).attr("src");

             //设置图片路径  
             $("#photo").find("img").attr("src", photo_url);

             $("#show").fadeIn(300);  //显示图片效果  
//             //设置显示放大后的图片位置  
//             document.getElementById("show").style.left = $(window).width() / 2 - 300;
//             document.getElementById("show").style.top = $(window).height() / 2 - 100;

             
             //单击放大后的图片消失  
             $("#photo").click(function () {
                 $("#show").fadeOut(300); //图片消失效果  
             });
         }

         function onAdd() {
             $('#addwindow').window('open');
             $('#addwindow').window('refresh', '/artical/AppLoadAdd.aspx');
         }
         function onEdit() {
             var row = $("#gdgrid").datagrid("getSelected");
             if (!row) {
                 $.messager.alert('消息', '你没有选择数据', 'error');
                 return;
             }
             var id = row["Id"];
             $('#editwindow').window('open');
             $('#editwindow').window('refresh', '/artical/AppLoadEdit.aspx?id=' + id);
         }
         function onEditState() {
             var row = $("#gdgrid").datagrid("getSelected");
             if (!row) {
                 $.messager.alert('消息', '你没有选择数据', 'error');
                 return;
             }
             var id = row["Id"];
             $.post("/artical/AppLoadHandler.ashx", { 'action': 'editState', 'id': id }, function (data) {
                 if (data == 1) {
                     $.messager.alert('消息', '操作成功！', 'info', function () {
                         onSearch();
                     });
                 }
             });
         }

         function onDelete() {
             var row = $("#gdgrid").datagrid("getSelected");
             if (!row) {
                 $.messager.alert('消息', '你没有选择数据', 'error');
                 return;
             }
             var id = row["Id"];
             if (confirm("确认要删除吗?")) {
                 $.post("/artical/AppLoadHandler.ashx", { 'action': 'Delete', 'id': id }, function (data) {
                     if (data == 1) {
                         $.messager.alert('消息', '操作成功！', 'info', function () {
                             onSearch();
                         });
                        
                     }
                     
                 });
             }
         }
         //搜索
         function onSearch() {
             $("#gdgrid").datagrid("options").url = "/artical/AppLoadHandler.ashx?" + $("#schForm").serialize();
             $("#gdgrid").datagrid("load");
         }
         //关闭弹窗
         function onClose() {
             $('[id$=window]').window('close');
             onSearch();
         }

  </script>

</asp:Content>
