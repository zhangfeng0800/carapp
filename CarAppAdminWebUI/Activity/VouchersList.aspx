<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="VouchersList.aspx.cs" Inherits="CarAppAdminWebUI.Activity.VouchersList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">

<form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">用户姓名</span> <span class="">
                    <input class="adm_21" id="compname" name="compname" type="text" value="" style="width:80px;" />
                </span></span>
                <span class="input_blo"><span class="input_text">状态</span> <span class="">
                    <select name="status">
                    <option value="">不限</option>
                    <option value="未使用">未使用</option>
                    <option value="已使用">已使用</option>
                    </select>
                </span></span>
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
                    
            </div>
        </div>
    </div>

    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="代金券" style="width: 1200px; height: 400px;">
    </div>
    <div id="editwindow" title="代金券" style="width: 500px; height: 280px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();
        });
        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
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
                url: "/Activity/VouchersHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "用户代金券",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },

                { field: 'Cost', title: '代金券面值', width: 100 },
                { field: 'StartTime', title: '生效日期', width: 100, formatter: easyui_formatterdate,sortable:true },
                { field: 'EndTime', title: '失效日期', width: 100, formatter: easyui_formatterdate ,sortable:true},
                { field: 'compname', title: '所属用户', width: 100, formatter: fusername },
                { field: 'Status', title: '状态', width: 100 },
                { field: 'OrderId', title: '对应订单', width: 100,formatter:fOrder },
                { field: 'UseTime', title: '使用时间', width: 100,formatter:formattime,sortable:true}
                    ]
                ]
            });
        }
        function fOrder(value, row, index) {
            if (value != "") {
                var html = "<a style='text-decoration:underline;' href='javascript:onShowOrder(\"" + value + "\")'>" + value + "</a> ";
                return html;
            }
            else
                return "";
        }
        function fusername(value, row, index) {
            var html = "<a style='text-decoration:underline;' href='javascript:onShow(" + row.UserId + ")'>" + value + "</a> ";
            return html;
        }

        function formattime(value, row, index) {
            if (value != null) {
                return value.split("T")[0] + " " + value.split("T")[1].substr(0, 8);
            }
            else
                return "";
        }
        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }

        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Activity/VouchersHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Activity/FundingAdd.aspx');
        }
      
        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            } else if (row["Status"] == '已使用') {
                $.messager.alert('消息', '使用中的规则无法删除', 'error');
                return;
            }
            var id = row["Id"];
            if (confirm("确认要删除吗?")) {
                $.post("/Activity/FundingHandler.ashx", { 'action': 'deleteRules', 'id': id }, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', "删除成功");
                        onSearch();
                    } else {
                        $.messager.alert('消息', data.Message);
                    }
                }, "json");
            }
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>

</asp:Content>
