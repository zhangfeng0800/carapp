<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyAppraise.aspx.cs" Inherits="WebApp.PCenter.MyAppraise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
//        $(document).ready(function () {
//            if (GetQueryString("Remarked") == "True")
//                $("#A_Remark1").addClass("per-order-active");
//            else
//                $("#A_Remark0").addClass("per-order-active");
//            $("#A_Remark0").click(function () {
//                window.location.href = QSRBU("Remarked", "False", QSR("Previous", "0"));
//            });
//            $("#A_Remark1").click(function () {
//                window.location.href = QSRBU("Remarked", "True", QSR("Previous", "0"));
//            });
//        });

        function GetPagelist(where) {
            var type = $("#type").val();
            var pageSize = 10;
            var pageIndex = parseInt($("#curpage").val());
            var totalpage = parseInt($("#total").html());
            switch (where) {
                case "first":
                    pageIndex = 0;
                    break;
                case "pre":
                    if (pageIndex > 1)
                        pageIndex = pageIndex - 2;
                    else
                        return;
                    break;
                case "next":
                    if (pageIndex < totalpage)
                        pageIndex = pageIndex;
                    else
                        return;
                    break;
                case "last":
                    pageIndex = totalpage - 1;
                    break;
                default:
                    pageIndex = parseInt(where);
                    break;
            }

            if (type == "true") {
                $("#A_Remark1").addClass("per-order-active");
                $("#A_Remark0").removeClass("per-order-active");
            }
            else {
                $("#A_Remark0").addClass("per-order-active");
                $("#A_Remark1").removeClass("per-order-active");
            }
            $.ajax({
                url: "MyAppraise.aspx",
                data: { pageIndex: pageIndex, Remarked: type },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.status == 1) {
                        var list = data.data;
                        var rowCount = data.rowCount;
                        var html = " <tr class='order_tr'><td>订单号 </td><td>乘车人</td><td>用车方式</td><td>所选车型</td><td>上车时间</td><td>下单时间</td><td>操作</td></tr>";
                        for (i = 0; i < list.length; i++) {
                            if (list[i].departureTime.indexOf("T") != -1) {
                                list[i].departureTime = list[i].departureTime.replace(/T/gi, " ");
                            }
                            if (list[i].orderDate.indexOf("T") != -1) {
                                list[i].orderDate = list[i].orderDate.replace(/T/gi," ");
                            }
                            html += "<tr><td>" + list[i].orderId + "</td><td>" + list[i].passengerName + "</td><td>" + list[i].caruseway + "</td><td>" + list[i].cartype + "</td><td>" +
                            list[i].departureTime + "</td><td>" + list[i].orderDate + "</td>";
                            if (where == "true")
                                html += "<td><a href='MyRemark.aspx?orderid=" + list[i].orderId + "'>修改</a></td></tr>";
                            else
                                html += "<td><a href='MyRemark.aspx?orderid=" + list[i].orderId + "'>评价</a></td></tr>";
                        }
                        $("#aplist").html(html);
                        $("#curpage").val(pageIndex + 1);
                        if (rowCount / pageSize > parseInt(rowCount / pageSize))
                            $("#total").html(parseInt(rowCount / pageSize) + 1);
                        else
                            $("#total").html(parseInt(rowCount / pageSize));
                        $("#acList").html(html);
                        if (rowCount > pageSize)
                            $("#pager").show();
                        else {
                            $("#pager").hide();
                        }
                    }
                },
                error: function () {
                    alert("error");
                }
            })
        }
        function GoPage() {
            var pageIndex = $("#curpage").val();
            var totalpage = parseInt($("#total").html());
            if (pageIndex < 1 || pageIndex > totalpage) {
                alert("对不起，页码超出范围！");
                return;
            }
            else
                GetPagelist(pageIndex - 1);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <div class="right_section">
                <h3 class="per-order-til">
                    订单评价</h3>
                <div class="per_bg">
                  <div class="person-tab-order">
                    <a  style="width:88px; text-align:center; cursor:pointer;" class="per-order-active" onclick="javascript:$('#type').val('false');GetPagelist(0)" id="A_Remark0">待评价订单</a>
                    <a  style="width:88px; text-align:center; cursor:pointer;" onclick="javascript:$('#type').val('true');GetPagelist(0)"  id="A_Remark1">已评价订单</a>
                    <input id="type" style=" display:none;" />
                </div>
                    <div class="dingdan_tb" id="waitAppraise">
                        <table class="order_tb" cellpadding="0" cellspacing="0" border="0" id="aplist">
                            <tr class="order_tr">
                                <td>订单号 </td>
                                <td>乘车人 </td>
                                <td>用车方式 </td>
                                <td>所选车型 </td>
                                <td>上车时间 </td>
                                <td>下单时间 </td>
                                <td>操作 </td>
                            </tr>
                            <tbody id="waitAppraiseBody">
                                <%for(int i=0,max=orderList.Count;i<max;i++){ %>
                                <tr>
                                    <td><%=orderList[i].orderId %></td>
                                    <td><%=orderList[i].passengerName %></td>
                                    <td><%=new BLL.CarUseWayBLL().GetUseName(new BLL.RentCarBLL().GetModel(orderList[i].rentCarID).carusewayID)%></td>
                                    <td><%=new BLL.CarTypeBLL().GetCarType(new BLL.RentCarBLL().GetModel(orderList[i].rentCarID).carTypeID) %></td>
                                    <td><%=orderList[i].departureTime.ToString("yyyy-MM-dd HH-mm")%></td>
                                    <td><%=orderList[i].orderDate.ToString("yyyy-MM-dd HH-mm") %></td>
                                    <td><a href="MyRemark.aspx?orderid=<%=orderList[i].orderId%>"><%=Request.QueryString["Remarked"] == "True" ? "修改" : "评价"%></a></td>
                                </tr>
                                <%} %>
                            </tbody>
                        </table>
                         <div id="pager" style="text-align:center; <%if(totalPage<=1){%> display:none;<% }%>  ">
        <a style="cursor:pointer;" onclick="GetPagelist('first')">首页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPagelist('pre')">上一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPagelist('next')">下一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPagelist('last')">末页</a>&nbsp;&nbsp;

        当前页：<input id="curpage" style="width:20px;" value="1" onkeyup="value=value.replace(/\D/g,'')" /><button type="button" onclick="GoPage()">跳</button> &nbsp;&nbsp;&nbsp;&nbsp;共<span id="total"><%=totalPage%></span>页
        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
