<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="OrderMultiCharts.aspx.cs" Inherits="CarAppAdminWebUI.charts.OrderMultiCharts" %>

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
            width: 100%;
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
                    时间<input type="text" id="txtstarttime"  onclick='WdatePicker()' onfocus="WdatePicker()" value="<%=DateTime.Now.AddDays(-60).ToString("yyyy-MM-dd") %>" />至<input
                        type="text" id="txtendtime" onfocus="WdatePicker()"  onclick='WdatePicker()' value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                    <select id="province" onchange="loadPlace('city',$(this).val(),'city')">
                        <option value="">不限</option>
                    </select>
                    <select id="city" onchange="loadPlace('town',$(this).val(),'town')">
                        <option value="">不限</option>
                    </select>
                    <select id="town">
                        <option value="">不限</option>
                    </select>
                </td>
                <td>
                    <a id="btnsubmit" value="" class="easyui-linkbutton" href="javascript:query();">查询</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    <div class="container" id="chartsContainer">
        <div class="box" id="timespan" style="width: 50%">
        </div>
        <div class="box" id="origin" style="width: 50%">
        </div>
        <div class="box" id="useway" style="width: 50%">
        </div>
        <div class="box" id="orderweeklychart" style="width: 50%">
        </div>
        <div class="box" id="cartype" style="width: 75%">
        </div>
        <div class="box" id="genderdata" style="width: 25%">
        </div>
    </div>
    <script src="/Static/scripts/echarts-plain.js" type="text/javascript"></script>
    <script src="/Static/scripts/lodash.min.js" type="text/javascript"></script>
    <script src="../Static/scripts/js/highcharts.js" type="text/javascript"></script>
    <script>

             function getOrderWeeklyData(startDate, endDate, container,type,title) {
                $.ajax({
                    url: "/charts/orderchartshandler.ashx",
                    data: { starttime: startDate, endtime: endDate,type:type,province:$("#province").val() ,city:$("#city").val(),town:$("#town").val()},
                    type: "post",
                    success: function (data) {
                        var myChart = echarts.init(document.getElementById(container));
                       var option = {
                            tooltip: {
                                trigger: 'axis'
                            },
                            toolbox: {
                                show: true,
                                feature: {
                                 
                                    saveAsImage: { show: true }
                                }
                            },
                           
                            calculable: true,
                            legend: {
                                data: [ '订单总额','订单数量', '平均单价'],
                                x:"center",
                                y:"bottom"
                            },
                               title : {
                                   text:title,
                                  x :"center",
                                  y:"top"
                               },
                            xAxis: [
                                {
                                    type: 'category',
                                    data: data.monthname
                                }
                            ],
                            yAxis: [ {
                                    type: 'value',
                                    name: '订单数量',
                                    axisLabel: {
                                        formatter: '{value} '
                                    }
                                } ,
                                {
                                    type: 'value',
                                    name: '总金额/平均单价',
                                    axisLabel: {
                                        formatter: '{value}元'
                                    }
                                }
                                
                            ],
                            series: [ 
                                {
                                    name: '订单总额',
                                    type: 'bar',
                                      yAxisIndex:1,
                                    data: data.totalmoney, 
                                },{
                                    name: '订单数量',
                                    type: 'bar',     
                                    yAxisIndex:0,
                                    data: data.ordernum
                                },
                                {
                                    name: '平均单价',
                                    type: 'line',
                                      yAxisIndex:1,
                                    data: data.avgnum
                                }
                            ]
                        };

                        myChart.setOption(option);
                    }
                });
            }
 
           function query() {
                   getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "timespan","timespan","订单预约时间段统计",20,'--按预约时间');
                  getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "origin","origin","完成订单来源统计",0,'--按完成时间');
                  getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "useway","useway","完成订单用车方式统计",0,'--按完成时间');
                    getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "cartype","cartype","完成订单车型统计",0,'--按完成时间');
                     getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "orderweeklychart","orderweeklychart","完成订单星期统计",0,'--按完成时间');
                      getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "genderdata","genderdata","完成订单性别统计",0,'--按完成时间');
           }
            $(function () {
                getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "timespan","timespan","订单预约时间段统计",20,'--按预约时间');
                  getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "origin","origin","完成订单来源统计",0,'--按完成时间');
                  getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "useway","useway","完成订单用车方式统计",0,'--按完成时间');
                    getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "cartype","cartype","完成订单车型统计",0,'--按完成时间');
                     getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "orderweeklychart","orderweeklychart","完成订单星期统计",0,'--按完成时间');
                      getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "genderdata","genderdata","完成订单性别统计",0,'--按完成时间');
