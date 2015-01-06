<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="AccountList.aspx.cs" Inherits="CarAppAdminWebUI.Member.AccountList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">开始时间</span> <span class="">
                    <input class="adm_21 Wdate" id="startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                        name="startDate" type="text" style="width: 130px;" /></span></span>
                <span class="input_blo"><span class="input_text">结束时间</span><span class="">
                    <input class="adm_21 Wdate" id="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                        name="endDate" type="text" style="width: 130px;" /></span></span>
                <span class="input_blo"><span class="input_text">用户名</span> <span class="">
                    <input name="username" id="username" style="width:100px;" />
                </span></span><span class="input_blo"><span class="input_text">操作类型</span> <span
                    class="">
                    <select id="operationtype" name="operationtype">
                        <option value="">请选择</option>
                        <option>支付宝充值</option>
                        <option>网银充值</option>
                        <option>银联手机支付</option>
                        <option>支付订单</option>
                        <option>订单退款 </option>
                        <option>使用充值卡</option>
                        <option>充值送车费</option>
                    </select>
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
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
                url: "/Member/AccountHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,

                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "流水信息管理",
                frozenColumns: [[
                { field: 'ck', checkbox: true },
                { field: 'accountnumber', title: '流水号', align: "center" }
                ]]
                ,
                columns: [
                [
                 { field: 'orderid', title: '订单号', formatter: forderid1, align: "center" },
                { field: "username", title: "用户名", align: "center", formatter: fusername },
                { field: 'type', title: '存入/支出', formatter: ftype },
                { field: 'datetime', title: '时间', formatter: easyui_formatterdate, align: "center" },
                { field: 'money', title: '存入金额（元）', formatter: showmoneys },
                { field: ' ', title: '支出金额（元）', formatter: showmoneyp },
                { field: 'balance', title: '账户余额（元）', sortable: true },
                { field: 'action', title: '详细操作' }
                ]
                ]
            });
        }

        function showmoneys(value, row, index) {
            if (row.type == "1") {
                return "<span style='color:blue;'>+" + value + "</span>";
            }
            else
                return 0;
        }
        function showmoneyp(value, row, index) {
            if (row.type == "1") {
                return 0;
            }
            else
                return "<span style='color:red;'>-" + row.money + "</span>";
        }

        function fusername(value, row, index) {
            var html = "<a style='text-decoration:underline;' href='javascript:onShow(" + row.userid + ")'>" + value + "</a> ";
            return html;
        }
        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }
      
        /* formatter */
        function forderid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a href='javascript:onShowOrder(\"" + value + "\")'>查看相关订单</a>";
            return html;
        }
        function forderid1(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + value + "\")'>" + value + "</a>";
            return html;
        }
        function ftype(value, row, index) {
            if (value == "0") {
                return '<span style="color:red;">支出</span>';
            } else {
                return '<span style="color:blue;">存入</span>';
            }
        }

        function fuid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a href='javascript:onShowUser(\"" + value + "\")'>查看相关用户</a>";
            return html;
        }

        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }

        function onShowUser(id) {
            top.addTab("会员详细(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/AccountHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
