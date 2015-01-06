<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="TravelthemeList.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.TravelthemeList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">名称</span> <span class="">
                    <input class="adm_21" id="Keyword" name="Keyword" type="text" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
            </div>
        </div>
    </div>
    <div  id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
               
                <td>
                
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
             
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">修改</a>
                
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
    <div id="addwindow" title="添加新的线路主题" style="width: 400px; height: 175px;">
    </div>
    <div id="editwindow" title="编辑线路主题信息" style="width: 400px; height: 175px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();
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
            var height = ($(window).height() -$("#querycontainer").height()-10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/ProvinceCity/TravelthemeHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                title: "旅游线路主题",
                collapsible: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                toolbar:"#toolbar",
                columns: [
                    [
                        { field: 'ck', checkbox: true },

                        { field: 'Name', title: '主题名称', width: 100 },
                        { field: 'SortOrder', title: '排序', width: 100 }
                    ]
                ]
            });
        }

        /* formatter */
        function fpid(value, row, index) {
            if (value == 0) {
                return "根节点";
            }
            return '[' + value + ']' + row.PName;
        }


        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/ProvinceCity/TravelthemeHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/ProvinceCity/TravelthemeAdd.aspx');
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "Id", "/ProvinceCity/TravelthemeEdit.aspx?id=");
        }

        function onDelete() {
            commondelete("/ProvinceCity/TravelthemeHandler.ashx?action=delete", "gdgrid", "Id", onSearch);
        }
    </script>
</asp:Content>
