<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="AuthorizeUser.aspx.cs" Inherits="WebApp.PCenter.AuthorizeUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".A_SetStatus").click(function () {
                if (!confirm("确定要" + ($(this).html() == "取消授权" ? "取消" : "恢复") + $(this).parent().siblings("td:first").text() + "的授权？"))
                    return false;
                var thisTag = $(this);
                $.post("AuthorizeUser.aspx", {
                    Action: "SetStatus",
                    Value: thisTag.attr("title")
                }, function (data) {
                    if (data.Message == "success") {
                        if (thisTag.parent().prev().text() == "启用") {
                            thisTag.parent().prev().html("<span style=\"color:#f00\">失效</span>");
                            thisTag.text("恢复授权");
                        }
                        else {
                            thisTag.parent().prev().text("启用");
                            thisTag.text("取消授权");
                        }
                        alert("设置成功！");
                    }
                    else {
                        alert("设置失败！");
                    }
                }, "json");
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="per-order-til">
        授权管理</h3>
    <div class="article clearfix">
        <a href="AuthorizeUserManager.aspx" class="person-button"><em>添加授权人</em></a>
    </div>
    <div class="per_bg">
        <div class="dingdan_tb">
            <table class="order_tb" cellpadding="0" cellspacing="0" border="0" id="tablelist">
                <tr class="order_tr">
                    <td>姓名</td>
                    <td>手机号</td>
                    <td>失效日期</td>
                    <td>账户余额</td>
                    <td>账户上限</td>
                    <td>身份</td>
                    <td>状态</td>
                    <td>操作</td>
                </tr>
                <% for (int i = 1, max = userList.Count; i < max; i++){ %>
                <tr>
                    <td><%=userList[i].Compname %></td>
                    <td><%=userList[i].Telphone %></td>
                    <td><%=userList[i].userRestrict.Deadline.ToString("yyyy-MM-dd HH:mm:ss") %></td>
                    <td><%=userList[i].userRestrict.Balance %></td>
                    <td><%=userList[i].userRestrict.CostToplimit == 0 ? "未限制" : userList[i].userRestrict.CostToplimit.ToString()%></td>
                    <td><%=(userList[i].Type == 1?"部门经理":"部门员工") %></td>
                    <td><%=userList[i].userRestrict.Status == 1 ? "启用" : "<span style=\"color:#f00\">失效</span>"%></td>
                    <td><a href="AuthorizeUserManager.aspx?Uid=<%=userList[i].Id%>">修改</a>|
                    <% if (userList[i].userRestrict.Status == 1){ %>
                    <a href="javascript:;" onclick="showConfirm('0','<%= userList[i].Id %>')" class="A_SetStatus" title="<%= userList[i].Id %>">取消授权</a>
                    <% }else{ %>
                    <a href="javascript:;" onclick="showConfirm('1','<%= userList[i].Id %>')" class="A_SetStatus" title="<%= userList[i].Id %>">恢复授权</a></td>
                    <% } %>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
</asp:Content>
