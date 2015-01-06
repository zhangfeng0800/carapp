<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="hotline.aspx.cs" Inherits="WebApp.hotline" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>爱易租 租车新生活</title>
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <link rel="stylesheet" type="text/css" href="css/public.css" />
    <link rel="stylesheet" type="text/css" href="css/subpage.css" />
    <!--[if IE 6]>
  <script type="text/javascript" src="js/png.js"></script>
  <script type="text/javascript" src="js/fixpng.js"></script>
<![endif]-->
   
    <script src="Scripts/app.js" type="text/javascript"></script>
    <script>
        $(function () {
            if (window.location.search.substring(1).split("=")[0] == "cityid") {
                GetHotLineByid('<%=querystring %>', 0);
            } else {
                GetHotLineByid('<%=List.First().CodeId %>', 0);
            }
            getProvinceName("#hot_province", 6);
            $("#hot_province").change(function () {
                getCityListByPro($("#hot_province").val(), "#hot_city", 6);
            });
            $("#hot_city").change(function () {
                getTownByCity($("#hot_city").val(), "#hot_town", 6);
                //                getServiceType($(this).val(), "#hot_town");
            });
            $("#hot_town").change(function () {
                GetHotLineByid($("#hot_town").val(), 0);
            });
        });

        function setSelectedClass(element, id) {
            $("#citycontainer li a").removeClass("selected");
            $(element).addClass("selected");
            GetHotLineByid(id, 0);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="dc-process">
        <div class="city hotLine-bg">
            <h2 class="city-til">
                热门线路开启自由之旅</h2>
            <p class="city-til-red">
                选择你出发的城市</p>
            <div class="city-info">
                <ul class="city-con" id="citycontainer">
                    <%
                        if (Request.QueryString["cityid"] != null)
                        {
                            var cityid = Request.QueryString["cityid"];

                            foreach (var m in List)
                            {

                                if (m.CodeId == cityid)
                                {%>
                    <li><a class="selected" href="javascript:void(0);" id="<%=m.CodeId %>" onclick="setSelectedClass('#<%=m.CodeId %>','<%=m.CodeId %>')">
                        <%=GetCityName(m.ParentId)+m.CityName%></a></li>
                    <% }
                                else
                                {
                    %>
                    <li><a href="javascript:void(0);" id="<%=m.CodeId %>" onclick="setSelectedClass('#<%=m.CodeId %>','<%=m.CodeId %>')">
                        <%=GetCityName(m.ParentId) + m.CityName%></a></li>
                    <%   }
                    %>
                    <%}
                        }
                        else
                        {
                            var index = 0;
                            foreach (var m in List)
                            {
                                index++;
                                if (index == 1)
                                {%>
                    <li><a class="selected" href="javascript:void(0);" id="<%=m.CodeId %>" onclick="setSelectedClass('#<%=m.CodeId %>','<%=m.CodeId %>')">
                        <%=GetCityName(m.ParentId) + m.CityName%></a></li>
                    <% }
                                else
                                {
                    %>
                    <li><a href="javascript:void(0);" id="<%=m.CodeId %>" onclick="setSelectedClass('#<%=m.CodeId %>','<%=m.CodeId %>')">
                        <%=GetCityName(m.ParentId) + m.CityName%></a></li>
                    <%   }
                    %>
                    <%}
                        }%>
                </ul>
            </div>
        </div>
        <div class="city-bg">
            <div class="dc-style-til clearfix">
                <a class="dc-style-tab" href="javascript:;">热门线路</a> <span class="span-sl">&nbsp;&nbsp; 用车省份
                    <select name="" id="hot_province">
                        <option value="0">请选择</option>
                    </select>
                    &nbsp;&nbsp; 用车城市
                    <select name="" id="hot_city">
                        <option value="0">请选择</option>
                    </select>
                    &nbsp;&nbsp; 用车区县
                    <select name="" id="hot_town">
                        <option value="0">请选择</option>
                    </select>
                </span>
            </div>
            <div class="dc-style">
                <table id="hotline1" class="hot-line-table" width="100%" border="0" cellspacing="0"
                    cellpadding="0">
                     
                </table>
            </div>
        </div>
    </div>
</asp:Content>
