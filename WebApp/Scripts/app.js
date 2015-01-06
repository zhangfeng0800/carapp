

function fillSelect(id, data, textName, valueName) {
    if (data.length == 0) {
        return;
    } else {
        var html = "<option value='0'>请选择</option>";

        $.each(data, function (index, val) {
            if (val[textName] && val[valueName] && val["carusewayID"]!=8) {
                html += "<option value='" + val[valueName] + "'>" + val[textName] + "</option>";
            }
        });
        $(id).html(html);
    }
}

function getProvinceName(id, val) {
    $.ajax({
        url: "/api/orderapi/GetProvinceList.ashx",
        data: { type: val },
        type: "post",
        success: function (data) {
            if (data.StatusCode == "0") {
                return;
            }
            fillSelect(id, data.Data, "provinceName", "provinceID");
        }
    });
}
function getCityListByPro(provinceId, elementId, type) {
    if (provinceId == "0") {
        $(elementId).val("0");
        return;
    }
    $(elementId + " option:gt(0)").remove();
    $.ajax({
        url: "/api/orderapi/getCityList.ashx?provinceId=" + provinceId + "&type=" + type,
        success: function (data) {
            if (data.StatusCode == "0") {
                return;
            }
            fillSelect(elementId, data.Data, "cityName", "cityID");
        }
    });
}
function getTownByCity(cityid, elementid, type) {
    if (cityid == 0) {
        $(elementid).val("0");
        return;
    }
    $(elementid + "option:gt(0)").remove();
    $.ajax({
        url: "/api/orderapi/gettownlist.ashx?cityid=" + cityid + "&type=" + type,
        success: function (data) {
            if (data.StatusCode == 0) {
                return;
            }
            fillSelect(elementid, data.Data, "townname", "townid");
        }
    });
}
function showRoundTrip(val) {
    if (val == "6") {
        $("#isroundtrip").css("display", "block");
        $.ajax({
            url: "api/orderapi/GetHotLineByCity.ashx?cityId=" + $("#input_town").val(),
            success: function (data) {
                $('#hotlinename option:gt(0)').remove();
                if (data.StatusCode == "0") {

                    return;
                }
                var ci = "";
                $.each(data.Data, function (index, value) {
                    ci += '<option value=' + value.HotlineId + '>';
                    ci += value.targetCityName;
                    ci += '</option>';
                });
                $("#hotlinename").append(ci);
            }
        });
    } else {
        $("#isroundtrip").css("display", "none");
    }
}
function checkTripStyle() {
    if ($("#hotlinename").val() == "0") {
        return;
    }
    var val = $("#hotlinename").val();
    $.ajax({
        url: "api/orderapi/GetHotLineStyle.ashx?hotlineId=" + val + "&cityId=" + $("#input_town").val(),
        success: function (data) {
            var html = "";
            if (data.StatusCode == 0) {
                $("#onePath").html("");
                $("#twoPath").html("");
                return;
            }
            if (data.Data.length == 1) {
                if (data.Data[0] == "0") {
                    $("#twoPath").html("<input id=\"roundway\" type=\"radio\" value=\"0\" name=\"is_round\" />往返");
                    $("#onePath").html("");
                } else {
                    $("#onePath").html("<input id=\"singleway\" type=\"radio\"  checked=\"checked\" value=\"1\" name=\"is_round\" />单程");
                    $("#twoPath").html("");
                }
                return;
            }
            $.each(data.Data, function (index, values) {

                if (values.isoneway == "1") {
                    $("#onePath").html("<input id=\"singleway\" type=\"radio\"  checked=\"checked\" value=\"1\" name=\"is_round\" />单程");
                } else {
                    $("#twoPath").html("<input id=\"roundway\" type=\"radio\" value=\"0\" name=\"is_round\" />往返");
                }
            });
        }
    });
}
function getServiceType(cityId, element) {
    $.ajax({
        url: "/api/orderapi/GetCarUseWayByCity.ashx?cityId=" + cityId,
        success: function (data) {
            var html = "";
            if (data.StatusCode == 0) {
                return;
            }
            fillSelect(element, data.Data, "carusewayName", "carusewayID");

        }
    });
}
function getServiceByCity(cityId, elementId, url) {
    $.ajax({
        url: "/api/orderapi/GetCarUseWayByCity.ashx?cityId=" + cityId,
        success: function (data) {
            var html = "";
            if (data.StatusCode == 0) {
                return;
            }
            $.each(data.Data, function (index, val) {
                if (val.carusewayID != 8) {
                   
                    if (data.Data.length == 1) {
                        html += "<li class=\"clearfix\"><input class=\"choose-radio\" onclick=\"showRoundTrip('" + val.carusewayID + "')\" type=\"radio\" name=\"zcType\"  value=\"" + val.carusewayID + "\"/><em class=\"yc-ico\">  <img src=\"/images/" + val.carusewayID + ".jpg\" alt=\"\" />" + val.carusewayName + " <span class=\"yc-gray\">(" + val.Description + ")</span></em></li>";
                        if (val.carusewayID == 6) {
                            html += "<li id='isroundtrip' class=\"hotline_to_pos_area\" style=\"margin-left: 20px; display:none; \"><select onchange=\"checkTripStyle()\" id=\"hotlinename\" name=\"hotline_to_pos_ZW\" style=\"width: 105px;\"><option value=\"0\">请选择目的城市</option></select><label id=\"onePath\"></label><label id=\"twoPath\"></label></li>";
                        }
                    } else {
                        if (index == 0) {
                            html += "<li class=\"clearfix\"><input onclick=\"showRoundTrip('" + val.carusewayID + "')\" checked=\"checked\" class=\"choose-radio\" type=\"radio\" name=\"zcType\"  value=\"" + val.carusewayID + "\"/><em class=\"yc-ico\">  <img src=\"/images/" + val.carusewayID + ".jpg\" alt=\"\" />" + val.carusewayName + " <span class=\"yc-gray\">(" + val.Description + ")</span></em></li>";
                            if (val.carusewayID == "6") {
                                html += "<li id='isroundtrip' class=\"hotline_to_pos_area\" style=\"margin-left: 20px; display:none\"><select onchange=\"checkTripStyle()\" id=\"hotlinename\" name=\"hotline_to_pos_ZW\" style=\"width: 105px;\"><option value=\"0\">请选择目的城市</option></select><label id=\"onePath\"></label><label id=\"twoPath\"></label></li>";
                            }
                        } else {
                            html += "<li class=\"clearfix\"><input class=\"choose-radio\" onclick=\"showRoundTrip('" + val.carusewayID + "')\" type=\"radio\" name=\"zcType\"  value=\"" + val.carusewayID + "\"/><em class=\"yc-ico\">  <img src=\"/images/" + val.carusewayID + ".jpg\" alt=\"\" />" + val.carusewayName + " <span class=\"yc-gray\">(" + val.Description + ")</span></em></li>";
                            if (val.carusewayID == 6) {
                                html += "<li id='isroundtrip' class=\"hotline_to_pos_area\" style=\"margin-left: 20px; display:none; \"><select onchange=\"checkTripStyle()\" id=\"hotlinename\" name=\"hotline_to_pos_ZW\" style=\"width: 105px;\"><option value=\"0\">请选择目的城市</option></select><label id=\"onePath\"></label><label id=\"twoPath\"></label></li>";
                            }
                        }
                    }
                }

            });
            $(elementId).html(html);
        }
    });
}
function postUseType() {
    var provinceId = $("#select_province").val();
    var cityId = $("#select_city").val();
    var use = $('input:radio[name="type"]:checked').val();
    if (use == "6") {
        if ($("#hotlineName").val() == 0) {
            alert("请选择热门线路目的地！");
            return;
        } else {
            window.location.href = "/SelectCar.aspx?cityID=" + cityId + "&useType=" + use + "&hotlineId=" + $("#hotlinename").val() + "&lineType=" + $('input:radio[name="is_round"]:checked').val();
        }
    } else {
        window.location.href = "/SelectCar.aspx?cityID=" + cityId + "&useType=" + use;
    }

}
function GetCars(cityId, useType, container, hotlineId, lineType) {
    //    var others;
    //    if (useType == "3" || useType == "4" || useType == "5") {
    //        others = "费用不包含高速费和停车费";
    //    } else {
    //        others = "费用包含高速费，不含停车费";
    //    }
    var search = "";
    if (arguments.length == 3) {
        search = "cityid=" + cityId + "&usewayid=" + useType;
    } else if (arguments.length == 5) {
        search = "cityId=" + cityId + "&useType=" + useType + "&hotlineId=" + hotlineId + "&lineType=" + lineType;
    } else {
        alert("参数错误");
        return;
    }
    $.ajax({
        url: "/api/selectcarapi/GetCars.ashx?" + search,
        success: function (data) {
            if (data.StatusCode == "0") {
                $(container).html("<div class=\"car-mod-info clearfix\">暂无可用车型</div>");
                return;
            }
            $(container).html("");
            var html = "";

            $.each(data.Data, function (index, val) {
                var carname = getBrandNames(val.rentCarID);
                var imgurl = "";
                if (val.carTypeImage != "") {
                    imgurl = "http://admin.iezu.cn/" + val.carTypeImage;
                } else {
                    imgurl = "/images/dailyrent.jpg";
                }
                html += "<dl class=\"car-mod-info clearfix\"><dt><img src=\"" + imgurl + "\" alt=\"\" /></dt><dd><h4 class=\"car-mod-til\">" + val.typeName + "<em>（" + carname + "等）</em></h4><ul class=\"car-mod-ul\"><li>可乘人数：" + val.passengerNum + "人</li><li><span style='float:left'>费用包含：</span> <span class=\"span-btn\">油</span> <span class=\"span-btn\">驾</span> <span class=\"span-btn\">险</span> </li><li>" + val.feeIncludes + "</li><li style=\" visibility:hidden;\">palceholder</li><li>超时费用：" + parseFloat(val.hourPrice).toFixed(2) + "元/分钟</li><li>超公里费：" + parseFloat(val.kiloPrice).toFixed(2) + "元/公里</li><li style=\"width:300px;\">备注：" + val.others + "</li><li>套餐价：<del>" + val.startPrice.toFixed(2) + "元</del></li><li >推广价：<em class=\"price-num\">" + val.discountprice.toFixed(2) + "元</em></li><li class=\"choose-mod-yuding\"><a href=\"javascript:;\" onclick=\"checkLogin('" + val.rentCarID + "')\">预订</a> </li></ul></dd></dl>";
            });

            $(container).html(html);
        }
    });
}

