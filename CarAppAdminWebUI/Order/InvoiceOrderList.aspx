<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="InvoiceOrderList.aspx.cs" Inherits="CarAppAdminWebUI.Order.InvoiceOrderList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script src="../Static/easyui/datagrid-detailview.js" type="text/javascript"></script>
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">订单编号</span> <span class="">
                    <input class="adm_21" id="orderid" name="orderid" type="text" value="" />
                </span></span>
                 <span class="input_blo"><span class="input_text">邮寄状态</span> <span class="">
                    <select id="invoiceStatus" name="invoiceStatus">
                    <option value="0">未邮寄</option>
                       <option value="1">已邮寄</option>
                          <option value="2">已取消</option>
                    </select>
                </span></span>
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span><span class="input_blo"><a href="javascript:onMail()"
                        class="easyui-linkbutton" iconcls="icon-remove">设为已邮寄发票</a> </span>
                        <span class="input_blo">  <a href="javascript:onExport()" class="easyui-linkbutton" iconcls="icon-remove">根据条件导出</a> </span>
                      
            </div>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="carwindow" title="派车(车辆信息仅供参考,请以实际情况为准)" style="width: 1000px; height: 500px;">
    </div>
    <div id="editwindow" title="编辑订单信息" style="width: 600px; height: 500px;">
    </div>
    <div id="recarwindow" title="更改派遣车辆" style="width: 600px; height: 500px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            initProvinceSelect("provenceID", "不限");
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
            var width = $(window).width();
            var hight = $(window).height() - $("#querycontainer").height() - 10;
            $("#gdgrid").css("height", hight);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Order/InvoiceOrderHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                frozenColumns: [[
                  { field: 'ck', checkbox: true },
                { field: 'orderId', title: '订单编号', width: 150, formatter: forderid }
                ]],
                columns: [
                [
                { field: 'passengerName', title: '用户名', width: 100 },
                { field: 'passengerPhone', title: '电话', width: 140 },
                  { field: 'totalMoney', title: '总额（元）', width: 100 },
                { field: 'invoiceClass', title: '发票类型', width: 100, formatter: getclass },
                { field: 'invoiceHead', title: '发票抬头', width: 100 },
                { field: 'invoiceType', title: '发票内容', width: 100, formatter: gettype },
                { field: 'invoiceAdress', title: '邮寄地址', width: 100 },
                { field: 'invoiceZipCode', title: '邮政编码', width: 100 },
                { field: 'CompAccount', title: '公司账号', width: 100 },
                { field: 'CompAdd', title: '公司地址', width: 200 },
                { field: 'CompBank', title: '开户银行', width: 100 },
                { field: 'CompTel', title: '联系电话', width: 100 },
                { field: 'TaxpayerID', title: '纳税标识', width: 100 },
                { field: 'status', title: '邮寄状态', width: 100, formatter: getstatus }
                   ]
                ]
            });
        }

        function onExport() {
            window.open("/Order/InvoiceExport.aspx?" + $("#schForm").serialize());
        }

        /*formatter*/
        function getclass(value, row, index) {
               var status = new Array("增值税专用发票", "普通发票");
               return status[value - 1];

        }
        function gettype(value, row, index) {
            var status = new Array("租赁费", "租赁服务费", "汽车租赁费", "代驾服务费");
            return status[value - 1];
        }
        function getstatus(value, row, index) {
            var status = new Array("未邮寄", "已邮寄", "已取消");
            return status[value];
        }
        function fuserID(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a href='javascript:onShowUser(" + value + ")'>查看</a>";
            return html;
        }

        function forderid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.orderId + "\")'>" + value + "</a>";
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
            $("#gdgrid").datagrid("options").url = "/Order/InvoiceOrderHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }

        /* 设置邮寄 */
        function onMail() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "你确定要设置为邮寄么？", function (r) {
                if (r) {
                    $.post("/Order/InvoiceOrderHandler.ashx", { "action": "setMail", "id": row.orderId }, function (data) {
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
