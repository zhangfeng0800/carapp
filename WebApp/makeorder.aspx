<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="makeorder.aspx.cs" Inherits="WebApp.makeorder" %>

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
    <script src="Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script src="Scripts/jquery.validate.js" type="text/javascript"></script>
    <script src="js/moment.min.js" type="text/javascript"></script>
    <style type="text/css">
        .backg
        {
            background-color: #fefefe;
            border: 1px solid #e6e6fa;
            font-family: Microsoft yahei;
            line-height: 26px;
            padding-left: 10px;
            width: 500px;
            position: absolute;
            left: 107px;
            top: 30px;
            display: none;
        }
        .backg p:hover
        {
            background-color: #dedede;
            cursor: pointer;
        }
    </style>
    <script type="text/javascript">
        function SubmitOrder() {
            var validator;
            var rules;
            var messages;
            var time;
            var data;
            var ischecked;
            if ($("#usewayid").val() == 6) {
                time = $("#txt_hotline_date").val() + " " + $("#txt_hotline_hour").val() + ":" + $("#txt_hotline_minites").val()+":00";
                data = {
                    rentWay: 6,
                    rentCarInfo: $("#rentId").val(),
                    hotStart: $("#txt_hotline_startplace").val(),
                    hotTime: time,
                    hotProvince: $("#txt_hotline_province").val(),
                    hotCity: $("#txt_hotline_townid").val(),
                    hotAddr: $("#txt_hotline_endplace").val(),
                    //passengerName: $("#passengerName").val(),
                    passengerName: $("#passangers option:selected").text(),
                   passengerPhone: $("#passengerPhone").val(),
                    passengerNum: $("#passengerNum").val(),
                    BZ: $("#others").val(),
                    addressDetail: $("#txt_hotline_detailplace").val(),
                    position: $("#txt_hotline_position").val(),
                    endPosition: $("#hotline_mudi_postion").val(),
                    ticketnum:<%=realnum %>
                };
                rules = {
                    txt_hotline_startplace: { required: true },
                    txt_hotline_endplace: { required: true },
                    passengerPhone: { required: true },

                    txt_hotline_date: { required: true },
                    txt_hotline_hour: { min: 0 },
                    txt_hotline_minites: { min: 0 }
                };
                messages = {
                    txt_hotline_startplace: { required: "" },
                    txt_hotline_endplace: { required: "" },
                    passengerPhone: { required: "" },

                    txt_hotline_date: { required: "" },
                    txt_hotline_hour: { min: "" },
                    txt_hotline_minites: { min: "" }
                };

            } else if ($("#usewayid").val() == 1) {
                var time = $("#txt_jieji_startdate").val() + " " + $("#txt_jieji_starthour").val() + ":" + $("#txt_jieji_startminute").val()+":00";
                data = {
                    rentWay: "1",
                    rentCarInfo: $("#rentId").val(),
                    startAddr: $("#txt_jieji_airportname").find("option:selected").text(),
                    flightDate: time, flightNum: "",
                    select_province: $("#txt_jieji_province").val(),
                    startPlace: "",
                    select_city: $("#txt_jieji_muditown").val(),
                    arrivalAddr: $("#txt_jieji_endaddr").val(),
                    passengerName: $("#passangers option:selected").text(),
                    flightNumber: $("#flightNumber").val(),
                    passengerPhone: $("#passengerPhone").val(),
                    passengerNum: $("#passengerNum").val(),
                    BZ: $("#others").val(),
                    airportId: $("#txt_jieji_airportname").val(),
                    endPosition: $("#jieji_mudi_position").val()
                };
                rules = {
                    txt_jieji_endaddr: { required: true },
                    passengerPhone: { required: true },

                    txt_jieji_airportname: { min: 1 },
                    txt_jieji_startdate: { required: true },
                    txt_jieji_starthour: { min: 0 },
                    txt_jieji_startminute: { min: 0 },
                    txt_jieji_province: { min: 1 },
                    txt_jieji_city: { min: 1 }
                };
                messages = {
                    txt_jieji_endaddr: { required: "" },

                    txt_jieji_airportname: { min: "" },
                    txt_jieji_startdate: { required: "" },
                    txt_jieji_starthour: { min: "" },
                    txt_jieji_startminute: { min: "" },
                    txt_jieji_province: { min: "" },
                    txt_jieji_city: { min: "" },
                    passengerPhone: { required: "" }
                };

            } else if ($("#usewayid").val() == 2) {
                var time = $("#txt_songji_startDate").val() + " " + $("#txt_songji_startHour").val() + ":" + $("#txt_songji_startMinute").val()+":00";
                data = {
                    rentWay: "2",
                    select_portName: $("#txt_songji_airportName").val(),
                    rentCarInfo: $("#rentId").val(),
                    startAddr: $("#txt_input_startplace").val(),
                    airTime: time,
                    arriveAddr: $("#txt_songji_airportName").find("option:selected").text(),
                    select_city: $("#txt_songji_muditown").val(),
                    arrivalAddr: $("#txt_songji_airportName").val(),
                    passengerName: $("#passangers option:selected").text(),
                    //passengerName: $("#passengerName").val(),
                    passengerPhone: $("#passengerPhone").val(),
                    passengerNum: $("#passengerNum").val(),
                    BZ: $("#others").val(),
                    addressDetail: $("#txt_input_detailplace").val(),
                    position: $("#txt_songji_position").val()

                };

                rules = {
                    txt_input_startplace: { required: true },
                    passengerPhone: { required: true },

                    txt_songji_startDate: { required: true },
                    txt_songji_startHour: { min: 0 },
                    txt_songji_startMinute: { min: 0 },
                    txt_songji_mudiprovince: { min: 1 },
                    txt_songji_mudicity: { min: 1 },
                    txt_songji_muditown: { min: 1 },
                    txt_songji_airportName: { min: 1 }
                };
                messages = {
                    txt_input_startplace: { required: "" },
                    passengerPhone: { required: "", minLength: "请输入正确的手机号码", maxLength: "请输入正确的手机号码" },

                    txt_songji_startDate: { required: "" },
                    txt_songji_startHour: { min: "" },
                    txt_songji_startMinute: { min: "" },
                    txt_songji_mudiprovince: { min: "" },
                    txt_songji_mudicity: { min: "" },
                    txt_songji_muditown: { min: "" },
                    txt_songji_airportName: { min: "" }
                };


            } else {
                var time = $("#txt_rizu_startDate").val() + " " + $("#txt_rizu_startHour").val() + ":" + $("#txt_rizu_startMinutes").val()+":00";
                data = {
                    rentWay: useway,
                    rentCarInfo: $("#rentId").val(),
                    rentAddr: $("#txt_rizu_startplace").val(),
                    rentTime: time,
                    useHour: $("#txt_rizu_useHour").val(),
                    province: $("#txt_rizu_province").val(),
                    city: $("#txt_rizu_town").val(),
                    rentArrive: $("#txt_rizu_endplace").val(),
                    passengerName: $("#passangers option:selected").text(),
                    //passengerName: $("#passengerName").val(),
                    passengerPhone: $("#passengerPhone").val(),
                    passengerNum: $("#passengerNum").val(),
                    BZ: $("#others").val(),
                    addressDetail: $("#txt_rizu_detailplace").val(),
                    position: $("#txt_rizu_position").val(),
                    endPosition: $("#rizu_mudi_position").val()

                };

                rules = {
                    txt_rizu_startplace: { required: true },
                    txt_rizu_endplace: { required: true },
                    passengerPhone: { required: true },

                    txt_rizu_startDate: { required: true },
                    txt_rizu_startHour: { min: 0 },
                    txt_rizu_startMinutes: { min: 0 },
                    txt_rizu_province: { min: 1 },
                    txt_rizu_city: { min: 1 },
                    txt_rizu_town: { min: 1 }
                };
                messages = {
                    txt_rizu_startplace: { required: "" },
                    txt_rizu_endplace: { required: "" },
                    passengerPhone: { required: "" },

                    txt_rizu_startDate: { required: "" },
                    txt_rizu_startHour: { min: "" },
                    txt_rizu_startMinutes: { min: "" },
                    txt_rizu_province: { min: "" },
                    txt_rizu_city: { min: "" },
                    txt_rizu_town: { min: "" }
                };

            }
            data.isSmsPassenger = $("#cksmspassenger").attr("checked") == "checked" ? "1" : "0";

            var form = $("#form1").validate({
                rules: rules,
                messages: messages
            });
            var v = form.form();

            if (!v) {
                alert("请填写完整信息");
                return false;
            }
            if (data.position == "") {
                alert("请选择正确的地址");
                return false;

            }
            if (data.endPosition == "") {
                alert("请选择正确的地址");
                return false;

            }
            $.ajax({
                url: "/api/Order.ashx",
                type: "post",
                data: data,
                success: function (data) {
                    if (data == "notlogined") {
                        alert("请登录");
                        window.location.href = "/login.aspx";
                    }
                    if (data == "time") {
                        alert("只能预订70分钟以后的车辆");
                        return;
                    }
                    else if (data != "failed") {
                        $("#goto_next").val("订单提交成功");
                        $("#goto_next").removeAttr("disabled");
                        window.location.href = "/orderconfirm.aspx?orderId=" + data.toString();
                    }
                    else if(data=="permission")
                    {
                        alert("取消次数超过5次，不能在下单");
                        return;
                    }
                    else {
                        alert("订单提交失败！");
                        $("#submitLoading").hide();
                        $("#btnInfo").show();
                    }
                },
                complete: function () {
                    $("#goto_next").val("下一步，提交订单");
                    $("#goto_next").removeAttr("disabled");
                },
                beforeSend: function () {
                    $("#goto_next").val("订单提交中");
                    $("#goto_next").attr("disabled", "disabled");
                }
            });
        }

        $(function () {
            showdiv();
            $("#goto_next").click(function () {
            $.post("/api/PermissionController.ashx", { action: "count", type: 3 }, function (data) {
                 if (data >= 5) {
                    alert("对不起！您当天取消订单超过5次，不可下单。");
                    return false;
                }
                SubmitOrder();
            });
                
            });
        });
    </script>
    <script>
        $(function () {
            $("#goto_next").val("下一步，提交订单");
            //日租的时间
            $("#txt_rizu_startHour").change(function () {
                getMinutes($(this).val(), "#txt_rizu_startMinutes", $("#citytype").val());
            });
            //接机的时间

            $("#txt_jieji_starthour").change(function () {
                getMinutes($(this).val(), "#txt_jieji_startminute", $("#citytype").val());
            });
            /// 送机
            $("#txt_songji_startHour").change(function () {
                getMinutes($(this).val(), "#txt_songji_startMinute", $("#citytype").val());
            });
            ///热门路线
            $("#txt_hotline_hour").change(function () {
                getMinutes($(this).val(), "#txt_hotline_minites", $("#citytype").val());
            });
        });

    </script>
    <script>
        function setValue(id, parentContainer, postioncontainer, namecontainer, addresscontainer) {
            var html = $("#p" + id).html();
            $(namecontainer).val(html.split(',')[0]);
            $(addresscontainer).val(html.split(',')[1]);
            $(parentContainer).hide();
            $(postioncontainer).val($("#p" + id).attr("position"));
            $(parentContainer).html("");
        }
        function setAddress(obj, parentContainer, postioncontainer, namecontainer, addresscontainer) {
            var html = $(obj).html();
            $(namecontainer).val(html);
            $(postioncontainer).val($(obj).next().next().val());
            $(addresscontainer).val($(obj).next().val());
            $(parentContainer).hide();
        }
        function getUserAddress(c, container, positionContainer, namecontainer, addresscontainer) {
            $.ajax({
                url: "/api/GetUserAddress.ashx",
                data: { userid: $("#uid").val(), cityid: c },
                type: "post",
                success: function (data) {
                    if (data.msg == "成功") {
                        var list = data.data;
                        var html = "";
                        for (i = 0; i < list.length; i++) {
                            html += "<p  onclick='setAddress(this,\"" + container + "\",\"" + positionContainer + "\",\"" + namecontainer + "\",\"" + addresscontainer + "\")'>" + list[i].address + "</p><input type='hidden' value='" + list[i].remarks + "'/><input type='hidden' value='" + list[i].location + "'/>";
                        }

                        $(container).show();
                        $(container).html(html);
                    }
                },
                dataType: "json"
            });
        }
        function getplace(q, c, container, positionContainer, namecontainer, addresscontainer) {
            $.ajax({
                url: "/api/baiduplaceapi.ashx",
                data: { q: q, c: c },
                type: "post",
                success: function (data) {
                    if (data.status == 0) {
                        var dataResult = "";
                        if (data.results.length == 0) {
                            return;
                        }
                        $.each(data.results, function (index, val) {
                            if (val.name && val.address) {
                                dataResult += "<p position=\"" + val.location.lng + "," + val.location.lat + "\" onclick=\'setValue(\"" + index + "\",\"" + container + "\",\"" + positionContainer + "\",\"" + namecontainer + "\",\"" + addresscontainer + "\")\' id=\"p" + index + "\">" + val.name + "," + val.address + "</p>";
                            }
                        });
                        $(container).show();
                        $(container).html(dataResult);
                    }
                }
            });
        }
        function setMudiValue(id, parentContainer, postioncontainer, namecontainer) {
            var html = $("#mudi_p" + id).html();
            $(namecontainer).val(html);
            $(parentContainer).hide();
            var postion = $("#mudi_p" + id).attr("position");
            $(postioncontainer).val(postion);
            $(parentContainer).html("");
        }
        function getmudiplace(q, c, container, positionContainer, namecontainer, ishot) {
            $.ajax({
                url: "/api/baiduplaceapi.ashx",
                data: { q: q, c: c, ishot: ishot },
                type: "post",
                success: function (data) {
                    if (data.status == 0) {
                        var dataResult = "";
                        if (data.results.length == 0) {
                            return;
                        }
                        $.each(data.results, function (index, val) {
                            if (val.name && val.address) {
                                dataResult += "<p position=\"" + val.location.lng + "," + val.location.lat + "\" onclick=\'setMudiValue(\"" + index + "\",\"" + container + "\",\"" + positionContainer + "\",\"" + namecontainer + "\")\'  id=\"mudi_p" + index + "\">" + val.name + "," + val.address + "</p>";
                            }
                        });
                        $(container).show();
                        $(container).html(dataResult);
                    }
                }
            });
        }
        $(function () {
            $("#jieji_mudi_position").val("");
            $("#txt_hotline_position").val("");
            $("#hotline_mudi_postion").val("");
            $("#txt_songji_position").val("");
            $("#txt_rizu_position").val("");
            $("#rizu_mudi_position").val("");
            $("#txt_jieji_endaddr").val("");
            $("#txt_input_startplace").val("");
            $("#txt_rizu_startplace").val("");
            $("#txt_rizu_endplace").val("");
            $("#txt_hotline_startplace").val("");
            $("#txt_hotline_endplace").val("");

            $("#txt_input_startplace").keyup(function () {
                $("#txt_songji_position").val("");
                getplace($(this).val(), $("#txt_songji_town").val(), "#songjiresult", "#txt_songji_position", "#txt_input_startplace", "#txt_input_detailplace");
            });
            $("#txt_input_startplace").focus(function () { //得到常用乘车地址
                getUserAddress($("#txt_songji_town").val(), "#songjiresult", "#txt_songji_position", "#txt_input_startplace", "#txt_input_detailplace");
            });

            $("#txt_rizu_startplace").keyup(function () {
                $("#txt_rizu_position").val("");
                getplace($(this).val(), $("#txt_rizu_starttown").val(), "#rizuresult", "#txt_rizu_position", "#txt_rizu_startplace", "#txt_rizu_detailplace");
            });
            $("#txt_rizu_startplace").focus(function () { //得到常用乘车地址
                getUserAddress($("#txt_rizu_starttown").val(), "#rizuresult", "#txt_rizu_position", "#txt_rizu_startplace", "#txt_rizu_detailplace");
            });

            $("#txt_hotline_startplace").keyup(function () {
                $("#txt_hotline_position").val("");
                getplace($(this).val(), $("#txt_hotline_townid").val(), "#hotlineresult", "#txt_hotline_position", "#txt_hotline_startplace", "#txt_hotline_detailplace");
            });
            $("#txt_hotline_startplace").focus(function () { //得到常用乘车地址
                getUserAddress($("#txt_hotline_townid").val(), "#hotlineresult", "#txt_hotline_position", "#txt_hotline_startplace", "#txt_hotline_detailplace");
            });

            $("#txt_jieji_endaddr").keyup(function () {
                $("#jieji_mudi_position").val("");
                getmudiplace($(this).val(), $("#txt_jieji_muditown").val(), "#jieji_mudi_result", "#jieji_mudi_position", "#txt_jieji_endaddr", 0);
            });
            $("#txt_jieji_endaddr").focus(function () { //得到常用乘车地址
                getUserAddress($("#txt_jieji_muditown").val(), "#jieji_mudi_result", "#jieji_mudi_position", "#txt_jieji_endaddr", "");
            });

            $("#txt_rizu_endplace").keyup(function () {
                $("#rizu_mudi_position").val("");
                getmudiplace($(this).val(), $("#txt_rizu_town").val(), "#rizu_mudi_result", "#rizu_mudi_position", "#txt_rizu_endplace", 0);
            });
            $("#txt_rizu_endplace").focus(function () { //得到常用乘车地址
                getUserAddress($("#txt_rizu_town").val(), "#rizu_mudi_result", "#rizu_mudi_position", "#txt_rizu_endplace", "");
            });

            $("#txt_hotline_endplace").keyup(function () {
                $("#hotline_mudi_postion").val("");
                getmudiplace($(this).val(), $("#txt_hotline_targetcityid").val(), "#hotline_mudi_result", "#hotline_mudi_postion", "#txt_hotline_endplace", 1);
            });
            $("#txt_hotline_endplace").focus(function () { //得到常用乘车地址
                getUserAddress($("#txt_hotline_targetcityid").val(), "#hotline_mudi_result", "#hotline_mudi_postion", "#txt_hotline_endplace", "");
            });

        });

        function showContactor() {
            $("#passengerName").hide();
            $("#txtcontactorname").show();
        }
        function addContact(name, telphone, namecontainer, telphonecontainer) {
            $.ajax({
                url: "/api/addcontactor.aspx",
                data: { name: name, telphone: telphone },
                type: "post",
                success: function (data) {
                    if (data == 1) {
                        $(namecontainer).append("<option selected='selected'>" + name + "</option>");
                        $(telphonecontainer).val(telphone);
                    } else {

                    }
                }
            });
        }
        function showPassangerDiv(id) {
            if (id == "passangerInfo") {
                $("#passangerInfo").show();
                $("#addPassanger").hide();
            }
            else {
                $("#passangerInfo").hide();
                $("#addPassanger").show();
            }
        }
        function getFlight() {
            isFlightClick = 0;
            var query = $("#flightNumber").val();
            $.post("api/GetFlightNum.ashx", { "q": query }, function (data) {
                var resultHtml = "";
                for (var key in data.result) {
                    resultHtml += "<p onclick='getDetail($(this))'>" + key + "," + data.result[key] + "</p>";
                }
                $("#flightResult").html(resultHtml);
                $("#flightResult").show();
            });
        }
        var isFlightClick = 0;
        function hideFlight() {
            if (isFlightClick == 0) {
                $("#flightNumber").val("");
            }
            $("#flightResult").fadeOut("1000");
        }
        function getDetail(thisElement) {
            var values = thisElement.html();
            values = values.split(",");
            $.post("api/getFlightInfo.ashx", { "date": "<%=DateTime.Now.ToShortDateString() %>", "flightNumber": values[0] }, function (data) {
                try {
                    isFlightClick = 1;
                    var arriveDate = new Date(data.result[0].arr_time * 1000);
                    var flightResult = { "year": arriveDate.getFullYear(),
                        "month": arriveDate.getMonth() + 1,
                        "day": arriveDate.getDate(),
                        "hour": arriveDate.getHours(),
                        "minutes": arriveDate.getMinutes()
                    };
                    $("#flightNumber").val(values);
                    $("#txt_jieji_startdate").val(flightResult.year + "-" + flightResult.month + "-" + flightResult.day);
                    $("#txt_jieji_starthour").append("<option value=\"" + flightResult.hour + "\" selected=\"selected\">" + flightResult.hour + "</option>");
                    $("#txt_jieji_startminute").append("<option value=\"" + flightResult.minutes + "\" selected=\"selected\">" + flightResult.minutes + "</option>");
                } catch (e) {
                    alert("抱歉！没有查到此订单的任何信息");
                    $("#flightNumber").val("");
                }
            });
        }
    </script>
    <style type="text/css">
        label.error
        {
            background: url("/images/error.gif") no-repeat scroll left center rgba(0, 0, 0, 0);
            color: #FF0000;
            font-size: 13px;
            margin-left: 5px;
            padding-left: 16px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <input type="hidden" id="uid" value="<%=Account.Id %>" />
    <div class="dc-process">
        <div class="step">
            <ul class="dc-step">
                <li class="step-one">1、选择用车方式</li>
                <li class="step-gray">2、选择车型</li>
                <li class="step-gray step-orange">3、填写联系人</li>
                <li class="step-gray-end">4、提交订单</li>
            </ul>
        </div>
        <form id="form1">
        <div class="dc-info clearfix">
            <input type="hidden" name="usewayid" id="usewayid" />
            <input type="hidden" name="rentId" id="rentId" />
            <input type="hidden" name="citytype" id="citytype" value="<%=cittype %>" />
            <div class="dc-main">
                <div class="section" id="useway1" style="position: relative">
                    <h3 class="per-info-til">
                        乘车信息</h3>
                    <p class="per-info-text">
                        <span class="per-info-name">用车城市</span>
                        <input id="txt_jieji_pct" type="text" disabled="disabled" />
                        <input id="txt_jieji_provinceid" type="hidden" /><input id="txt_jieji_cityid" type="hidden" /><input
                            id="txt_jieji_townid" type="hidden" />
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">机场名称</span>
                        <select id="txt_jieji_airportname" name="txt_jieji_airportname">
                            <option value="0">请选择</option>
                        </select>
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">航 班 号&nbsp;&nbsp;&nbsp;</span>
                        <input class="per-info-input" type="text" id="flightNumber" onkeyup="getFlight()"
                            onblur="hideFlight()" />(选填) <span id="flightResult" class="backg" style="left: 95px;
                                top: 155px; z-index: 100; width: 290px"></span>
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">航班时间</span>
                        <input class="per-info-input" style="width: 80px;" type="text" id="txt_jieji_startdate"
                            onchange="gethour($(this).val(), '#txt_jieji_starthour', $('#citytype').val())"
                            name="txt_jieji_startdate" value="" readonly onclick="WdatePicker()" onfocus="WdatePicker({minDate:'%y-%M-{%d}'})" />
                        <select id="txt_jieji_starthour" size="1" name="txt_jieji_starthour">
                            <option value="-1" selected="selected">时</option>
                        </select>时
                        <select id="txt_jieji_startminute" size="1" name="txt_jieji_startminute">
                            <option value="-1" selected="selected">分</option>
                        </select>
                        分
                    </p>
                    <p style="color: #ff0000; font-size: 12px; padding-left: 50px;">
                        注：市区订车提前1小时10分钟；郊县订车提前2小时10分钟。
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">目的城市</span><select id="txt_jieji_province" size="1" name="txt_jieji_province">
                            <option selected="selected" value="0">请选择</option>
                        </select>
                        <select id="txt_jieji_city" size="1" name="txt_jieji_city">
                            <option selected="selected" value="0">请选择</option>
                        </select>
                        <select id="txt_jieji_muditown" size="1" name="txt_jieji_muditown">
                            <option selected="selected" value="0">请选择</option>
                        </select>
                    </p>
                    <p class="per-info-text" style="position: relative;">
                        <span class="per-info-name">下车地点</span>
                        <input class="per-info-input" type="text" id="txt_jieji_endaddr" name="txt_jieji_endaddr"
                            style="width: 500px;" />
                        <span id="jieji_mudi_result" class="backg"></span>
                        <input type="hidden" id="jieji_mudi_position" />
                    </p>
                </div>
                <div class="section" id="useway2">
                    <h3 class="per-info-til">
                        乘车信息</h3>
                    <p class="per-info-text">
                        <span class="per-info-name">出发城市</span>
                        <input id="txt_songji_pct" type="text" disabled="disabled" />
                        <input id="txt_songji_province" type="hidden" />
                        <input id="txt_songji_city" type="hidden" />
                        <input id="txt_songji_town" type="hidden" />
                    </p>
                    <p class="per-info-text" style="position: relative;">
                        <span class="per-info-name">出发地点</span>
                        <input class="per-info-input" type="text" id="txt_input_startplace" name="txt_input_startplace"
                            style="width: 500px;" /><br />
                        <span id="songjiresult" class="backg"></span>
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">补充地址</span>
                        <input class="per-info-input" type="text" id="txt_input_detailplace" name="txt_input_detailplace"
                            style="width: 500px;" /><br />
                        <input type="hidden" id="txt_songji_position" />
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">出发时间</span>
                        <input class="per-info-input" style="width: 80px;" type="text" value="" readonly
                            name="txt_songji_startDate" onclick="WdatePicker()" id="txt_songji_startDate"
                            onchange="gethour($(this).val(), '#txt_songji_startHour', $('#citytype').val())"
                            onfocus="WdatePicker({minDate:'%y-%M-{%d}'})" />
                        <select id="txt_songji_startHour" size="1" name="txt_songji_startHour">
                            <option value="-1" selected="selected">时</option>
                        </select>时
                        <select id="txt_songji_startMinute" size="1" name="txt_songji_startMinute">
                            <option selected="selected" value="-1">分</option>
                        </select>
                        分
                    </p>
                    <p style="color: #ff0000; font-size: 12px; padding-left: 50px;">
                        注：市区订车提前1小时10分钟；郊县订车提前2小时10分钟；客服服务时间是8点至22点</p>
                    <p class="per-info-text">
                        <span class="per-info-name">目的城市</span>
                        <select id="txt_songji_mudiprovince" name="txt_songji_mudiprovince">
                            <option value="0">请选择</option>
                        </select>
                        <select id="txt_songji_mudicity" name="txt_songji_mudicity">
                            <option value="0">请选择</option>
                        </select>
                        <select id="txt_songji_muditown" name="txt_songji_muditown">
                            <option value="0">请选择</option>
                        </select>
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">机场名称</span>
                        <select id="txt_songji_airportName" name="txt_songji_airportName">
                            <option value="0">请选择</option>
                        </select>
                    </p>
                </div>
                <div class="section" id="useway4">
                    <h3 class="per-info-til">
                        乘车信息</h3>
                    <p class="per-info-text">
                        <span class="per-info-name">出发城市</span>
                        <input id="txt_rizu_pct" type="text" disabled="disabled" />
                        <input id="txt_rizu_startprovince" type="hidden" />
                        <input id="txt_rizu_startcity" type="hidden" />
                        <input id="txt_rizu_starttown" type="hidden" />
                    </p>
                    <p class="per-info-text" style="position: relative;">
                        <span class="per-info-name">出发地点</span>
                        <input class="per-info-input" type="text" id="txt_rizu_startplace" name="txt_rizu_startplace"
                            style="width: 500px;" />
                        <span id="rizuresult" class="backg" style="z-index: 150;"></span>
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">补充地址</span>
                        <input class="per-info-input" type="text" id="txt_rizu_detailplace" name="txt_rizu_detailplace"
                            style="width: 500px;" /><br />
                        <input type="hidden" id="txt_rizu_position" />
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">出发时间</span>
                        <input class="per-info-input" style="width: 80px;" type="text" id="txt_rizu_startDate"
                            onchange=" gethour($(this).val(), '#txt_rizu_startHour', $('#citytype').val())"
                            name="txt_rizu_startDate" value="" readonly onclick="WdatePicker()" onfocus="WdatePicker({minDate:'%y-%M-{%d}'})" />
                        <select id="txt_rizu_startHour" size="1" name="txt_rizu_startHour">
                            <option value="-1" selected="selected">时</option>
                        </select>时
                        <select id="txt_rizu_startMinutes" size="1" name="txt_rizu_startMinutes">
                            <option value="-1" selected="selected">分</option>
                        </select>
                        分
                    </p>
                    <p style="color: #ff0000; font-size: 12px; padding-left: 50px;">
                        注：市区订车提前1小时10分钟；郊县订车提前2小时10分钟；客服服务时间是8点至22点</p>
                    <p class="per-info-text" id="info_renttime">
                        <span class="per-info-name">用车时长</span>
                        <select id="txt_rizu_useHour">
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                        </select>小时
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">目的地点</span>
                        <select id="txt_rizu_province" size="1" name="txt_rizu_province">
                            <option selected="selected" value="0">请选择</option>
                        </select>
                        <select id="txt_rizu_city" size="1" name="txt_rizu_city">
                            <option selected="selected" value="0">请选择</option>
                        </select>
                        <select id="txt_rizu_town" size="1" name="txt_rizu_town">
                            <option selected="selected" value="0">请选择</option>
                        </select>
                    </p>
                    <p class="per-info-text" style="position: relative;">
                        <span class="per-info-name">下车地点</span>
                        <input class="per-info-input" type="text" id="txt_rizu_endplace" name="txt_rizu_endplace"
                            style="width: 500px;" />
                        <span id="rizu_mudi_result" class="backg"></span>
                        <input type="hidden" id="rizu_mudi_position" />
                    </p>
                </div>
                <div class="section" id="useway6">
                    <h3 class="per-info-til">
                        乘车信息</h3>
                    <p class="per-info-text">
                        <span class="per-info-name">出发城市</span>
                        <input id="txt_hotline_pct" type="text" disabled="disabled" />
                        <input id="txt_hotline_provinceid" type="hidden" />
                        <input id="txt_hotline_cityid" type="hidden" />
                        <input id="txt_hotline_townid" type="hidden" />
                    </p>
                    <p class="per-info-text" style="position: relative;">
                        <span class="per-info-name">出发地点</span>
                        <input class="per-info-input" type="text" id="txt_hotline_startplace" name="txt_hotline_startplace"
                            style="width: 500px;" />
                        <span id="hotlineresult" class="backg" style="z-index: 125;"></span>
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">补充地址</span>
                        <input class="per-info-input" type="text" id="txt_hotline_detailplace" name="txt_hotline_detailplace"
                            style="width: 500px;" /><br />
                        <input type="hidden" id="txt_hotline_position" />
                    </p>
                    <p class="per-info-text">
                        <span class="per-info-name">出发时间</span>
                        <input class="per-info-input" style="width: 80px;" type="text" value="" id="txt_hotline_date"
                            name="txt_hotline_date" onclick="WdatePicker()" readonly onfocus="WdatePicker({minDate:'%y-%M-{%d}'})"
                            onchange="gethour($(this).val(), '#txt_hotline_hour', $('#citytype').val())" />
                        <select id="txt_hotline_hour" size="1" name="txt_hotline_hour">
                            <option value="-1" selected="selected">时</option>
                        </select>时
                        <select id="txt_hotline_minites" size="1" name="txt_hotline_minites">
                            <option value="-1" selected="selected">分</option>
                        </select>
                        分
                    </p>
                    <p style="color: #ff0000; font-size: 12px; padding-left: 50px;">
                        注：市区订车提前1小时10分钟；郊县订车提前2小时10分钟；客服服务时间是8点至22点</p>
                    <p class="per-info-text">
                        <span class="per-info-name">目的城市</span>
                        <input type="text" disabled="disabled" id="txt_hotline_targetname" />
                        <input type="hidden" disabled="disabled" id="txt_hotline_targetcityid" />
                    </p>
                    <p class="per-info-text" style="position: relative;">
                        <span class="per-info-name">下车地点</span>
                        <input class="per-info-input" type="text" id="txt_hotline_endplace" name="txt_hotline_endplace"
                            style="width: 500px;" />
                        <span class="backg" id="hotline_mudi_result"></span>
                        <input type="hidden" id="hotline_mudi_postion" />
                    </p>
                </div>
                <div class="section">
                    <h3 class="per-info-til">
                        <a style="cursor: pointer" href="javascript:showPassangerDiv('passangerInfo')">乘车人信息</a><a
                            style="cursor: pointer; margin-left: 40px;" href="javascript:showPassangerDiv('addPassanger')">添加乘车人</a>
                    </h3>
                    <div id="passangerInfo">
                        <p class="per-info-text">
                            <span class="per-info-name">乘&nbsp;&nbsp;车&nbsp;&nbsp;人</span>
                            <select id="passangers" onchange="changePassanger()">
                                <option value="<%=Account.Telphone %>">
                                    <%=Account.Compname %></option>
                                <%foreach (var item in Persons)
                                  {
                                      Response.Write("<option value='" + item.TelePhone + "'>" + item.ContactName + "</option>");
                                  } %>
                            </select>
                            <script type="text/javascript">
                                function changePassanger() {
                                    var values = $("#passangers").val();
                                    if (values == "<%=Account.Telphone %>") {
                                        $("#cksmspassenger").hide();
                                        $("#allowPassanger").hide();
                                    }
                                    else {
                                        $("#cksmspassenger").show();
                                        $("#allowPassanger").show();
                                    }
                                    $("#passengerPhone").val(values);
                                    $("#allowPassanger").html("允许<em style='color:red'>" + $("#passangers option:selected").text() + "</em>接收服务短信，不勾选则由下单人代收短信");
                                }
                            </script>
                            <input type="checkbox" id="cksmspassenger" checked="checked" style="display: none" /><label
                                for="cksmspassenger" id="allowPassanger" style="display: none">允许<em style="color: red"><%=Account.Compname%></em>接受服务短信，不勾选则由下单人代收短信</label>
                        </p>
                        <p class="per-info-text">
                            <span class="per-info-name">手&nbsp;&nbsp;机&nbsp;&nbsp;号</span>
                            <input class="per-info-input" type="text" id="passengerPhone" name="passengerPhone"
                                value="<%=Account.Telphone %>" readonly="readonly" />
                            <br />
                        </p>
                        <p class="per-info-text">
                            <span class="per-info-name">乘车人数</span>
                            <select id="passengerNum" size="1">
                                <% for (int i = 1; i < passnum + 1; i++)
                                   {
                                       Response.Write("<option value='" + i + "'>" + i + "</option>");
                                   } %>
                            </select>人
                        </p>
                        <p class="per-info-text">
                            <span class="per-info-name">特殊要求</span>
                            <textarea rows="1" cols="30" style="height: 50px; width: 300px; resize: none;" id="others" maxlength="200" ></textarea>
                        </p>
                        <input type="hidden" id="start_checkaddr" />
                        <input type="hidden" id="end_checkaddr" />
                    </div>
                    <script type="text/javascript">
                        function DoAddPassanger() {
                            if (checkNull()) {
                                $("#PassangerLoding").show();
                                var passangerName = $("#addPassangerName").val();
                                var passangerPhone = $("#addPassangerPhone").val();
                                $.post("api/addcontactor.ashx", { "name": passangerName, "telphone": passangerPhone }, function (data) {
                                    if (data == "1") {
                                        $("#passangers").append("<option value='" + passangerPhone + "'  selected='selected'>" + passangerName + "</option>");
                                        $("#passengerPhone").val(passangerPhone);
                                        showPassangerDiv('passangerInfo');
                                        $("#addPassangerName").val("");
                                        $("#addPassangerPhone").val("");
                                        $("#PassangerLoding").hide();
                                        $("#passangerNameCntNull").hide();
                                        $("#notMobile").hide();
                                        changePassanger();
                                    }
                                    else {
                                        alert("手机号码已经存在");
                                        $("#PassangerLoding").hide();
                                        $("#passangerNameCntNull").hide();
                                        $("#notMobile").hide();
                                    }
                                });
                            }
                        }
                        function checkNull() {
                            var passangerName = $("#addPassangerName").val();
                            var passangerPhone = $("#addPassangerPhone").val();
                            var MobileReg = /^1\d{10}$/gi;
                            if (passangerName == "") {
                                $("#passangerNameCntNull").show();
                                return false;
                            }
                            if (passangerPhone == "" || MobileReg.test(passangerPhone) == false) {
                                $("#notMobile").show();
                                return false;
                            }
                            return true;
                        }
                        function DoHidePassanger() {

                        }
                    </script>
                    <div id="addPassanger" style="height: 183px; display: none; position: relative">
                        <div id="PassangerLoding" style="position: absolute; width: 100%; height: 100%; display: none">
                            <img src="images/loading_s.gif" style="position: relative; left: 200px; top: 100px;" />
                        </div>
                        <p class="per-info-text">
                            <span class="per-info-name">乘车人姓名：</span><input type="text" class="per-info-input"
                                id="addPassangerName" maxlength="10" /><label style="color: Red; display: none" id="passangerNameCntNull">乘车人不能为空</label></p>
                        <p class="per-info-text">
                            <span class="per-info-name">乘车人电话：</span><input type="text" class="per-info-input" length="11"
                                id="addPassangerPhone" /><label style="color: Red; display: none" id="notMobile">电话号码格式不正确</label></p>
                        <p class="yc-type">
                            <input class="yc-btn" id="Text1" value="添加" type="button" style="border: 0px; cursor: pointer;
                                margin-top: 20px; width: 100px; float: left" onclick="DoAddPassanger()" />
                            <input class="yc-btn" id="Text2" value="取消" type="button"  style="border: 0px; cursor: pointer;
                                margin-top: 20px; width: 100px; float: left" onclick="showPassangerDiv('passangerInfo')" />
                        </p>
                    </div>
                </div>
                <div class="section">
                    <p class="yc-type">
                        <input class="yc-btn" id="goto_next" type="button"  value="下一步，提交订单" style="border: 0px; cursor: pointer;" />
                    </p>
                </div>
            </div>
            <div class="dc-side" id="order_right_1">
                <h3 class="per-ser per-ser-til">
                    您的用车方式</h3>
                <div class="ser-info car-side-mar">
                    <ul class="car-zuche-con">
                        <li>用车方式：<%
                                     var str = "";
                                     if (Request.QueryString["istravel"] != null)
                                     {
                                         Response.Write("爱旅游线路");

                                     }
                                     else
                                     {
                                         if (model.carusewayID == 6)
                                         {
                                             str = model.IsOneWay == 0 ? "(往返)" : "(单程)";
                                         }
                                         Response.Write(model.CarUseWayName + str);

                                     }
                                   
                        %></li>
                        <li>
                            <%
                                if (model.carusewayID == 6)
                                {
                                    Response.Write(cityfullname);
                                }
                                else
                                {
                                    Response.Write("   城&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;市：" + cityfullname);
                                }
                                
                            %>
                        </li>
                    </ul>
                </div>
                <h3 class="per-ser per-ser-til">
                    所选车辆</h3>
                <div class="ser-info car-side-mar">
                    <ul class="car-zuche-con">
                        <li>车型信息：<%=model.carTypeName %></li>
                        <li>费用包含：<%=model.FeeIncludes %></li>
                        <li>起步价：<%=model.DiscountPrice %>元<%=ticketnum %></li>
                        <li>每分钟价格：<%=model.hourPrice %>元/分钟</li>
                        <li>每公里价格：<%=model.kiloPrice %>元/公里</li>
                    </ul>
                </div>
                <img class="ser-tel" src="images/serTel.png" alt="" />
            </div>
        </div>
        </form>
    </div>
</asp:Content>
