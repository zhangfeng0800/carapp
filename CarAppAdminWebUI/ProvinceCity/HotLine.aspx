<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="HotLine.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.HotLine" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script src="../Static/easyui/datagrid-detailview.js" type="text/javascript"></script>
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省份</span> <span class="">
                    <select class="adm_21" id="provenceID" style="width: 80px;" name="provenceID">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">城市</span> <span class="">
                    <select class="adm_21" id="cityID" style="width: 80px;" name="cityID">
                    </select></span> </span><span class="input_blo"><span class="input_text">区县</span> <span
                        class="">
                        <select class="adm_21" id="townID" style="width: 80px;" name="townID">
                        </select>
                    </span></span><span class="input_blo"><span class="input_text">名称</span> <span class="">
                        <input class="adm_21"  style="width: 80px;" id="Keyword" name="Keyword" type="text" value="" />
                    </span></span><span class="input_blo"><span class="input_text">是否景点</span> <span
                        class="">
                        <select class="adm_21" id="IsTravel" style="width:50px;" name="IsTravel">
                            <option value="-1">不限</option>
                            <option value="1">是</option>
                            <option value="0">否</option>
                        </select>
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
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">修改</a>
                    <a href="javascript:onTheme()" class="easyui-linkbutton" iconcls="icon-edit">编辑主题信息</a>
                    <a style="display: none" href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的线路城市" style="width: 900px; height: 760px;">
    </div>
    <div id="editwindow" title="编辑线路城市信息" style="width: 900px; height: 760px;">
    </div>
    <div id="themewindow" title="编辑线路城市主题" style="width: 500px; height: 150px;">
    </div>
    <div id="w" class="easyui-window" title="查看图片" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 350px; height: 350px;">
        <span>
            <img src="" id="imgcontainer" style="margin: 0 auto;" /></span>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            initProvinceSelectValue("provenceID", "不限", "13");
            initCitySelect("cityID", "不限", "13", "1301");
            initCitySelect("townID", "不限", "1301", "");

            citySelectChange("provenceID", "cityID", "townID", "不限");
            citySelectChange("cityID", "townID", "", "不限");

            resizeTable();
            resizeCarwindow("addwindow");
            resizeCarwindow("editwindow");

            bindGrid();
            bindWin();

        });
        function showBimg(value, data, index) {
            return "<a  style=\"text-decoration:underline\" href=\"javascript:showImg(true,'" + value + "')\">点击查看</a>";
        }
        function showSimg(value, data, index) {
            return "<a style=\"text-decoration:underline\" href=\"javascript:showImg(false,'" + value + "')\">点击查看</a>";
        }
        function showImg(isbig, value) {
            if (isbig) {
                $("#imgcontainer").css("width", 200);
                $("#imgcontainer").css("height", 250);
                $("#imgcontainer").css("margin-left", 50);
                $("#imgcontainer").css("margin-top", 25);
            } else {
                $("#imgcontainer").css("width", 150);
                $("#imgcontainer").css("height", 150);
                $("#imgcontainer").css("margin-left", 75);
                $("#imgcontainer").css("margin-top", 75);
            }
            if (value == "" || value == null) {
                $.messager.alert("提示信息", "暂无图片");
                return;
            }
            $("#imgcontainer").attr("src", value);
            $("#w").window("open");
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
        function resizeTable() {
            var height = ($(window).height() -$("#querycontainer").height()-10);
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
                url: "/ProvinceCity/HotLineList.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                collapsible: true,
                pageSize: 15,
                title: "热线目的城市维护",
                toolbar: "#toolbar",
                view: detailview,
                frozenColumns: [[
                   { field: 'ck', checkbox: true },
                        { field: 'name', title: '名称', width: 100 }
                ]],
                columns: [
                    [

                        { field: 'CityName', title: '所属城市', width: 100 },
                        { field: 'IsTravel', title: '是否景点', width: 100, formatter: IsTravelformatter },
                        { field: 'Price', title: '门票价格(元)', width: 100, formatter: Priceformatter, sortable: true },
                        { field: 'ImgUrl', title: '展示图片(大)', width: 100, formatter: showBimg },
                        { field: 'SImgUrl', title: '展示图片(小)', width: 100, formatter: showSimg },
                        { field: 'SortOrder', title: '排序', width: 100, sortable: true }
                    ]
                ],
                detailFormatter: function (rowIndex, rowData) {
                    return "<b>概要说明：</b><br/>" + rowData.Summary
                    + "<br/><b>相关主题：</b><br/>" + rowData.TravelTheme;
                }
            });
        }

        function imageformatter(value, data, index) {
            if (value != "") {
                return "<img src='" + value + "' width='20px' height='20px'/>";
            }
            return "";
        }
        function lookImg() {

        }
        /* formatter */
        function IsTravelformatter(value, row, index) {
            if (value == 1) {
                return "√";
            }
            return "";
        }

        function Priceformatter(value, row, index) {
            if (row.IsTravel == 1) {
                return value;
            }
            return "";
        }


        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/ProvinceCity/HotLineList.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/ProvinceCity/HotLineAdd.aspx');
        }
        function onTheme() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#themewindow').window('open');
            $('#themewindow').window('refresh', "/ProvinceCity/HotLineTraveltheme.aspx?id=" + row.id);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "id", "/ProvinceCity/HotLineEdit.aspx?id=");
        }

        function onDelete() {
            commondelete("/ProvinceCity/SaveHotLine.ashx", "gdgrid", "id", onSearch);
        }
    </script>
</asp:Content>
