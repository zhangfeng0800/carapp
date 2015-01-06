<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="Accountstatistics.aspx.cs" Inherits="CarAppAdminWebUI.Member.Accountstatistics" %>

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
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：用户流水统计
            </td>
        </tr>
    </table>
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div style="padding: 5px; height: 55px;">
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
    <div class="container">
		<div class="box" id="totalinout"></div>
        <div class="box" id="monthlymoney"></div>
        
		<div class="box" id="dailycontainer" ></div>
	 
	</div>
    
    <script src="../Static/scripts/echarts-plain.js" type="text/javascript"></script>
    <script src="../Static/scripts/lodash.min.js" type="text/javascript"></script>
    <script>
        function getTotalInOut(startDate, endDate, container) {
            $.ajax({
                url: "/member/DataStatistics.ashx",
                data: { startDate: startDate, endDate: endDate, type: "total" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = [];
                    var ydata = [];
                    $.each(data, function (index, val) {
                        xdata.push(val.type);
                        ydata.push(val.totalmoney);
                    });
                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}：{c}元"
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
                            text: "收入支出统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: [data[0].type, data[1].type]
                        },
                        series: [
                        {

                            "type": "pie",
                            "data": [
                                { value:parseInt(data[0].totalmoney), name: data[0].type },
                                { value: parseInt(data[1].totalmoney), name: data[1].type }
                            ], itemStyle: {
                                normal: {
                                    label: {
                                        position: 'outer',
                                        formatter: function (a, b, c, d) { return b + c + "\n\r(" + (d - 0).toFixed(0) + '%)' }
                                    },
                                    labelLine: {
                                        show: false
                                    }
                                },
                                emphasis: {
                                    label: {
                                        show: true,
                                        formatter: function (a, b, c, d) { return b + c + "\n\r(" + (d - 0).toFixed(0) + '%)'; }
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

        function getMonthTotal(startDate, endDate, container) {
            $.ajax({
                url: "/member/DataStatistics.ashx",
                data: { startDate: startDate, endDate: endDate, type: "month" },
                type: "post",
                success: function (data) {

                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = _.uniq(_.pluck(data, 'date'));
                    var inydata = [];
                    var outydata = [];
                    $.each(xdata, function (index, val) {
                        var temp = _.where(data, { type: "收入", date: val });
                        if (temp.length == 0) {
                            inydata.push(0);
                        } else {
                            inydata.push(parseInt(temp[0].totalmoney));
                        }
                        var temptout = _.where(data, { type: "支出", date: val });
                        if (temptout.length == 0) {
                            outydata.push(0);
                        } else {
                            outydata.push(parseInt(temptout[0].totalmoney));
                        }
                    });

                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}：{c}元"
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
                            text: "月收入支出统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: _.uniq(_.pluck(data, 'type'))
                        },
                        series: [
                        {
                            name: "收入",
                            "type": "bar",
                            "data": inydata,
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
                            name: "支出",
                            type: "bar",
                            'data': outydata,
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
        function getDayTotal(startDate, endDate, container) {
            $.ajax({
                url: "/member/DataStatistics.ashx",
                data: { startDate: startDate, endDate: endDate, type: "day" },
                type: "post",
                success: function (data) {

                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = _.uniq(_.pluck(data, 'date'));
                    var inydata = [];
                    var outydata = [];
                    $.each(xdata, function (index, val) {
                        var temp = _.where(data, { type: "收入", date: val });
                        if (temp.length == 0) {
                            inydata.push(0);
                        } else {
                            inydata.push(temp[0].totalmoney);
                        }
                        var temptout = _.where(data, { type: "支出", date: val });
                        if (temptout.length == 0) {
                            outydata.push(0);
                        } else {
                            outydata.push(temptout[0].totalmoney);
                        }
                    });

                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}：{c}元"
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
                            text: "日收入支出统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: _.uniq(_.pluck(data, 'type'))
                        },
                        series: [
                        {
                            name: "收入",
                            "type": "bar",
                            "data": inydata, itemStyle: {
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
                            name: "支出",
                            type: "bar",
                            'data': outydata,
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

        function getHourTotal(startDate, endDate, container) {
            $.ajax({
                url: "/member/DataStatistics.ashx",
                data: { startDate: startDate, endDate: endDate, type: "hour" },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));
                    var xdata = _.uniq(_.pluck(data, 'date'));
                    var inydata = [];
                    var outydata = [];
                    $.each(xdata, function (index, val) {
                        var temp = _.where(data, { type: "收入", date: val });
                        if (temp.length == 0) {
                            inydata.push(0);
                        } else {
                            inydata.push(temp[0].totalmoney);
                        }
                        var temptout = _.where(data, { type: "支出", date: val });
                        if (temptout.length == 0) {
                            outydata.push(0);
                        } else {
                            outydata.push(temptout[0].totalmoney);
                        }
                    });

                    var option = {
                        tooltip: {
                            show: true,
                            formatter: "{b}时：{c}元"
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
                            text: "小时平均收入支出统计",
                            x: "center"
                        },
                        legend: {
                            orient: 'horizontal',
                            x: 'center',
                            y: "bottom",
                            data: _.uniq(_.pluck(data, 'type'))
                        },
                        series: [
                        {
                            name: "收入",
                            "type": "bar",
                            "data": inydata, itemStyle: {
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
                            name: "支出",
                            type: "bar",
                            'data': outydata,
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

        function showData(startDate, endDate) {
            $.ajax({
                url: "/member/datastatistics.ashx",
                data: { startData: startDate, endDate: endDate, type: "compare" },
                type: "post",
                success: function (data) {
                    if (data == 1) {
                        getTotalInOut(startDate, endDate, "totalinout");
                        getMonthTotal(startDate, endDate, "monthlymoney");
                        getDayTotal(startDate, endDate, "dailycontainer");
                        //                        getHourTotal(startDate, endDate, "hourlycontainer");
                    } else {
                        $.messager.alert("提示信息", "开始时间要小于结束时间");
                    }

                }
            });
        }
        $(function () {
            getTotalInOut("", "", "totalinout");
            getMonthTotal("", "", "monthlymoney");
            getDayTotal("", "", "dailycontainer");
            //            getHourTotal("", "", "hourlycontainer");
            $("#btnquery").click(function () {
                showData($("#startDate").val(), $("#endDate").val());
            });
        });

    </script>
    </form>
</asp:Content>
