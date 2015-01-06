<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyPassenger.aspx.cs" Inherits="WebApp.PCenter.MyPassenger" %>

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
            $.post("/api/MyPassenger.ashx", { 'action': 'Delete', 'ids': datas }, function (data) {
                window.location.href = "<%=Request.Url %>";
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
            <h3 class="per-til-h3">
                修改常用乘车人</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <div class="dingdan_tb">
                    <table class="order_tb" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:10px;">
                        <tr class="order_tr">
                            <td style="width: 70px;">
                                <input type="checkbox" id="selectAll" />全选</td>
                            <td style="width: 214px;">姓名</td>
                            <td style="width: 230px;">手机号</td>
                            <td>操作</td>
                        </tr>
                        <tbody>
                            <%
                                foreach (var item in passengers)
                                {
                                    Response.Write("<tr>");
                                    Response.Write("<td>");
                                    Response.Write("<input type='checkbox' name='selects' value='"+item.Id+"'/></td>");
                                    Response.Write("<td>"+item.ContactName+"</td>");
                                    Response.Write("<td >"+item.TelePhone+"</td>");
                                    Response.Write("<td><a href='MyPassengerManager.aspx?id=" + item.Id + "'>修改</a></td> ");
                                    Response.Write("</tr> ");
                                }
                            %>
                        </tbody>
                    </table>
                    <a href="javascript:Delete()" class="person-button"><em>删除所选</em></a>
                    <a href="MyPassengerManager.aspx" class="person-button"><em>添加常用乘车人</em></a>
                </div>
            </div>
</asp:Content>
