<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="DailyRent.aspx.cs" Inherits="WebApp.DailyRent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="css/subpage.css" />
    <script type="text/javascript" src="Scripts/jquery-1.7.1.min.js"></script>
    <script src="Scripts/app.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            var cid = $("#nav li:first a").attr("cid");
            var cname = $("#nav li:first a").attr("cname");
            if (cid != "") {
                getproduct(cid,cname);
            }
        });

        function  showSelected(element,id,cname) {
            $("#nav li a").removeClass("selected");
            $(element).addClass("selected");
            getproduct(id,name);
        }
        function getproduct(cid,cname) {
            $("#products").html("");
            $.get("/api/DailyRentHandler.ashx?action=list", { "cid": cid,wayid:<%=Request.QueryString["wayid"] %> }, function (result) {
                if (result.length <= 0) {
                    $("#products").html("暂无此类型车辆");
                    return;
                }
                var html = "";
                for (var i = 0; i < result.length; i++) {
                    var imgurl = "";
                    if (result[i].ImgUrl != "") {
                        imgurl = " http://admin.iezu.cn/" + result[i].ImgUrl;
                    } else {
                        imgurl = "/images/dailyrent.jpg";
                    }
                    html += '<div class="car-mod-class clearfix">';
                    html += '<div class="car-l">';
                    html += "<img src=\""+imgurl+"\" alt=\"\" />";
                    html += '</div>';
                    html += '<div class="car-mid">';
                    html += '<h4 class="car-mod-til">' + result[i].carTypeName + '<em>（' + result[i].brandName + '同级车）</em></h4>';
                    html += '<ul class="car-mod-ul">';
                    html += '<li>可乘人数：' + result[i].passengerNum + '人</li>';
                    html += '<li><span class="feiyong">费用包含：</span> <span class="span-btn">油</span> <span class="span-btn">驾</span> <span class="span-btn">险</span></li>';
                    html += '<li>' + result[i].feeIncludes + '</li>';
                    html += '<li style=\"visibility: hidden\">元起租</li>';
                    html += '<li>超时费用：' + result[i].hourPrice + '元/分钟</li>';
                    html += '<li>超公里费：' + result[i].kiloPrice + '元/公里</li>';
                    html += "<li style=\"width:300px;\">备注："+result[i].CarRemark+"</li>";
                    html += '</ul>';
                    html += '</div>';
                    html += '<div class="car-r">';
                    html += '<p class="price-zuche">套餐价：<del>￥' + result[i].startPrice+ '元</del></p>';
                    html += '<p class="price-xianjia"><strong>￥' +  result[i].DiscountPrice + '元</strong></p>';
                    html += '<p><a class="zuche-book" href=\"javascript:;\" onclick=\"checkLogin('+ result[i].id +')\">预订</a></p>';
                    html += '</div>';
                    html += '</div>';
                }
                $("#products").html(html);
            });
        }
    </script>
    <script>
        $(function () {
            getProvinceName("#txt_province", <%=wayid %>);
            $("#txt_province").change(function() {
                getCityListByPro($(this).val(), "#txt_city", <%=wayid %>);
            });
            $("#txt_city").change(function() {
                getTownByCity($(this).val(), "#txt_town", <%=wayid %>);
            });
            $("#txt_town").change(function() {
                getproduct($("#txt_town").val(), "cname");
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="dc-process">
        <div class="city">
            <h2 class="city-til">
                租车生活从爱易租开始</h2>
            <p class="city-til-red">
                选择你出发的城市</p>
            <div class="city-info">
                <ul class="city-con" id="nav">
                    <%
                        if (List.Count > 0)
                        {


                            var index = 0;
                            foreach (var m in List)
                            {
                                index++;
                                if (index == 1)
                                {
                    %>
                    <li><a href="javascript:void(0);" class="selected" id="<%= m.CodeId %>" cname="<%= m.CityName %>"
                        cid="<%= m.CodeId %>" onclick="showSelected('#<%= m.CodeId %>','<%= m.CodeId %>','<%= m.CityName %>')">
                        <%=GetCityName(m.ParentId)+ m.CityName%></a></li>
                    <%
}
                                else
                                {
                    %>
                    <li><a href="javascript:void(0);" id="<%= m.CodeId %>" cname="<%= m.CityName %>"
                        cid="<%= m.CodeId %>" onclick="showSelected('#<%= m.CodeId %>','<%= m.CodeId %>','<%= m.CityName %>')">
                        <%=GetCityName(m.ParentId)+ m.CityName%></a></li>
                    <%
                        }
                            }
                        }
                    %>
                </ul>
            </div>
        </div>
        <div class="city-bg">
            <div class="dc-style-til clearfix">
                <a class="dc-style-tab" href="javascript:;">
                    <%=wayname %></a> 用车省份：
                <select id="txt_province">
                    <option value="0">请选择</option>
                </select>
                用车城市 ：
                <select id="txt_city">
                    <option value="0">请选择</option>
                </select>
                用车区县：
                <select id="txt_town">
                    <option value="0">请选择</option>
                </select>
            </div>
            <div class="dc-style" id="products">
            </div>
        </div>
    </div>
</asp:Content>
