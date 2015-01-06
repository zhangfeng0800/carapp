<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="article.aspx.cs" Inherits="WebApp.article" %>

<%@ Import Namespace="BLL" %>
<%@ Import Namespace="Model" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/public.css" rel="stylesheet" type="text/css" />
    <link href="css/subpage.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="content clearfix">
        <div class="sidebar about">
            <%
                if (Request.QueryString["typeid"] != null)
                {
                    int typeid = Convert.ToInt32(Request.QueryString["typeid"]);
                    var model = ArticalBLL.GetArticalNameByID(typeid);
                    Response.Write("  <ul class=\"con-ul-lh\"><li><a class=\"selected\" href=\"javascript:void(0)\">" + model + "</a></li>  ");
                    var list = BLL.ArticalContent.GetArticalContent(typeid).Where(p => p.isPublish == 1).ToList();
                    foreach (var articalContent in list)
                    {
                        Response.Write("<li><a href=\"/article.aspx?typeid=" + articalContent.articalID + "&id=" + articalContent.ID + "\">" + Substr(articalContent.title) + "</a></li>");
                    }
                    Response.Write("   </ul>");
                }
            %>
        </div>
        <div class="main main-margin">
            <h3 class="con-til-style">
                <%    var instance = BLL.ArticalContent.GetArticalContentByID(Convert.ToInt32(Request.QueryString["id"]));
                      if (instance != null)
                      {
                          Response.Write(instance.title);
                      }
                    
                %>
            </h3>
            <div class="con-text-gray">
                <% 
                    var time = BLL.ArticalContent.GetArticalContentByID(Convert.ToInt32(Request.QueryString["id"]));
                    if (time != null)
                    {
                        Response.Write("发布日期：" + time.dateTime.ToShortDateString());
                    }
                                               
                %></div>
            <div class="con-text">
                <%
                    if (instance != null)
                    {

                        Response.Write(instance.contents);
                    }
                %>
            </div>
        </div>
    </div>
</asp:Content>
