<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CarInfoDetail.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarInfoDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：车辆详细信息
            </td>
        </tr>
    </table>
    <div class="adm_20">
        <table border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td style="width: 65%;" valign="top">
                    <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td class="mytitle" colspan="4">
                                基本信息
                            </td>
                        </tr>
                        <tr>
                            <td class="adm_45" align="right" height="30" width="15%">
                                编号：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.Id %>
                            </td>
                            <td class="adm_45" align="right" height="30" width="15%">
                                车辆类型编号：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.CarTypeId %>
                            </td>
                        </tr>
                        <tr>
                            <td class="adm_45" align="right" height="30" width="15%">
                                车辆工作状态：
                            </td>
                            <td class="adm_42" width="40%">
                                <%=GetWorkStatus(CarInfoModel.carWorkStatus) %>
                            </td>
                            <td class="adm_45" align="right" height="30" width="15%">
                                车牌号：
                            </td>
                            <td class="adm_42" width="40%">
                                <%=CarInfoModel.CarNo %>
                            </td>
                        </tr>
                        <tr>
                            <td class="adm_45" align="right" height="30" width="15%">
                                名称：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.Name %>
                            </td>
                            <td class="adm_45" align="right" height="30" width="15%">
                                电话：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.telPhone %>
                            </td>
                        </tr>
                        <tr>
                            <td class="adm_45" align="right" height="30" width="15%">
                                用车方式：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.CarUseWay %>
                            </td>
                            <td class="adm_45" align="right" height="30" width="15%">
                                热门线路：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.HotLine %>
                            </td>
                        </tr>
                        <tr>
                            <td class="adm_45" align="right" height="30" width="15%">
                                经度：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.longitude %>
                            </td>
                            <td class="adm_45" align="right" height="30" width="15%">
                                纬度：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.latitude %>
                            </td>
                        </tr>
                        <tr>
                            <td class="adm_45" align="right" height="30" width="15%">
                                最后数据时间：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.updateTime %>
                            </td>
                            <td class="adm_45" align="right" height="30" width="15%">
                                车辆当前位置：
                            </td>
                            <td class="adm_42" width="25%">
                                <%=CarInfoModel.currentPosition %>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table border="0" width="100%">
                        <tr>
                            <td>
                                <table id="gd1">
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
      <%--  <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onCancel()">返回</a>
        </p>--%>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
        });
        function resizeTable() {
            var height = ($(window).height())-290;
            var width = $(window).width();
            $("#gd1").css("height",height);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gd1').datagrid({
                url: "/Car/CarInfoHandler.ashx?action=carorderlist&id=<%=CarInfoModel.Id %>",
                method: 'post',
                title: "相关订单记录",
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                frozenColumns: [[
                   { field: 'orderId', title: '订单编号',formatter:forderid }
                ]],
                columns: [[
                { field: 'orderDate', title: '下单时间', formatter: easyui_formatterdate },
                { field: 'departureCity', title: '出发城市'},
                { field: 'targetCity', title: '目的城市' },
                { field: 'CarType', title: '租车类型'},
                { field: 'orderMoney', title: '订单额（元）' },
                { field: "unpaidMoney", title: "二次付款金额（元）" },
                   { field: "totalMoney", title: "订单总额（元）" },
                { field: 'passengerName', title: '乘车人'}
            ]]
            });
        }
        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }
        function forderid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a style=\"text-decoration:underline\" href='javascript:onShowOrder(\"" + row.orderId + "\")'>" + value + "</a>";
            return html;
        }
        function onCancel() {
            top.closeTab('close');
        }
    </script>
</asp:Content>
