<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ActivitiesList.aspx.cs" Inherits="CarAppAdminWebUI.Car.ActivitiesList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script src="/Static/easyui/datagrid-detailview.js" type="text/javascript"></script>
    <form id="schForm">
    <input name="action" type="hidden" value="list" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省份</span> <span class="">
                    <select class="adm_21" id="sprovinceId" style="width: 100px;" name="provinceId">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">城市</span> <span class="">
                    <select class="adm_21" id="scityId" style="width: 100px;" name="cityId">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">区县</span> <span class="">
                    <select class="adm_21" id="scountyId" style="width: 100px;" name="countyId">
                        <option value="">不限</option>
                    </select>
                </span></span>
                <%--<span class="input_blo"><span class="input_text">名称</span> <span class="">
                    <input class="adm_21" style="width: 80px;" id="Keyword" name="Keyword" type="text"
                        value="" />
                </span></span>--%>
                <span class="input_blo"><span class="input_text">焦点图
                    <input class="adm_21" value="1" id="isFocus" name="isFocus" type="checkbox" />
                </span></span><span class="input_blo"><span class="input_text">是否隐藏
                    <input class="adm_21" value="1" id="isHide" name="isHide" type="checkbox" />
                </span></span><span class="input_blo"><span class="input_text">优惠类型
                    <select name="activitytype" id="activitytype">
                        <option value="">不限</option>
                        <option value="1">优惠文章</option>
                        <option value="0">用车优惠</option>
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
    <div id="addwindow" title="添加新的优惠信息" style="width: 690px; height: 600px;">
    </div>
    <div id="editwindow" title="编辑优惠信息" style="width: 690px; height: 600px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();


            initCitySelect("sprovinceId", "不限", 0, "13");
            initCitySelect("scityId", "不限", "13", "");
            citySelectChange("sprovinceId", "scityId", "scountyId", "不限");
            citySelectChange("scityId", "scountyId", "", "不限");

            onSearch();
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
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }

        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Car/ActivitiesHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "优惠活动信息管理",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'id', title: '编号', width: 50 },
                { field: 'CityName', title: '城市名称', width: 100 },
                { field: 'price', title: '活动价格', width: 60 },
                { field: 'ordernum', title: '排序', width: 50 },
              
                { field: 'imgurl', title: '相关图片', width: 100 },
                { field: 'IsFocus', title: '是否焦点图', width: 75, formatter: getValue },
                { field: 'IsTop', title: '是否置顶', width: 60, formatter: getValue },
                { field: 'IsHide', title: '是否隐藏', width: 60, formatter: getValue },
                  { field: 'IsArticle', title: '文章类型', width: 60, formatter: getValue }
                    ]
                ],
                detailFormatter: function (rowIndex, rowData) {
                    var html = "活动描述：<br/>" + rowData.description;
                    if (rowData.Content != "")
                        html += "<br/>文章内容：<br/>" + rowData.Content;
                    return html;
                },
                view: detailview
            });
        }

        function getValue(value, row, index) {
            if (value == "1")
                return "<span style='color:red;'>是</span>";
            else
                return "否";
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/ActivitiesHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");

        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Car/ActivitiesAdd.aspx');
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "id", "/Car/ActivitiesEdit.aspx?id=");
        }

        function onDelete() {
            ajaxdelete("activities", "id", "id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            window.location.reload();
        }
    </script>
</asp:Content>
