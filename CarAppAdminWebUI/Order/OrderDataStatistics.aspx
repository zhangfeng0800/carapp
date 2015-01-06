<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="OrderDataStatistics.aspx.cs" Inherits="CarAppAdminWebUI.Order.OrderDataStatistics" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
      <style>
        #chartsContainer tr td
        {
            width: 50%;
            height: 300px;
            text-align: center;
            padding: 20px;
            margin: 10px;
        }
        
        .container
        {
            width: 100%;
            background: #fff;
            overflow: hidden;
        }
        .box
        {
            display: inline;
            float: left;
            width: 620px;
            height: 400px;
        }
    </style>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：订单信息统计
            </td>
        </tr>
    </table>
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div style="padding: 5px; height: 55px;" id="Div1">
        <table>
            <tr>
                <td>
                    开始时间：
                </td>
                <td>
                    <input class="adm_21 Wdate" id="startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                        name="startDate" type="text" />
                </td>
                <td>
                    结束时间：
                </td>
                <td>
                    <input class="adm_21 Wdate" id="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                        name="endDate" type="text" />
                </td>
                <td>
                    <a href="javascript:;" class="easyui-linkbutton" iconcls="icon-search" id="btnquery">
                        查询</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    <div class="container" id="chartsContainer">
        <div class="box" id="orderstatuscharts">
        </div>
        <div class="box" id="monthlymoney">
        </div>
        <div class="box" id="dailycontainer">
        </div>
        <div class="box" id="hourlycontainer">
        </div>
       <%-- <div class="box" id="userorderContainer">
        </div>--%>
    </div>
    <script src="../Static/scripts/echarts-plain.js" type="text/javascript"></script>
    <script src="../Static/scripts/lodash.min.js" type="text/javascript"></script>
    <script>

        function getOrderStatus(startDate, endDate, container) {
            $.ajax({
                url: "/order/OrderStatisticsHandler.ashx",
                data: { startDate: startDate, endDate: endDate, type: "status" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    var datasource = [];
                    $.each(data, function (index, val) {
                        if (val.orderStatus) {
                            xdata.push(val.orderStatus);
                            ydata.push(val.totalmoney);
                            datasource.push({ value: val.totalnum, name: val.orderStatus });
                        }

                    });
                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}：{c}（{d}%）"
                        },
                        toolbox: {
                            show: true,
                            feature: {
                                dataView: { show: true, readOnly: false, lang: ['数据视图', '关闭', '刷新'] },
                                restore: { show: true, title: "刷新" },
                                saveAsImage: { show: true }
                            }
                        },
                        title: {
                            text: "订单状态统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'left',
                            y: "bottom",
                            data: xdata
                        },
                        series: [
                            {

                                "type": "pie",
                                "data": datasource,
                                radius: '55%',
                                center: ['50%', 200],
                                itemStyle: {
                                    normal: {
                                        label: {
                                            position: 'outer',
                                            formatter: function (a, b, c, d) { return b + c + "：(" + (d - 0).toFixed(2) + '%)'; }
                                        },
                                        labelLine: {
                                            show: false
                                        }
                                    }

                                }
                            }
                        ]
                    };
                    myChart.setOption(option);
                }
            });
        }

        function getMonthOrder(startDate, endDate, container) {
            $.ajax({
                url: "/order/OrderStatisticsHandler.ashx",
                data: { startDate: startDate, endDate: endDate, type: "month" },
                type: "post",
                success: function (data) {

                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.date);
                        ydata.push(val.totalnum);
                    });


                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}<br/>订单数{c}"
                        }, toolbox: {
                            show: true,
                            feature: {
                                dataView: { show: true, readOnly: false, lang: ["数据视图", "关闭", "刷新"] },
                                magicType: { show: true, type: ['line', 'bar'] },
                                restore: { show: true, title: "刷新" },
                                saveAsImage: { show: true }
                            }
                        },
                        xAxis: [
                            {
                                type: 'category',
                                data: xdata
                            }
                        ],
                        yAxis: [
                            {
                                type: 'value',
                                splitArea: { show: true }
                            }
                        ],
                        title: {
                            text: "月订单统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: ["订单总量"]
                        },
                        series: [
                            {

                                name: "订单总量",
                                type: "bar",
                                data: ydata,
                                itemStyle: {
                                    normal: {                   // 系列级个性化，横向渐变填充
                                        borderRadius: 2,
                                        label: {
                                            show: true,
                                            textStyle: {
                                                fontSize: '12',
                                                fontFamily: '微软雅黑',
                                                fontWeight: 'bold'
                                            }
                                        }
                                    }
                                }
                            }
                        ]
                    };
                    myChart.setOption(option);

                }
            });
        }
        function getDayOrder(startDate, endDate, container) {
            $.ajax({
                url: "/order/OrderStatisticsHandler.ashx",
                data: { startDate: startDate, endDate: endDate, type: "day" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    $.each(data, function (index, val) {
                        ydata.push(val.totalorders);
                        xdata.push(val.date);
                    });
                    var option = {
                        tooltip: {
                            show: true
                        },
                        toolbox: {
                            show: true,
                            feature: {
                                dataView: { show: true, readOnly: false, lang: ["数据视图", "关闭", "刷新"] },
                                magicType: { show: true, type: ['line', 'bar'] },
                                restore: { show: true, title: "刷新" },
                                saveAsImage: { show: true }
                            }
                        },
                        xAxis: [
                            {
                                type: 'category',
                                data: xdata
                            }
                        ],
                        yAxis: [
                            {
                                type: 'value',
                                splitArea: { show: true }
                            }
                        ],
                        title: {
                            text: "每日订单统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: ["订单数量"]
                        },
                        series: [
                            {
                                name: "订单数量",
                                "type": "bar",
                                "data": ydata,
                                itemStyle: {
                                    normal: {                   // 系列级个性化，横向渐变填充
                                        borderRadius: 2,
                                        label: {
                                            show: true,
                                            textStyle: {
                                                fontSize: '12',
                                                fontFamily: '微软雅黑',
                                                fontWeight: 'bold'
                                            }
                                        }
                                    }
                                }
                            }
                        ]
                    };
                    myChart.setOption(option);
                }
            });
        }

        function getUsewayTotal(startDate, endDate, container) {
            $.ajax({
                url: "/order/OrderStatisticsHandler.ashx",
                data: { startDate: startDate, endDate: endDate, type: "useway" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    var datasource = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.name);
                        ydata.push(val.totalnum);
                        datasource.push({ value: val.totalnum, name: val.name });
                    });
                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}：{c}（{d}%）"
                        },
                        toolbox: {
                            show: true,
                            feature: {
                                dataView: { show: true, readOnly: false, lang: ['数据视图', '关闭', '刷新'] },
                                restore: { show: true, title: "刷新" },
                                saveAsImage: { show: true }
                            }
                        },
                        title: {
                            text: "用车方式统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: xdata
                        },
                        series: [
                            {

                                "type": "pie",
                                "data": datasource, radius: '55%',
                                center: ['50%', 200],
                                itemStyle: {
                                    normal: {
                                        label: {
                                            position: 'outer',
                                            formatter: function (a, b, c, d) { return b + c + "：(" + (d - 0).toFixed(2) + '%)'; }
                                        },
                                        labelLine: {
                                            show: false
                                        }
                                    }

                                }
                            }
                        ]
                    };
                    myChart.setOption(option);

                }
            });
        }

        function getUserOrderData(startDate, endDate, container) {
            $.ajax({
                url: "/order/OrderStatisticsHandler.ashx",
                data: { startDate: startDate, endDate: endDate, type: "userorders" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    var datasource = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.name);
                        ydata.push(val.totalnum);
                        datasource.push({ value: val.totalnum, name: val.name });
                    });
                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}<br/>{c}（{d}%）"
                        },
                        toolbox: {
                            show: true,
                            feature: {
                                dataView: { show: true, readOnly: false, lang: ['数据视图', '关闭', '刷新'] },
                                restore: { show: true, title: "刷新" },
                                saveAsImage: { show: true }
                            }
                        },
                        title: {
                            text: "用户订单统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: xdata
                        },
                        series: [
                            {

                                "type": "pie",
                                "data": datasource, radius: '55%',
                                center: ['50%', 200],
                                itemStyle: {
                                    normal: {
                                        label: {
                                            position: 'outer',
                                            formatter: function (a, b, c, d) { return b + "\n\r" + c + "(" + (d - 0).toFixed(2) + '%)'; }
                                        },
                                        labelLine: {
                                            show: false
                                        }
                                    }

                                }
                            }
                        ]
                    };
                    myChart.setOption(option);

                }
            });
        }
        function showData(startDate, endDate) {
            $.ajax({
                url: "/member/datastatistics.ashx",
                data: { startData: startDate, endDate: endDate, type: "compare" },
                type: "post",
                success: function (data) {
                    if (data == 1) {
                        getOrderStatus(startDate, endDate, "orderstatuscharts");
                        getMonthOrder(startDate, endDate, "monthlymoney");
                        getDayOrder(startDate, endDate, "dailycontainer");
                        getUsewayTotal(startDate, endDate, "hourlycontainer");
                        getUserOrderData(startDate, endDate, "userorderContainer");
                    } else {
                        $.messager.alert("提示信息", "开始时间要小于结束时间");
                    }

                }
            });
        }
        $(function () {
            getOrderStatus("", "", "orderstatuscharts");
            getMonthOrder("", "", "monthlymoney");
            getDayOrder("", "", "dailycontainer");
            getUsewayTotal("", "", "hourlycontainer");
            getUserOrderData("", "", "userorderContainer");
            $("#btnquery").click(function () {
                showData($("#startDate").val(), $("#endDate").val());
            });
        });

    </script>
    </form>
</asp:Content>
