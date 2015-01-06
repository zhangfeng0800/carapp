<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="AirPort.aspx.cs" Inherits="CarAppAdminWebUI.Air.AirPort" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=P0IuySP2OeqbIxwu0H5qjfR6"></script>
    <form id="schForm">
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省份</span> <span class="">
                    <select class="adm_21" id="provenceID" style="width: 100px;" name="provenceID">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">机场名称</span> <span
                    class="">
                    <input class="adm_21" id="Keyword" name="Keyword" type="text" value="" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td colspan="5">
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">编辑</a>
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
    <div id="addwindow" title="添加新的机场" style="width: 1000px; height: 600px;">
    </div>
    <div id="editwindow" title="编辑机场信息" style="width: 1000px; height: 600px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            //initProvinceSelectValue("provenceID", "不限", "13");

            resizeTable();
            resizeCarwindow("addwindow");
            resizeCarwindow("editwindow");
            bindGrid();
            bindWin();

            initCitySelect("provenceID", "请选择", 0, "");
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
            var height = ($(window).height() - $("#querycontainer").height()-10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        function resizeCarwindow(obj) {
            var height = ($(window).height());
            var width = $(window).width();
            $("#" + obj).css("height", height);
            $("#" + obj).css("width", width);
        }

        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Air/AirPortList.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "机场信息维护",
                collapsible: true,
                toolbar: "#toolbar",
                columns: [
                    [
                        { field: 'ck', checkbox: true },
                        { field: 'AirPortName', title: '机场名称', width: 100 },
                        { field: 'CityName', title: '城市名称', width: 100 },
                        { field: 'Lng', title: '经度', width: 100 },
                        { field: 'Lat', title: '纬度', width: 100 }
                    ]
                ]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Air/AirPortList.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Air/AirPortEdit.aspx?id=' + row.Id);
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Air/AirPortAdd.aspx');
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onDelete() {
            ajaxdelete("airport", "id", "Id", "gdgrid", onSearch);
        }
    </script>
</asp:Content>