function getBrandNames(id) {
    var brandName = "";
    $.ajax({
        url: "/api/selectcarapi/GetCarBrand.ashx?rentId=" + id,
        async: false,
        success: function (data) {
            if (data.StatusCode == "0") {
                return;
            }
            $.each(data.Data[0].Table, function (index, val) {
                if (index == data.Data.length - 1) {
                    brandName += "<span> " + val.brandName + "</span>";
                } else {
                    brandName += "<span> " + val.brandName + "</span>|";
                }
            });
        }
    });
    return brandName;
}

function getSelectCarRight(cityid, usetype, linetype) {
    var request = "";
    request += "cityId=" + cityid + "&useType=" + usetype;
    if (linetype != null) {
        request += "&lineType=" + linetype;
    }
    $.ajax({
        url: "/api/selectcarapi/selectcarright.ashx?" + request,
        success: function (data) {

            $("#typeName").text(data.Data.usetype);
            if (data.Data.linetype != "") {
                $("#cityName").text(data.Data.targetPlace + "->" + data.Data.cityname + "(" + data.Data.linetype + ")");
            } else {
                $("#cityName").text("用车城市：" + data.Data.cityname);
            }

        }
    });
}

function checkLogin(rendCarId) {
    var url = window.location.href;
    $.ajax({
        url: "/api/checklogin.ashx",
        data: { url: url },
        type: "post",
        success: function (data) {
            if (data.StatusCode == "0") {
                if (data.Data == 1) {
                    alert(data.Message);
                    return false;
                }
                window.location.href = "/login.aspx?returnVal=" + url;
            } else {
                window.location.href = "/makeorder.aspx?transdata=" + rendCarId;
            }
        }
    });
}
function checkLoginAndDirect(rendCarId, urlpalce) {
    var url = window.location.href;
    $.ajax({
        url: "/api/checklogin.ashx",
        data: { url: url },
        type: "post",
        success: function (data) {
            if (data.StatusCode == "0") {
                if (data.Data == 1) {
                    alert(data.Message);
                    return false;
                }
                window.location.href = "/login.aspx?returnVal=" + url;
            } else {
                window.location.href = "/makeorder.aspx?transdata=" + rendCarId;
            }
        }
    });
}
function btnSubmitData(rentCarID) {
    $.ajax({
        url: "/api/checklogin.ashx",
        success: function (data) {
            if (data.StatusCode == 1) {
                window.location.href = "/OrderInfo.aspx?transdata=" + rentCarID;
            } else {
                var i = $.layer({
                    type: 1,
                    title: false,
                    closeBtn: true,
                    border: [0],
                    area: ['302px', '200px'],
                    page: { dom: '#baidu' }
                });
                $('#btncancle').on('click', function () {
                    layer.close(i);
                });
            }
        }
    });

}
function substr(str) {
    var returnstr;
    if (str.indexOf('.') > 0) {
        str = str.substr(0, str.indexOf('.') + 2);
    } else { }
}
function userLogin(username, password) {
    if (username == "" || password == "") {
        alert("用户名或密码不能为空！");
        return;
    }
    $.ajax({
        url: "/api/login.ashx",
        type: "post",
        data: { username: username, password: password },
        success: function (data) {
            if (data.result == "0") {
                $("#loginoutanchor").show();
                $("#loginanchor").hide();
                $("#registeranchor").hide();
                $("#currentuser").text(data.accountInfo.Username);
                $("#xubox_layer1").hide();
                $("#xubox_shade1").hide();
            }
            else {
                $("#userName").focus();
            }
        }
    });
}

