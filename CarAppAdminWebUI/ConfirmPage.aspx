<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfirmPage.aspx.cs" Inherits="CarAppAdminWebUI.ConfirmPage" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="BLL" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Static/scripts/jquery.min.js" type="text/javascript"></script>
    <link href="Static/styles/admin.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <script>
        function submitOrder(orderid, couponid,voucherid) {
            if (!confirm("确认提交支付吗？")) {
                return;
            }
            $.ajax({
                url: "/ajax/payfororder.ashx",
                data: { orderid: orderid, couponid: couponid,voucherid:voucherid,ordernum:<%=ordercount %>, querystring: '<%=Request.QueryString["querystring"] %>' },
                type: "post",
                success: function (data) {
                    if (data.resultcode == 0) {
                        alert(data.msg);
                    } else {
                        alert(data.msg);
                        window.location.href = "/layer.aspx?telphone=" + data.location;
                    }
                },
                beforeSend: function () {
                    $("#btnsubmit").attr("disabled", "disabled");
                    $("#btnsubmit").text("提交中...");
                },
                complete: function() {
                    $("#btnsubmit").removeAttr("disabled");
                    $("#btnsubmit").text("确认付款");
                }
            });
        }
        function redirect() {
            window.location.href = "/Layer.aspx?telphone=<%=querystring %>";
        }

        function changeMoneyVouchers() {
            var voucherval = $("#voucherlist").val();
            var couponval = $("#couponlist").val();
            if (voucherval != "") {
                $("#couponlist").attr("disabled", "disabled");
            } else {
               $("#couponlist").removeAttr("disabled");
            }
            if (couponval != "") {
                $("#voucherlist").attr("disabled", "disabled");
            } else {
               $("#voucherlist").removeAttr("disabled");
            }
        }

        $(function() {
            $.ajax({
                url:"/car/rentcarhandler.ashx?id=<%=orderid %>&action=predict",
             dataType:'json',
                success:function(data) {
                    $("#predictmoney").html(data.result+"元");
                    $("#totalkm").html(data.km+"公里");
                    $("#totalminute").html(data.hour+"分钟");
                },
                beforeSend:function() {
                    $("#predictmoney").html("加载中");
                }
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="adm_20" style="width: 100%; margin-top: 20px;">
        <h2 style="margin: 10px;">
            用车方式</h2>
        <hr />
        <div style="padding: 5px; font-size: 14px;">
            <span>用车方式：</span><%=CarUseway %>
            <%
                if (_rentModel.carusewayID == 6)
                {
                    Response.Write(_rentModel.IsOneWay==1?"（单程）":"（往返）");
                }
                 %>
            </div>
        <% if (ismutil)
           {%>
        <div style="padding: 5px; font-size: 14px;">
            <span>订单数量：</span><%=ordercount %></div>
        <%  }
        %>
        <div style="padding: 5px; font-size: 14px;">
            <span>出发城市：</span><%=GetStartCityInfo(OrderModel.rentCarID) %></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>出发地点：</span><%=GetStartAddress(OrderModel.rentCarID) %></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>目的城市：</span><%=GetTargetCityInfo(orderid)%></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>目的地点：</span><%=GetEndAddress(OrderModel.rentCarID) %></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>出发时间：</span><%=OrderModel.departureTime.ToString("yyyy-MM-dd HH:mm:ss") %></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>乘车人：</span><%=OrderModel.passengerName %></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>联系电话：</span><%=OrderModel.passengerPhone %></div>
        <h2 style="margin: 10px;">
            车型信息</h2>
        <hr />
        <% if (_rentModel != null)
           {%>
        <div style="padding: 5px; font-size: 14px;">
            <span>车型：</span><%=GetCarType(_rentModel.carTypeID) %></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>乘车人数：</span><%=OrderModel.passengerNum %></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>消费金额：</span><%=OrderModel.orderMoney %>元
            <%
               if (ismutil)
               {
                   Response.Write("*" + ordercount.ToString() + "=" + ordercount * OrderModel.orderMoney + "元");
               }
            %>
        </div>
        <div style="padding: 5px; font-size: 14px;">
            <span>费用包含：</span><%=_rentModel.feeIncludes %></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>超分钟：</span><%=_rentModel.hourPrice %>元/分钟</div>
        <div style="padding: 5px; font-size: 14px;">
            <span>超里程：</span><%=_rentModel.kiloPrice %>元/公里
        </div>
        <%} %>
        <h2 style="margin: 10px;">
            结算信息<span style="color: red; font-size: 12px;">(优惠券代金券只能使用一种)</span></h2>
        <hr />
        <div style="padding: 5px; font-size: 14px;">
            <span>结算账户：</span><%=UserName%></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>预估总费用：</span><span id="predictmoney"></span>
           <ul>
               <li>预计总里程：<span id="totalkm"></span></li>
                 <li>预计总时间：<span id="totalminute"></span></li>
           </ul></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>优惠券：</span><select id="couponlist" onchange="changeMoneyVouchers()">
                <option value="">请选择</option>
                <%
                    foreach (var coupon in CouponList.Where(p => p.Startdate.Date <= DateTime.Now.Date && p.Deadline.Date>= DateTime.Now.Date && p.Status == 0 && p.Restrictions <= OrderModel.orderMoney))
                    {%>
                <option value='<%=coupon.Id %>'>
                    <%=coupon.Name %>(<%=coupon.Cost %>)</option>
                <%}
                %>
            </select></div>
        <div style="padding: 5px; font-size: 14px;">
            <span>代金券：</span><select id="voucherlist" onchange="changeMoneyVouchers()">
                <option value="">请选择</option>
                <%
                    foreach (DataRow dr in dt.Rows)
                    {%>
                <option value='<%=dr["id"].ToString() %>'>
                    <%=dr["cost"].ToString() %>元(<%=dr["num"].ToString() %>张)</option>
                <%}
                %>
            </select></div>
        <div style="text-align: center; margin-top: 50px;">
            <button type="button" onclick="submitOrder('<%=OrderModel.orderId %>',$('#couponlist').val(),$('#voucherlist').val())"
                class="reg_btn" style="text-align: center; display: inline;" id="btnsubmit">
                确认付款</button>
            <button type="button" class="reg_btn" style="text-align: center; display: inline;"
                onclick="redirect()">
                返回</button>
        </div>
    </div>
    </form>
</body>
</html>
