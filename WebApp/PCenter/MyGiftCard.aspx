<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyGiftCard.aspx.cs" Inherits="WebApp.PCenter.MyGiftCard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function GetPageList(where) {
            var pageSize = 5;
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
                        pageIndex = pageIndex + 1;
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
                url: "MyGiftCard.aspx",
                data: { pageIndex: pageIndex },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.status == 1) {
                        var list = data.data;
                        var rowCount = data.rowCount;
                        var html = " <tr class='order_tr'><td>序列号</td><td>充值卡名称</td><td>面值</td><td>使用时间</td></tr>";
                        for (i = 0; i < list.length; i++) {
                            var time = "";
                            if (list[i].useTime != null) {
                                time = list[i].useTime.toString().replace('T',' ').substring(0,19);
                            }
                            html += "<tr><td>" + list[i].Sn + "</td><td>" + list[i].Name + "</td><td>" + list[i].Cost + "</td><td>" + time + "</td></tr>";

                        }
                        $("#giftCards").html(html);
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
        充值卡</h3>  
    <div class="article clearfix">
        <span class="fleft">您共有：<em class="price-num"><%=giftCount %></em>&nbsp;张充值卡</span>
        <a href="MyGiftCardGet.aspx" class="person-button"><em>兑换充值卡</em></a>
    </div>
    <table class="order_tb" cellpadding="0" cellspacing="0" border="0" id="giftCards">
        <tr class="order_tr">
            <td>充值卡编号</td>
            <td>充值卡名称</td>
            <td>面值</td>
            <td>使用时间</td>
        </tr>
        <tr>
            <%
                foreach (var item in giftCards)
                {
                    Response.Write("<tr>");
                    Response.Write("<td>" + item.Sn + " </td>");
                    Response.Write("<td>" + item.Name + " </td>");
                    Response.Write("<td>" + item.Cost + " </td>");
                    Response.Write("<td>" + item.useTime+ "</td>");
                    Response.Write("</tr>");
                }
            %>
        </tr>
    </table>
    <div id="pager" style="text-align:center; <%if(totalPage<=1){%> display:none;<% }%>  ">
        <a style="cursor:pointer;" onclick="GetPageList('first')">首页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPageList('pre')">上一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPageList('next')">下一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPageList('last')">末页</a>&nbsp;&nbsp;

        当前页：<input id="curpage" style="width:20px;" value="1" onkeyup="value=value.replace(/\D/g,'')" /><button type="button" onclick="GoPage()">跳</button> &nbsp;&nbsp;&nbsp;&nbsp;共<span id="total"><%=totalPage%></span>页
        </div>
</asp:Content>