function getHotCity() {
    $.ajax({
        url: "/api/getHotCityList.ashx",
        type: "get",
        async: false,
        success: function (data) {
            $("#hotcityContainer").html("");
            if (data.StatusCode == 1) {
                var html = "";
                $.each(data.Data, function (index, val) {
                    html += " <li><a href=\"#tabs-" + (index + 1) + "\">" + val.cityname + "</a></li>";
                    $.ajax({
                        url: "/api/gethotline.ashx?cityId=" + val.cityID,
                        async: false,
                        success: function (result) {

                            if (result.StatusCode == 0) {
                                return;
                            } else {
                                var hotresult = result.Data;
                                var text = "";
                                $("#hotline" + (index + 1)).html("");
                                $.each(hotresult, function (hotindex, hotval) {
                                    text += "<tr><td><a href=\"\"> <img class=\"hot-line-img\" src=\"images/tam.jpg\" alt=\"\" /></a>";
                                    text += "   </td><td>";
                                    text += hotval.linename;
                                    text += "</td>";
                                    text += "<td>";
                                    var cartype = hotval.cartype;
                                    $.each(cartype, function (cartypeindex, cartypeval) {
                                        text += cartypeval.typename + "<br/>";
                                    });
                                    text += "</td><td>";
                                    $.each(hotval.SingleWay, function (singleindex, singleval) {
                                        text += singleval.TripName + "  <em class=\"price\">" + singleval.Price + "￥/趟</em><br />";
                                    });
                                    text += "</td><td>";
                                    $.each(hotval.RoundWay, function (roundindex, roundval) {
                                        text += roundval.TripName + "  <em class=\"price\">" + roundval.Price + "￥/趟</em><br />";
                                    });
                                    text += "</td><td>  <a href=\"/ChooseCar.aspx?cityid=" + val.cityID + "&carusewayid=6&hotlineId=" + hotval.hotlineid + "&lineType=1\" class=\"book-line-btn\">单程预订</a>" +
                                        "<br/> <a href=\"/ChooseCar.aspx?cityid=" + val.cityID + "&carusewayid=6&hotlineId=" + hotval.hotlineid + "&lineType=0\" class=\"book-line-btn\">往返预订</a></td></tr>";
                                });
                                $("#hotline" + (index + 1)).html(text);
                            }
                        }
                    });

                });
                $("#hotcityContainer").html(html);
            } else {
                $("#hotcityContainer").html("");
                return;
            }
        }
    });
}
function getCityByUseway(usewayid, element) {
    $.ajax({
        url: "/api/getCityByUseway.ashx?wayid=" + usewayid,
        type: "get",
        success: function (data) {
            if (data.StatusCode == 0) {
                return;
            } else {
                fillSelect(element, data.Data, "cityname", "cityid");
            }
        }
    });
}
function getHotLineContent(container) {
    $.ajax({
        url: "/api/gethotlinecontent.ashx",
        type: "get",
        success: function (data) {
            if (data.StatusCode == 0) {
                return;
            } else {

            }
        }
    });
}