//                       getOrderWeeklyData($("#txtstarttime").val(), $("#txtendtime").val(), "demo","timespan","订单预约时间段统计",20);
                loadPlace("province", 0, "province");

            });
            function loadPlace(type,code,container) {
                $.ajax({
                    url:"/charts/OrderStatisticCityList.ashx",
                    type:"post",
                    data: {type:type,code:code},
                    success:function(data) {
                        if (data.length > 0) {
                            var html = "<option value=''>不限</option>";
                            $.each(data, function(index, val) {
                                html+="<option value='"+val.codeid+"'>"+val.cityname+"</option>";
                            });
                            $("#" + container).html(html);
                        }
                    }
                });
            }
    </script>
    <script>

        function getOrderHighchartsData(startDate, endDate, container, type, title, routate) {
            var angle;
            if (routate) {
                angle = 40;
            } else {
                angle = 0;
            }

            $.ajax({
                url: "/charts/orderchartshandler.ashx",
                data: { starttime: startDate, endtime: endDate, type: type, province: $("#province").val(), city: $("#city").val(), town: $("#town").val() },
                type: "post",
                success: function (data) {

                    $('#' + container).highcharts({
                        credits: { enabled: false },
                        chart: {
                            zoomType: 'xy'
                        },
                        title: {
                            text: title
                        },
                        subtitle: {
                            text: ''
                        },
                        xAxis: [{
                            categories: data.monthname
                        }],
                        yAxis: [{
                            labels: {
                                formatter: function () {
                                    return this.value;
                                },
                                style: {
                                    color: '#89A54E'
                                }
                            },
                            title: {
                                text: '订单均价',
                                style: {
                                    color: '#89A54E'
                                }
                            },
                            opposite: true, min: 0

                        }, {
                            gridLineWidth: 0,
                            title: {
                                text: '订单数量',
                                style: {
                                    color: '#4572A7'
                                }
                            },
                            labels: {
                                formatter: function () {
                                    return this.value;
                                },
                                style: {
                                    color: '#4572A7'
                                }
                            }, min: 0

                        }, {
                            gridLineWidth: 0,
                            title: {
                                text: '订单总额',
                                style: {
                                    color: '#AA4643'
                                }
                            },
                            labels: {
                                formatter: function () {
                                    return this.value + '元';
                                },
                                style: {
                                    color: '#AA4643'
                                }
                            },
                            opposite: true, min: 0
                        }],
                        tooltip: {
                            shared: true
                        },
                        legend: {
                            layout: 'horizontal',
                            align: 'center',

                            verticalAlign: 'bottom',

                            backgroundColor: '#FFFFFF'
                        },
                        series: [{
                            name: '订单数量',
                            color: '#4572A7',
                            type: 'column',
                            yAxis: 1,
                            data: data.ordernum,
                            tooltip: {
                                valueSuffix: ''
                            }

                        }, {
                            name: '订单总额',
                            type: 'column',
                            color: '#AA4643',
                            yAxis: 2,
                            data: data.totalmoney,
                            marker: {
                                enabled: false
                            },
                            dashStyle: 'shortdot',
                            tooltip: {
                                valueSuffix: ' 元'
                            }

                        }, {
                            name: '订单均价',
                            color: '#89A54E',
                            type: 'spline',
                            data: data.avgnum,
                            tooltip: {
                                valueSuffix: ' 元'
                            }
                        }]
                    });
                }
            });
        }


        $(function () {
            getOrderHighchartsData();
        });
       
    </script>
    </form>
</asp:Content>
