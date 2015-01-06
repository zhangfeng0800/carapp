<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="LotteryList.aspx.cs" Inherits="CarAppAdminWebUI.Activity.LotteryList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
 <script src="../Static/My97DatePicker/moment.min.js" type="text/javascript"></script>
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
                <span class="input_blo"><span class="input_text">手机号码</span> <span class="">
                    <input class="adm_21" id="telphone" name="telphone" type="text" value="" style="width:80px;" />
                </span></span>
                
                 <span class="input_blo"><span class="input_text">日期</span> <span class="">
                    <input class="adm_21 Wdate" style=" width:80px;" id="dates" name="dates"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" value="<%=DateTime.Now.ToString("yyyy-MM-01") %>"  />-
                    <input class="adm_21 Wdate" style=" width:80px;" id="datee" name="datee"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                </span></span>
                  <span class="input_blo"><span class="input_text">
                 <select id="timesel" onchange="search()">
                <option value="">不限</option>
                 <option value="day">本日</option>
                 <option value="month">本月</option>
                 <option value="year">本年</option>
                </select>
                 </span></span>
                 <span class="input_blo"><span class="input_text">
                 <select id="tableName" name="tableName" onchange="javascript:onSearch()">
                 <option value="wxNewsChildren">分享抽奖</option>
                 <option value="orders">分享订单</option>
                 </select>
                 </span></span>

                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>

                 <span class="input_blo"><a href="javascript:showData()" class="easyui-linkbutton"
                    iconcls="icon-search">中奖次数金额统计</a></span>
            </div>

        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>

     <div id="num" class="easyui-window" title="各金额中奖次数" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 350px; height: 350px;">
      <div style=" width:350px; height:40px; margin-top:5px;">
        <span class="input_blo">日期<span class="">
                    <input class="adm_21 Wdate" style=" width:80px;" id="datestart" name="datestart"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" value="<%=DateTime.Now.ToString("yyyy-MM-01") %>"  />-
                    <input class="adm_21 Wdate" style=" width:80px;" id="dateend" name="dateend"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                </span></span>
                   <span class="input_blo"><a href="javascript:onSearchStatis()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a>   <span class="input_blo">
       </div>
        <table id="mydata">
            
        </table>
    </div>

    <div id="collect" class="easyui-window" title="详细信息" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 550px; height: 430px;">
        <input type="hidden" id="teldetail" />
        <table id="mycollect" style=" height:400px;">
            
        </table>
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
                url: "/Activity/LotteryHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                showFooter: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "用户分享抽奖信息",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'compname', title: '用户姓名', width: 100, formatter: fusername },
                { field: 'telphone', title: '手机号码', width: 100 },
                { field: 'Money', title: '中奖总金额', width: 100 ,sortable:true},
                { field: 'num', title: '分享次数', width: 100, sortable: true },
                { field: 'id', title: '查看明细', width: 100 ,formatter:fCollect}
//                { field: 'CreateTime', title: '分享时间', width: 100, formatter: easyui_formatterdate },
                ]
                ]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Activity/LotteryHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }

        function showData() {
            onSearchStatis();
            $("#num").window("open");
        }
        function fCollect(value, row, index) {
            return "<a href='#' onclick='showCollect(" + row.telphone + ")'>查看明细</a>";
        }

        function showCollect(telphone) {
            $("#teldetail").val(telphone);
            onSearchCollect();
            $("#collect").window("open");
        }
        function onSearchCollect() {
            if ($("#tableName").val() == "wxNewsChildren") {
                $('#mycollect').datagrid({
                    url: "/Activity/LotteryHandler.ashx?action=LotteryCollect&telphone=" + $("#teldetail").val() + "&dates=" + $("#dates").val() + "&datee=" + $("#datee").val(),
                    method: 'post',
                    pagination: true,
                    fitColumns: true,
                    singleSelect: true,
                    title: "",
                    columns: [
                    [
                        { field: 'compname', title: '用户姓名', width: 100, formatter: fusername },
                    { field: 'Money', title: '对应金额', width: 150 },
                    { field: 'CreateTime', title: '抽奖时间', width: 150, formatter: easyui_formatterdate }
                    ]
                ]
                });
            }
            else {
                $('#mycollect').datagrid({
                    url: "/Activity/LotteryHandler.ashx?action=LotteryOrders&telphone=" + $("#teldetail").val() + "&dates=" + $("#dates").val() + "&datee=" + $("#datee").val(),
                    method: 'post',
                    pagination: true,
                    fitColumns: true,
                    singleSelect: true,
                    title: "",
                    columns: [
                    [
                        { field: 'compname', title: '用户姓名', width: 100, formatter: fusername },
                    { field: 'orderId', title: '对应订单', width: 150, formatter: forderid },
                    { field: 'CreateTime', title: '分享时间', width: 150, formatter: easyui_formatterdate }
                    ]
                ]
                });
            }
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

        function onSearchStatis() {
            $('#mydata').datagrid({
                url: "/Activity/LotteryHandler.ashx?action=LotteryStatistics&datestart=" + $("#datestart").val() + "&dateend=" + $("#dateend").val(),
                method: 'post',
                pagination: false,
                fitColumns: true,
                singleSelect: true,
                title: "",
                columns: [
                    [
                
                    { field: 'Money', title: '对应金额', width: 150 },
                    { field: 'num', title: '次数', width: 150 }
                    ]
                ]
            });
        }


        function search() {
            var day = moment().format("YYYY-MM-DD");
            if ($("#timesel").val() == "day") {
                $("#dates").val(day);
                $("#datee").val(day);
                onSearch();
            } else if ($("#timesel").val() == "month") {
                $("#dates").val(moment().format("YYYY-MM-01"));
                $("#datee").val(day);
                onSearch();
            }
            else if ($("#timesel").val() == "year") {

                $("#dates").val(moment().format("YYYY-01-01"));
                $("#datee").val(day);
                onSearch();
            }

        }


        function fusername(value, row, index) {
            var html = "<a style='text-decoration:underline;' href='javascript:onShow(" + row.UserId + ")'>" + value + "</a> ";
            return html;
        }
        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Activity/LotteryHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
 


       
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
