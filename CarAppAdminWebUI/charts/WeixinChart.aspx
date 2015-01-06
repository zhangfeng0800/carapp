<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="WeixinChart.aspx.cs" Inherits="CarAppAdminWebUI.charts.WeixinChart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <style type="text/css">
        td input
        {
            margin-left: 0 !important;
        }
        /* 因为admin.css 里的 td input 样式会使 combogrid 下拉框错位 所以加下面的样式 */
        .combobox-item
        {
            height: 20px;
        }
        /*EassyUI 下拉框第一项为空时,撑开第一项 */
        .ke-dialog-body .tabs
        {
            height: 0px;
            border: 0px;
        }
        /*KindEdit 的图片上传选择框和EasyUI样式冲突 */
        .datagrid-cell
        {
            white-space: normal !important;
        }
        /*easyui列自动换行*/
        .datagrid-row-selected
        {
            background: #E9F9F9 !important;
        }
        
        .field-validation-valid
        {
            color: Red;
        }
        
        .clearfix:before, .clearfix:after
        {
            content: "";
            display: table;
        }
        
        .clearfix:after
        {
            clear: both;
        }
        
        /* For IE 6/7 (trigger hasLayout) */
        .clearfix
        {
            zoom: 1;
        }
        
        .container
        {
            background: #E0EDFE;
            margin-top: 0px;
            padding: 0;
            padding-top: 10px;
            width: 100%;
            min-width: 500px;
        }
        
        .con_border
        {
            border: 1px solid #9c9c9c;
            padding: 10px;
            position: relative;
        }
        
        .con_til
        {
            background: #E0EDFE;
            font: 12px Tahoma,SimSun;
            position: absolute;
            top: -20px;
            padding: 0 5px;
        }
        
        .con_bg
        {
            overflow: hidden;
            padding-top: 10px;
        }
        
        .input_text
        {
            margin-right: 3px;
        }
        
        .input_style
        {
            background: #fff;
            border: 1px solid #ddd;
            height: 20px;
            line-height: 20px;
        }
        
        .input_blo
        {
            display: inline;
            float: left;
            height: 25px;
            margin: 2px 3px;
        }
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
            width: 92%;
            height: 350px;
        }
    </style>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：用户订单统计
            </td>
        </tr>
    </table>
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div style="padding: 5px; height: 30px;" id="Div1">
        <table>
            <tr>
                <td>
                    时间<input type="text" id="txtstarttime" onfocus="WdatePicker()" onclick='WdatePicker()'
                        readonly="readonly" value="<%=DateTime.Now.AddDays(-60).ToString("yyyy-MM-dd") %>" />至<input
                            type="text" id="txtendtime" onfocus="WdatePicker()" onclick='WdatePicker()' readonly="readonly"
                            value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                </td>
                <td>
                    <a id="btnsubmit" value="" class="easyui-linkbutton" href="javascript:query();">统计</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    <div class="container" id="chartsContainer">
        <div class="box" id="dailydata">
        </div>
        <div class="box" id="weeklydata">
        </div>
        <div class="box" id="monthlydata" style="width: 45%">
        </div>
        <div class="box" id="yearlydata" style="width: 45%">
        </div>
    </div>
    <script src="/Static/scripts/echarts-plain.js" type="text/javascript"></script>
    <script src="/Static/scripts/lodash.min.js" type="text/javascript"></script>
    <script src="../Static/scripts/js/highcharts.js" type="text/javascript"></script>
    <script>
        function getWeixinData(startDate, endDate, container, type, title) {
            $.ajax({
                url: "/charts/UserRegistChartsHandler.ashx",
                data: { starttime: startDate, endtime: endDate, type: type },
                type: "post",
                success: function (data) {
                    var myChart = echarts.init(document.getElementById(container));

                    var option = {
                        tooltip: {
                            trigger: 'axis',
                            axisPointer: {
                                type: 'shadow'
                            }
                        },
                        legend: {
                            data: ['10元', '5元', '2元', '1.5元', '1元', '0.5元','抽奖金额（元）'],
                            x: "center",
                            y: "bottom"
                        }, title: {
                            text: title,
                            x: "center",
                            y: "top"
                        },
                        calculable: true,
                        xAxis: [
                            {
                                type: 'category',
                                data: data.monthname
                            }
                        ],
                        yAxis: [{
                            type: 'value',
                            name: '抽奖次数',
                            axisLabel: {
                                formatter: '{value} '
                            },
                        },
                                {
                                    type: 'value',
                                    name: '抽奖金额（元）'
                                   
                                }

                            ],
                        series: [
                            {
                                name: '10元',
                                type: 'bar',
                                stack: '抽奖数量',
                                data: data.tenyuan
                            },
                            {
                                name: '5元',
                                type: 'bar',
                                stack: '抽奖数量',
                                data: data.fiveyuan
                            }, {
                                name: '2元',
                                type: 'bar',
                                stack: '抽奖数量',
                                data: data.twoyuan
                            }, {
                                name: '1.5元',
                                type: 'bar',
                                stack: '抽奖数量',
                                data: data.fifthyuan
                            }, {
                                name: '1元',
                                type: 'bar',
                                stack: '抽奖数量',
                                data: data.oneyuan
                            }, {
                                name: '0.5元',
                                type: 'bar',
                                stack: '抽奖数量',
                                data: data.zerofiveyuan
                            } ,
                            {
                                name: '抽奖金额（元）',
                                type: 'line', 
                                data: data.totalmoney,
                                  yAxisIndex: 1
                            } 
                        ]
                    };


                    myChart.setOption(option); 
                }
            });
        }
        function query() {
                          getWeixinData($("#txtstarttime").val(), $("#txtendtime").val(), "weeklydata","weixinweekly","周微信抽奖统计");
                         getWeixinData($("#txtstarttime").val(), $("#txtendtime").val(), "monthlydata","weixinmonthly","月微信抽奖统计");
          getWeixinData($("#txtstarttime").val(), $("#txtendtime").val(), "dailydata", "weixindaily", "日微信抽奖统计");
                               getWeixinData($("#txtstarttime").val(), $("#txtendtime").val(), "yearlydata","weixinyearly","年微信抽奖统计");
        }
        $(function () {
                           getWeixinData($("#txtstarttime").val(), $("#txtendtime").val(), "weeklydata","weixinweekly","周微信抽奖统计");
          getWeixinData($("#txtstarttime").val(), $("#txtendtime").val(), "monthlydata","weixinmonthly","月微信抽奖统计");
            getWeixinData($("#txtstarttime").val(), $("#txtendtime").val(), "dailydata", "weixindaily", "日微信抽奖统计");
               getWeixinData($("#txtstarttime").val(), $("#txtendtime").val(), "yearlydata","weixinyearly","年微信抽奖统计");

        });

    </script>
    </form>
</asp:Content>
