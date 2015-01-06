<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResendCarRecord.aspx.cs"
    MasterPageFile="~/Admin.Master" Inherits="CarAppAdminWebUI.Car.ResendCarRecord" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                改派查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">开始时间</span> <span class="">
                    <input class="adm_21 Wdate" id="startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                        name="startDate" type="text" style="width: 150px;" />
                </span></span><span class="input_blo"><span class="input_text">结束时间</span> <span
                    class="">
                    <input class="adm_21 Wdate" id="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                        name="endDate" type="text" style="width: 150px;" />
                </span></span><span class="input_blo"><span class="input_text">改派人姓名</span> <span
                    class="">
                    <input class="adm_21" id="username" name="username" width="80" /></span> </span>
                <span class="input_blo"><span class="input_text">车牌号</span> <span class="">
                    <input class="adm_21" id="carNo" name="carNo" width="80" /></span> </span><span class="input_blo">
                        <a href="javascript:onSearch()" class="easyui-linkbutton" icon="icon-search">查询</a></span>
                <span class="input_blo"><a href="javascript:onClear()" class="easyui-linkbutton"
                    icon="icon-cancel">清空</a></span>
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
            var width = $(window).width;
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
                url: "/Car/ResendCarHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                singleSelect: true,
                showFooter: true,
                fitColumns: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "车辆改派记录",
                frozenColumns: [[
                { field: 'ck', checkbox: true, width: 50 },
                { field: 'orderid', title: '订单号', width: 230, formatter: orderlink }
                ]],
                columns: [[
                { field: 'resendTime', title: '改派时间',sortable:true, width: 50  },
                { field: 'username', title: '改派人', width: 40 },
                { field: 'exten', title: '坐席号', width: 40 },
                { field: 'formerCarNo', title: '原车牌号', width: 50 },
                { field: 'nowCarNo', title: '现车牌号', width: 50 }
                ]]
            });
        }

        function orderlink(value, row, index) {

            var html = "<a title='点击查看订单信息' style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.orderid + "\")'>" + value + "</a>";
            return html;
        }
        function onShowOrder(id) {
            top.addTab("订单详细(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }


        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/ResendCarHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        //清空查询条件
        function onClear() {
            $("#username").val("");
            $("#carNo").val("");
            $("#startDate").val("");
            $("#endDate").val("");
        }
    </script>
</asp:Content>