function GetHotLineByid(cityid, topnum) {
    if (cityid == 0) {
        $("#hotline1").html("");

        return;
    }
    $("#moreline").attr("href", "/hotline.aspx?cityid=" + cityid);
    $.ajax({
        url: "/api/gethotline.ashx?cityId=" + cityid + "&num=" + topnum,
        async: false,
        success: function (result) {

            if (result.StatusCode == 0) {
                $("#hotline1").html("");
                return;
            } else {
                var hotresult = result.Data;
                if (hotresult.length == 0) {
                    $("#hotline1").html("暂无此类型车辆");
                    return;
                }
                var text = "";
                $("#hotline1").html("");
                $.each(hotresult, function (hotindex, hotval) {
                    var imgurl = "";
                    if (hotval.ImgUrl != "") {
                        imgurl = "http://admin.iezu.cn" + hotval.ImgUrl;
                    } else {
                        imgurl = "/images/defaultsmall.jpg";
                    }
                    text += "<tr style='border-bottom:1px dashed #ddd;'><td><a href=\"javascript:;\"> <img class=\"hot-line-img\" src=\"" + imgurl + "\" alt=\"\" /></a>";
                    text += "   </td><td>";
                    text += " <p style=\"text-align:center;\">" + hotval.linename.split('-')[0] + "</p>";
                    text += "	<p style=\"text-align:center;\"><img src=\"images/jiantou.gif\" alt=\"\" /></p>";
                    text += "    	<p style=\"text-align:center;\">" + hotval.linename.split('-')[1] + "</p>";
                    text += " </td>";
                    text += "<td>";
                    var cartype = hotval.cartype;
                    $.each(cartype, function (cartypeindex, cartypeval) {
                        text += cartypeval.typename + "<br/>";
                    });
                    text += "</td><td>";
                    $.each(hotval.SingleWay, function (singleindex, singleval) {
                        text += singleval.TripName + "  <em class=\"price\">" + singleval.Price + "￥/趟</em><br />";
                    });
                    text += "</td><td>";
                    $.each(hotval.RoundWay, function (roundindex, roundval) {
                        text += roundval.TripName + "  <em class=\"price\">" + roundval.Price + "￥/趟</em><br />";
                    });

                    text += "</td><td>  <a href=\"/ChooseCar.aspx?cityid=" + cityid + "&carusewayid=6&hotlineId=" + hotval.hotlineid + "&lineType=1\" class=\"book-line-btn\">单程预订</a>" +
                                        "<br/> <a href=\"/ChooseCar.aspx?cityid=" + cityid + "&carusewayid=6&hotlineId=" + hotval.hotlineid + "&lineType=0\" class=\"book-line-btn\">往返预订</a></td></tr>";
                });
                $("#hotline1").html(text);
            }
        }
    });
}
function getHotCityList() {
    //    $.jBox.tip("loading...", 'loading');
    $.ajax({
        url: "/api/getHotCityList.ashx",
        async: false,
        success: function (data) {
            if (data.StatusCode == 0) {
                return;
            } else {
                var html = "";
                $.each(data.Data, function (index, val) {
                    if (index == 0) {
                        $("#firsthotcity").val(val.cityID);
                        html += " <a class=\"selected\" href=\"javascript:;\" id=\"hotcity" + val.cityID + "\" style=\"padding: 2px 5px;\" onclick=\"showSeletCity('#hotcity" + val.cityID + "','" + val.cityID + "')\">" + val.citynames + val.cityname + "</a>";
                    } else {
                        html += " <a  id=\"hotcity" + val.cityID + "\" href=\"javascript:;\" style=\"padding: 2px 5px;\" onclick=\"showSeletCity('#hotcity" + val.cityID + "','" + val.cityID + "')\">" + val.citynames + val.cityname + "</a>";
                    }

                });
                $("#hotcitycontainer").html(html);

            }
        }
    });
}

