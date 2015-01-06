<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyRemark.aspx.cs" Inherits="WebApp.PCenter.MyRemark" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            if ($("#remarkContent").val() == "") {
                $("#remarkContent").val("请输入您的评论，最多200字");
                $("#remarkContent").css("color", "ccc");
            }
            $("#remarkContent").focus(function () {
                if ($("#remarkContent").val() == "请输入您的评论，最多200字")
                    $("#remarkContent").val("");
            });
            $("#remarkContent").blur(function () {
                if ($("#remarkContent").val() == "")
                    $("#remarkContent").val("请输入您的评论，最多200字");
            });
        });
        function submitRemark() {
            var remarkContent = $("#remarkContent").val();
            if (remarkContent.length > 200) {
                alert("您输入的评论内容过长（已输入" + remarkContent.length + "字，最多200字）");
                return false;
            }
            var orderID = '<%=Request.QueryString["orderId"] %>';
            $.post("/api/MyAppraise.ashx", {
                "action": "subRemark",
                "remarkContent": remarkContent,
                "score": ++indexStar,
                "orderid": orderID
            }, function (data) {
                if (data == "add") {
                    alert("添加成功");
                    window.location.href = "MyAppraise.aspx"
                }
                if (data == "update") {
                    alert("修改成功！");
                    window.location.href = "MyAppraise.aspx"
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="per-line-til order-name-top">
        <span class="order-name-style">
            <%=CUWB.GetUseName(Convert.ToInt32(RCB.GetUseWayById(orderThis.rentCarID)))%><!--（石家庄）--></span>
        <span class="order-name-style">订单编号：<%=orderThis.orderId %></span> <span class="order-name-style">
            订单状态：<%=(Common.OrderStatus)orderThis.orderStatusID%></span>
        <!--span class="order-name-style">付款状态：<%=orderThis.paystatus == Common.PayStatus.Paid ? "已付款" : "未付款"%></span-->
    </h3>
    <h3 class="per-line-til">
        订单信息
    </h3>
    <div class="per-line-bg">
        <ul class="order-info-ul clearfix">
            <li>乘车人：<%=orderThis.passengerName %></li>
            <li>乘车人数：<%=orderThis.passengerNum %>人</li>
            <li>联系电话：<%=orderThis.passengerPhone %></li>
            <li>服务留言：<%=orderThis.remarks %></li>
        </ul>
        <ul class="order-info-con">
            <li>用车方式：<%=carUseWayStr%></li>
            <li>预定车型：<%=carTypeStr %></li>
        </ul>
        <ul class="order-info-ul clearfix">
            <li>上车地点：<%=orderThis.startAddress %></li>
            <li>下车地点：<%=orderThis.arriveAddress %></li>
            <li>出发时间：<%=orderThis.departureTime.ToString("yyyy年MM月dd日 HH点mm分") %></li>
            <li>预计用车时长：<%=orderThis.useHour %>小时</li>
        </ul>
    </div>
    <h3 class="per-line-til">
        优惠券</h3>
    <div class="per-line-bg">
        <ul class="order-info-con">
            <!--li>结算账户：<%=new BLL.UserAccountBLL().GetMaster(orderThis.userID).Compname %></li-->
            <%if (couponThis != null)
              { %>
            <li>使用优惠券：<%=couponThis.Name %></li>
            <li>优惠金额：<%=couponThis.Cost %></li>
            <%}
              else
              { %>
            <li>使用优惠券：无</li>
            <%} %>
        </ul>
    </div>
    <h3 class="per-line-til">
        发票信息</h3>
    <div class="per-line-bg">
        <% if (orderThis.isreceipts != 0 && thisInvo!=null)
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
    <h3 class="per-line-til">
        二次支付费用详情
    </h3>
    <div class="per-line-bg">
        <ul class="order-info-ul clearfix">
            <li>服务总时长：<%=Convert.ToInt16(orderThis.UseTime/60)%>小时<%= orderThis.UseTime % 60%>分</li>
            <li>服务总里程：<%=orderThis.UseKm %></li>
            <li>超小时数：<%=orderExt.overMinut/60%>小时<%=orderExt.overMinut%60%>分</li>
            <li>超时费用：<%=orderExt.overMinutMoney %>元</li>
            <li>超公里数：<%=orderExt.overKM %>公里</li>
            <li>超公里费用：<%=orderExt.overKMMoney %>元</li>
            <li>高速费：<%=orderExt.highwayMoney %>元</li>
            <li>停车费：<%=orderExt.carStopMoney %>元</li>
            <li>机场费：<%=orderExt.airportMoney %>元</li>
            <li>空驶费：<%=orderExt.emptyCarMoney %>元</li>
        </ul>
    </div>
    <h3 class="per-line-til">
        费用信息
    </h3>
    <div class="per-line-bg">
        <ul class="order-info-ul clearfix">
            <li>预付费用：<%=orderThis.orderMoney%>元</li>
            <li>二次支付费用：<%=orderThis.unpaidMoney%>元</li>
            <li>总费用：<%=orderThis.totalMoney%>元</li>
        </ul>
    </div>
    <h3 class="per-line-til">
        评论这次服务
    </h3>
    <div class="per-line-bg">
        <style type="text/css">
            .Div_Score
            {
                width: 300px;
                height: 30px;
                display: block;
                margin: 10px;
            }
            .Div_Score ul
            {
                width: 120px;
                height: 19px;
                padding: 0px;
                margin: 0px;
                float: left;
            }
            .Div_Score ul li
            {
                width: 19px;
                height: 19px;
                float: left;
                margin: 5px 5px 0px 0px;
                padding: 0px;
                background: url("../images/score0.png") no-repeat;
            }
            .Div_Score ul li a
            {
                width: 19px;
                height: 19px;
                display: block;
            }
            .Span_Hint
            {
                width: 100px;
                height: 28px;
                margin-left: 10px;
                display: block;
                border: 1px solid #ffdfb6;
                background: #ffecd3;
                float: left;
                color: #f90;
                font: 12px/28px 'Verdana' , '宋体';
                text-indent: 8px;
            }
        </style>
        <script type="text/javascript">
            var indexStar = <%=remarkContent.Score-1 %>;
            $(document).ready(function () {
                ChangeBgImg(indexStar);
                $(".A_Score").click(function () {
                });
                $(".Div_Score ul li").click(function () {
                    indexStar = $(this).index();
                });
                $(".Div_Score ul li").mouseover(function () {
                    ChangeBgImg($(this).index());
                });
                $(".Div_Score ul li").mouseout(function () {
                    ChangeBgImg(indexStar);
                });
            });
            function ChangeBgImg(index) {
                for (var i = 0; i < 5; i++) {
                    if (i <= index)
                        $(".Div_Score ul li a").eq(i).css("background-image", "url(../images/score" + (index < 2 ? "12" : "345") + ".png)");
                    else
                        $(".Div_Score ul li a").eq(i).css("background-image", "none");
                }
                switch (index) {
                    case 0:
                        $(".Span_Hint").text("很不满意");
                        break;
                    case 1:
                        $(".Span_Hint").text("不满意");
                        break;
                    case 2:
                        $(".Span_Hint").text("一般");
                        break;
                    case 3:
                        $(".Span_Hint").text("满意");
                        break;
                    case 4:
                        $(".Span_Hint").text("很满意");
                        break;
                }
            }
        </script>
        <div class="Div_Score">
            <ul>
                <li><a href="javascript:;"></a></li>
                <li><a href="javascript:;"></a></li>
                <li><a href="javascript:;"></a></li>
                <li><a href="javascript:;"></a></li>
                <li><a href="javascript:;"></a></li>
            </ul>
            <span class="Span_Hint"></span>
        </div>
        <textarea style="max-height: 200px; max-width: 80%; min-height: 150px; min-width: 80%;
            margin-bottom: 10px; border: 1px solid #ccc;" id="remarkContent"><%=Common.Tool.GetString(remarkContent.Content) %></textarea>
        <input class="yc-btn bank-btn per-button-border" type="button" value="提交评论" onclick="submitRemark()" />
    </div>
</asp:Content>
