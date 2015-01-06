<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true" CodeBehind="Score.aspx.cs" Inherits="WebApp.Score" %>
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
              <ul class="con-ul-lh"><li><a class="selected" href="javascript:void(0)">积分规则</a></li>  </ul>
        </div>
        <div class="main main-margin">
            <h3 class="con-til-style">
                积分规则
            </h3>
            <div class="con-text-gray">
          &nbsp;
                </div>
            <div class="con-text">
                <p style="margin-top: 10px; line-height: 2em;">
               </p>

                <table width="100%;">
                <tr>
                    <td colspan="2">个人用户 <hr/></td>
                   
                </tr>
                <tr>
                    <td  style=" padding: 5px; width:150px;">
                        级别
                    </td>
                    <td  style=" padding: 5px;">
                        积分规则
                    </td>
                </tr>
                <% foreach (var level in data.Where(p=>p.UserType==3))
                   {%>
                <tr>
                    <td style=" padding: 10px;">
                        <%=level.Name %>
                    </td>
                    <td>
                        <%=level.ScoreLL %>-<%=level.ScoreUL %>
                    </td>
                </tr>
                <%} %>
            </table>
              <table width="100%;">
                <tr>
                    <td colspan="2">企业用户<hr/></td>
                </tr>
                <tr>
                    <td  style=" padding: 5px;  width:150px;">
                        级别
                    </td>
                    <td  style=" padding: 5px;">
                        积分规则
                    </td>
                </tr>
                <% foreach (var level in data.Where(p=>p.UserType!=3))
                   {%>
                <tr>
                    <td style=" padding: 10px;">
                        <%=level.Name %>
                    </td>
                    <td>
                        <%=level.ScoreLL %>-<%=level.ScoreUL %>
                    </td>
                </tr>
                <%} %>
            </table>
            </div>
        </div>
    </div>

</asp:Content>
