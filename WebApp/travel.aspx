<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="travel.aspx.cs" Inherits="WebApp.travel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/subpage.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/app.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="Tour_Scenic">该业务暂缓开通</div>
    <div class="dc-process" style="display:none;">
        <div class="city Tour_bg">
            <h2 class="city-til">
                爱旅游说走就走的旅行</h2>
            <p class="city-til-red">
                选择你出发的城市</p>
            <div class="city-info">
                <input type="hidden" id="txtfirstcity" value="<% if (data.Rows.Count > 0){Response.Write(data.Rows[0]["townid"].ToString());} %>" />
                <input type="hidden" id="txtselectedthemes" />
                <ul class="city-con" id="travelCityContainer">
                   
                </ul>
            </div>
        </div>
        <div class="Tour_Scenic">
            <dl class="Tour_Scenic_til clearfix">
                <dt>请选择主题：</dt>
                <dd>
                    <a class="Tour_sel" href="javascript:;" onclick="clickToSelectTheme(this,0)">不限</a>
                    <% for (int i = 0; i < ThemeList.Count; i++)
                       {%>
                    <a href="javascript:;" onclick="clickToSelectTheme(this,<%=ThemeList[i].Id %>)">
                        <%=ThemeList[i].Name %></a>
                    <%} %>
                </dd>
            </dl>
        </div>
        <div class="city-bg">
            <div class="dc-style-til clearfix">
                <a class="dc-style-tab" href="">爱旅游</a> 省份&nbsp;&nbsp;
                <select id="province">
                    <option value="0">请选择</option>
                </select>&nbsp;&nbsp;城市&nbsp;&nbsp;
                <select id="city">
                    <option value="0">请选择</option>
                </select>&nbsp;&nbsp;区县&nbsp;&nbsp;
                <select id="town">
                    <option value="0">请选择</option>
                </select>
            </div>
            <div class="dc-style" id="listContainer">
            </div>
        </div>
    </div>
    <script>
        $(function () {
            $("#txtselectedthemes").val("0");
            getTravelPlace(1, 0, "province", "#province");
            $("#province").change(function () {
                getTravelPlace(1, $(this).val(), "city", "#city");
            });
            $("#city").change(function () {
                getTravelPlace(1, $(this).val(), "town", "#town");
            });
            $("#town").change(function () {
                getTravelList($(this).val(), "#listContainer", $("#txtselectedthemes").val());
                $("#txtfirstcity").val($(this).val());
            });
            getTravelList($("#txtfirstcity").val(), "#listContainer", $("#txtselectedthemes").val());
            getTravelCityList("#travelCityContainer");
        });
        function getTravelPlace(istravel, cityid, type, element) {
            $.ajax({
                url: "/api/getserviceplace.ashx",
                data: { istravel: istravel, cityid: cityid, type: type },
                type: "post",
                success: function (data) {
                    if (data.CodeId == 0) {
                        $(element).html("");
                        return;
                    } else {
                        var html = "<option value='0'>请选择</option>";
                        $.each(data.Data, function (index, val) {
                            html += "<option value='" + val.id + "'>" + val.name + "</option>";
                        });
                        $(element).html(html);
                    }
                }
            });
        }

        function getTravelCityList(element) {
            $.ajax({
                url: "/api/gettravelcitylist.ashx",
                success: function (data) {
                    if (data.CodeId == 0) {
                        $(element).html("");
                        return;
                    } else {
                        var html = "";
                        $.each(data.Data, function (index, val) {
                            if (index == 0) {
                                html += "<li><a href=\"javascript:;\" class=\"selected\" onclick=\"clickElement(this," + val.townid + ")\">" + val.cityname + "</a></li>";
                            } else {
                                html += "<li><a href=\"javascript:;\" onclick=\"clickElement(this," + val.townid + ")\">" + val.cityname + "</a></li>";
                            }
                        });
                        $(element).html(html);
                    }
                }
            });
        }
        function clickElement(element, townid) {
            var list = $("#travelCityContainer li a");
            $.each(list, function (index, val) {
                $(val).removeClass("selected");
            });
            $(element).addClass("selected");
            $("#txtfirstcity").val(townid);
            getTravelList(townid, "#listContainer", $("#txtselectedthemes").val());
        }

        function clickToSelectTheme(element, themeid) {
            $(".Tour_sel:first").removeClass("Tour_sel");
            $(element).addClass("Tour_sel");
            $("#txtselectedthemes").val(themeid);
            getTravelList($("#txtfirstcity").val(), "#listContainer", $("#txtselectedthemes").val());
        }

      
    </script>
</asp:Content>