function getCityByLetter(lindex, element) {
    $.ajax({
        url: "/api/getCityByLetter.ashx?index=" + lindex,
        success: function (data) {
            if (data.StatusCode == 0) {
                return;
            } else {
                var html = "";
                $.each(data.Data, function (index, val) {
                    html += " <a href=\"javascript:;\">" + val.cityname + "</a>";
                });
                $(element).html(html);
            }
        }
    });
}

function getairportProvinceName(element) {
    $.ajax({
        url: "/api/makeorder/getprovincebyairport.ashx",
        success: function (data) {
            if (data.StatusCode == 0) {
                $(element).html("");
                return;
            }
            fillSelect(element, data.Data, "cityname", "codeid");
        }
    });
}
function getairportcity(provinceid, element) {
    $.ajax({
        url: "/api/makeorder/getcitybyairport.ashx?provinceid=" + provinceid,
        success: function (data) {
            if (data.StatusCode == 0) {
                $(element).html("");
                return;
            }
            fillSelect(element, data.Data, "cityname", "codeid");
        }
    });
}

function getairporttown(cityid, element) {
    $.ajax({
        url: "/api/makeorder/gettownbyairport.ashx?cityid=" + cityid,
        success: function (data) {
            if (data.StatusCode == 0) {
                $(element).html("");
                return;
            }
            fillSelect(element, data.Data, "cityname", "codeid");
        }
    });
}

function getairportBytown(townid, element) {
    $.ajax({
        url: "/api/makeorder/getairportbytown.ashx?townid=" + townid,
        success: function (data) {
            if (data.StatusCode == 0) {
                $(element).html("");
                return;
            }
            fillSelect(element, data.Data, "airportName", "id");
        }
    });
}
function getcityinfo(element, type, id) {

    $.ajax({
        url: "/api/orderapi/getTargetCityList.ashx?type=" + type + "&id=" + id,
        success: function (data) {
            if (data.StatusCode == 0) {
                $(element).html("");
                return;
            }
            fillSelect(element, data.Data, "cityname", "codeid");
        }
    });
}


