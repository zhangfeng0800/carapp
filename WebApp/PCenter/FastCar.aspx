<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="FastCar.aspx.cs" Inherits="WebApp.PCenter.FastCar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/MyInfo.js" type="text/javascript"></script>
    <script src="../Scripts/FastCar.js" type="text/javascript"></script>
    <style type="text/css">
        .Dl_Form { width: 96%; }
        .Dl_Form dt { width: 10%; float: left; min-height: 40px; _height: 40px; text-align: left; font: 12px/36px 'Verdana' , '宋体'; margin-bottom: 5px; }
        .Dl_Form dd { width: 90%; min-height: 40px; _height: 40px; float: left; margin-bottom: 5px; }
        .Dl_Form dd #A_headPic { width: 160px; height: 160px; display: block; margin-bottom: 5px; border: 1px solid #ddd; }
        .Dl_Form dd img { width: 160px; height: 160px; display: block; margin-bottom: 5px; }
        .backg { background-color: #fefefe; border: 1px solid #e6e6fa; font-family: Microsoft yahei; line-height: 26px; padding-left: 10px; width: 500px; position: absolute; left: 0px; top: 30px; display: none; z-index: 100; }
        .backg p:hover { background-color: #dedede; cursor: pointer; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="per-order-til">
        快捷订车
    </h3>
    <div class="per-line-bg">
        <form action="FastCar.aspx" method="post" id="fastCarForm">
        <dl class="Dl_Form">
            <dt>名字：</dt>
            <dd>
                <input class="per-input" type="text" value="<%=updateQuickOrderCar.name %>" name="name"  id="name"/>
            </dd>
            <dt>服务类型：</dt>
            <dd>
                <select id="caruseway" name="caruseway">
                    <option value="1">接机</option>
                    <option value="2">送机</option>
                    <option value="3">时租</option>
                    <option value="4">日租</option>
                    <option value="5">半日租</option>
                </select>
            </dd>
            <dt>上车城市：</dt>
            <dd>
                <select id="upProvice">
                    <option value="0">请选择省</option>
                </select>
                <select id="upCity">
                    <option value="0">请选择市</option>
                </select>
                <select id="upCountry" name="upCountry">
                    <option value="0">请选择县</option>
                </select>
            </dd>
            <dt id="dt_upAddress">上车地址：</dt>
            <dd style="position: relative; z-index: 10;" id="dd_upAddress">
                <input class="per-input" type="text" id="upAddress" name="upAddress" value="<%=updateQuickOrderCar.upAddress %>" />
                <input type="hidden" id="upAddress_Detail" name="upAddress_Detail" value="<%=updateQuickOrderCar.upAddressDetail %>" />
                <input type="hidden" id="upAddress_position" name="upAddress_position" value="<%=updateQuickOrderCar.upPosition %>" />
                <span id="upAddress_detail" class="backg"></span>
            </dd>
              <dt id="dt_airPort">选择机场：</dt>
             <dd id="dd_airPort">
                <select id="Select_airPort">
                    <option value="0">请选择机场</option>
                </select>
            </dd>
            <dt>下车城市：</dt>
            <dd>
                <select id="downProvice">
                    <option value="0">请选择省</option>
                </select>
                <select id="downCity">
                    <option value="0">请选择市</option>
                </select>
                <select id="downCountry" name="downCountry">
                    <option value="0">请选择县</option>
                </select>
            </dd>
            <dt id="dt_downAddress">下车地址：</dt>
            <dd style="position: relative; z-index: 0;" id="dd_downAddress">
                <input class="per-input" type="text" id="downAddress" style="position: absolute;
                    z-index: 0; left: 0px; top: 0px;" name="downAddress" value="<%=updateQuickOrderCar.downAddress %>" />
                <input type="hidden" id="downAddress_Detail" name="downAddress_Detail" value="<%=updateQuickOrderCar.downAddressDetail %>" />
                <input type="hidden" id="downAddress_Position" name="downAddress_Position" value="<%=updateQuickOrderCar.downPosition %>" />
                <span id="downAddress_detail" class="backg"></span>
            </dd>
             <dt id="dt_downAirPort">选择机场：</dt>
             <dd id="dd_downAirPort">
                <select id="Select_downAirPort">
                    <option value="0">请选择机场</option>
                </select>
            </dd>
            <dt>使用车型：</dt>
            <dd style="min-height: 32px; _height: 32px; padding-top: 8px;">
                <select id="selectCars" name="selectCars">
                    <%foreach (var item in carFullTypes)
                  {
                      foreach (var item2 in item.CarBrands)
                      {
                          Response.Write( "<option value='" + item.RentCar.id + "' feeInclude='" + item.RentCar.feeIncludes + "' discountPrice='" + item.RentCar.DiscountPrice + "'>" + item2.brandName + "("+item.CarType.typeName+")</option>");
                      }
                  } %>
                    <option value="0">请选择车型</option>
                </select>
                <span id="carDiscount">起步价：<%=carFullTypes.FirstOrDefault()==null?"":carFullTypes.FirstOrDefault().RentCar.DiscountPrice.ToString() %>元、费用包含：<%=carFullTypes.FirstOrDefault() == null ? "" : carFullTypes.FirstOrDefault().RentCar.feeIncludes%> 
                可乘人数：<%=carFullTypes.FirstOrDefault() == null ? "" : carFullTypes.FirstOrDefault().CarType.passengerNum.ToString() %>人</span></dd>
            <dt>乘车人姓名：</dt>
            <dd>
                <select id="passangers">
                    <%foreach (var item in passangerList)
                      {%>
                    <option value="<%=item.TelePhone %>"><%=item.ContactName %></option>
                    <%} %>
                </select>
                <input type="hidden" name="passangers" />
                <a href="/PCenter/MyPassengerManager.aspx">添加常用乘车人</a>
            </dd>
            <dt>乘车人电话：</dt>
            <dd>
                <input class="per-input" type="text" value="<%=updateQuickOrderCar.passangerPhone%><%=firstPassangerPhone%>"
                    readonly="readonly" id="passangerTel" name="passangerTel" />
            </dd>
            <dt style="width: 100%;">
                <input type="hidden" id="isOrder" value="0" />
                <input type="hidden" id="orderCarID" value="<%=Request.QueryString["id"] %>"  name="orderCarID"/>
                <input type="hidden" id="address_up" provicecodeid="<%=upCityFull.privoce.CodeId  %>"
                    citycodeid="<%=upCityFull.city.CodeId  %>" countrycodeid="<%=upCityFull.country.CodeId  %>"
                    cityname="<%=upCityFull.city.CityName  %>" countryname="<%=upCityFull.country.CityName  %>" />
                <input type="hidden" id="address_down" provicecodeid="<%=downCityFull.privoce.CodeId  %>"
                    citycodeid="<%=downCityFull.city.CodeId  %>" countrycodeid="<%=downCityFull.country.CodeId  %>"
                    cityname="<%=downCityFull.city.CityName  %>" countryname="<%=downCityFull.country.CityName  %>" />
                <input type="hidden" id="caruseway_update" value="<%=updateQuickOrderCar.carUseWayID %>" />
                <input class="yc-btn bank-btn per-button-border" id="save" type="button" value="保存"
                    style="margin-left: 35px;" onclick="submitForm(0)" />
              
            </dt>
            <dd style="display: none">
            </dd>
        </dl>
        </form>
    </div>
</asp:Content>
