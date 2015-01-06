<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="OrderTimespan.aspx.cs" Inherits="CarAppAdminWebUI.Order.OrderTimespan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script src="/Static/easyui/datagrid-groupview.js" type="text/javascript"></script>
    <form id="schForm">
    <input id="action" name="action" value="timespancount" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">日期</span> <span class="">
                    <input class="adm_21 Wdate" style="width: 80px;" id="starttime" name="starttime"
                        onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" value="<%=DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd") %>" />-
                    <input class="adm_21 Wdate" style="width: 80px;" id="endtime" name="endtime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                        type="text" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                </span></span><span class="input_blo"><span class="input_text"></span><span class="">
                    <select id="type" name="type">
                           <option value="">不限</option>
                        <option value="province">省</option>
                        <option value="city">市</option>
                        <option value="town">县</option>
                    </select>
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
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
                url: "/order/orderhandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                showFooter: true,
                pageSize: 15,
                title: "订单时间段统计信息(按预约时间统计)",
                groupField: 'cityname',
                view: groupview,
                groupFormatter: function (value, rows) {
                    var ordercount = 0;
                    var ordermoney = 0;
                    for (var num = 0; num < rows.length; num++) {
                        ordercount += rows[num].totalorder;
                        ordermoney += rows[num].totalmoney;
                    }
                    num = 0;
                    return value + ' - ' + ordercount + ' 个订单，总金额：' + parseFloat(ordermoney).toFixed(2) + "元";
                },
                columns: [
                [
                
                { field: 'timespan', title: '时间段', width: 100 },
                { field: 'totalorder', title: '订单数量', width: 150 },
                    { field: 'totalmoney', title: '订单金额（元）', width: 150 }
                ]
                ]
            });
        }



        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/order/orderhandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }




        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
