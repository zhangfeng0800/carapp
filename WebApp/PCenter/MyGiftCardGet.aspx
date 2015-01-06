<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyGiftCardGet.aspx.cs" Inherits="WebApp.PCenter.MyGiftCardGet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#A_Submit").click(function () {

                if ($("#Text_SN").val().Trim() == "") {
                    alert("序列号不能为空！");
                    return;
                }
                $.post("MyGiftCardGet.aspx", {
                    Action: "Get",
                    SN: $("#Text_SN").val().Trim()
                }, function (data) {
                    if (data.Message == "Complete") {
                        if (confirm("充值成功，是否继续充值？"))
                            $("#Text_SN").val("");
                        else
                            window.location.href = "MyGiftCard.aspx";
                    } else {
                        alert(data.Message);
                        $("#Text_SN").val("");
                    }
                });
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">   
	<h3 class="per-line-til">
		使用充值卡
	</h3>
	<div class="per-line-bg">
		<ul class="per-ul">
			<li><span class="per-name-style">序列号</span>
            <input type="text" class="per-input" id="Text_SN" name="rechargeMo"/></li>
			<li class="per-button-padding">
            <input class="yc-btn bank-btn per-button-border"  style="margin-left:90px;"  id="A_Submit" type="button" value="充值"/>
            </li>
		</ul>
	</div>
</asp:Content>