function gethour(dt, element, type) {
    var ar = [];
    var now = moment().format("YYYY-MM-DD");
    if (now == dt) {
        if (moment().get("hour") > 22 && moment().get("hour") < 8) {
        } else {
            if (type == 2) {
                var hour = moment().add("hours", 1).add("minutes", 10).hour();
                for (var k = hour; k < 24; k++) {
                    ar.push(k);
                }
            } else {
                var hour = moment().add("hours", 2).add("minutes", 10).hour();
                for (var i = hour; i < 24; i++) {
                    ar.push(i);
                }
            }
        }
    } else {
        for (var i = 0; i < 24; i++) {
            ar.push(i);
        }
    }
    var html = "";
    html += "<option value='-1'>时</option>";
    for (var j = 0; j < ar.length; j++) {
        html += "<option value='" + ar[j] + "'>" + ar[j] + "</option>";
    }

    $(element).html(html);
}
function getMinutes(hour, elminute, type) {
    var ar = [];
    if (type == 2) {

        if (hour == moment().add("hours", 1).add("minutes", 10).hour()) {
            var minute = moment().add("hours", 1).add("minutes", 10).minute();
            var yushu = 5 - minute % 5;
            for (var i = minute + yushu; i < 60; i += 5) {
                ar.push(i);
            }
        } else {
            for (var i = 0; i < 60; i += 5) {
                ar.push(i);
            }
        }
    } else {
        if (hour == moment().add("hours", 2).add("minutes", 10).hour()) {
            var minute = moment().add("hours", 2).add("minutes", 10).minute();
            var yushu = 5 - minute % 5;
            for (var i = minute + yushu; i < 60; i += 5) {
                ar.push(i);
            }
        } else {
            for (var i = 0; i < 60; i += 5) {
                ar.push(i);
            }
        }
    }
    var html = "";
    html += "<option value='-1'>分</option>";
    for (var i = 0; i < ar.length; i++) {
        html += "<option value='" + ar[i] + "'>" + ar[i] + "</option>";
    }
    $(elminute).html(html);
}
var useway;
function showdiv() {
    $("div[id^='useway']").hide();
    if (!window.location.search) {
        window.location.href = "/";
    } else {
        var search = window.location.search;
        $.ajax({
            url: "/api/orderapi/showway.ashx" + search,
            type: "get",
            success: function (data) {
                if (data.StatusCode == 1) {
                    if (data.Data == 3 || data.Data == 4 || data.Data == 5) {

                        useway = data.Data;
                        $("#useway4").show();
                        $("#usewayid").val(data.Data);
                        if (data.Data == 3) {
                            $("#txt_rizu_useHour").val("1");
                            $("#txt_rizu_useHour").attr("disabled", "disabled");
                        } else if (data.Data == 4) {
                            $("#txt_rizu_useHour").val("8");
                            $("#txt_rizu_useHour").attr("disabled", "disabled");
                        } else {
                            $("#txt_rizu_useHour").val("4");
                            $("#txt_rizu_useHour").attr("disabled", "disabled");
                        }
                        getcityinfo("#txt_rizu_province", "province", 0);
                        $("#txt_rizu_province").change(function () {
                     
                            getcityinfo("#txt_rizu_city", "city", $(this).val());
                        });
                        $("#txt_rizu_city").change(function () {
                       
                            getcityinfo("#txt_rizu_town", "town", $(this).val());
                        });
                        getcityName("#txt_rizu_pct", "#txt_rizu_startprovince", "#txt_rizu_startcity", "#txt_rizu_starttown");

                    } else if (data.Data == 1) {
                        getJieJiData();
                        getcityName("#txt_jieji_pct", "#txt_jieji_provinceid", "#txt_jieji_cityid", "#txt_jieji_townid");
                        getcityinfo("#txt_jieji_province", "province", 0);
                        $("#txt_jieji_province").change(function () {
                            getcityinfo("#txt_jieji_city", "city", $(this).val());
                         
                        });
                        $("#txt_jieji_city").change(function () {
                            getcityinfo("#txt_jieji_muditown", "town", $(this).val());

                        });
                    } else if (data.Data == 2) {
                        getcityName("#txt_songji_pct", "#txt_songji_province", "#txt_songji_city", "#txt_songji_town");
                        getairportProvinceName("#txt_songji_mudiprovince");
                        $("#txt_songji_mudiprovince").change(function () {
                            getairportcity($(this).val(), "#txt_songji_mudicity");
                        });

                        $("#txt_songji_mudicity").change(function () {
                            getairporttown($("#txt_songji_mudicity").val(), "#txt_songji_muditown");
                        });
                        $("#txt_songji_muditown").change(function () {
                            getairportBytown($(this).val(), "#txt_songji_airportName");
                        });
                    } else if (data.Data == 6) {
                        getHotLineName();
                        getProvinceName("#txt_hotline_province");
                        $("#txt_hotline_province").change(function () {
                            getCityListByPro($(this).val(), "#txt_hotline_city");
                        });
                    }
                    else {

                    }
                    $("#useway" + data.Data).show();
                    $("#usewayid").val(data.Data);
                    $("#rentId").val(search.substring(1).split('&')[0].split('=')[1]);
                } else {
                    window.location.href = "/login.aspx?returnVal=" + window.location.href;
                }
            }
        });
    }
}
function getJieJiData() {
    var search = window.location.search;
    $.ajax({
        url: "/api/makeorder/getairportByCityid.ashx" + search,
        success: function (data) {
            if (data.StatusCode == 0) {
                return;
            } else {
                var html = "";
                $.each(data.Data, function (index, val) {
                    html += "<option value='" + val.id + "'>" + val.airportName + "</option>";
                });
                $("#txt_jieji_airportname").append(html);
                var provinceinfo = "<option value='" + data.Data.provinceid + "'>" + data.Data.provincename + "</option>";
                $("#txt_jieji_provinceid").html(provinceinfo);
                var cityinfo = "<option value='" + data.Data.cityid + "'>" + data.Data.citysname + "</option>";
                $("#txt_jieji_cityid").html(cityinfo);
                var towninfo = "<option value='" + data.Data.townid + "'>" + data.Data.townname + "</option>";
                $("#txt_jieji_townid").html(towninfo);
            }
        }
    });
}
function getcityName(namecontainer, elementpro, elementcity, elementtown) {
    var search = window.location.search;
    $.ajax({
        url: "/api/makeorder/getcityname.ashx" + search,
        success: function (data) {
            if (data.StatusCode == 0) {
                return;
            } else {
                $(namecontainer).val(data.Data.provincename + data.Data.cityname + data.Data.townname);
                $(elementpro).val(data.Data.provinceid);
                $(elementcity).val(data.Data.cityid);
                $(elementtown).val(data.Data.townid);
            }
        }
    });
}
function getHotLineName() {
    var search = window.location.search;
    $.ajax({
        url: "/api/makeorder/gethotlineCityName.ashx" + search,

        success: function (data) {
            if (data.StatusCode == 0) {
                return;
            } else {
                $("#txt_hotline_provinceid").val(data.Data.provinceid);
                $("#txt_hotline_cityid").val(data.Data.cityid);
                $("#txt_hotline_townid").val(data.Data.startid);
                $("#txt_hotline_pct").val(data.Data.startcityname + data.Data.townname);
                $("#txt_hotline_targetname").val(data.Data.targetprovince + data.Data.targetcity + data.Data.cityname);
                $("#txt_hotline_targetcityid").val(data.Data.endid);
            }
        }
    });
}

