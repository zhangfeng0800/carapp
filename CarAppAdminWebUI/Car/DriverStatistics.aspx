<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="DriverStatistics.aspx.cs" Inherits="CarAppAdminWebUI.Car.DriverStatistics" %>

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
        .container{ width: 100%;background: #fff;overflow: hidden;}
		.box{
			 
			display: inline;
			float: left;
			width: 620px;
			height: 400px;
		}
    </style>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style=" display:none;">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：司机统计
            </td>
        </tr>
    </table>
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div style="padding: 5px; height: 55px;" id="Div1">
        <table style=" display:none;">
            <tr>
                <td>
                    开始时间：
                </td>
                <td>
                    <input class="adm_21 Wdate" id="startDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                        name="startDate" type="text" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                </td>
                <td>
                    结束时间：
                </td>
                <td>
                    <input class="adm_21 Wdate" id="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                        name="endDate" type="text" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
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
    <div  class="container">
        <div class="box" id="totalinout"></div>
        <div class="box" id="monthlymoney"></div>
        <div class="box" id="montyKm" style=" display:none;"></div>
        <div class="box" id="dailycontainer" style=" display:none;"></div>
    </>
     
    <script src="../Static/scripts/echarts-plain.js" type="text/javascript"></script>
    <script src="../Static/scripts/lodash.min.js" type="text/javascript"></script>
    <script>
        function getAgeGroupData(container) {
            $.ajax({
                url: "/car/DriverDataStatistics.ashx",
                data: { action: "agegroup" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    var datas = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.agegroup);
                        ydata.push(val.num);
                        datas.push({ value: val.num, name: val.agegroup });
                    });
                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}：{c}人"
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
                            text: "司机年龄统计",
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
                                "data": datas,
                                radius: '55%',
                                center: ['50%', 200],
                                itemStyle: {
                                    normal: {
                                        label: {
                                            position: 'outer',
                                            formatter: function (a, b, c, d) { return b + "：" + c + "人(" + (d - 0).toFixed(2) + '%)'; }
                                        },
                                        labelLine: {
                                            show: false
                                        }
                                    },
                                    emphasis: {
                                        label: {
                                            show: true,
                                            formatter: function (a, b, c, d) { return b + "：" + c + "人(" + (d - 0).toFixed(2) + '%)'; }
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

        function getDriverTime(container) {
            $.ajax({
                url: "/car/DriverDataStatistics.ashx",
                data: { action: "drivertime" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    var datas = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.drivertime);
                        ydata.push(val.num);
                        datas.push({ value: val.num, name: val.drivertime });
                    });
                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}：{c}人"
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
                            text: "司机驾龄统计",
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
                                "data": datas,
                                radius: '55%',
                                center: ['50%', 200],
                                itemStyle: {
                                    normal: {
                                        label: {
                                            position: 'outer',
                                            formatter: function (a, b, c, d) { return b + "：" + c + "人(" + (d - 0).toFixed(2) + '%)'; }
                                        },
                                        labelLine: {
                                            show: false
                                        }
                                    },
                                    emphasis: {
                                        label: {
                                            show: true,
                                            formatter: function (a, b, c, d) { return b + "：" + c + "人(" + (d - 0).toFixed(2) + '%)'; }
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

        function getUserKm(startDate, endDate, container) {
            $.ajax({
                url: "/car/DriverDataStatistics.ashx",

                data: { startDate: startDate, endDate: endDate, action: "driverKm" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydatabar = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.name);
                        ydatabar.push(val.Km);
                    });

                    var option = {
                        tooltip: {
                            show: true,
                            trigger: 'axis'
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
                            axisLabel: {
                                formatter: '{value}公里'
                            },
                            splitArea: { show: true }
                        }
                            ],
                        title: {
                            text: "司机服务公里统计",
                            x: "center"
                            
                        },
//                        legend: {
//                            orient: 'horizontal',
//                            x: 'center',
//                            y:"bottom",
//                            data: ['服务公里']
//                        },
                        series: [
                        {
                            name: "服务公里",
                            "type": "bar",
                            "data": ydatabar,
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
                        }]
                    };
                    myChart.setOption(option);

                }
            });
        }

        function getUserOrders(startDate, endDate, container) {
            $.ajax({
                url: "/car/DriverDataStatistics.ashx",

                data: { startDate: startDate, endDate: endDate, action: "driverorder" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydatabar = [];
                    var ydataline = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.name);
                        ydatabar.push(val.totalmoney);
                        ydataline.push(val.ordernum);
                    });

                    var option = {
                        tooltip: {
                            show: true,
                            trigger: 'axis'
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
                            name: '订单金额',
                            axisLabel: {
                                formatter: '{value}元'
                            },
                            splitArea: { show: true }
                        }, {
                            type: 'value',
                            name: '订单数量',
                            axisLabel: {
                                formatter: '{value}'
                            },
                            splitLine: { show: false }
                        }
                            ],
                        title: {
                            text: "司机接单情况统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: ['订单金额', '订单数量']
                        },
                        series: [
                        {
                            name: "订单金额",
                            "type": "bar",
                            "data": ydatabar,
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
                        }, {
                            name: "订单数量",
                            type: "line",
                            data: ydataline,
                            yAxisIndex: 1,
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
                        }]
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
                        getUserOrders(startDate, endDate, "dailycontainer");
                        getUserKm(startDate, endDate, "montyKm");
                    } else {
                        $.messager.alert("提示信息", "开始时间要小于结束时间");
                    }

                }
            });
        }
        $(function () {
            getAgeGroupData("totalinout");
            getDriverTime("monthlymoney");
            getUserKm("", "", "montyKm");
            getUserOrders("", "", "dailycontainer");
            $("#btnquery").click(function () {
                showData($("#startDate").val(), $("#endDate").val());
            });
        });

    </script>
    </form>
</asp:Content>
