<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true" CodeBehind="carinfo.aspx.cs" Inherits="WebApp.carinfo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/subpage.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/app.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <!-- The article page code beging -->
    <div class="content">
        <h3 class="con_til">
            <%=car_Brand.brandName%>
        </h3>
        <div class="con_artSourse">
        </div>            
        <div class="con_text">
            <%=car_Brand.MoreDescript%>
        </div>
    </div>
    <!-- The article page code end -->
</asp:Content>
