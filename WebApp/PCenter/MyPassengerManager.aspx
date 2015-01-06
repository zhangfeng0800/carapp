<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyPassengerManager.aspx.cs" Inherits="WebApp.PCenter.MyPassengerManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function checkNull() {
            if ($("input[name='passengerName']").val() == "") {
                $("#warning1").show();
                return false;
            }
            if ($("input[name='telePhone']").val() == "") {
                $("#warning2").show();
                return false;
            }
            if (!isMobile($("input[name='telePhone']").val())) {
                $("#warning2").text("您输入的手机号不正确！");
                $("#warning2").show();
                return false;
            }
            
                $.ajax({
                    url: "/api/checkPassenger.ashx",
                    type: "post",
                    async:false,
                    data: { telPhone: $("#telPhone").val(), updateID: '<%=updateID %>' },
                    success: function (data) {
                        if (data.resultcode != 0) {
                            alert(data.msg);
                            return;
                        } else {
                            $("#Button_Submit").attr("disabled", "disabled");
                            $("#sendData").submit();
                        }
                    }
                });
           
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <h3 class="per-line-til">
                <%=Method %></h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <form action="MyPassengerManager.aspx" method="post" id="sendData">
                <input type="hidden" value="<%=FormMethod %>" name="event" />
                <ul class="per-ul">
                    <li><span class="per-name-style">*姓名：</span>
                        <input type="text" name="passengerName" value="<%=passenger.ContactName %>" maxlength="20" /><span
                            style="color: Red; display: none" id="warning1">*</span></li>
                    <li><span class="per-name-style">*手机：</span>
                        <input type="text" name="telePhone" value="<%=passenger.TelePhone %>" id="telPhone" maxlength="11" /><span
                            style="color: Red; display: none" id="warning2">*</span></li>
                    <li class="per-button-padding">
                        <input name="updateid" type="hidden" value="<%=passenger.Id %>" />
                        <input id="Button_Submit" class="yc-btn bank-btn per-button-border" type="button"
                            value="保存" onclick="checkNull()" />
                    </li>
                </ul>
                </form>
            </div>
        </div>
    </div>
</asp:Content>