function substr(str) {
    if (str.length > 50) {
        return str.substring(0, 50) + '...';
    } else {
        return str;
    }
}
function getTravelList(cityid, container, idlist) {
    $.ajax({
        url: "/api/gettravellist.ashx",
        data: { cityid: cityid, idlist: idlist },
        type: "post",
        async: false,
        success: function (data) {
            if (data.CodeId == 0) {
                $(container).html("");
            } else {
                var html = "";
                if (data.Data.length == 0) {
                    $(container).html("暂无此类型的线路");
                    return;
                }
                $.each(data.Data, function (index, val) {
                    var themelist = "";
                    if (val.SpotInfo.ThemeList.length == 0) {
                        themelist = "";
                    } else {
                        $.each(val.SpotInfo.ThemeList, function (tinde, tval) {
                            themelist += "   <em class=\"travel_class\">" + tval.NAME + "</em>";
                        });
                    }
                    html += "<div class=\"Tour_list clearfix\"><dl class=\"Tour_img\"><dt><a href=\"/spotInfo.aspx?id=" + val.SpotInfo.HotLineId + "\" target=\"_blank\"><img src=\"http://admin.iezu.cn/" + val.SpotInfo.SpotImg + "\" alt=\"\" /><p>景点介绍</p></a><span>" + themelist + "</span></dt><dd><div class=\"Tour_info clearfix\"><div class=\"Tour_til\"><strong>" + val.SpotInfo.StartPlace + "→" + val.SpotInfo.EndPlace + "</strong><em class=\"Tour_scenic_info\">★" + substr(val.SpotInfo.Summary) + "[<a href=\"/spotInfo.aspx?id=" + val.SpotInfo.HotLineId + "\" target=\"_blank\">详细</a> ]</em></div></div><ul class=\"Tour_goods\" id=\"catypeContainer" + index + "\"><li><em id=\"includesfee" + index + "\">" + val.SpotInfo.Includes + "</em>&nbsp;&nbsp;&nbsp;费用包含：<em class=\"travle_gray\">油</em> <em class=\"travle_gray\">驾</em> <em class=\"travle_gray\">险</em> </li> <li>超时费用：<em id=\"hourprice" + index + "\">" + val.SpotInfo.HourPrice + "</em>元/分钟  &nbsp;&nbsp;&nbsp;&nbsp;  超公里费：<em id=\"kiloprice" + index + "\">" + val.SpotInfo.KiloPrice + "</em>元/公里</li><li >可乘人数：<em id=\"passengernum" + index + "\">" + val.SpotInfo.FirstNum + "</em>人</li>  <li>备注：费用包含高速费，不含停车费</li>";
                    $.each(val.RentInfo, function (rentIndex, rentVal) {
                        if (rentIndex == 0) {
                            html += "<li><em onclick=\"clickToSelected(this," + rentVal.RentCarId + "," + index + ")\" id=\"cartypeid" + rentVal.RentCarId + "\" class=\"Tour_carType Tour_carType_selected\">" + rentVal.CarTypeName + "： ";
                        } else {
                            html += "<li><em onclick=\"clickToSelected(this," + rentVal.RentCarId + "," + index + ")\" id=\"cartypeid" + rentVal.RentCarId + "\"  class=\"Tour_carType\">" + rentVal.CarTypeName + "： ";
                        }
                        $.each(rentVal.CarBrands, function (brandindex, brandval) {
                            html += " <a href=\"carinfo.aspx?id=" + brandval.id + "\" target=\"_blank\">" + brandval.brandName + "</a>";
                        });
                        html += "<em style=\"position:absolute; right:20px;\">请选择</em></em></li>";
                    });
                    html += "</ul><div class=\"Tour_ticket\"><span class=\"Tour_ticket_info\">门票<em id=\"ticketPrice" + index + "\">" + val.SpotInfo.SpotPrice + "</em>元/张 门票 </span> <span class=\"clearfix\"><a onclick=\"minNum('" + index + "')\" class=\"Tour_add\">-</a><input class=\"Tour_num\" type=\"text\" name=\"num\" value=\"0\" readonly=\"readonly\"  id=\"txtticketnum" + index + "\"/> <a class=\"Tour_add\" onclick=\"addNum('" + index + "')\">+</a></span><span class=\"Tour_ticket_info\">张</span></div>    <div class=\"AITour_price\"><del>套餐价：<em id=\"originPriceContainer" + index + "\">" + val.SpotInfo.OriginPrice + "</em>￥</del><em class=\"Tour_taocan\">推广价：<em id=\"priceContainer" + index + "\">" + val.SpotInfo.FirstPrice + "</em>￥</em><input id=\"txtPrice" + index + "\" type=\"hidden\" value=\"" + val.SpotInfo.FirstPrice + " \"/><input id=\"txtOriginPrice" + index + "\" type=\"hidden\" value=\"" + val.SpotInfo.OriginPrice + " \"/></div><a class=\"zuche-book Tour_btn\" href=\"javascript:;\" onclick=\"redirectToBookCar(" + index + "," + cityid + ")\">预定</a></dd></dl></div><input type=\"hidden\" id=\"rentid" + index + "\" value=\"" + val.SpotInfo.RentCarId + "\"/>";
                });
                $(container).html(html);
            }
        }
    });
}
function redirectToBookCar(index, cityid) {
    var rentid = $("#rentid" + index).val();
    var booknum = $("#txtticketnum" + index).val();
    window.location.href = "/makeorder.aspx?transdata=" + rentid + "&booknum=" + booknum + "&townid=" + cityid + "&istravel=1";
}
function addNum(index) {
    var num = parseInt($("#txtticketnum" + index).val());
    $("#txtticketnum" + index).val(num + 1);
    num = num + 1;
    var singlePrice = parseInt($("#ticketPrice" + index).text());
    var currentPrice = parseInt($("#txtPrice" + index).val());
    var orginPrice = parseInt($("#txtOriginPrice" + index).val());
    $("#priceContainer" + index).text(currentPrice + num * singlePrice);
    $("#originPriceContainer" + index).text(orginPrice + num * singlePrice);
}

