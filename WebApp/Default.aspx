<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="WebApp.Default" %>

<%@ Import Namespace="System.Data" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title></title>
    <!--[if IE 6]>
  <script type="text/javascript" src="js/png.js"></script>
  <script type="text/javascript" src="js/fixpng.js"></script>
<![endif]-->
    <script type="text/javascript" src="js/lanrenzhijia.js"></script>
    <script type="text/javascript" src="js/carmodel.js"></script>
    <script src="Scripts/app.js" type="text/javascript"></script>
    <script src="js/Marquee.js" type="text/javascript"></script>
    <script>
        function redirect() {
            if ($("#input_city").val() == "0" || $("#input_province").val() == "0" || $("#input_caruseway").val() == "0") {
                alert("请选择");
            } else {
                if ($("#input_caruseway").val() == 6) {
                    window.location.href = "/hotline.aspx?cityid=" + $("#input_town").val();
                } else {
                    window.location.href = "/ChooseCar.aspx?cityid=" + $("#input_town").val() + "&carusewayid=" + $("#input_caruseway").val();
                }
            }
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $("span[id^='cnzz_stat_icon']").hide();
//          getHotCityList();
            GetHotLineByid($("#firsthotcity").val(),4);
            <%--顶部车型信息的表开始--%>
            getProvinceName("#input_province",0);
            $("#input_province").change(function () {
                getCityListByPro($("#input_province").val(), "#input_city",0);
            });
            $("#input_city").change(function () {
                getTownByCity($("#input_city").val(), "#input_town",0);
            });
            $("#input_town").change(function () {
                getServiceType($(this).val(), "#input_caruseway");
            
            });
            <%--顶部车型信息的表结束--%>
            <%--热门路线的省市信息开始--%>
            getProvinceName("#hot_province",6);
            $("#hot_province").change(function () {
                getCityListByPro($("#hot_province").val(), "#hot_city",6);
            });
            $("#hot_city").change(function () {
                getTownByCity($("#hot_city").val(), "#hot_town",6);
//                getServiceType($(this).val(), "#hot_town");
            });
            $("#hot_town").change(function() {
                GetHotLineByid($("#hot_town").val(),4);
            });
            <%--热门路线的省市信息结束--%>
        });
        function showSeletCity(element, cityid) {
            $("#hotcitycontainer a").removeClass("selected");
            $(element).addClass("selected");
            GetHotLineByid(cityid,4);
        }
    </script>
    <style>
        #hotcitycontainer a.selected
        {
            background: #ec7500;
            color: #fff;
            text-decoration: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="firsthotcity" value="<%= Hotcitylist.Rows.Count>0?Hotcitylist.Rows[0]["cityid"].ToString():"" %>" />
    <div class="banner clearfix">
        <div id="full-screen-slider">
           <ul id="slides">
                  <li style="background: url('images/01.jpg') no-repeat center top"><a href="/huanbao.html"
                    target="_blank"></a></li>
                <li style="background: url('images/02.jpg') no-repeat center top"><a href="/article.aspx?typeid=40&id=79"
                    target="_blank"></a></li>
                <li style="background: url('images/03.jpg') no-repeat center top"><a href="/article.aspx?typeid=40&id=78"
                    target="_blank"></a></li>
            </ul>
        </div>
        <div class="book-up">
            <div class="book-box">
                <h3 class="book-til">
                    60秒快速订车</h3>
                <div id="tabcontent1" class="book-bg">
                    <p>
                        用车省份：
                        <select class="option-border" name="city" id="input_province">
                            <option value='0' selected='selected'>请选择</option>
                        </select>
                    </p>
                    <p>
                        用车城市：
                        <select class="option-border" name="city" id="input_city">
                            <option value='0' selected='selected'>请选择</option>
                        </select>
                    </p>
                    <p>
                        用车区县：
                        <select class="option-border" name="city" id="input_town">
                            <option value='0' selected='selected'>请选择</option>
                        </select>
                    </p>
                    <p>
                        用车方式：
                        <select class="option-border" name="date" id="input_caruseway">
                            <option value="0">请选择</option>
                        </select>
                    </p>
                    <p>
                        <button class="choose-btn" type="button" onclick="redirect()">
                            下一步，去选车</button>
                    </p>
                </div>
            </div>
        </div>
    </div>
    <div class="main clearfix">
        <div class="main-left">
            <div class="hot-line">
                <div class="hot-line-top clearfix">
                    <h3 class="hot-line-til">
                        热门线路</h3>
                    <span class="span-sl">&nbsp;&nbsp; 用车省份
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
                    <div class="more-line">
                        <a href="/hotline.aspx">更多城市</a>
                    </div>
                </div>
                <%--<div class="hot-line-top clearfix">
                    <ul class="hot-line-tab">
                        <li><a href="#tabs-1">热门城市</a></li>
                        <li><a href="#tabs-2">ABCDEF</a></li>
                        <li><a href="#tabs-3">GHIJKL</a></li>
                        <li><a href="#tabs-4">MNOPQR</a></li>
                        <li><a href="#tabs-5">STWXYZ</a></li>
                    </ul>
                    <div class="more-line">
                        <a href="">更多城市</a>
                    </div>
                </div>--%>
                <div style="border: 1px solid #BEBEBE; border-top: none; padding: 5px; margin: 0 0 10px 0;
                    font-size: 12px;" id="hotcitycontainer">
                    <% for (var i = 0; i < Hotcitylist.Rows.Count; i++)
                       {
                           if (i == 0)
                           { %>
                    <a id="hotcity<%=Hotcitylist.Rows[i]["cityid"] %>" class="selected" href="javascript:;"
                        style="padding: 2px 5px;" onclick="showSeletCity('#hotcity<%=Hotcitylist.Rows[i]["cityid"] %>','<%=Hotcitylist.Rows[i]["cityid"] %>')">
                        <%=Hotcitylist.Rows[i]["citynames"].ToString()+Hotcitylist.Rows[i]["cityname"].ToString() %></a>
                    <% }
                           else
                           {%>
                    <a id="hotcity<%=Hotcitylist.Rows[i]["cityid"] %>" href="javascript:;" style="padding: 2px 5px;"
                        onclick="showSeletCity('#hotcity<%=Hotcitylist.Rows[i]["cityid"] %>','<%=Hotcitylist.Rows[i]["cityid"] %>')">
                        <%=Hotcitylist.Rows[i]["citynames"].ToString()+Hotcitylist.Rows[i]["cityname"].ToString() %></a>
                    <%}
                       } %>
                </div>
                <div class="hot-line-bg">
                </div>
                <table id="hotline1" class="hot-line-table" width="100%" border="0" cellspacing="0"
                    cellpadding="0">
                </table>
                <div style="background: #ededed; height: 30px; line-height: 30px; text-align: center;">
                    <a style="color: #999; font-size: 14px;" href="javascript:;" id="moreline">更多线路>></a></div>
            </div>
        </div>
        <div class="main-side">
            <h3 class="service">
                服务特色</h3>
            <div class="ser-ico clearfix">
                <ul class="service-ico">
                    <%
                        Model.Artical articaltype = BLL.ArticalBLL.GetArticalList().Where(s => s.Name.Contains("服务特色")).FirstOrDefault();
                        string[] articalID = new string[8];
                        for (int i = 0; i < articalID.Length; i++)
                        {
                            articalID[i] = "javascript:void(0)";
                        }
                        if (articaltype != null)
                        {
                            List<Model.ArticalContent> articalContents = BLL.ArticalContent.GetArticalContent(articaltype.ID).Where(p => p.isPublish == 1).ToList();

                            articalID[0] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("城际特快")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype.ID;
                            articalID[1] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("热门线路")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype.ID;
                            articalID[2] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("安心支付")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype.ID;
                            articalID[3] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("快捷订车")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype.ID;
                            articalID[4] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("专业司机")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype.ID;
                            articalID[5] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("高级车型")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype.ID;
                            articalID[6] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("高端服务")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype.ID;
                            articalID[7] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("免费保险")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype.ID;
                        }
                    %>
                    <li><a class="ico1" href="<%=articalID[0]%>">城际特快</a></li>
                    <li><a class="ico2" href="<%=articalID[1]%>">热门线路</a></li>
                    <li><a class="ico3" href="<%=articalID[2]%>">安心支付</a></li>
                    <li><a class="ico4" href="<%=articalID[3]%>">快捷订车</a></li>
                    <li><a class="ico5" href="<%=articalID[4]%>">专业司机</a></li>
                    <li><a class="ico6" href="<%=articalID[5]%>">高级车型</a></li>
                    <li><a class="ico7" href="<%=articalID[6]%>">高端服务</a></li>
                    <li><a class="ico8" href="<%=articalID[7]%>">免费保险</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="main clearfix">
        <%
            Model.Artical articaltype2 = BLL.ArticalBLL.GetArticalList().Where(s => s.Name.Contains("公司公告")).FirstOrDefault();
            string[] stringLink = new string[4] { "javascript:void(0)", "javascript:void(0)", "javascript:void(0)", "javascript:void(0)" };
            if (articaltype2 != null)
            {
                List<Model.ArticalContent> articalContents = BLL.ArticalContent.GetArticalContent(articaltype2.ID).Where(p => p.isPublish == 1).ToList();

                try
                {
                    stringLink[0] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("最新优惠")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype2.ID;
                }
                catch (Exception)
                {
                    stringLink[0] = "javascript:;";
                }
                stringLink[1] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("合作伙伴")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype2.ID;
                stringLink[2] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("爱易租公告")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype2.ID;
                stringLink[3] = "article.aspx?id=" + articalContents.Where(s => s.title.Contains("关注我们")).FirstOrDefault().ID.ToString() + "&typeid=" + articaltype2.ID;
            }
        %>
        <ul class="icon-show">
            <li><a class="icon-one" href="<%=  stringLink[0] %>">最新优惠</a> </li>
            <li><a class="icon-two" href="<%=  stringLink[1] %>">合作伙伴</a> </li>
            <li><a class="icon-three" href="<%=  stringLink[2] %>">爱易租公告</a> </li>
            <li><a class="icon-four" href="<%=  stringLink[3] %>">关注我们</a> </li>
        </ul>
    </div>
    <div class="main">
    <a name="brandimg"> </a> 
        <h3 class="cartil">
            公司车型</h3>
        <!-- 车型 -->
        <style type="text/css">
            .Div_CarInfo
            {
                height: 190px;
                overflow: hidden;
                position: relative;
            }
            .Div_CarInfo ul
            {
                width: 100%;
                overflow: auto;
                position: absolute;
                top: 0px;
                left: 0px;
            }
            .Div_CarInfo ul li
            {
                width: 250px;
                height: 190px;
                float: left;
                position: relative;
            }
            .Div_CarInfo ul li p
            {
                width: 210px;
                height: 0px;
                color: #fff;
                font: 12px/26px 'Verdana' , '宋体';
                padding: 0px 20px;
                position: absolute;
                bottom: 0px;
                left: 0px;
                display: none;
                background: transparent;
                background-color: rgba(0,0,0,0.5);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#88000000,endColorstr=#88000000);
                overflow: hidden;
            }
            .Div_CarInfo ul li a
            {
                width: 240px;
                height: 172px;
                padding-top: 7px;
                margin: 5px;
                display: block; /*background:#ddd;*/
            }
            .Div_CarInfo ul li a img
            {
                border: 1px solid #ddd;
                width: 240px;
                height: 170px;
                margin: 0px auto;
                display: block; /*border:none;*/
            }
            #hotline1 tbody tr td {
                font-size: 12px;
            }
        </style>
        <div class="Div_CarInfo">
            <ul>
                <%for (int i = 0, max = carBrandList.Count; i < max; i++)
                  {%>
                <li><a href="carinfo.aspx?id=<%=carBrandList[i].id%>"><img alt="<%=carBrandList[i].brandName%>" src="http://admin.iezu.cn<%=carBrandList[i].ImgUrl%>" title="<%=carBrandList[i].brandName%>" /></a>
                    <p><%=carBrandList[i].brandName%><br /><%=Common.Tool.StrCut(carBrandList[i].Description,32,true)%></p>                 
                </li>
                <%} %>
            </ul>
        </div>
        <!-- 车型 en`d -->
    </div>
    <div class="vip-client" style="display: none;">
        <h3 class="cartil">
            VIP客户</h3>
        <div class="clearfix">
            <ul class="vip-ul">
                <li><a href="javascript:;">
                    <img src="images/3425521354.png" alt="" /></a></li>
                <li><a href="javascript:;">
                    <img src="images/708770890.png" alt="" /></a></li>
                <li><a href="javascript:;">
                    <img src="images/3346349614.png" alt="" /></a></li>
                <li><a href="javascript:;">
                    <img src="images/3728902396.png" alt="" /></a></li>
                <li><a href="javascript:;">
                    <img src="images/4231483442.jpeg" alt="" /></a></li>
            </ul>
        </div>
    </div>
    <script>
//        $(function () {
//            $("#adContainer").slideDown("800");
//            setTimeout(function () {
//                $("#adContainer").slideUp("800");
//            }, 20000);
//        });
//        function closeAd() {
//            $("#adContainer").slideUp("800");
//        }
    </script>
  <%--  <div style="width: 100%; text-align: center; height: 100%; position: fixed; top: 30px;
        display: none; z-index: 1000000;" id="adContainer">
        <a href="http://iezu.cn/article.aspx?typeid=30&id=72">
            <img src="/images/ad.jpg" /></a>
        <div style="position: relative; width: 1000px; margin: 0 auto;">
            <strong style="color: #333; display: block; cursor: pointer; height: 30px; line-height: 30px;
                width: 30px; text-align: center; position: absolute; top: -500px; right: 0;"
                onclick="closeAd()">X </strong>
        </div>
    </div>--%>
    <script type="text/javascript">        var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://"); document.write(unescape("%3Cspan id='cnzz_stat_icon_1000328393'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s5.cnzz.com/z_stat.php%3Fid%3D1000328393%26show%3Dpic' type='text/javascript'%3E%3C/script%3E"));</script>
</asp:Content>
