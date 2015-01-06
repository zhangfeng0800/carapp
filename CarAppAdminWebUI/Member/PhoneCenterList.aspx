<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="PhoneCenterList.aspx.cs" Inherits="CarAppAdminWebUI.Member.PhoneCenterList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">座席号</span> <span class="">
                    <input class="adm_21" id="jobnumber" name="jobnumber" type="text" />
                </span></span><span class="input_blo"><span class="input_text">状态</span> <span class="">
                    <select id="status" name="status">
                        <option value="">全部</option>
                        <option value="0">签出</option>
                        <option value="1">签入</option>
                    </select>
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span> <span style="display: none;" class="input_blo"><a
                        href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">添加</a>
                </span><span class="input_blo" style="display: none;"><a href="javascript:onEdit()"
                    class="easyui-linkbutton" iconcls="icon-remove">编辑</a> </span>
            </div>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的管理员" style="width: 500px; height: 300px;">
    </div>
    <div id="editwindow" title="编辑管理员信息" style="width: 500px; height: 300px;">
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
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Member/PhoneCenterHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                title: "呼叫中心客服管理",
                pageSize: 15,
                columns: [
                    [
                        { field: 'ck', checkbox: true },

                        { field: "Exten", title: "坐席号", width: 100 },

                        { field: 'Status', title: '当前状态', width: 100, formatter: fStatus }

                    ]
                ]
            });
        }

        function fStatus(value, data, index) {

            if (data.Status == 1) {
                return "<a href=\"javascript:;\" onclick=\"checkInOut('" + data.Exten + "')\" style=\"color:red;text-decoration:underline\">签入</a>";
            } else {
                return "<a href=\"javascript:;\" onclick=\"checkInOut('" + data.Exten + "')\" style=\"text-decoration:underline\">签出</a>";
            }
        }

        function checkInOut(exten) {
            $.ajax({
                url: "/member/phonecenterhandler.ashx",
                type: "post",
                data: { groupid: "0", exten: exten, action: "checkinout" },
                success: function (data) {
                    if (data.resultcode == 1) {
                        $("#textContainer").text(data.text);
                        alert("操作成功");
                    } else {
                        alert("操作失败");
                    }
                    bindGrid();
                }
            });
        }

        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/PhoneCenterHandler.ashx?" + $("#schForm").serialize(),
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Member/PhoneCenterAdd.aspx');
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Manager/ManagerEdit.aspx?id=' + row.AdminId);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "此项操作会删除该城市开通的所有用车服务,并且此操作不可恢复，你确定要执行此操作么？", function (r) {
                if (r) {
                    $.post("/ProvinceCity/SaveServiceCity.ashx", { "action": "delete", "cityId": row.CityId }, function (data) {
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
    </script>
</asp:Content>
