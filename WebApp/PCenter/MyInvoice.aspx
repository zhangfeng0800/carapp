<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyInvoice.aspx.cs" Inherits="WebApp.PCenter.MyInvoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            var isChecked = 0;
            $("#selectAll").click(function () {
                if (isChecked == 0) {
                    $("input[name='selects']").each(function () {
                        $(this).attr("checked", "checked");
                    });
                    isChecked = 1;
                }
                else if (isChecked == 1) {
                    $("input[name='selects']").each(function () {
                        $(this).removeAttr("checked");
                    });
                    isChecked = 0;
                }
            });
        })
        function Delete() {
            if (confirm("确定删除所有选中项？提示：未邮寄的发票不可删除。")) {
                var datas = "";
                $("input[name='selects']").each(function () {
                    if ($(this).prop("checked") == true) {
                        datas += ($(this).val() + ",");
                    }
                });
                if (datas.length == 0) {
                    alert("请选择");
                    return;
                }
                $.post("/api/MyInvoice.ashx", { 'action': 'Delete', 'ids': datas }, function (data) {
                    window.location.href = "<%=Request.Url %>";
                });
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <h3 class="per-order-til">常用发票信息管理</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <div class="dingdan_tb">
                    <table class="order_tb" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:10px">
                        <tr class="order_tr">
                            <td style="width: 70px;">
                                <input type="checkbox" id="selectAll" />全选</td>
                            <td style="width: 200px;">发票抬头</td>
                            <td style="width: 120px;">发票内容</td>
                            <td style="width: 120px;">发票类型</td>
                            <td>邮寄地址</td>
                            <td style="width: 60px;">邮政编码</td>
                            <td style="width: 60px;">操作</td>
                        </tr>
                        <% for (int i = 0, max = invoices.Count; i < max; i++){ %>
                        <tr>
                            <td><input type="checkbox" name="selects" value="<%=invoices[i].Id %>"/></td>
                            <td><%=Common.Tool.StrCut(invoices[i].InvoiceHead, 12, false)%></td>
                            <td><%=(Model.Enume.InvoiceType)invoices[i].InvoiceType%></td>
                            <td><%=(Model.Enume.InvoiceClass)invoices[i].invoiceClass%></td>
                            <td><%=Common.Tool.StrCut(invoices[i].InvoiceAdress, 12, false)%></td>
                            <td><%=invoices[i].InvoiceZipCode%></td>
                            <td><% if (new BLL.InvoiceBLL().CanEdit(invoices[i].Id))
                                   { %> <a href="MyInvoiceEdit.aspx?id=<%= invoices[i].Id %>">修改</a><% }
                                   else
                                   { %><a style="color:#ccc">修改</a><% } %></td>
                        </tr>
                        <% } %>
                    </table>
                    <a href="javascript:Delete()" class="person-button"><em>删除所选</em></a>
                    <a href="MyInvoiceManager.aspx" class="person-button"><em>添加常用发票</em></a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
