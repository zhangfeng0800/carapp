<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ArticalList.aspx.cs" Inherits="CarAppAdminWebUI.artical.ArticalList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">文章标题</span> <span class="">
                    <input class="adm_21" id="title" name="title" />
                </span></span><span class="input_blo"><span class="input_text">文章栏目</span> <span
                    class="">
                    <select id="typeid" name="typeid">
                        <option value="">不限</option>
                        <%for (int i = 0; i < articalTypes.Count; i++)
                          { %>
                        <option value="<%=articalTypes[i].ID %>">
                            <%=articalTypes[i].Name%></option>
                        <%} %>
                    </select>
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>
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
    <div id="addwindow" title="添加文章内容" style="width: 1200px; height: 800px;">
    </div>
    <div id="editwindow" title="编辑文章内容" style="width: 1200px; height: 800px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            resizeCarwindow("addwindow");
            resizeCarwindow("editwindow");
            bindWin();
            bindGrid();

        });
        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height()-10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/artical/ArticalHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                toolbar: "#toolbar",
                title: "文章管理",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'ID', title: '自动编号', width: 60 },
                { field: 'articalName', title: '文章栏目', width: 100 },
                { field: 'title', title: '文章标题', width: 100 },
                {field: 'datetime', title: '创建时间', width: 120,formatter:easyui_formatterdate },
                { field: 'isPublish', title: '发布状态', width: 100, formatter: getPub },
                { field: 'orderNumber', title: '排序', width: 100 },
                { field: 'imagePath', title: '图片', width: 100, formatter: getImg }
                ]]
            });
        }
        function resizeCarwindow(obj) {
            var height = ($(window).height());
            var width = $(window).width();
            $("#" + obj).css("height", height);
            $("#" + obj).css("width", width);
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

        function getType(value, row, index) {
            var result = '';
            $.ajax({
                url: 'ArticalHandler.ashx',
                type: 'post',
                async: false,
                data: { action: 'getType', ID: value },
                success: function (data) {
                    result = data;
                }
            });
            return result;
        }
        function getPub(value, row, index) {
            if (value == 1)
                return "已发布";
            else
                return "<span style='color:red;'>未发布</span>";
        }

        function getImg(value, row, index) {
            if (value != "")
                return "  <img alt='' width='50px' height='50px' src='" + value + "' />";
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/artical/ArticalHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }


        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"];
            $("#editwindow").window("open");
            $("#editwindow").window("refresh", "/artical/ArticalManage.aspx?method=update&contentID=" + id);
        }

        function onAdd() {
            $("#addwindow").window("open");
            $("#addwindow").window("refresh", "/artical/ArticalManage.aspx?method=add")
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"] + ",";
            if (confirm("确认要删除吗?")) {
                $.post("../Ajax/ArticalContentController.ashx", { 'action': 'DeleteContent', 'ids': id }, function (data) {
                    onSearch();
                });
            }
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');

        }

    </script>
</asp:Content>
