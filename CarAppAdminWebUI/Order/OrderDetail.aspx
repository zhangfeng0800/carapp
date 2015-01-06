<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="OrderDetail.aspx.cs" Inherits="CarAppAdminWebUI.Order.OrderDetail" %>

<%@ Import Namespace="System.ServiceModel.Activities" %>
<%@ Import Namespace="BLL" %>
<%@ Import Namespace="Model.GPS" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：订单详细信息
            </td>
        </tr>
    </table>
    <div class="adm_20">
        <table border="0" cellpadding="0" cellspacing="0" id="detail">
            <tbody>
                <tr>
                    <td style="width: 65%;">
                        <p style="text-align: center;">
                            <a class="easyui-linkbutton" href="javascript:onCancel()">返回</a>
                            <%
                                if (OrderModel.orderStatusID == 6 && OrderModel.WindPrice==0)
                                {%>
                            <a href="javascript:openRefoundWindow();" class="easyui-linkbutton">订单退款</a>
                            <%}
                            %>
                        </p>
                        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td class="mytitle" colspan="4">
                                    基本信息
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    订单编号：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.orderId %>[<span style="color: red;"><%=carusename%></span>]【<a title="点击查看轨迹"
                                        href="javascript:onShowRoute('<%=OrderModel.orderId %>')">查看轨迹</a>】
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    下单时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.orderDate.ToString("yyyy-MM-dd HH:mm:ss") %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    下单人：
                                </td>
                                <td class="adm_42" width="40%">
                                    <a style="text-decoration: underline;" href="javascript:onShowUser(<%=OrderModel.userID %>)">
                                        <%=string.IsNullOrEmpty(UserName)?"无此用户信息":UserName %>（<%=UserTelphone %>） </a>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    乘车人：
                                </td>
                                <td class="adm_42" width="40%">
                                <%if (dtPassengers != null) {
                                      foreach (System.Data.DataRow row in dtPassengers.Rows) { 
                                      %>
                                      <%=row["passengername"]%> (<%=row["passengerphone"]%>)&nbsp;预定座位：<%=row["booknum"] %>(<%=row["device"] %>)<br />
                                    <%  } 
                                  
                                  }
                                  else {%> 
                                    <%=OrderModel.passengerName %>（<%=OrderModel.passengerPhone %>）
                                  <%} %>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    出发城市：
                                </td>
                                <td class="adm_42" width="25%">
                                    [<%=OrderModel.departureCityID %>]<%=new CityBLL().GetCityName(OrderModel.departureCityID.Trim()) %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    目的城市：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=GetTargetCity(id) %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    上车地址：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=GetStartAddress(OrderModel.rentCarID) %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    下车地址：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=GetEndAddress(OrderModel.rentCarID) %>(经纬度信息：<%=OrderModel.EndPosition %>)
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td class="adm_45" align="right" height="30" width="15%">
                                    实际上车地址：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel==null?"":OrderTimesModel.ActualStartAddr %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    实际下车地址：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel==null?"":OrderTimesModel.ActualEndAddr %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    上车详细地址：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.startAddressDetail %>(经纬度信息：<%=OrderModel.mapPoint %>）
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    乘车人数：
                                </td>
                                <td class="adm_42" width="25%">
                                   <%if (dtPassengers != null)
                                     {
                                     %>最大乘车人数：<%=OrderModel.passengerNum %>人   预定人数：<%=actualNum%>人    <%
                                       }
                                     else {%> 
                                     <%=OrderModel.passengerNum %>人
                                     <%} %>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    预约出发时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%
                                        if (OrderTimesModel != null && OrderTimesModel.UserOrderedtime != "")
                                        {
                                            Response.Write(OrderTimesModel.UserOrderedtime.ToString());
                                        }
                                    %>
                                    <%
                                        if (OrderTimesModel != null && OrderTimesModel.OrderActualtime != "")
                                        {
                                            Response.Write("(实际出发时间)" + OrderTimesModel.OrderActualtime.ToString());
                                        }
                                    %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    用车时长：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=GetTimeString(OrderModel.UseTime) %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    航班信息：
                                </td>
                                <td class="adm_42" width="25%">
                                    机场名称：[<%=airportModel!=null&&!string.IsNullOrEmpty(airportModel.AirPortName)?airportModel.AirPortName :"无此机场信息"%>]
                                    ；航班号：[<%=string.IsNullOrEmpty(OrderModel.flightNo)?"暂无":OrderModel.flightNo %>]
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    乘车人电话：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.passengerPhone %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    订单完成时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%
                                        if (OrderTimesModel != null && OrderTimesModel.OrderCompleteTime != "")
                                        {
                                            Response.Write(OrderTimesModel.OrderCompleteTime.ToString());
                                        }
                                    %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    是否索要发票：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.isreceipts==0?"否":"是" %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    用车要求：
                                </td>
                                <td class="adm_42" width="25%" colspan="3">
                                    <%=OrderModel.remarks %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    订单状态：
                                </td>
                                <td class="adm_42" width="25%" style="color: red;">
                                    <%=(new OrderBLL().IsOrderExpire(OrderModel.orderId))?"订单过期": ((Common.OrderStatus)OrderModel.orderStatusID).ToString()%>
                                    <%
                                        if (OrderModel.orderStatusID == 6)
                                        {%>
                                    （共<%=OrderModel.UseKm%>公里<%=GetTimeString(OrderModel.UseTime) %>，套餐<%=RentCarModel.feeIncludes %>，超出<%=ordersExtInfoModel==null?0:ordersExtInfoModel.overKM %>公里<%=GetTimeString(ordersExtInfoModel == null ? 0 : ordersExtInfoModel.overMinut)%>）
                                    <%}
                                    %>
                                    <%
                                        if (ordersExtInfoModel != null)
                                        {
                                            Response.Write("(gps里程数：" + ordersExtInfoModel.gpsdistance.ToString() + "；司机端里程数：" + OrderModel.UseKm.ToString() + ")");
                                        }
                                    %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    订单来源：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.OrderOrigin %>
                                    <%if (OrderModel.OrderOrigin == "电话订车" && centerOrder != null)
                                      {%>
                                    (客服名称：<a href="javascript:onShowCallOrder(1,'<%=centerOrder.UserName %>')"><%=centerOrder.UserName %></a>
                                    坐席号：<a href="javascript:onShowCallOrder(2,'<%=centerOrder.Exten %>')"><%=centerOrder.Exten %></a>)
                                    <%}%>
                                </td>
                            </tr>
                            <tr>
                                <td class="mytitle" colspan="4">
                                    付款信息
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    预付款：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%if (OrderModel.orderStatusID == 1)
                                      {
                                          Response.Write("0");
                                      }
                                      else if (cancel != null && cancel.OrderState == "等待确认")
                                      {
                                          Response.Write("0");
                                      }
                                      else
                                      {
                                          Response.Write(OrderModel.orderMoney + " 元" + ((OrderTimesModel != null && OrderTimesModel.PayTime != "") ? "(支付时间" + OrderTimesModel.PayTime + ")" : ""));
                                      }
                                    %>

                                    <%if (OrderModel.WindPrice == 0) { %>
                                      (套餐包<%=RentCarModel.feeIncludes %>
                                    ，超出后
                                    <%=RentCarModel.kiloPrice %>
                                    元/公里，<%=RentCarModel.hourPrice %>元/分钟
                                    <%if (mycoupn != null && mycoupn.Id != 0)
                                      {
                                          Response.Write("，该单使用优惠券： 面值" + mycoupn.Cost + "元 满" + mycoupn.Restrictions + "元可以使用");
                                      } %>
                                    <%if (vouchers != null)
                                      {
                                          Response.Write("，该单使用代金券券： 面值" + vouchers.Cost + "元");
                                      } %>
                                    )
                                   <%   } else {%>
                                     （座位单价：<%=OrderModel.WindPrice %> 元）
                                      <%} %>

                                    
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    是否有二次费用：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.unpaidMoney>0?"是":"否" %>
                                </td>
                            </tr>
                            <%if (cancel != null)
                              { %>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    扣费金额：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=cancel.DeductMoney %>元 (<%=cancel.Remark==""?"无扣费":cancel.Remark %>)
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    取消订单时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=cancel.CancelTime.ToString("yyyy-MM-dd HH:mm:ss") %>&nbsp;&nbsp;(取消时订单状态：<%=cancel.OrderState %>)
                                </td>
                            </tr>
                            <%  } %>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    该项服务总额：
                                </td>
                                <td class="adm_42" width="25%" style="color: Red;">
                                    <%
                                        if (OrderModel.orderStatusID == 1)
                                        {
                                            Response.Write("0");
                                        }
                                        else
                                        {
                                            Response.Write(OrderModel.totalMoney + "元");
                                            if (cancel != null)
                                            {
                                                if (cancel.OrderState != "等待确认")
                                                    Response.Write(" (退回用户金额：" + (OrderModel.orderMoney - cancel.DeductMoney) + "元)");
                                                else
                                                    Response.Write(" (退回用户金额：0 元)");
                                            }
                                        }
                                    %>
                                    <%if (OrderModel.orderStatusID == 6 && ordersExtInfoModel != null && OrderModel.WindPrice==0)
                                      {
                                          if (ordersExtInfoModel.emptyCarMoney == 0)
                                          {
                                              Response.Write(" (预付款" + OrderModel.orderMoney + "元 + 超公里费" +
                                                             ordersExtInfoModel.overKMMoney + "元 + 超时费用" + ordersExtInfoModel.overMinutMoney + "元 + 高速费" + ordersExtInfoModel.highwayMoney + "元 + 机场费" +
                                                             ordersExtInfoModel.airportMoney + "元 + 停车费" + ordersExtInfoModel.carStopMoney + "元 + 上车空驶费" + ordersExtInfoModel.DriverStartEmptyFee + "元+下车空驶费" + ordersExtInfoModel.DriverEndEmptyFee + "元+其它费用"+ordersExtInfoModel.OtherFee+"元)=" + OrderModel.totalMoney + "元");

                                          }
                                          else
                                          {
                                              Response.Write(" (预付款" + OrderModel.orderMoney + "元 + 超公里费" +
                                                          ordersExtInfoModel.overKMMoney + "元 + 超时费用" + ordersExtInfoModel.overMinutMoney + "元 + 高速费" + ordersExtInfoModel.highwayMoney + "元 + 机场费" +
                                                          ordersExtInfoModel.airportMoney + "元 + 停车费" + ordersExtInfoModel.carStopMoney + "元 +  空驶费" + ordersExtInfoModel.emptyCarMoney + "元)");

                                          }
                                      }%>

                                      <%if (OrderModel.WindPrice != 0 && (OrderModel.orderStatusID == 6 || OrderModel.orderStatusID == 5))
                                        {
                                            Response.Write("（已付费用：" + actualNum + "座 * " + OrderModel.WindPrice + "元 + 取消扣费：" + deductmoney + "元 = "+OrderModel.totalMoney+"元）");
                                        } %>


                           




                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    二次付款金额：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.unpaidMoney %>元
                                    <%
                                        Response.Write((OrderTimesModel != null && OrderTimesModel.TwicePayTime != "") ? "(二次付款时间" + OrderTimesModel.TwicePayTime + ")" : "");%>
                                </td>
                            </tr>

                           <%if (cancelPassengers != null && cancelPassengers.Rows.Count>0)
                                            { %>
                           <tr>
                           <td  class="adm_45" align="right" height="30" width="15%">顺风车取消信息：</td>
                           
                           <td class="adm_42" width="25%">
                                <table style="width:100%;">
                                  <%foreach (System.Data.DataRow row in cancelPassengers.Rows) 
                                  {%>
                                  <tr><td >乘车人：<a style="text-decoration: underline;" href='javascript:onShowUser(<%=row["userId"] %>)'><%=row["passengername"]%></a></td><td >电话：<%=row["passengerphone"]%></td>
                                  <td>扣费金额：<%=row["deductmoney"]%> 元</td><td>扣费时间：<%=row["deductime"]%></td><td>来源：<%=row["device"]%></td></tr>
                                  <%} %>
                                  </table>
                           </td>
                          
                          </tr>   
                             <% } %>



                            <% if (ordersExtInfoModel != null)
                               {%>
                            <tr>
                                <td class="mytitle" colspan="4">
                                    二次付款信息
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    超分钟：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%= ordersExtInfoModel.overMinut %>分钟
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    超分钟费用：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%
                                   if (ordersExtInfoModel.overMinut > 0)
                                   { %>
                                    <%= ordersExtInfoModel.overMinutMoney %>元 (
                                    <%= RentCarModel.hourPrice %>元/分钟 *
                                    <%= ordersExtInfoModel.overMinut %>分钟 =
                                    <%= Math.Round(ordersExtInfoModel.overMinut*RentCarModel.hourPrice,2) %>元，如不一致，则司机改动)
                                    <% }
                                   else
                                   {
                                       Response.Write("0元");
                                   }
                                    %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    超公里：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%= ordersExtInfoModel.overKM %>公里
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    超公里费用：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%
                                   if (ordersExtInfoModel.overKM > 0)
                                   { %>
                                    <%= ordersExtInfoModel.overKMMoney %>元 (
                                    <%= RentCarModel.kiloPrice %>元/公里 *
                                    <%= ordersExtInfoModel.overKM %>公里 =<%=Math.Round(RentCarModel.kiloPrice * ordersExtInfoModel.overKM,2)%>
                                    元，如不一致，则司机改动)
                                    <% }
                                   else
                                   {
                                       Response.Write("0元");
                                   }
                                    %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    高速费：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%= ordersExtInfoModel.highwayMoney %>元
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    停车费：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%= ordersExtInfoModel.carStopMoney %>元
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    机场费：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%= ordersExtInfoModel.airportMoney %>元
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    空驶费：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%--   <%= ordersExtInfoModel.emptyCarMoney %>元
                                    <%if (ordersExtInfoModel.emptyCarMoney > 0)
                                      {%>
                                    （<%=ordersExtInfoModel.emptydistance
                                    %>公里*<%=RentCarModel.kiloPrice %>元/公里=<%=Math.Round(ordersExtInfoModel.emptydistance*RentCarModel.kiloPrice,2) %>元，如不一致，则司机改动）
                                    <%} %>--%>
                                    <%
                                   if (ordersExtInfoModel.emptyCarMoney > 0)
                                   { %>
                                    <%= ordersExtInfoModel.emptyCarMoney %>元
                                    <% if (ordersExtInfoModel.emptyCarMoney > 0)
                                       { %>
                                    （<%= ordersExtInfoModel.emptydistance
                                    %>公里*<%= RentCarModel.kiloPrice %>元/公里=<%= Math.Round(ordersExtInfoModel.emptydistance*RentCarModel.kiloPrice, 2) %>元，如不一致，则司机改动）
                                    <% } %>
                                    <% }
                                   else
                                   {%>
                                    上车空驶费<%=ordersExtInfoModel.DriverStartEmptyFee %>元 （<%= ordersExtInfoModel.startemptydistance
                                    %>公里*<%= RentCarModel.kiloPrice %>元/公里=<%= Math.Round(ordersExtInfoModel.startemptydistance*RentCarModel.kiloPrice, 2) %>元，如不一致，则司机改动）<br />
                                    下车空驶费<%=ordersExtInfoModel.DriverEndEmptyFee %>元 （<%= ordersExtInfoModel.endemptydistance
                                    %>公里*<%= RentCarModel.kiloPrice %>元/公里=<%= Math.Round(ordersExtInfoModel.endemptydistance*RentCarModel.kiloPrice, 2) %>元，如不一致，则司机改动）
                                    <% }
                                    %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    其它费用：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%= ordersExtInfoModel.OtherFee %>元
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    其他费用说明：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%= ordersExtInfoModel.OtherFeeRemark %>
                                </td>
                            </tr>
                            <%
                               } %>
                       
                            <tr>
                                <td class="mytitle" colspan="4">
                                    订车信息
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    车辆类型：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=new CarTypeBLL().GetCarType(RentCarModel.carTypeID) %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    用车方式：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=GetCarUseWay(RentCarModel.carusewayID) %><%=GetHotLineName(RentCarModel.hotLineID) %>
                                </td>
                            </tr>
                            <%
                                if (OrderTimesModel != null && OrderModel.orderStatusID > 1)
                                {%>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    下单时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderModel.orderDate.ToString("yyyy-MM-dd HH:mm:ss") %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    支付时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.PayTime??"暂无" %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    派车时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.SendCarTime??"暂无" %>
                                    <%
                                    if (sendRecord.Rows.Count > 0)
                                    {
                                        Response.Write("（客服：" + sendRecord.Rows[0]["username"].ToString() + " 坐席号" + sendRecord.Rows[0]["exten"].ToString() + "）");
                                    }
                                    %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    接单时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.PickOrdertime??"暂无" %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    司机出发时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.DriverStartTime??"暂无" %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    司机就位时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.DriverPlacetime??"暂无" %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    开始服务时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.OrderActualtime??"暂无" %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    计费时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.ChargingTime??"暂无" %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    服务结束时间：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.ServiceEndtime??"暂无" %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    订单完成时间
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=OrderTimesModel.OrderCompleteTime %>
                                </td>
                            </tr>
                            <% }
                            %>
                            <% if (CarInfoModel != null)
                               {
                            %>
                            <tr>
                                <td class="mytitle" colspan="4">
                                    服务车辆
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    车牌号：
                                </td>
                                <td class="adm_42" width="25%">
                                    <a href="javascriot:void(0);" onclick="onShowCarInfo('<%=CarInfoModel.Id %>')" style="text-decoration: underline;">
                                        <%=CarInfoModel.CarNo %>
                                    </a>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    名称：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=CarInfoModel.Name %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    电话：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=CarInfoModel.telPhone %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    当前位置：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=GetCurrentPosotion()
                                 
                                    %>
                                </td>
                            </tr>
                            <%
                               } %>
                            <% if (DriverAccountModel != null)
                               {
                            %>
                            <tr>
                                <td class="mytitle" colspan="4">
                                    服务司机
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    司机姓名：
                                </td>
                                <td class="adm_42" width="25%">
                                    <a href="javascript:void(0);" style="text-decoration: underline;" onclick="onShowDriver('<%=DriverAccountModel.JobNumber %>')">
                                        <%=DriverAccountModel.Name %>
                                        <a href="javascript:operateOrder('<%=CarInfoModel.telPhone %>','<%
                                                                                                            if (OrderModel.orderStatusID == 9)
                                                                                                            {
                                                                                                            Response.Write(OrderModel.JobNumber);
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                  var driverid = CarInfoModel.DriverID;
                                                                                                            if (driverid!=0)
                                                                                                            {
                                                                                                                var driverModel = (new DirverAccountBLL().GetModel(driverid));
                                                                                                               Response.Write(driverModel==null?"":driverModel.JobNumber.Trim()); 
                                                                                                            }
                                                                                                            }
                                                                                                          
                                         %>','<%=OrderModel.orderId %>',<%=OrderModel.orderStatusID %>);">
                                            <%=GetStatus(OrderModel.orderStatusID) %></a> </a>
                                </td>
                                <%-- var driverid = CarInfoModel.DriverID;
                                                                                                            if (driverid!=0)
                                                                                                            {
                                                                                                                var driverModel = (new DirverAccountBLL().GetModel(driverid));
                                                                                                               Response.Write(driverModel==null?"":driverModel.JobNumber.Trim()); 
                                                                                                            }--%>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    工号：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=DriverAccountModel.JobNumber %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    私人手机：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=DriverAccountModel.DriverPhone %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    驾照编号：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=DriverAccountModel.CardNo %>
                                </td>
                            </tr>
                            <tr>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    身份证号：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=DriverAccountModel.SSN %>
                                </td>
                                <td class="adm_45" align="right" height="30" width="15%">
                                    常用住址：
                                </td>
                                <td class="adm_42" width="25%">
                                    <%=DriverAccountModel.Address %>
                                </td>
                            </tr>
                            <%
                               } %>
                        </table>
                        <p style="text-align: center;">
                            <a class="easyui-linkbutton" href="javascript:onCancel()">返回</a>
                        </p>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div id="w" class="easyui-window" title="计算账单" data-options="modal:true,closable:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false,maximizable:false"
        style="width: 750px; height: 400px; padding: 10px;">
        <table id="endserviceInfo" class="adm_8" border="0" cellpadding="0" cellspacing="0"
            width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="30">
                    服务时长：
                </td>
                <td class="adm_42" width="100">
                    <span id="servicehour"></span>小时 <span id="serviceminute"></span>分钟
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30">
                    超时时长：
                </td>
                <td class="adm_42" width="100">
                    <span id="overhour"></span>小时 <span id="overminute"></span>分钟
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30">
                    服务里程：
                </td>
                <td class="adm_42" width="100">
                    <input class="adm_21" id="totalkm" name="totalkm" type="text" />公里
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30">
                    高速费用：
                </td>
                <td class="adm_42" width="100">
                    <input type="text" style="width: 150px;" class="in_border" name="highway" id="highway"
                        value="0" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30">
                    <span class="field-validation-valid">*</span>停车费用：
                </td>
                <td class="adm_42" width="100">
                    <input class="adm_21" id="parkfee" name="parkfee" value="0" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30">
                    <span class="field-validation-valid">*</span>机场费用：
                </td>
                <td class="adm_42" width="100">
                    <input class="adm_21" id="airportfee" name="airportfee" value="0" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30">
                    <span class="field-validation-valid">*</span>上车空驶费：
                </td>
                <td class="adm_42" width="100">
                    <input class="adm_21" id="emptyfee" value="0" name="emptyfee" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30">
                    <span class="field-validation-valid">*</span>下车空驶费：
                </td>
                <td class="adm_42" width="100">
                    <input class="adm_21" id="endemptyfee" value="0" name="endemptyfee" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_42" width="100" colspan="4" style="text-align: center;">
                    <input type="button" value="计算账单" id="btnsubmit" onclick="calculateFee('<%=OrderModel.orderId %>')" />
                </td>
            </tr>
        </table>
        <table id="accountInfo" class="adm_8" border="0" cellpadding="0" cellspacing="0"
            width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>订单总额：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_totalmoney"></span>元
                </td>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>账户余额：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_balance"></span>元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>客户预付款：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_ordermoney"></span>元
                </td>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>二次支付费用：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_twicepay"></span>元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="100">
                    服务时长：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_totalhour"></span>小时 <span id="account_totalminute"></span>分钟
                </td>
                <td class="adm_45" align="right" height="30" width="100">
                    超时时长：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_overhour"></span>小时 <span id="account_overminute"></span>分钟(<span
                        id="account_minuteprice"></span>元/分钟)
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>超时费用：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_overminitefee"></span>元
                </td>
                <td class="adm_45" align="right" height="30" width="100">
                    服务里程：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_totalkm"></span>公里
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>超公里数：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_overkm"></span>公里(<span id="account_kmprice"></span>元/公里)
                </td>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>超公里费：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_overkmfee"></span>元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="100">
                    高速费用：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_high"></span>元
                </td>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>停车费用：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_parkfee"></span>元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>机场费用：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_airportfee"></span>元
                </td>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>上车空驶费：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_empyfee"></span>元
                </td>
                <td class="adm_45" align="right" height="30" width="100">
                    <span class="field-validation-valid">*</span>下车空驶费：
                </td>
                <td class="adm_42" width="100">
                    <span id="account_endemptyfee"></span>元
                </td>
            </tr>
            <tr>
                <td class="adm_42" width="100" colspan="4" style="text-align: center;">
                    <input type="button" value="提交账单" id="Button1" onclick="submitbill('<%=CarInfoModel==null?"":CarInfoModel.telPhone %>','<%=DriverAccountModel==null?"":DriverAccountModel.JobNumber %>','<%=OrderModel.orderId %>')" />
                </td>
                <td>
                    <input type="button" value="返回" id="Button2" onclick="onReturn()" />
                </td>
            </tr>
        </table>
    </div>
    <div id="refoundwindow" class="easyui-window" title="订单退款" data-options="modal:true,closable:true,closed:true,iconCls:'icon-save',collapsible:false,minimizable:false,maximizable:false"
        style="width: 500px; height: 300px; padding: 10px;">
        <table id="tb_refoud" class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="80">
                    退款项目：
                </td>
                <td class="adm_42" width="100">
                    <select id="refounditem" onchange="onSelectChange($(this).val())">
                        <%
                            if (ordersExtInfoModel != null)
                            {%>
                        <option value="">请选择</option>
                        <option value="<%=ordersExtInfoModel.DriverStartEmptyFee %>">上车空驶费（<%=ordersExtInfoModel.DriverStartEmptyFee %>元）</option>
                        <option value="<%=ordersExtInfoModel.DriverEndEmptyFee %>">下车空驶费（<%=ordersExtInfoModel.DriverEndEmptyFee %>元）</option>
                        <option value="<%=ordersExtInfoModel.airportMoney %>">机场费（<%=ordersExtInfoModel.airportMoney %>元）</option>
                        <option value="<%=ordersExtInfoModel.carStopMoney %>">停车费（<%=ordersExtInfoModel.carStopMoney %>元）</option>
                        <option value="<%=ordersExtInfoModel.highwayMoney %>">高速费（<%=ordersExtInfoModel.highwayMoney %>元）</option>
                        <option value="<%=ordersExtInfoModel.overMinutMoney %>">超分钟费用（<%=ordersExtInfoModel.overMinutMoney %>元）</option>
                        <option value="<%=ordersExtInfoModel.overKMMoney %>">超里程费用（<%=ordersExtInfoModel.overKMMoney %>元）</option>
                           <option value="<%=OrderModel.orderMoney %>">预付款（<%=OrderModel.orderMoney %>元）</option>
                               <option value="<%=ordersExtInfoModel.OtherFee %>">其它费用（<%=ordersExtInfoModel.OtherFee %>元）</option>
                        <% }
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="80">
                    退款金额：
                </td>
                <td class="adm_42" width="100">
                    <input type="text" value="0" style="width: 50px;" id="txt_refoundmoney" />
                    <input id="hid_refoundmoney" type="hidden" value="0" style="width: 50px;" />
                </td>
            </tr>
            <tr style="display: none" id="overkmtr">
                <td class="adm_45" align="right" height="30" width="80">
                    超公里数：
                </td>
                <td class="adm_42" width="100">
                    <input id="overkm" name="overkm" type="text" value="<%=ordersExtInfoModel==null?0:ordersExtInfoModel.overKM %>" style="width: 50px;" />公里
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="80">
                    备注信息：
                </td>
                <td class="adm_42" width="100">
                    <textarea rows="5" cols="20" style="width: 200px; height: 50px;" id="remark"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding: 10px; text-align: center;">
                    <button onclick="javascript:onRefound();" class="easyui-linkbutton" id="btnrefound">
                        订单退款</button>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript">
        $(function () {
            $("#detail").css("width", $(window).width());
        });
        function onShowRoute(id) {
            top.addTab("订单路径(ID:" + id + ")", "/car/carroute.aspx?orderid=" + id, "icon-nav");
        }
        function onShowUser(id) {
            top.addTab("会员详细(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }

        function onShowCarInfo(id) {
            top.addTab("车辆详细(ID:" + id + ")", "/Car/CarInfoDetail.aspx?id=" + id, "icon-nav");
        }

        function onShowDriver(id) {
            top.addTab("司机详细(ID:" + id + ")", "/Car/DriverDetail.aspx?id=" + id, "icon-nav");
        }

        function onCancel() {
            top.closeTab('close');
        }
        function onReturn() {
            $("#accountInfo").hide();
            $("#endserviceInfo").show();
        }
        function onShowCallOrder(type, name) {
            if (type == 1) {
                top.addTab("客服订单", "/Order/KefuOrderList.aspx?username=" + name, "icon-nav");
            }
            else {
                top.addTab("客服订单", "/Order/KefuOrderList.aspx?exten=" + name, "icon-nav");
            }

        }
        function refresh() {
            window.location.reload();
        }

        function operateOrder(phone, jobnumber, orderid, orderStatus) {
            if (orderStatus == 4) {
                getEndServiceData(orderid);
                return;
            }
            $.messager.confirm("提示信息", '确认<%=GetStatus(OrderModel.orderStatusID)  %>', function (r) {
                if (r) {
                    $.ajax({
                        url: "/order/orderhandler.ashx?action=op&phone=" + phone + '&jobnumber=' + jobnumber + '&orderid=' + orderid + '&status=' + orderStatus,
                        contentType: "text/json",
                        success: function (data) {
                            if (orderStatus == 3) {
                                if (data.resultcode == 1) {
                                    $("#servicehour").text(data.data[0].totalhour);
                                    $("#serviceminute").text(data.data[0].totalminutes);
                                    $("#overhour").text(data.data[0].overhours);
                                    $("#overminute").text(data.data[0].overminutes);
                                    $("#totalkm").val(data.totalDistant);
                                    $("#accountInfo").css("display", "none");
                                    $("#endserviceInfo").css("display", "");
                                    $('#w').window('open');
                                }
                            } else {
                                if (data.resultcode == 1) {
                                    refresh();
                                } else {
                                    $.messager.alert("提示信息", data.msg);
                                }

                            }
                        }
                    });
                }
            });
        }
        function getEndServiceData(orderid) {
            $.ajax({
                url: "/order/orderhandler.ashx?action=enddata&orderid=" + orderid + "",
                contentType: "text/json",
                success: function (data) {
                    $("#servicehour").text(data.data.TotalHours);
                    $("#serviceminute").text(data.data.TotalMinutes);
                    $("#overhour").text(data.data.OverHours);
                    $("#overminute").text(data.data.OverMinutes);
                    $("#totalkm").val(data.data.TotalDistant);
                    //                  $("#account_empyfee").val(data.);
                    $("#accountInfo").css("display", "none");
                    $("#endserviceInfo").css("display", "");
                    $('#w').window('open');
                }
            });
        }
        function submitbill(phone, jobnumber, orderid, orderStatus) {
            $.ajax({
                url: "/order/orderhandler.ashx?action=subbill&phone=" + phone + '&jobnumber=' + jobnumber + '&orderid=' + orderid,
                contentType: "text/json",
                success: function (data) {
                    if (data.resultcode == 0) {
                        $.messager.alert("提示信息", " 账单计算失败 ");
                    } else {
                        if (data.isneed == 0) {
                            $.messager.alert("提示信息", " 订单完成 ", "info", function (r) {
                                $('#w').window('close');
                                refresh();
                            });
                        } else {
                            if (data.isenough == 1) {
                                $.messager.alert("提示信息", " 订单支付完成 ", "info", function () {
                                    $('#w').window('close');
                                    refresh();
                                });
                            } else {
                                $.messager.alert("提示信息", " 请司机等待乘客二次付款 ");
                            }
                        }
                    }
                }
            });
        }
        function calculateFee(orderid) {
            $.ajax({
                url: '/order/orderhandler.ashx',
                type: "post",
                data: {
                    orderid: orderid,
                    status: 4,
                    action: "op",
                    km: $("#totalkm").val(),
                    highWayStr: $("#highway").val(),
                    partStr: $("#parkfee").val(),
                    portStr: $("#airportfee").val(),
                    emptyFee: $("#emptyfee").val(),
                    endemptyfee: $("#endemptyfee").val()
                },
                success: function (data) {
                    if (data.resultcode == 0) {
                        $("#accountInfo").css("display", "");
                        $("#endserviceInfo").css("display", "none");
                        $("#account_totalmoney").text(data.totalMoney);
                        $("#account_balance").text(data.userBalance);
                        $("#account_airportfee").text(data.airPort);
                        $("#account_ordermoney").text(data.orderMoney);
                        $("#account_empyfee").text(data.driverStartEmptyFee);
                        $("#account_high").text(data.highWay);
                        $("#account_kmprice").text(data.kiloPrice);
                        $("#account_minuteprice").text(data.hourPrice);
                        $("#account_overkm").text(data.overKm);
                        $("#account_overkmfee").text(data.overKmFee);
                        $("#account_totalhour").text(data.totalHours);
                        $("#account_totalminute").text(data.totalMinutes);
                        $("#account_twicepay").text(data.twiceMoney);
                        $("#account_parkfee").text(data.park);
                        $("#account_overminitefee").text(data.overHourFee);
                        $("#account_totalkm").text(data.km);
                        $("#account_endemptyfee").text(data.driverEndEmptyFee);
                        $("#account_overhour").text(data.overhours);
                        $("#account_overminute").text(data.overmi);

                    } else {
                        $.messager.alert("提示信息", data.msg, 'error');
                    }

                }
            });
        }
        function openRefoundWindow() {
            $("#refounditem").val('');
            $("#txt_refoundmoney").val(0);
            $("#refoundwindow").window("open");
        }
        function onSelectChange(val) {
            if (val && val.length > 0) {
                $("#txt_refoundmoney").val(val);
            }
            if ($("#refounditem").get(0).selectedIndex == 7) {
                $("#overkmtr").show();
            } else {
                $("#overkmtr").hide();
            }
        }
        function onRefound() {
            if ($('#refounditem').val() == '') {
                $.messager.alert('提示信息', '请选择项目');
            } else {
                var money = $("#txt_refoundmoney").val();
                var flag = $('#refounditem').get(0).selectedIndex;
                var orderid = '<%=ordersExtInfoModel==null?"":ordersExtInfoModel.orderID %>';
                var remark = $("#remark").val();
                var data = { money: money, orderid: orderid, type: flag, remark: remark,overkm:$("#overkm").val(), action: "refound", telphone: '<%=UserTelphone %>' };
                $.ajax({
                    url: "/order/orderhandler.ashx",
                    data: data,
                    type: "post",
                    success: function (data) {
                        if (data.resultcode == 0) {
                            $.messager.alert('提示信息', data.msg);
                        } else {
                            $.messager.alert('提示信息', '操作成功', 'info', function () {
                                $("#btnrefound").text("订单退款");
                                $("#btnrefound").removeAttr("disabled");
                                $("#refoundwindow").window("close");
                                window.location.reload();
                            });
                        }
                    },
                    beforeSend: function () {
                        $("#btnrefound").text("退款中");
                        $("#btnrefound").attr("disabled", "disabled");
                    },
                    complete: function () {
                        $("#btnrefound").text("订单退款");
                        $("#btnrefound").removeAttr("disabled");
                    }
                });
            }

        }
    </script>
</asp:Content>
