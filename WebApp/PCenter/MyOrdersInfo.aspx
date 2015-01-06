<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyOrdersInfo.aspx.cs" Inherits="WebApp.PCenter.MyOrdersInfo" %>

<%@ Import Namespace="BLL" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="WebApp.api" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function SecontPay() {
            window.location.href = "../twicepay.aspx?orderid=<%=orderThis.orderId %>";
        }
        function showDriver() {
            $("#goOrderDiv").fadeIn(300);
        }
        function cancelDriver() {
            $("#goOrderDiv").fadeOut(300);
        }
    </script>
    <style type="text/css">
        a
        {
            cursor: pointer;
        }
        #goOrderDiv
        {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0px;
            left: 0px;
            display: none;
        }
        #orderForm
        {
            position: absolute;
            width: 350px;
            height: 400px;
            background-color: White;
            left: 38%;
            top: 25%;
            padding: 10px;
        }
        #orderFormTable td *
        {
            float: left;
            padding: 2px;
        }
        #zhezhao
        {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0px;
            left: 0px;
            background-color: #000;
            filter: alpha(opacity:80);
            opacity: 0.8;
            z-index: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="per-line-til order-name-top">
        <span class="order-name-style">
            <%=GetCarUseWayName(orderThis.orderId)%></span> <span class="order-name-style">订单编号：<%=orderThis.orderId %></span><span
                class="order-name-style">订单状态：<%=GetOrderStatus(orderThis.orderId)%></span><!--span class="order-name-style">付款状态：<%=orderThis.paystatus == Common.PayStatus.Paid ? "已付款" : "未付款"%></span--></h3>
   <%if (rentCar.carusewayID == 8) { %><span style=" color:red">顺风车订单详情及操作请登录手机app查看</span><%} %> 

    <h3 class="per-line-til">
        订单信息
    </h3>
    <div class="per-line-bg">
        <ul class="order-info-ul clearfix">
            <li>乘车人：<%=orderThis.passengerName %></li>
            <li>乘车人数：<%=orderThis.passengerNum %>人</li>
            <li>联系电话：<%=orderThis.passengerPhone %></li>
            <li style="overflow: hidden;">用车要求：<%=orderThis.remarks %></li>
        </ul>
        <ul class="order-info-con">
            <li>用车方式：<%=carUseWayStr%></li>
            <li>预定车型：<%=carTypeStr %>（含油、险、驾，<%=rentCar.feeIncludes %>）</li>
            <%if(orderThis.carId != null&&carinfo!=null)
              {%>
            <li>车型-汽车牌照：<%=carinfo.Name+"-"+carinfo.CarNo%></li>
            <%}%>
            <%if(!string.IsNullOrEmpty(orderThis.JobNumber))
              {%>
            <li>司机：<a style="color: Orange;" href="javascript:showDriver()">工号：<%=driverInfo.JobNumber%>
                姓名：<%=driverInfo.Name %></a></li>
            <%}%>
            <li></li>
            <li>
                <%=hotLineWayName%></li>
            <% if (istravel)
               {
                   Response.Write("<li>门票数量：" + ticketnum + "张</li>");
               } %>
            <%
                if (carUseWayStr == "接机")
                {%>
            <li>机场信息：<%
                         var airportModel = (new AirportBLL()).GetModel(orderThis.airportID);
                         Response.Write(airportModel != null ? airportModel.AirPortName : "");
            %></li>
            <li>航班号：<%=string.IsNullOrEmpty(orderThis.flightNo)?"":orderThis.flightNo%></li>
            <%}%>
        </ul>
        <ul class="order-info-con order-info-con1 clearfix">
            <li>预约上车地点：<%=upCity+","+orderThis.startAddress %></li>
            <%
                if (timeModel != null)
                {%>
            <%
                //if (timeModel.OrderActualtime != "")
                //{
                //    Response.Write("  <li>实际出发时间：" + Convert.ToDateTime(timeModel.OrderActualtime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                //}
                  
            %>
            <% }    %>
            <%
                if (timeModel != null)
                {%>
            <%
                if (timeModel.ActualStartAddr != "")
                {%>
            <li>实际上车地点：<%=upCity+","+timeModel.ActualStartAddr%></li>
            <% }
            %>
            <% }
                
            %>
            <li>预约下车地点：<%=downCity+","+orderThis.arriveAddress %></li>
            <%
                if (timeModel != null)
                {%>
            <%
                if (timeModel.ActualEndAddr != "")
                {%>
            <li>实际下车地点：<%=downCity+","+timeModel.ActualEndAddr%></li>
            <% } %>
            <% }
     
            %>
            <%--      <%if (orderThis.useHour != 0)
              {
            %>
            <li>预计用车时长：<%=orderThis.useHour %>小时</li><%
                                                        }%>--%>
            <li>预约出发时间：<%
      

                           if (timeModel != null)
                           {
                               Response.Write(timeModel.UserOrderedtime != "" ? Convert.ToDateTime(timeModel.UserOrderedtime).ToString("yyyy年MM月dd日 HH点mm分") : orderThis.departureTime.ToString("yyyy年MM月dd日 HH点mm分"));
                           }
                           else
                           {
                               Response.Write(orderThis.departureTime.ToString("yyyy年MM月dd日 HH点mm分"));
                           }
            %></li>
            <li>下单时间：<%=orderThis.orderDate.ToString("yyyy年MM月dd日 HH点mm分")%></li>
            <%
                if (timeModel != null)
                {
                    if (timeModel.PayTime != "")
                    {
                        Response.Write("<li>预付时间：" + Convert.ToDateTime(timeModel.PayTime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.SendCarTime != "")
                    {
                        Response.Write("<li>派车时间：" + Convert.ToDateTime(timeModel.SendCarTime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.PickOrdertime != "")
                    {
                        Response.Write("<li>司机接单时间：" + Convert.ToDateTime(timeModel.PickOrdertime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.DriverStartTime != "")
                    {
                        Response.Write("<li>司机出发时间：" + Convert.ToDateTime(timeModel.DriverStartTime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.DriverPlacetime != "")
                    {
                        Response.Write("<li>司机就位时间：" + Convert.ToDateTime(timeModel.DriverPlacetime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.OrderActualtime != "")
                    {
                        Response.Write("<li>开始服务时间：" + Convert.ToDateTime(timeModel.OrderActualtime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.ChargingTime != "")
                    {
                        Response.Write("<li>开始计费时间：" + Convert.ToDateTime(timeModel.ChargingTime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.ServiceEndtime != "")
                    {
                        Response.Write("<li>服务结束时间：" + Convert.ToDateTime(timeModel.ServiceEndtime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.TwicePayTime != "")
                    {
                        Response.Write("<li>二次支付时间：" + Convert.ToDateTime(timeModel.TwicePayTime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                    if (timeModel.OrderCompleteTime != "")
                    {
                        Response.Write("<li>订单完成时间：" + Convert.ToDateTime(timeModel.OrderCompleteTime).ToString("yyyy年MM月dd日 HH点mm分") + "</li>");
                    }
                }
            %>
        </ul>
    </div>
    <%--    <h3 class="per-line-til">
        优惠券</h3>
    <div class="per-line-bg">
        <ul class="order-info-con">
            <!--li>结算账户：<%=new BLL.UserAccountBLL().GetMaster(orderThis.userID).Compname %></li-->
            <%if (couponThis != null)
              { %>
            <li>优惠券名称：<%=couponThis.Name %></li>
            <li>优惠金额：<%=couponThis.Cost %></li>
            <%}
              else
              { %>
            <li>使用优惠券：无</li>
            <%} %>
            <%if (vouchers != null)
              {
                  %>
            <li>使用代金券：<%=vouchers.Cost%> 元</li>
                  <%
              }%>
        </ul>
    </div>--%>
    <h3 class="per-line-til">
        发票信息</h3>
    <div class="per-line-bg">
        <% if (orderThis.isreceipts != 0 || orderThis.invoiceID != 0)
           { %>
        <ul class="order-info-ul clearfix">
            <li>发票地址：<%= thisInvo.InvoiceAdress %></li>
            <li>发票抬头：<%= thisInvo.InvoiceHead %></li>
            <li>发票类型：<%= (Model.Enume.InvoiceType)thisInvo.InvoiceType %></li>
            <li>邮政编码：<%= thisInvo.InvoiceZipCode %></li>
            <li>发票种类：<%= (Model.Enume.InvoiceClass)thisInvo.InvoiceClass%></li>
            <li>发票状态:
                <%= (Model.Enume.InvoiceStatus)orderThis.invoiceStatus%></li>
        </ul>
        <% }
           else
           { %>
        未索要
        <%} %>
    </div>
    <% if (orderThis.orderStatusID == 6 || orderThis.orderStatusID == 9)
       {%>
    <h3 class="per-line-til">
        二次支付费用详情
    </h3>
    <div class="per-line-bg">
        <ul class="order-info-ul clearfix">
            <li>服务总时长：<%=Convert.ToInt32(orderThis.UseTime / 60).ToString("0")%>小时<%=(orderThis.UseTime % 60).ToString("0")%>分</li>
            <li>服务总里程：<%=orderThis.UseKm %></li>
            <li>超小时数：<%=orderExt.overMinut/60%>小时<%=orderExt.overMinut%60%>分</li>
            <li>超时费用：<%=orderExt.overMinutMoney %>元</li>
            <li>超公里数：<%=orderExt.overKM %>公里</li>
            <li>超公里费用：<%=orderExt.overKMMoney %>元</li>
            <li>高速费：<%=orderExt.highwayMoney %>元</li>
            <li>停车费：<%=orderExt.carStopMoney %>元</li>
            <li>机场费：<%=orderExt.airportMoney %>元</li>
            <%
                if (orderExt.emptyCarMoney > 0)
                { %>
                      <li>空驶费：<%= orderExt.emptyCarMoney %>元</li>
              <% }
                else
                {%>
                      <li>上车空驶费：<%= orderExt.DriverStartEmptyFee %>元</li>
                        <li>下车空驶费：<%= orderExt.DriverEndEmptyFee %>元</li>
              <%  }
                 %>
            <li>其它费用：<%=orderExt.OtherFee %>元</li>
            <li>其他费用说明：<%=orderExt.OtherFeeRemark %></li>
        </ul>
    </div>
    <%} %>
    <h3 class="per-line-til">
        费用信息
    </h3>
    <div class="per-line-bg">
        <ul class="order-info-ul clearfix">
            <li>预付费用：
                <%if (cancel == null)
                  { %>
                <%=orderThis.orderStatusID == 1 ? "0" : orderThis.orderMoney.ToString()%>元<%}
                  else
                  {
                      if (cancel.OrderState == "等待确认")
                      {
                          Response.Write("0元");
                      }
                      else
                      {
                          Response.Write(orderThis.orderMoney + "元");
                      }
                  } %></li>
            <%if (couponThis != null)
              { %>
            <li>优惠券名称：<%=couponThis.Name %></li>
            <li>优惠金额：<%=couponThis.Cost %></li>
            <%}
              else
              { %>
            <li>使用优惠券：无</li>
            <%} %>
            <li>二次支付费用：<%=(orderThis.orderStatusID == 6 || orderThis.orderStatusID == 9) ? orderThis.unpaidMoney.ToString() : "0"%>元</li>
            <%if (vouchers != null)
              {
            %>
            <li>使用代金券：<%=vouchers.Cost%>
                元</li>
            <%
              }else
                {%>
            <li>使用代金券：无</li>
            <%} %>
            <li style="width: 500px;">总费用：<%=(orderThis.orderStatusID > 1) ? orderThis.totalMoney.ToString() : "0"%>元
            </li>
        </ul>
        <% if (canPay == 0)
           {%>
        <p>
            付款状态：预支付完成</p>
        <%} if (canPay == 1)
           { %>
        应付金额：<%=  orderThis.orderMoney%>元
        <form action="../payorder.aspx" method="post" target="_self">
        <input type="hidden" name="orderId" value="<%= orderThis.orderId %>" />
        <% if (orderThis.orderStatusID == 1)
           { %>
        <input class="yc-btn bank-btn per-button-border" type="submit" value="去付款" />
        <% } %>
        </form>
        <% } if (canPay == 2)
           { %>
        <p>
            付款状态：超过最后支付期限，请重新下单</p>
        <% } if (canPay == 3)
           { %>
        <p>
            付款状态：您已被集团管理员限制订车</p>
        <% } if (canPay == 4)
           { %>
        <input class="yc-btn bank-btn per-button-border" type="submit" value="二次付款" onclick="SecontPay()" />
        <% } if (canPay == 5)
           { %>
        <p>
            付款状态：服务已取消</p>
        <% } if (canPay == 6)
           { %>
        <p>
            付款状态：支付完成</p>
        <%}
           if (canPay == 7)
           {%>
        <p>
            订单状态：服务中</p>
        <%} %>
    </div>
    <%
        if (cancel != null)
        {%>
    <h3 class="per-line-til">
        服务取消信息
    </h3>
    <div class="per-line-bg">
        <ul class="order-info-ul clearfix">
            <li>取消时间：
                <%=cancel.CancelTime %></li>
            <li>取消时状态：<%=cancel.OrderState %></li>
            <li>扣除金额：<%=cancel.DeductMoney %>元</li>
            <li>扣费说明：<%=cancel.Remark == "" ? "无扣费" : cancel.Remark%></li>
        </ul>
    </div>
    <%}
    %>
    <div id="goOrderDiv">
        <div id="zhezhao">
        </div>
        <div id="orderForm">
            <table class="order_tb" cellpadding="0" cellspacing="0" border="0" id="orderFormTable">
                <tr class="order_tr">
                    <td colspan="4">
                        司机详细信息
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>姓名</em>
                    </td>
                    <td>
                        <%=driverInfo.Name %>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>工号</em>
                    </td>
                    <td>
                        <%=driverInfo.JobNumber %>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>驾龄</em>
                    </td>
                    <td>
                        <%=driverInfo.GetLicenseDay==null?0:Math.Ceiling(Convert.ToDouble((DateTime.Now-driverInfo.GetLicenseDay.Value).Days)/365)%> 年


                    </td>
                </tr>
                <tr id="order_useHour">
                    <td>
                        <em>接单总数</em>
                    </td>
                    <td>
                        <%=driverDt.Rows[0]["orderNum"] ?? ""%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>完成订单总数</em>
                    </td>
                    <td>
                        <%=driverDt.Rows[0]["servNum"]??""%>
                    </td>
                </tr>
    
            </table>
            <br />
            <a href="javascript:cancelDriver()" class="person-button" style="margin-left: 115px;">
                <em style="width: 100px; text-align: center;">关闭</em></a>
        </div>
    </div>
</asp:Content>
