$(function () {
    setCarUseWay();
    setPassangers();
    getCitysService({ "useway": "1" }, "#upProvice", function () { setCitySelectValue(); });
    getCitys("0", "#downProvice", function () {
        setCitySelectValue();
    });
    $("#upProvice").change(function () {
        var provinceid = $(this).val();
        var usewayid = $("#caruseway").val();
        getCitysService({ "useway": usewayid, "province": provinceid }, "#upCity");
    });
    $("#upCity").change(function () {
        var provinceid = $("#upProvice").val();
        var usewayid = $("#caruseway").val();
        var cityid = $(this).val();
        getCitysService({ "useway": usewayid, "province": provinceid, "city": cityid }, "#upCountry");
    });
    $("#selectCars").change(function () {
        if ($(this).val() != "0") {
            var discountPrice = $(this).children("option[value='" + $(this).val() + "']").attr("discountPrice");
            var feeInclude = $(this).children("option[value='" + $(this).val() + "']").attr("feeInclude");
            var passengerNum = $(this).children("option[value='" + $(this).val() + "']").attr("passengerNum");
            $("#carDiscount").html("起步价：" + discountPrice + "元、费用包含：" + feeInclude + " 可乘人数：" + passengerNum + "人");
        }
    });
    $("#caruseway").change(function () {
        var carusewayid = $(this).val();
        $("#upProvice").html("<option value='0'>请选择省</option>");
        $("#upCity").html("<option value='0'>请选择市</option>");
        $("#upCountry").html("<option value='0'>请选择县</option>");
        $("#upAddress").val("");
        $("#downProvice").html("<option value='0'>请选择省</option>");
        $("#downCity").html("<option value='0'>请选择市</option>");
        $("#downCountry").html("<option value='0'>请选择县</option>");
        $("#downAddress").val("");
        getCitysService({ "useway": carusewayid }, "#upProvice", function () { setCitySelectValue(); });
        //        if (countryid != "0") {
        //            setRentCarList(carusewayid, countryid);
        //        }
        changeAddressAirPort(carusewayid);
        if (carusewayid == "2") {
            getAirPort_serviceCity("0", "0", "#downProvice");
        }
        else {
            getCitys("0", "#downProvice");
        }
    });
    $("#upCountry").change(function () {
        $("#upAddress").val("");
        var carusewayid = $("#caruseway").val();
        var countryid = $(this).val();
        setRentCarList(carusewayid, countryid);
        if (carusewayid == "1") {
            getAirPort($("#upCity").val(), "#Select_airPort");
        }
    });
    $("#downProvice").change(function () {
        $("#downAddress").val("");
        var pid = $(this).val();
        if ($("#caruseway").val() == "2") {
            getAirPort_serviceCity("province", pid, "#downCity");
        }
        else {
            getCitys(pid, "#downCity");
        }
    });
    $("#downCity").change(function () {
        var pid = $(this).val();
        if ($("#caruseway").val() == "2") {
            getAirPort_serviceCity("city", pid, "#downCountry");
        }
        else {
            getCitys(pid, "#downCountry");
        }

    });
    $("#downCountry").change(function () {
        $("#downAddress").val("");
        if ($("#caruseway").val() == "2") {
            getAirPort($("#downCity").val(), "#Select_downAirPort");
        }
    });
    $("#passangers").change(function () {
        var telPhone = $(this).val();
        $("#passangerTel").val(telPhone);
    });
    $("#upAddress").keyup(function () {
        $("#upAddress_position").val() == "";
        var query = $(this).val();
        var city = $("#upCity option[value='" + $("#upCity").val() + "']").html();
        getPlaceAPI(city, query, "#upAddress_detail");
    }).focus(function () {
        if ($("#upCountry").val() == "0") {
            alert("请选择上车城市");
            $("#upCountry").focus();
        }
    });
    $("#downAddress").keyup(function () {
        $("#downAddress_position").val() == "";
        var query = $(this).val();
        var city = $("#downCity option[value='" + $("#downCity").val() + "']").html();
        getPlaceAPI(city, query, "#downAddress_detail");
    }).focus(function () {
        if ($("#downCountry").val() == "0") {
            alert("请选择下车城市");
            $("#downCountry").focus();
        }
    });
});
function getCitys(parentID, id, fn) {
    var htmlString = "<option value='0'>请选择</option>";
    if (!$("#caruseway_update").val() == "") {
        if ($("#caruseway_update").val() == "2") {
            getAirPort_serviceCity("0", "0", "#downProvice");
            $("Select_downAirPort option").each(function () {
                if ($(this).html() == $("#address_down").attr("#upAddress")) {
                    $(this).attr("selected", "selected");
                }
            });
            return;
        }
    }
    $.post("../api/GetCitys.ashx", { "pid": parentID }, function (data) {
        for (var i = 0; i < data.length; i++) {
            htmlString += "<option value='" + data[i].codeid + "'>" + data[i].cityname + "</option>";
        }
        $(id).html(htmlString);
        fn();
    });
}
function getCitysService(parameter, id, callBack) {
    var htmlString = "<option value='0'>请选择</option>";
    $.post("/api/getCity_service.ashx", parameter, function (data) {
        if (id == "#upProvice") {
            for (var i = 0; i < data.length; i++) {
                htmlString += "<option value='" + data[i].Province.CodeId + "'>" + data[i].Province.CityName + "</option>";
            }
        }
        if (id == "#upCity") {
            for (var i = 0; i < data.length; i++) {
                htmlString += "<option value='" + data[i].City.CodeId + "'>" + data[i].City.CityName + "</option>";
            }
        }
        if (id == "#upCountry") {
            for (var i = 0; i < data.length; i++) {
                htmlString += "<option value='" + data[i].Country.CodeId + "'>" + data[i].Country.CityName + "</option>";
            }
        }
        $(id).html(htmlString);
        if (callBack) {
            callBack();
        }
    });
}
function getPlaceAPI(city, queryString, id) {
    var resultHtml = "";
    $.post("/api/baiduplaceapi.ashx", { "q": queryString, "c": city, "ishot": "0" }, function (data) {
    if (data.results.length == 0) {
        $(id).hide();
        return;
    }
        for (var i = 0; i < data.results.length; i++) {
            resultHtml += "<p detail='" + data.results[i].address + "'  onclick=\"setAddressDetail($(this),'" + id + "')\" position=\"" + data.results[i].location.lng + "," + data.results[i].location.lat + "\">" + data.results[i].name + "</p>";
        }
        $(id).show();
        $(id).html(resultHtml);
    });
}
function setAddressDetail(thisElement, divID) {
    var address = $(thisElement).html();
    var addressDetail = $(thisElement).attr("detail");
    var position = $(thisElement).attr("position");
    $(divID).hide();
    if (divID == "#downAddress_detail") {
        $(divID).siblings("input[id='downAddress']").val(address);
        $(divID).siblings("input[id='downAddress_Detail']").val(addressDetail);
        $(divID).siblings("input[id='downAddress_Position']").val(position);
    }
    else {
        $(divID).siblings("input[id='upAddress']").val(address);
        $(divID).siblings("input[id='upAddress_Detail']").val(addressDetail);
        $(divID).siblings("input[id='upAddress_position']").val(position);
    }
}
function setRentCarList(carUseWayID, countryID) {
    var resultHtml = "<option value='0'>请选择车型</option>";
    $.post("api/GetRentCarList.ashx", { "useWay": carUseWayID, "upCountryID": countryID }, function (data) {
        for (var i = 0; i < data.length; i++) {
            for (var j = 0; j < data[i].CarBrands.length; j++) {
                resultHtml += "<option value='" + data[i].RentCar.id + "' feeInclude='" + data[i].RentCar.feeIncludes + "' discountPrice='" + data[i].RentCar.DiscountPrice + "' passengerNum='" + data[i].CarType.passengerNum + "'>" + data[i].CarBrands[j].brandName + "(" + data[i].CarType.typeName + ")</option>";
            }
        }
        $("#selectCars").html(resultHtml);
    });
}
function submitForm(isOrder) {
    if (isOrder == 1) {
        $("#isOrder").val("1");
    }
    if ($("#caruseway").val() == "1") {
        setUpAddressByAirPort();
    }
    if ($("#caruseway").val() == "2") {
        setDownAddressByAirPort();
    }
    if ($("input[name='name']").val().trim() == "" || $("#upCountry").val() == "0" || $("#upAddress").val().trim() == "" || $("#downCountry").val() == "0") {
        alert("请填写完整信息！");
        return;
    }
    if ($("#downAddress").val().trim() == "" || $("#selectCars").val() == "0") {
        alert("请填写完整信息");
        return;
    }
    if ($("#downAddress_Position").val() == "") {
        alert("请填写正确的下车地址");
        return;
    }
    if ($("#upAddress_position").val() == "") {
        alert("请填写正确的上车地址");
        return;
    }
    var passangersValue = $("#passangers").val();
    passangersValue = $("#passangers option[value='" + passangersValue + "']").html();
    $("input[name='passangers']").val(passangersValue);
    $("#fastCarForm").submit();
}
function setCitySelectValue() {
    if (!$("#address_up").attr("proviceCodeID") == "") {
        var provice = $("#address_up").attr("proviceCodeID");
        var city = $("#address_up").attr("cityCodeID");
        var city_cityName = $("#address_up").attr("cityName");
        var country = $("#address_up").attr("countryCodeID");
        var country_name = $("#address_up").attr("countryName");
        $("#upProvice option[value='" + provice + "']").attr("selected", "selected");
        $("#upCity").html("<option value='" + city + "'>" + city_cityName + "</option>");
        $("#upCountry").html("<option value='" + country + "'>" + country_name + "</option>");
    }
    if (!$("#address_down").attr("proviceCodeID") == "") {
        var provice = $("#address_down").attr("proviceCodeID");
        var city = $("#address_down").attr("cityCodeID");
        var city_cityName = $("#address_down").attr("cityName");
        var country = $("#address_down").attr("countryCodeID");
        var country_name = $("#address_down").attr("countryName");
        $("#downProvice option[value='" + provice + "']").attr("selected", "selected");
        $("#downCity").html("<option value='" + city + "'>" + city_cityName + "</option>");
        $("#downCountry").html("<option value='" + country + "'>" + country_name + "</option>");
    }
}
function setCarUseWay() {
    if (!$("#caruseway_update").val() == "") {
        if ($("#caruseway_update").val() == "1") {
            getAirPort($("#address_up").attr("citycodeid"), "#Select_airPort");
            $("Select_airPort option").each(function () {
                if ($(this).html() == $("#address_up").attr("#upAddress")) {
                    $(this).attr("selected", "selected");
                }
            });
        }
        if ($("#caruseway_update").val() == "2") {
            getAirPort($("#address_down").attr("citycodeid"), "#Select_downAirPort");
            $("Select_downAirPort option").each(function () {
                if ($(this).html() == $("#address_down").attr("#upAddress")) {
                    $(this).attr("selected", "selected");
                }
            });
        }
        var usewayID = $("#caruseway_update").val();
        $("#caruseway option[value='" + usewayID + "']").attr("selected", "selected");
        changeAddressAirPort($("#caruseway").val());
    }
}
function setPassangers() {
    if (!$("#passangerTel").val() == "") {
        $("#passangers option[value='" + $("#passangerTel").val() + "']").eq(0).attr("selected", "selected");
    }
}
function changeAddressAirPort(carusewayid) {
    if (carusewayid == "1") {
        $("#dt_upAddress").hide();
        $("#dd_upAddress").hide();
        $("#dt_airPort").show();
        $("#dd_airPort").show();
        $("#dt_downAddress").show();
        $("#dd_downAddress").show();
        $("#dt_downAirPort").hide();
        $("#dd_downAirPort").hide();
        return;
    }
    if (carusewayid == "2") {
        $("#dt_downAddress").hide();
        $("#dd_downAddress").hide();
        $("#dt_downAirPort").show();
        $("#dd_downAirPort").show();
        $("#dt_upAddress").show();
        $("#dd_upAddress").show();
        $("#dt_airPort").hide();
        $("#dd_airPort").hide();
    }
    else {
        $("#dt_downAddress").show();
        $("#dd_downAddress").show();
        $("#dt_downAirPort").hide();
        $("#dd_downAirPort").hide();
        $("#dt_upAddress").show();
        $("#dd_upAddress").show();
        $("#dt_airPort").hide();
        $("#dd_airPort").hide();
    }
}
function getAirPort(cityid, elementid) {
    $.post("../api/GetAirportInfo.ashx", { "cityid": cityid }, function (data) {
        var html = "";
        for (var i = 0; i < data.length; i++) {
            html += "<option value='" + data[i].Id + "' lng='" + data[i].Lng + "' lat='" + data[i].Lat + "'>" + data[i].AirPortName + "</option>";
        }
        $(elementid).html(html);
    });
}
function getAirPort_serviceCity(type, codeID, elementID) {
    var params = {};
    if (type == "0" || codeID == "0") {
        $.post("/api/Get_airport_service.ashx", {}, function (data) {
            var htmlResult = "<option value='0'>请选择</option>";
            for (var i = 0; i < data.length; i++) {
                htmlResult += "<option value='" + data[i].Province.CodeId + "'>" + data[i].Province.CityName + "</option>";
            }
            $(elementID).html(htmlResult);
            if ($("#caruseway_update").val() == "2") {
                setCitySelectValue();
            }
        });
    }
    else {
        switch (type) {
            case "province":
                {
                    params = { "province": codeID };
                    $.post("/api/Get_airport_service.ashx", params, function (data) {
                        var htmlResult = "<option value='0'>请选择</option>";
                        for (var i = 0; i < data.length; i++) {
                            htmlResult += "<option value='" + data[i].City.CodeId + "'>" + data[i].City.CityName + "</option>";
                        }
                        $(elementID).html(htmlResult);
                    });
                } break;
            case "city":
                {
                    params = { "city": codeID };
                    $.post("/api/Get_airport_service.ashx", params, function (data) {
                        var htmlResult = "<option value='0'>请选择</option>";
                        for (var i = 0; i < data.length; i++) {
                            htmlResult += "<option value='" + data[i].Country.CodeId + "'>" + data[i].Country.CityName + "</option>";
                        }
                        $(elementID).html(htmlResult);
                    });
                } break;
            // case "country": { params = { "country": codeID} } break;         
            default: break;
        }

    }
}
function setUpAddressByAirPort() {
    var airPortID = $("#Select_airPort").val();
    var upAddress = $("#Select_airPort option[value='" + airPortID + "']").html();
    var upAddress_detail = upAddress;
    var upAddress_position = $("#Select_airPort option[value='" + airPortID + "']").attr("lng") + "," + $("#Select_airPort option[value='" + airPortID + "']").attr("lat");
    $("#upAddress").val(upAddress);
    $("#upAddress_Detail").val(upAddress_detail);
    $("#upAddress_position").val(upAddress_position);
}
function setDownAddressByAirPort() {
    var airPortID = $("#Select_downAirPort").val();
    var downAddress = $("#Select_downAirPort option[value='" + airPortID + "']").html();
    var downAddress_detail = downAddress;
    var downAddressposition = $("#Select_downAirPort option[value='" + airPortID + "']").attr("lng") + "," + $("#Select_downAirPort option[value='" + airPortID + "']").attr("lat");
    console.log(downAddressposition);
    $("#downAddress").val(downAddress);
    $("#downAddress_Detail").val(downAddress_detail);
    $("#downAddress_Position").val(downAddressposition);
}
