<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="DriverDetail.aspx.cs" Inherits="CarAppAdminWebUI.Car.DriverDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
 <script src="../Static/My97DatePicker/moment.min.js" type="text/javascript"></script>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：司机详细信息
            </td>
        </tr>
    </table>
    <div class="adm_20">
        <table border="0" cellpadding="0" cellspacing="0" id="detail">
            <tr>
                <td style="width: 65%;" valign="top">
                    <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td class="mytitle" colspan="6">
                                基本信息
                            </td>
                        </tr>
                        <tr>
                            <td class="adm_45" align="right" height="30" width="10%">
                                工号：
                            </td>
                            <td class="adm_42" >
                                <%=Model.JobNumber%>
                            </td>
                            
                            <td class="adm_45" align="right" height="30" width="10%" >
                                司机姓名：
                            </td>
                            <td class="adm_42">
                                <%=Model.Name %>
                            </td>

                            <td class="adm_42" rowspan="2" colspan="2">
                               <img src="<%=Model.Imgurl %>" width="100" height="100"/>
                            </td>
                        </tr>



                        <tr>
                            <td class="adm_45" align="right" height="30" width="10%" >
                                驾照号码：
                            </td>
                            <td class="adm_42" >
                                <%=Model.CardNo%>
                            </td>
                               <td class="adm_45" align="right" height="30" width="10%" >
                                私人手机：
                            </td>
                            <td class="adm_42">
                                <%=Model.DriverPhone%>
                            </td>
                        
                        </tr>
   
                        <tr>
                        <td class="adm_45" align="right" height="30" >
                                身份证号：
                            </td>
                            <td class="adm_42" >
                                <%=Model.SSN%>
                            </td>
                          
                            <td class="adm_45" align="right" height="30" >
                                驾龄：
                            </td>
                            <td class="adm_42">
                            <%if(Model.GetLicenseDay!=null)
                              {
                                   %><%= DateTime.Now.Year - ((DateTime)Model.GetLicenseDay).Year %><%
                              } %>
                               
                            </td>
                              <td class="adm_45" align="right" height="30" >
                                年龄：
                            </td>
                            <td class="adm_42" width="25%">
                            <%if(Model.Birthday !=null)
                              {
                                  %><%=DateTime.Now.Year - ((DateTime)Model.Birthday).Year+1%><%
                              }%>
                                
                            </td>
                        </tr>
                        <tr>  
                              <td class="adm_45" align="right" height="30" >
                                籍贯：
                            </td>
                            <td class="adm_42" >
                                <%=Model.Address%>
                            </td>
                           
                            <td class="adm_45" align="right" height="30" >
                                其他：
                            </td>
                            <td class="adm_42" >
                                <%=Model.Other%>
                            </td> 
                            <td></td><td></td>
                           
                        </tr>
                    </table>
                </td>
            </tr>
          <%--  <tr>
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
            </tr>--%>
        </table>

         <div class="easyui-tabs" id="tabs">
            <div title="订单记录" style="padding: 10px">
                <table id="gd1">
                </table>
            </div>
            <div title="登录记录" style="padding: 10px">
                &nbsp;&nbsp;&nbsp;&nbsp;
                 <span class="input_blo">日期: <input class="Wdate" type="text" name="dates" id="dates" style=" width:100px;"  value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> - 
                 <input onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" name="datee" id="datee" style=" width:100px;"  value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>"  class="Wdate" /></span>
                 
                  <span class="input_blo"><span class="input_text">
                <select id="timesel" onchange="search()">
                <option value="">不限</option>
                 <option value="day">本日</option>
                 <option value="month">本月</option>
                 <option value="year">本年</option>
                </select>
                </span></span>
                 
                 <span class="input_blo"><a href="javascript:onSearchG2()" class="easyui-linkbutton"
                            iconcls="icon-search">查询</a></span>
                <span class="input_blo"><a href="javascript:onExport()"
                                class="easyui-linkbutton" iconcls="icon-remove">导出Excel</a> </span>
                <br /><br />
                <table id="gd2">
                </table>
            </div>
            </div>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();     

        });
        function resizeTable() {
            var height = ($(window).height()) - 300;
            var width = $(window).width();
            $("#gd1").css("height", height);
            $("#gd2").css("height", height-50);
            $("#detail").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gd1').datagrid({
                url: "/Car/DriverHandler.ashx?action=orderlist&id=<%=Model.JobNumber %>",
                method: 'post',
                title: "相关订单记录",

                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                frozenColumns: [[
                   { field: 'orderId', title: '订单编号', formatter: forderid }
                ]],
                columns: [[
                { field: 'orderDate', title: '下单时间', width: 200, formatter: easyui_formatterdate },
                { field: 'departureCity', title: '出发城市', width: 100 },
                { field: 'targetCity', title: '目的城市', width: 100 },
                { field: 'CarType', title: '租车类型', width: 100 },
                { field: 'orderMoney', title: '订单额（元）', width: 100 },
                   { field: "unpaidMoney", title: "二次付款金额（元）" },
                   { field: "totalMoney", title: "订单总额（元）" },
                { field: 'passengerName', title: '乘车人', width: 100 }
            ]]
            });

            onSearchG2();

        }
        function onSearchG2() {

            $('#gd2').datagrid({
                url: "/Car/DriverHandler.ashx?action=recordlist&id=<%=Model.JobNumber %>&dates=" + $("#dates").val() + "&datee=" + $("#datee").val(),
                method: 'post',
                title: "相关登录记录",

                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                showFooter:true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [[
                { field: 'loginTime', title: '登录时间', width: 200, sortable: true },
                { field: 'logoutTime', title: '退出时间', width: 200, sortable: true },
                { field: 'logoutType', title: '退出方式', width: 200 },
                { field: 'onlinetime', title: '本次登录时长（分）', width: 200, formatter: gettimestring, sortable: true }
            ]]
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

        function gettimestring(value, row, index) {
            return parseInt(value / 60) + "小时" + value % 60 + "分钟";
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
        //导出Excel  action
        function onExport() {
            window.open("/Car/DriverHandler.ashx?action=ToExcel&id=<%=Model.JobNumber %>&dates=" + $("#dates").val() + "&datee=" + $("#datee").val());
        }
    </script>
</asp:Content>
