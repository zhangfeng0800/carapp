<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyFundingList.aspx.cs" Inherits="WebApp.PCenter.MyFundingList" %>
<%@ Import Namespace="System.Data" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

 <script type="text/javascript">
     //ajax分页
     function GetPage(where) {
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
             url: "MyFundingList.aspx",
             data: { pageIndex: pageIndex },
             type: "post",
             dataType: "json",
             success: function (data) {
                 var list = data.data;
                 var rowCount = data.rowCount;
                 var html = "<tr class='order_tr'><td>金额</td><td>存入日期</td><td>到期日期</td><td>生效日期</td><td>状态</td><td>退款日期</td><td>每月返券数</td><td>单券面值</td></tr>";
                 for (i = 0; i < list.length; i++) {
                     html += "<tr><td>" + list[i].Amount + "元</td><td>" + list[i].InDate.split("T")[0] + "</td><td>" + list[i].ExpirationDate.split("T")[0] + "</td>";
                     html += "<td>" + list[i].CreateTime.split("T")[0] + "</td>";
                     html += "<td>" + list[i].Status + "</td>";
                     if (list[i].OutDate == null)
                         html += "<td></td><td>" + list[i].Num + "</td><td>" + list[i].Cost + "</td></tr>";
                     else {
                         html += "<td>" + list[i].OutDate.split("T")[0] + " </td><td>" + list[i].Num + "</td><td>" + list[i].Cost + "</td></tr>";
                     }
                 }

                 $("#curpage").val(pageIndex);
                 if (rowCount / pageSize > parseInt(rowCount / pageSize))
                     $("#total").html(parseInt(rowCount / pageSize) + 1);
                 else
                     $("#total").html(parseInt(rowCount / pageSize));
                 $("#fundingList").html(html);
                 if (rowCount > pageSize)
                     $("#pager").show();
                 else {
                     $("#pager").hide();
                 }

             },
             error: function (data) {
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
             GetPage(pageIndex);
     }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

 <div class="article article-padding">
        <h3 class="per-order-til">
            活动金额记录</h3>
       
              <table id="fundingList"  class="order_tb" cellpadding="0" cellspacing="0" border="0">
            <tr class="order_tr">
                <td>
                    金额
                </td>
                <td>存入日期</td>
                <td>
                   到期日期
                </td>
                <td>
                  生效日期 
                </td>
                <td>
                    状态
                </td>
                <td>
                    退款日期
                </td>
                <td>
                    每月返券数
                </td>
                <td>
                    单券面值
                </td>
            </tr>
            <%foreach (DataRow row in fundingList.Rows)
            {
                %>
                <tr><td><%=row["Amount"]%>元</td><td><%=Convert.ToDateTime(row["InDate"]).ToString("yyyy-MM-dd")%> </td>
                <td><%=Convert.ToDateTime(row["ExpirationDate"]).ToString("yyyy-MM-dd")%></td><td><%=Convert.ToDateTime(row["CreateTime"]).ToString("yyyy-MM-dd")%></td>
                <td><%=row["Status"] %></td><td><%=row["OutDate"].ToString() == "" ? "" : Convert.ToDateTime(row["OutDate"]).ToString("yyyy-MM-dd")%></td>
                <td><%=row["Num"] %></td><td><%=row["Cost"]%></td></tr>
                <%
            } %>
        </table>
         <div id="pager" style="text-align:center; <%if(totalPage<=1){%> display:none;<% }%>  ">
        <a style="cursor:pointer;" onclick="GetPage('first')">首页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('pre')">上一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('next')">下一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('last')">末页</a>&nbsp;&nbsp;

        当前页：<input id="curpage" style="width:20px;" value="1" onkeyup="value=value.replace(/\D/g,'')" /><button type="button" onclick="GoPage()">跳</button> &nbsp;&nbsp;&nbsp;&nbsp;共<span id="total"><%=totalPage%></span>页
        </div>
    </div>

</asp:Content>
