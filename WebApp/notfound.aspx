<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true" CodeBehind="notfound.aspx.cs" Inherits="WebApp.notfound" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/public.css" rel="stylesheet" type="text/css" />
    <link href="css/subpage.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
       <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="content error-page">
        <div class="text-error">
            <a href="/Default.aspx">返回首页</a> <a href="/hotline.aspx">选择热门线路</a>
        </div>
    </div>
</asp:Content>
