<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="AirPlane.aspx.cs" Inherits="CarAppAdminWebUI.Air.AirPlane" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：航班信息维护
            </td>
        </tr>
    </table>
    <form id="schForm">
    <div style="padding: 5px; height: 55px;" id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                   出发时间：
                </td>
                <td>
                    <input class="per-info-input" style="width: 80px;" type="text" value="" readonly
                            name="date" onclick="WdatePicker()" id="date"
                            onfocus="WdatePicker({minDate:'%y-%M-{%d}'})" />
                </td>
                <td>
                    航班号：
                </td>
                <td>
                    <input class="adm_21" id="number" name="number" type="text" />
                </td>
                <td>
                    <a href="javascript:onSearch()" class="easyui-linkbutton" iconcls="icon-search">查询</a>
                </td>
                <td style="display: none">
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
                </td>
                <td style="display: none">
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">编辑</a>
                </td>
                <td style="display: none">
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
    <div id="addwindow" title="添加新的航班" style="width: 500px; height: 240px;">
    </div>
    <div id="editwindow" title="编辑航班信息" style="width: 500px; height: 240px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();
            initProvince("provenceID");
        });
        function resizeTable() {
            var height = ($(window).height() - 110);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
        }
        function initProvince(targetSelect) {
            $.get("/Ajax/GetAllProvince.ashx", null, function (data) {
                var pro = "";
                pro += '<option value="">请选择所属省份</option>';
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].provinceID + '>';
                    pro += data[i].provincename;
                    pro += '</option>';
                }
                $("#" + targetSelect).append(pro);
            }, "json");
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
                url: "/ajax/GetAirportInfo.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: false,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [
                    [

                          { field: 'flight_number', title: '航班信息', width: 100, formatter: fflightInfo },
                        { field: 'dep_airport_info', title: '出发机场', width: 100, formatter: fairporInfo },

                        { field: 'dep_time', title: '起飞时间', width: 100, formatter: getLocalTime },
                          { field: 'airport_info', title: '降落机场', width: 100, formatter: fairporInfo },
                        { field: 'arr_time', title: '到达时间', width: 100, formatter: getarrtime }
                    ]
                ]
            });
        }
        function getLocalTime(value) {
            var tt = new Date(parseInt(value) * 1000).toLocaleString();
            return tt;
        }
        function getarrtime(value, rowData, rowIndex) {
            var tt = rowData.arr + "时间" + new Date(parseInt(value) * 1000).toLocaleString();
            return tt;
        }
        function fairporInfo(value) {
            if (value) {
                return value.name;
            } else {
                return "未知机场";
            }

        }

        function fflightInfo(value, rowData, rowIndex) {
            return rowData.company + "  " + value;
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/ajax/GetAirportInfo.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Air/AirPlaneEdit.aspx?id=' + row.Id);
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Air/AirPlaneAdd.aspx');
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onDelete() {
            ajaxdelete("airplane", "id", "Id", "gdgrid", onSearch);
        }
    </script>
</asp:Content>
