<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyCoupon.aspx.cs" Inherits="WebApp.PCenter.MyCoupon" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".person-tab-order a").click(function () {
                //                var UrlStr = "";
                //                switch ($(this).index()) {
                //                    case 1:
                //                        UrlStr = QSR("Status", "1");
                //                        break;
                //                    case 2:
                //                        UrlStr = QSR("Status", "2");
                //                        break;
                //                    default:
                //                        UrlStr = QSR("Status", "0");
                //                        break;
                //                }
                //                UrlStr = QSRBU("Previous", 0, UrlStr);
                //                window.location.href = UrlStr;
                $("#type").val($(this).index());
                GetPageList(1);

            });
            //PageReady();
        });

        function PageReady() {
            var status = 0;
            switch (GetQueryString('status')) {
                case "0":
                    status = 0;
                    break;
                case "1":
                    status = 1;
                    break;
                case "2":
                    status = 2;
                    break;
                default:
                    break;
            }
            $(".person-tab-order a").each(function () {
                if ($(this).index() == status) {
                    $(this).addClass("per-order-active");
                } else {
                    $(this).removeClass("per-order-active");
                }
            });
        }

        function GetPageList(where) {
            var status = $("#type").val();
            $(".person-tab-order a").each(function () {
                if ($(this).index() == status) {
                    $(this).addClass("per-order-active");
                } else {
                    $(this).removeClass("per-order-active");
                }
            });

            var pageSize = 10;
            var pageIndex = parseInt($("#curpage").val());
            var totalpage = parseInt($("#total").html());
            switch (where) {
                case "first":
                    pageIndex = 1;
                    break;
                case "pre":
                    if (pageIndex > 1)
                        pageIndex = pageIndex - 1;
                    else
                        return;
                    break;
                case "next":
                    if (pageIndex < totalpage)
                        pageIndex = pageIndex+1;
                    else
                        return;
                    break;
                case "last":
                    pageIndex = totalpage;
                    break;
                default:
                    pageIndex = parseInt(where);
                    break;
            }

            $.ajax({
                url: "MyCoupon.aspx",
                data: { pageIndex: pageIndex, status: status },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.status == 1) {
                        var list = data.data;
                        var rowCount = data.rowCount;
                        var html = " <tr class='order_tr'><td>序号</td><td>优惠券名称</td><td>面值</td><td>所需消费</td><td>生效日期</td><td>截止日期</td><td>状态</td></tr>";
                        for (i = 0; i < list.length; i++) {
                            if (list[i].Startdate.indexOf("T") != -1) {
                                list[i].Startdate = list[i].Startdate.replace(/T/gi, " ");
                            }
                            if (list[i].Deadline.indexOf("T") != -1) {
                                list[i].Deadline = list[i].Deadline.replace(/T/gi, " ");
                            }
                            html += "<tr><td>" + list[i].Id + "</td><td>" + list[i].Name + "</td><td>" + list[i].Cost + "</td><td>" + list[i].Restrictions + "</td><td>" + list[i].Startdate.substring(0, 10) + "</td><td>" + list[i].Deadline.substring(0, 19) + "</td>";
                            if (list[i].Status == "1")
                                html += "<td>已使用</td>";
                            else
                                html += "<td>未使用</td></tr>";
                        }
                        $("#couponlist").html(html);
                        $("#curpage").val(pageIndex);
                        if (rowCount / pageSize > parseInt(rowCount / pageSize))
                            $("#total").html(parseInt(rowCount / pageSize) + 1);
                        else
                            $("#total").html(parseInt(rowCount / pageSize));
                        if (rowCount > pageSize)
                            $("#pager").show();
                        else {
                            $("#pager").hide();
                        }
                    }
                    else {
                        alert(data.msg);
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        }
        function GoPage() {
            var pageIndex = $("#curpage").val();
            var totalpage = parseInt($("#total").html());
            if (pageIndex < 1 || pageIndex > totalpage) {
                alert("对不起，页码超出范围！");
                return;
            }
            else
                GetPageList(pageIndex);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="per-order-til">
        优惠券</h3>
    <div class="article clearfix">
        <a href="MyCouponGet.aspx" class="person-button"><em>兑换优惠券</em></a>
    </div>
    <div class="person-tab-order">
        <a style="width: 88px; text-align: center;" href="javascript:;" class="per-order-active">
            未使用</a> <a style="width: 88px; text-align: center;" href="javascript:;">已使用</a>
        <a style="width: 88px; text-align: center;" href="javascript:;">已过期</a>
        <input style="display: none;" id="type" value="0" />
    </div>
    <table id="couponlist" class="order_tb" cellpadding="0" cellspacing="0" border="0">
        <tr class="order_tr">
            <td>
                序号
            </td>
            <td>
                优惠券名称
            </td>
            <td>
                面值
            </td>
             <td>
                所需消费
            </td>
            <td>
                生效日期
            </td>
            <td>
                截止日期
            </td>
            <td>
                状态
            </td>
        </tr>
        <% for (int i = 0, max = CoupList.Count; i < max; i++)
           { %>
        <tr>
            <td>
                <%=CoupList[i].Id%>
            </td>
            <td>
                <%=CoupList[i].Name%>
            </td>
            <td>
                <%=CoupList[i].Cost%>
            </td>
          <td>
                <%=CoupList[i].Restrictions%>
            </td>
            <td>
                <%=CoupList[i].Startdate.ToString("yyyy-MM-dd")%>
            </td>
            <td>
                <%=CoupList[i].Deadline.ToString("yyyy-MM-dd")%>
            </td>
            <td>
                <%=CoupList[i].Status == 1?"已使用":"未使用"%>
            </td>
        </tr>
        <% } %>
    </table>
      <div id="pager" style="text-align:center; <%if(totalPage<=1){%> display:none;<% }%>  ">
        <a style="cursor:pointer;" onclick="GetPageList('first')">首页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPageList('pre')">上一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPageList('next')">下一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPageList('last')">末页</a>&nbsp;&nbsp;

        当前页：<input id="curpage" style="width:20px;" value="1" onkeyup="value=value.replace(/\D/g,'')" /><button type="button" onclick="GoPage()">跳</button> &nbsp;&nbsp;&nbsp;&nbsp;共<span id="total"><%=totalPage%></span>页
        </div>
</asp:Content>
