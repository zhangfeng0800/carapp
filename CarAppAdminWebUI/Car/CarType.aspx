<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CarType.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarType" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">类型名称</span> <span class="">
                    <input class="adm_21" id="Keyword" name="Keyword" type="text" value="" />
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
    <div id="addwindow" title="添加新的类型">
    </div>
    <div id="editwindow" title="编辑类型信息">
    </div>
    <div id="w" class="easyui-window" title="查看图片" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 350px; height: 350px;">
        <span>
            <img src="" id="imgcontainer" style="margin: 0 auto;" /></span>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeCarWindow("addwindow");
            resizeCarWindow("editwindow");
            resizeTable();
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
                $("#imgcontainer").css("width", 250);
                $("#imgcontainer").css("height", 200);
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
        function resizeCarWindow(name) {
            var height = $(window).height() - 210;

            var width = $(window).width() - 150;
            $("#" + name).css("width", width);
            $("#" + name).css("height", height);
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
            var height = ($(window).height() - $("#querycontainer").height()-10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
        }

        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Car/CarTypeHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "客户舒适度类型管理",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                 { field: 'typeName', title: '类型名称', width: 100 },
                { field: 'passengerNum', title: '乘坐人数', width: 100 },
                { field: 'description', title: '描述', width: 300 },
                  { field: "imgUrl", title: "图片", formatter: showBimg, width: 150 }
                    ]
                ]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/CarTypeHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Car/CarTypeAdd.aspx');
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "id", "/Car/CarTypeEdit.aspx?id=");
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "你确定要执行此操作么？", function (r) {
                if (r) {
                    var d = { "action": "delete", "id": row.id };
                    $.post("/Car/CarTypeHandler.ashx", d, function (data) {
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
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
