<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true" CodeBehind="spotInfo.aspx.cs" Inherits="WebApp.spotInfo" %>
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
            <%=hot_Line.name%>
        </h3>            
        <div class="con_artSourseBottom">
            <%=Common.Tool.StrCut(hot_Line.Summary,80,false) %>
        </div>
        <div class="con_text">
            <%=hot_Line.Description %>
        </div>
    </div>
    <!-- The article page code end -->
</asp:Content>