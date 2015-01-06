<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyInvoiceForAsked.aspx.cs" Inherits="WebApp.PCenter.MyInvoiceForAsked" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../pageControl/src/kkpager.min.js" type="text/javascript"></script>
    <link href="../pageControl/src/kkpager.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            kkpager.generPageHtml({
                pno: 1, //当前页码
                total: $("#kkpager_pageCount").val(), //总页码
                totalRecords: $("#kkpager_recordCount").val(), //总数据条数
                mode: 'click', //默认值是link，可选link或者click
                click: function (n) {
                    var resultHtml = "";
                    $.post("myinvoiceforasked.aspx", { "pageIndex": n }, function (data) {
                        for (var i = 0; i < data.length; i++) {
                            resultHtml += "<tr><td> <a href=\"/PCenter/MyOrdersInfo.aspx?OrderId=" + data[i].orderId + "\">" + data[i].orderId + "</a></td>";
                            resultHtml += "<td>" + (data[i].orderMoney + data[i].unpaidMoney).toFixed(2) + "</td>";
                            resultHtml += "<td>" + data[i].invoiceHead + "</td>";
                            resultHtml += "<td>" + data[i].invoiceAdress + "</td>";
                            resultHtml += "<td>" + swicthStatus(data[i].status) + "</td></tr>";
                        }
                        $("#order_body").html(resultHtml);
                        kkpager.selectPage(n);
                        return false;
                    }, "json");
                }
            });
        });
        function swicthStatus(status) {
            switch (status) {
                case 0: return "未邮寄";
                case 1: return "已邮寄";
                case 2: return "已取消";
                default: return "";

            }
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <!--索要的发票-->
            <h3 class="per-order-til" style="clear: both">
                已经索要的发票信息</h3>
            <div class="dingdan_tb">
                <table class="order_tb" cellpadding="0" cellspacing="0" border="0" style="margin-bottom: 10px">
                    <tr class="order_tr">
                        <td style="width: 120px;">
                            订单号
                        </td>
                        <td style="width: 120px;">
                            订单总额
                        </td>
                        <td style="width: 200px;">
                            发票抬头
                        </td>
                        <td>
                            邮寄地址
                        </td>
                        <td style="width: 60px;">
                            邮寄状态
                        </td>
                    </tr>
                    <tbody id="order_body">
                        <%foreach (DataRow item in invoList.Rows)
                           { %>
                        <tr>
                            <td>
                                <a href='/PCenter/MyOrdersInfo.aspx?OrderId=<%=item["orderId"]%>' >
                                    <%=item["orderId"]%></a>
                            </td>
                            <td>
                                <%= Convert.ToDecimal(item["orderMoney"]) + Convert.ToDecimal(item["unpaidMoney"])%>
                            </td>
                            <td>
                                <%=Common.Tool.StrCut(item["invoiceHead"].ToString(), 12, false)%>
                            </td>
                            <td>
                                <%=Common.Tool.StrCut(item["invoiceAdress"].ToString(), 12, false)%>
                            </td>
                            <td>
                                <%=(Model.Enume.InvoiceStatus)item["status"]%>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div>
                <div id="kkpager">
                </div>
                <input type="hidden" id="kkpager_pageCount" value="<%= pageCount %>" />
                <input type="hidden" id="kkpager_recordCount" value="<%= rowCount %>" />
            </div>
        </div>
    </div>
</asp:Content>
