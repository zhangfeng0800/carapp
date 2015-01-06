
var allowTime = { "year": "0", "month": "0", "day": "0", "hour": "0", "minutes": "0" }
var REALORDERMONEY = 0;
var QUICKORDERID = 0;
Date.prototype.ToShortTime = function () {
    var datas = { "year": this.getFullYear(), "month": this.getMonth() + 1, "day": this.getDate() }
    if (datas.month < 10) {
        datas.month = "0" + datas.month;
    }
    if (datas.day < 10) {
        datas.day = "0" + datas.day;
    }
    allowTime.year = datas.year;
    allowTime.month = datas.month;
    allowTime.day = datas.day;
    return datas.year + "-" + datas.month + "-" + datas.day;
}
$(function () {
    var nowDate = new Date().ToShortTime();
    $("#shortDate").val(nowDate);
});
function DeleteQuickOrderCar(id) {
    if (confirm("确定要删除么？")) {
        $.post("api/DeleteQuickOrderCar.ashx", { "id": id }, function (data) {
            if (data == 1) {
                window.location.reload();
            }
        });
    }
}
function GoOrderCar(id) {
    $.post("/api/PermissionController.ashx", { action: "count", type: 3 }, function (data) {
        if (data > 5) {
            alert("对不起，您当天取消订单超过5次，不可下单。");
            return false;
        }
        else {
            QUICKORDERID = id;
            var rentcarID = $("#jsonString_" + id).attr("rentCarID");
            var quickOrderInfo = $("#jsonString_" + id).html();
            quickOrderInfo = eval("(" + quickOrderInfo + ")");
            var useHourHtml = "";
            if (quickOrderInfo.carUseWayID == 1 || quickOrderInfo.carUseWayID == 2) {
                $("#order_useHour").hide();
            }
            if (quickOrderInfo.carUseWayID == 3 || quickOrderInfo.carUseWayID == 7) {
                for (var i = 1; i < 9; i++) {
                    useHourHtml += "<option value='" + i + "'>" + i + "</option>";
                }
                $("#useHour").html(useHourHtml);
            }
            if (quickOrderInfo.carUseWayID == 4) {
                $("#useHour").html("<option value='8'>8</option>");
            }
            if (quickOrderInfo.carUseWayID == 5) {
                $("#useHour").html("<option value='4'>4</option>");
            }
            if (quickOrderInfo.carUseWayID == 7) {
                SetAllwaysTime();
            }
            else {
                GetCityType(quickOrderInfo.startCountryID, function (data) {//根据codeID获得城市类型，给select赋值
                    var hourHtml = "";
                    var minutesHtml = "";
                    for (var i = data.hour; i < 24; i++) {
                        hourHtml += "<option value='" + i + "'>" + i + "</option>";
                    }
                    for (var i = data.minutes; i < 60; i++) {
                        if (i % 5 == 0) {
                            minutesHtml += "<option value='" + i + "'>" + i + "</option>";
                        }
                    }
                    $("#selectHour").html(hourHtml);
                    $("#selectMinutes").html(minutesHtml);
                    allowTime.hour = data.hour;
                    allowTime.minutes = data.minutes;
                });
            }
            GetDetail(quickOrderInfo.rentCarID, function (detail) {//根据RentCarID获取CarFullType对象
                if (detail.RentCar.carusewayID == 7) {
                    //                    var myDate = new Date();
                    //                    var minute = myDate.getMinutes() < 10 ? "0" + myDate.getMinutes() : myDate.getMinutes();
                    //                    $("#mytime").append(myDate.getFullYear() + "-" + myDate.getMonth() + "-" + myDate.getDate() + " " + myDate.getHours() + ":" + minute);
                    $("#shortDate").prop("disabled", "disabled");
                    $("#selectHour").prop("disabled", "disabled");
                    $("#selectMinutes").prop("disabled", "disabled");
                } else {
                    $("#shortDate").prop("disabled", "");
                    $("#selectHour").prop("disabled", "");
                    $("#selectMinutes").prop("disabled", "");
                }
                
                var orderMoney = detail.RentCar.DiscountPrice;
                REALORDERMONEY = orderMoney;
                var passangerNumbers = detail.CarType.passengerNum;
                var passangerNumberHtml = "";
                for (var i = 1; i < passangerNumbers + 1; i++) {
                    passangerNumberHtml += "<option value='" + i + "'>" + i + "</option>";
                }
                $("#passangerNumbers").html(passangerNumberHtml);
                $("#orderMoney").html(orderMoney + "元");
                GetCoupons(orderMoney, function (datas) {//获取优惠券
                    var resultHtml = "<option value='0'>请选择...</option>";
                    for (var i = 0; i < datas.length; i++) {
                        resultHtml += "<option value='" + datas[i].Id + "'>" + datas[i].Name + "(" + datas[i].Cost + "元)" + "</option>";
                    }
                    $("#useCounpons").html(resultHtml);
                    $("#goOrderDiv").fadeIn(300);
                });
                getVouchers();
            })
        }
    });
}
function getVouchers() {
    var html = "";
    html += "<option value='0' cost='0'>请选择</option>";
    $.ajax({
        url: "/api/makeorder/getvouchers.ashx",
        success: function (data) {
            if (data.CodeId == 0) {
                return;
            }
            $.each(data.Data, function (index, val) {
                html += " <option cost='" + val.Cost + "' value='" + val.Id + "'>" + val.Cost + "元(剩余" + val.Num + "张可用)</option>";
            });
            $("#useVouchers").html(html);
        }
    });
}