function minNum(index) {
    var num = parseInt($("#txtticketnum" + index).val());
    if (num > 0) {
        $("#txtticketnum" + index).val(num - 1);
        num = num - 1;
        var singlePrice = parseInt($("#ticketPrice" + index).text());
        var currentPrice = parseInt($("#txtPrice" + index).val());
        var orginPrice = parseInt($("#txtOriginPrice" + index).val());
        $("#priceContainer" + index).text(currentPrice + num * singlePrice);
        $("#originPriceContainer" + index).text(orginPrice + num * singlePrice);
    }
}

function clickToSelected(element, rentcarId, pindex) {

    var elements = $("#catypeContainer" + pindex + " li em[id^='cartypeid']");
    $.each(elements, function (index, val) {
        $(val).removeClass("Tour_carType_selected");
    });
    $(element).addClass("Tour_carType_selected");
    var num = parseInt($("#txtticketnum" + pindex).val());
    var price = parseInt($("#ticketPrice" + pindex).text());

    var orginPrice = $("#txtOriginPrice" + pindex).val();
    $.ajax({
        url: "/api/getprice.ashx?rentcarId=" + rentcarId,
        success: function (data) {
            $("#priceContainer" + pindex).text(data.price + num * price);
            $("#originPriceContainer" + pindex).text(data.OriginPrice + num * price);
            $("#txtPrice" + pindex).val(data.price);
            $("#includesfee" + pindex).text(data.FeeIncludes);
            $("#passengernum" + pindex).text(data.num);
            $("#rentid" + pindex).val(rentcarId);

            $("#txtOriginPrice" + pindex).val(data.OriginPrice);
        }
    });
}