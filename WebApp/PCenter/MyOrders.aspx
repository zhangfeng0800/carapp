<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyOrders.aspx.cs" Inherits="WebApp.PCenter.MyOrders" EnableSessionState="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/MySite.js" type="text/javascript"></script>
    <script src="../Scripts/SelectDate.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#status").val("all");
            Pager(1, 10, $("#Text_DateLL").val(), $("#Text_DateUL").val(), "all");
            $("#Button_Query").click(function () {
                if (!compareTime($("#Text_DateLL").val(), $("#Text_DateUL").val())) {
                    alert("开始时间应小于结束时间");
                    return;
                }
                if ($("#Text_DateLL").val() == "" || $("#Text_DateUL").val() == "") {
                    alert("请输入时间!");
                    return;
                }
                $("#txtstarttime").val($("#Text_DateLL").val());
                $("#txtendtime").val($("#Text_DateUL").val());
                Pager(1, 10, $("#txtstarttime").val(), $("#txtendtime").val(), "all");
                $(".person-tab-order a").each(function () {
                    if (($(this).index() == 7 ? 9 : $(this).index()) == status) {
                        $(this).addClass("per-order-active");
                    } else {
                        $(this).removeClass("per-order-active");
                    }
                });

            });
            $(".A_Cancel").click(function () {

            });

        });
        function cancelOrder(orderid) {
            if (!confirm("确定要取消这笔订单？取消订单超过5次当天不可下单哦！")) {
                return false;
            }
            $.post("MyOrders.aspx", { Action: "Cancel", OrderId: orderid.toString() },
            function (data) {
                if (data.Message == "Complete") {
                    alert("取消成功！");
                    Pager($("#currentpage").val(), 10, $("#txtstarttime").val(), $("#txtendtime").val(), $("#txtstatus").val());
                } else {
                    alert(data.Message);
                }
            });
        }
        function PageReady() {
            if (GetQueryString("DateLL") != "0") {
                $("#Text_DateLL").val(GetQueryString("DateLL"));
            }
            if (GetQueryString("DateUL") != "0") {
                $("#Text_DateUL").val(GetQueryString("DateUL"));
            }
            var status = parseInt(GetQueryString('Status'));
            if (isNaN(status)) {
                status = 0;
            }
            $(".person-tab-order a").each(function () {
                if (($(this).index() == 7 ? 9 : $(this).index()) == status) {
                    $(this).addClass("per-order-active");
                } else {
                    $(this).removeClass("per-order-active");
                }
            });
        }
        function compareTime(a, b) {
            var arr = a.split("-");
            var starttime = new Date(arr[0], arr[1], arr[2]);
            var starttimes = starttime.getTime();

            var arrs = b.split("-");
            var lktime = new Date(arrs[0], arrs[1], arrs[2]);
            var lktimes = lktime.getTime();
            if (starttimes > lktimes) {
                return false;
            } else {
                return true;
            }
        } 
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="article article-padding">
        <h3 class="per-order-til">
            订单查询</h3>
        <div class="per-order-bg">
            预定时间：
            <input id="Text_DateLL" class="Input_TM W_S H_XXS" type="text" onclick="fPopCalendar(event,this,this)"
                onfocus="this.select()" readonly="readonly" />
            <input type="hidden" id="txtstarttime" />
            至
            <input id="Text_DateUL" class="Input_TM W_S H_XXS" type="text" onclick="fPopCalendar(event,this,this)"
                onfocus="this.select()" readonly="readonly" />
            <input type="hidden" id="txtendtime" />
            <%-- 人员：
            <select id="Select_Member">
                <% for (int i = 0, max = UserList.Count; i < max; i++)
                   { %>
                <option value="<%=UserList[i].Id%>">
                    <%=UserList[i].Compname%></option>
                <% } %>
            </select>--%>
            <script type="text/javascript">                SetSelectValue('Select_Member', GetQueryString('UserId'))</script>
            <input class="per-btn-chaxun" type="button" value="查询" id="Button_Query" />
            <input class="per-btn-chaxun" type="button" value="打印详情" onclick="print()" />
        </div>
    </div>
    <div class="P_Hint">
        <em>友情提示：</em>如果您因自身原因取消已派车的订单，会视情况产生手续费。<a href="javascript:;" id="A_ShowRule">查看扣费规则</a><br />
        <div style="display:none;">
         <%foreach (var chargeModel in charges)
                {
                    if (!string.IsNullOrEmpty(chargeModel.Description))
                    {
                          Response.Write(chargeModel.Description);
                    }
                  
                } %>
        <a href="javascript:;" id="A_HiddenRule">收起</a></div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#A_ShowRule").click(function () {
                $(this).hide();
                $(".P_Hint div").show();
                $(".P_Hint span").show();
            });
            $("#A_HiddenRule").click(function () {
                $("#A_ShowRule").show();
                $(".P_Hint div").hide();
            });
            $("#firstpge").click(function () {
                Pager(1, 10, $("#txtstarttime").val(), $("#txtendtime").val(), $("#txtstatus").val());
            });
            $("#lastpage").click(function () {
                Pager($("#totalpage").val(), 10, $("#txtstarttime").val(), $("#txtendtime").val(), $("#txtstatus").val());
            });
            $("#prepage").click(function () {
                Pager(parseInt($("#currentpage").val()) - 1, 10, $("#txtstarttime").val(), $("#txtendtime").val(), $("#txtstatus").val());
            });
            $("#nextpage").click(function () {
                Pager(parseInt($("#currentpage").val()) + 1, 10, $("#txtstarttime").val(), $("#txtendtime").val(), $("#txtstatus").val());
            });
        });
        function getusetime(time) {
            if (time) {
                return time;
            } else {
                return "";
            }
        }
        function Pager(pageIndex, pageSize, startDate, endDate, status) {
            $("#txtstatus").val(status);
            $.ajax({
                url: "/api/myorderhandler.ashx",
                type: "post",
                data: { startDate: startDate, endDate: endDate, pageIndex: pageIndex, pageSize: pageSize, status: status },
                success: function (data) {
                    if (data.resultcode == 0) {
                        alert(data.msg);
                        return;
                    }
                    $("#container").html("");
                    var html = " <tr class=\"order_tr\"><td>订单号</td><td>乘车人数</td><td>下单时间</td><td>上车时间</td><td>用车方式</td><td>订单状态</td><td>操作</td></tr>";
                    $.each(data.data.rows, function (index, val) {

                        html += "<tr>";
                        html += " <td>" + val.orderId + "</td>";
                        html += " <td>" + val.passengerNum + "</td>";
                        html += " <td>" + val.orderDate.replace("T", " ") + "</td>";
                        html += " <td>" + val.departureTime.replace("T", " ") + "</td>";
                        html += " <td>" + val.caruseway + "</td>";

                        html += " <td>" + getOrderStatus(val.orderStatusID) + "</td>";
                        html += " <td><a href=\"MyOrdersInfo.aspx?OrderId=" + val.orderId + "\" title=\"查看详情\">查看</a>&nbsp";

                        if (val.orderStatusID == 1 || val.orderStatusID == 2 || val.orderStatusID == 7 || val.orderStatusID == 8 || val.orderStatusID == 10 || val.orderStatusID == 11 || val.orderStatusID == 12 || val.orderStatusID == 99) {
                            html += "  <a href=\"javascript:;\" class=\"A_Cancel\" title=\"取消订单\" onclick=\"cancelOrder('" + val.orderId + "')\">取消</a>";
                        }
                        html += "</td>";
                    });
                    $("#container").html(html);
                    if (data.data.total == 0) {
                        $("#pager").hide();
                    }
                    else if (data.data.total <= pageSize) {
                        $("#pager").hide();
                    }
                    else if (pageIndex == "1") {
                        $("#pager").show();
                        $("#firstpge").hide();
                        $("#nextpage").show();
                        $("#prepage").hide();
                        $("#lastpage").show();
                    } else if ($("#totalpage").val() == pageIndex) {
                        $("#pager").show();
                        $("#firstpge").show();
                        $("#nextpage").hide();
                        $("#prepage").show();
                        $("#lastpage").hide();
                    }
                    else {
                        $("#pager").show();
                        $("#firstpge").show();
                        $("#nextpage").show();
                        $("#prepage").show();
                        $("#lastpage").show();
                    }
                    $("#currentpage").val(pageIndex);
                    $("#totalpage").val(parseInt(data.data.total / pageSize) + 1);
                }

            });
            if (status == "all") {
                $(".person-tab-order a").each(function () {
                    $(this).removeClass("per-order-active");
                });
                $(".person-tab-order a:eq(0)").addClass("per-order-active");
            } else {
                $(".person-tab-order a").each(function () {
                    if (($(this).index() == 7 ? 9 : $(this).index()) == status) {
                        $(this).addClass("per-order-active");
                    } else {
                        $(this).removeClass("per-order-active");
                    }
                });
            }

        }

        function getOrderStatus(statusid) {
            switch (statusid) {
                case 1:
                    return "等待确认";
                case 2:
                    return "等待服务";
                case 3:
                    return "服务中";
                case 4:
                    return "服务结束";
                case 5:
                    return "服务取消";
                case 6:
                    return "订单完成";
                case 7:
                    return "司机等待";
                case 8:
                    return "等待派车";
                case 9:
                    return "二次付款";
                case 10:
                    return "司机已经出发";
                case 11:
                    return "司机已经就位";

                case 12:
                    return "订单已经接取";
                default:
                    return "订单过期";
            }
        }
    </script>
    <div class="article article-padding per-border-none" style="margin-top: 10px;">
        <h3 class="per-til-h3">
            最新订单</h3>
        <div class="person-tab-order">
            <a style="width: 60px; text-align: center;" href="javascript:;" class="per-order-active"
                onclick="Pager(1,10,$('#txtstarttime').val(),$('#txtendtime').val(),'all')">全部
            </a><a style="width: 60px; text-align: center;" href="javascript:;" onclick="Pager(1,10,$('#txtstarttime').val(),$('#txtendtime').val(),'1')">
                等待确认 </a><a style="width: 60px; text-align: center;" href="javascript:;" onclick="Pager(1,10,$('#txtstarttime').val(),$('#txtendtime').val(),'2')">
                    等待服务 </a><a style="width: 60px; text-align: center;" href="javascript:;" onclick="Pager(1,10,$('#txtstarttime').val(),$('#txtendtime').val(),'3')">
                        服务中 </a><a style="width: 60px; text-align: center;" href="javascript:;" onclick="Pager(1,10,$('#txtstarttime').val(),$('#txtendtime').val(),'4')">
                            服务结束 </a><a style="width: 60px; text-align: center;" href="javascript:;" onclick="Pager(1,10,$('#txtstarttime').val(),$('#txtendtime').val(),'5')">
                                服务取消 </a><a style="width: 60px; text-align: center;" href="javascript:;" onclick="Pager(1,10,$('#txtstarttime').val(),$('#txtendtime').val(),'6')">
                                    订单完成 </a><a style="width: 60px; text-align: center;" href="javascript:;" onclick="Pager(1,10,$('#txtstarttime').val(),$('#txtendtime').val(),'9')">
                                        二次付款 </a>
        </div>
        <table class="order_tb" cellpadding="0" cellspacing="0" border="0" id="container">
        </table>
        <div style="text-align: center; margin-top: 20px;" id="pager">
            <a href="javascript:;" style="margin: 0 10px;" id="firstpge">第一页</a><a href="javascript:;"
                style="margin: 0 10px;" id="prepage">上一页</a> <a href="javascript:;" style="margin: 0 10px;"
                    id="nextpage">下一页</a> <a href="javascript:;" style="margin: 0 10px;" id="lastpage">最后一页</a>
            当前第<input type="text" id="currentpage" readonly="readonly" style="border: 0; width: 30px;
                text-align: center;" />页 总共
            <input type="text" id="totalpage" readonly="readonly" style="border: 0; width: 30px;
                text-align: center;" />页
            <input type="hidden" id="txtstatus" readonly="readonly" />
        </div>
        <%--  <script type="text/javascript">PageSet(20, <%=MaxCount %>);</script>--%>
    </div>
</asp:Content>