function SetAllwaysTime() { //设置随叫随到的时间
    var hourHtml = "";
    var minutesHtml = "";
    var minutes = new Date().getMinutes();
    for (var i = new Date().getHours(); i < 24; i++) {
        hourHtml += "<option value='" + i + "'>" + i + "</option>";
    }
    for (var i = minutes; i < 60; i++) {
        if (i % 5 == 0) {
            minutesHtml += "<option value='" + i + "'>" + i + "</option>";
        }
    }
    $("#selectHour").html(hourHtml);
    $("#selectMinutes").html(minutesHtml);
}
function GetCoupons(orderMoney, callBack) {
    $.post("api/FastCarListController.ashx", { "action": "getCoupon", "ordermoney": orderMoney }, function (data) { callBack(data); });
}
function GetDetail(rentCarID, callBack) {
    $.post("api/FastCarListController.ashx", { "action": "getDetail", "rentCarID": rentCarID }, function (data) { callBack(data); });
}
function GetCityType(codeID, callBack) {
    $.post("api/FastCarListController.ashx", { "action": "getCityType", "codeid": codeID }, function (data) { callBack(data); });
}
function SubOrder() { //提交订单，订车。。
    var shortDate = $("#shortDate").val();
    var hour = $("#selectHour").val();
    var minutes = $("#selectMinutes").val();
    var passanger = $("#passangerNumbers").val();
    var couponID = $("#useCounpons").val();
    var voucherId = $("#useVouchers").val();
    var remarks = $("#remarks").val();
    var useHour = $("#useHour").val();
    $.post("api/FastCarListController.ashx", {
        "action": "subOrder",
        "useHour": useHour,
        "time_date": shortDate,
        "time_hour": hour,
        "time_minutes": minutes,
        "passangerNumber": passanger,
        "couponid": couponID,
        "voucherId":voucherId,
        "remarks": remarks,
        "quickOrderID": QUICKORDERID
    }, function (data) {
        if (data.orderID == "0") {
            alert("订单出错了。请稍后重试！");
        }
        else {
            $("#orderid").val(data.orderID);
            $("#orderFormPost").submit();
        }
    });
}
function cancelOrder() {
    $("#goOrderDiv").fadeOut(300);
}
$(function () {
    $("#selectHour").change(function () {//当小时改变的时候
        if ($(this).val() > allowTime.hour) {
            var resultHtml = "";
            for (var i = 5; i < 60; i++) {
                if (i % 5 == 0) {
                    resultHtml += "<option value='" + i + "'>" + i + "</option>";
                }
                $("#selectMinutes").html(resultHtml);
            }
        }
    });

    $("#useCounpons").change(function () {
        var costValue = $(this).val();
        if (costValue != 0) {
            $("#useVouchers").attr("disabled", true);
            $("#useVouchers").val("0");
        }
        else {
            $("#useVouchers").attr("disabled", false);
        }
        var cost = 0;
        try {
            cost = $(this).children("option[value='" + costValue + "']").html();
            cost = cost.match(/\(\d+.*?\)/gi);
            cost = cost[0].match(/\d+/gi);
        } catch (e) {
            cost = 0;
        }
        var resultCost = REALORDERMONEY - cost;
        if (resultCost < 0) {
            resultCost = 0;
        }
        $("#orderMoney").html(resultCost + "元");
    });

    $("#useVouchers").change(function () {

        var costValue = $(this).val();
        if (costValue != 0) {
            $("#useCounpons").attr("disabled", true);
            $("#useCounpons").val("0");
        }
        else {
            $("#useCounpons").attr("disabled", false);
        }
        var cost = 0;
        try {
            cost = $(this).children("option[value='" + costValue + "']").attr("cost");
        } catch (e) {
            cost = 0;
        }
        var resultCost = REALORDERMONEY - cost;
        if (resultCost < 0) {
            resultCost = 0;
        }
        $("#orderMoney").html(resultCost + "元");
    });
});
function dateChange(thisElement) {//当日期改变的时候
    var allowDate = new Date(allowTime.year, allowTime.month, allowTime.day);
    var thisDate = new Date($(thisElement).val().split('-')[0], $(thisElement).val().split('-')[1], $(thisElement).val().split('-')[2]);
    if (thisDate > allowDate) {
        var hourHtml = "";
        var minutesHtml = "";
        for (var i = 1; i < 24; i++) {
            hourHtml += "<option value='" + i + "'>" + i + "</option>";
        }
        for (var i = 0; i < 60; i++) {
            if (i % 5 == 0) {
                minutesHtml += "<option value='" + i + "'>" + i + "</option>";
            }
        }
        $("#selectHour").html(hourHtml);
        $("#selectMinutes").html(minutesHtml);
    }
    else {
        if (thisDate < allowDate) {
            alert("时间不合法，系统将给您返回到当前时间。");
            var nowDate = new Date().ToShortTime();
            $("#shortDate").val(nowDate);
        }
        else {
            var hourHtml = "";
            var minutesHtml = "";
            for (var i = allowTime.hour; i < 24; i++) {
                hourHtml += "<option value='" + i + "'>" + i + "</option>";
            }
            for (var i = allowTime.minutes; i < 60; i++) {
                if (i % 5 == 0) {
                    minutesHtml += "<option value='" + i + "'>" + i + "</option>";
                }
            }
            $("#selectHour").html(hourHtml);
            $("#selectMinutes").html(minutesHtml);
        }
    }
}
