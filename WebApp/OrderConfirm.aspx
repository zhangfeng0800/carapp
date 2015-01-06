<%@ Page Title="" Language="C#" MasterPageFile="~/SiteBase.Master" AutoEventWireup="true"
    CodeBehind="OrderConfirm.aspx.cs" Inherits="WebApp.OrderConfirm" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="BLL" %>
<%@ Import Namespace="Model" %>
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
    <script type="text/javascript" src="js/jquery-1.8.0.min.js"></script>
    <script src="Scripts/MySite.js" type="text/javascript"></script>
    <script src="Scripts/app.js" type="text/javascript"></script>
    <script src="Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script>
        $(function () {
            $("#noinvoicecontainer").hide();
            $("#invoicecontaienr").hide();
            $("#getInvoice").click(function () {
                if ($("#getInvoice").attr("checked"))
                    $(".invoiceInfo").show();
                else
                    $(".invoiceInfo").hide();
            });

            $("#getInvoice").removeAttr("checked");
            $("#input_hasinvoice").attr("checked", "checked");
            $("#input_hasnoinvoice").removeAttr("checked");
            $("input:text").val("");
            $("#ext_invoicetitle").val("0");
            getInvoicbyuser();
            getCoupon('<%=orderid %>');
            getVouchers('<%=orderid %>');
            SetCompInfo();
            $("#noext_invoiceclass").change(function () {
                SetCompInfo();
            });
            $("#personal").attr("checked", "checked");
            $("#personinvoice").show();
            $("#zengzhiinvoice").hide();
            $("#companyinvoice").hide();
            $("#invoiceclass").val(2);
        })
    </script>
    <script type="text/javascript">
        function SetCompInfo() {
            if ($("#noext_invoiceclass").val() == "1")
                $(".Li_CompInfo").show();
            else
                $(".Li_CompInfo").hide();
        }
        function changeInvoiceType() {
            if ($("#input_hasinvoice").attr("checked") == "checked") {
                $("#invoicecontainer").show();
                $("#noinvoicecontainer").hide();
            } else if ($("#input_hasnoinvoice").attr("checked") == "checked") {
                $("#invoicecontainer").hide();
                $("#noinvoicecontainer").show();
            }
        }
        function getinvoice() {
            if ($("#ext_invoicetitle").val() == "0") {
                $("#ext_invoiceaddress").val("");
                $("#ext_invoicezipcode").val("");
                return;
            }
            $.ajax({
                url: "/api/getinvoicebyid.ashx?invoiceid=" + $("#ext_invoicetitle").val(),
                success: function (data) {
                    if (data.ResultCode == 0) {
                        return;
                    }
                    $("#ext_invoiceaddress").val(data.invoiceAddress);
                    $("#ext_invoiceclass").val(data.invoiceClass);

                    $("#ext_invoicetype").val(data.invoiceType);
                    $("#ext_invoicezipcode").val(data.invoiceZipcode);
                }
            });
        }

        function submitOrder() {
            if (!$("#accept").attr("checked")) {
                alert("请确认同意爱易租用车《服务协议》");
                return;
            }
            var ischecked = $("#getInvoice").attr("checked");
            var posdata;
            if (ischecked) {
                if ($("#input_hasinvoice").attr("checked") == "checked") {
                    if ($("#ext_invoicetitle").val() == "0") {
                        alert("请选择发票！");
                        return false;
                    }
                    posdata = {
                        submitInfo: "submitOrder",
                        ordermessage: "",
                        orderId: $("#ContentPlaceHolder1_order").val(),
                        ordermoney: $("#paynum").text(),
                        couponId: $("#selectcoupon").val(),
                        invoiceHead: $("#ext_invoicetitle").val(),
                        invoiceType: $("#ext_invoicetype").val(),
                        address: $("#ext_invoiceaddress").val(),
                        zipcode: $("#ext_invoicezipcode").val(),
                        invoiceClass: $("#ext_invoiceclass").val(),
                        isinvoice: 1,
                        invoiceid: $("#ext_invoicetitle").val(),
                        vouchersId: $("#selectvouchers").val()
                    };
                } else {
//                    if ($("#noext_invoicetitle").val().length == 0 || $("#noext_invoicezipcode").val().length == 0 || $("#noext_invoiceaddress").val().length == 0||$("#noext_invoicetype").val()==0) {
//                        alert("请输入完整的发票信息");
//                        return false;
//                    }
//                    if ($("#noext_invoiceclass").val() == "1") {
//                        if ($("#Text_TaxpayerID").val() == "" || $("#Text_CompAdd").val() == "" || $("#Text_CompTel").val() == "" || $("#Text_CompBank").val() == "" || $("#Text_CompAccount").val() == "") {
//                            alert("请输入完整的发票信息");
//                            return false;
//                        }
//                        if (!isPhone($("#Text_CompTel").val())) {
//                            alert("联系电话格式有误");
//                            return false;
//                        }
//                    }
//                    var reg = /^([0-9]{6})$/;
//                    if (!reg.test($("#noext_invoicezipcode").val())) {
//                        alert("请输入正确的邮编格式");
//                        return false;
//                    }
                    var invoiceType;
                    if ($("#personal").attr("checked") == "checked") {
                        invoiceType = 0;
                        posdata = {
                            username: $("#username").val(),
                            ssn: $("#ssn").val()
                        };
                    } else if ($("#invoiceclass").val() == "2") {
                        invoiceType = 1;
                        posdata = {
                            invoiceClass: $("#invoiceclass").val(),
                            invoiceType: $("#invoicetype").val(),
                            invoiceHead: $("#invoicehead").val(),
                            TaxpayerID: $("#taxpayer").val()
                        };
                    } else {
                        invoiceType = 2;
                        posdata = {
                            invoiceClass: $("#invoiceclass").val(),
                            invoiceType: $("#invoicetype").val(),
                            invoiceHead: $("#invoicehead").val(),
                            TaxpayerID: $("#taxpayer").val(),
                            CompAdd: $("#Text_CompAdd").val(),
                            CompTel: $("#Text_CompTel").val(),
                            CompBank: $("#Text_CompBank").val(),
                            CompAccount: $("#Text_CompAccount").val(),
                            licence:$("#license").val(),
                            taxlicense:$("#taxlicense").val(),
                            commontaxpayer:$("#commontaxpayer").val(),
                            bankpermission:$("#bankpermission").val(),
                            orglicense:$("#orglicense").val(),
                            lawerid:$("#lawerid").val(),
                            agentid:$("#agentid").val(),
                            introductmsg:$("#introductmsg").val(),
                            resource:$("#resource").val()
                        };
                    }
                    posdata.address = $("#noext_invoiceaddress").val();
                    posdata.zipcode = $("#noext_invoicezipcode").val();
                    posdata.submitInfo = "submitOrder";
                    posdata.ordermessage = "";
                    posdata.orderId = $("#ContentPlaceHolder1_order").val();
                    posdata.ordermoney = $("#paynum").text();
                    posdata.couponId = $("#selectcoupon").val();
                    posdata.isinvoice = 0;
                    posdata.invoiceid = 0;
                    posdata.vouchersId = $("#selectvouchers").val();
                    posdata.invoice = invoiceType;

                }

            } else {
                posdata = {
                    submitInfo: "submitOrder",
                    ordermessage: "",
                    orderId: $("#ContentPlaceHolder1_order").val(),
                    ordermoney: $("#paynum").text(),
                    couponId: $("#selectcoupon").val(),
                    vouchersId: $("#selectvouchers").val(),
                    zipcode:""
                };
            }  
//            if (posdata.zipcode.length != 6) {
//                    alert("请输入正确的邮编");
//                    return false;
//                }
            if (invoiceType == 0) {
             
                if (posdata.username == "" || posdata.ssn == "" || posdata.address == "" || posdata.zipcode == "") {
                    alert("请输入完整的发票信息");
                    return false;
                }
                if (posdata.ssn.length != 18) {
                    alert("请输入正确的身份证号码");
                    return false;
                }
            } else if (invoiceType == 1) {
                if (posdata.invoiceHead == "" || posdata.TaxpayerID == "" || posdata.address == "" || posdata.zipcode == "") {
                    alert("请输入完整的发票信息");
                    return false;
                }
                if (posdata.TaxpayerID.length != 18 && posdata.TaxpayerID.length != 15) {
                    alert("请输入正确的纳税人标识号");
                    return false;
                }
            } else if (invoiceType == 2) {
                  if (posdata.invoiceHead == "" || posdata.TaxpayerID == "" || posdata.address == "" || posdata.zipcode == ""||posdata.CompAdd==""||posdata.CompAccount==""||posdata.CompBank==""||posdata.CompTel=="") {
                    alert("请输入完整的发票信息");
                    return false;
                }
                if (posdata.TaxpayerID.length != 18 && posdata.TaxpayerID.length != 15) {
                    alert("请输入正确的纳税人标识号");
                    return false;
                }
            } 
            $.ajax({
                url: "/api/Order.ashx",
                type: "post",
                data: posdata,
                success: function (data) {
                    $("#btnSubmitorder").removeAttr("disabled");
                    $("#btnSubmitorder").val("订单提交成功");
                    if (data == "notlogined") {
                        window.location.href = "/login.aspx";
                        return;
                    }
                    if (data == "inuse") {
                        alert("该订单已经使用过优惠券，不可重复使用");
                        return;
                    }
                    else if (data == "noauth") {
                        alert("您没有权限预定车辆，请联系集团管理员");
                        return;
                    }else if (data =="vouuse"){
                        alert("代金券重复使用，请刷新页面后重新提交!");
                        return;
                    }else if (data == "vouuse2"){
                        alert("该订单已经使用过代金券，无法继续使用!");
                        return;
                    }
                     else {
                        $("#formOrder").submit();
                    }
                },
                beforeSend: function () {
                    $("#btnSubmitorder").val("订单正在提交");
                    $("#btnSubmitorder").attr("disabled", "disabled");
                },
                error: function () {
                    alert("订单提交错误！");
                    $("#btnSubmitorder").removeAttr("disabled");

                    return;
                }
            });
        }

        function changeMoney() {
            var value = $("#selectcoupon").val();
            if ($("#selectcoupon").val() == 0) {
                $("#selectvouchers").attr("disabled",false); //选择优惠券时，设置代金券不可用
                $("#paynum").html($("#txthide").val());
                return;
            } else {
                $("#selectvouchers").val(0);
                $("#selectvouchers").attr("disabled","disabled");
                if ($("#txthide").val() - value.split('-')[1] > 0) {
                    $("#paynum").html(($("#txthide").val() - value.split('-')[1]).toFixed(2));
                } else {
                    $("#paynum").html(0);
                }
                return;
            }
        }
         function changeMoneyVouchers() {
            var value = $("#selectvouchers").val();
            if (value == 0) {
            $("#selectcoupon").attr("disabled",false);//选择代价券时，设置优惠券不可用
                $("#paynum").html($("#txthide").val());
                return;
            } else {
            $("#selectcoupon").val(0);
            $("#selectcoupon").attr("disabled","disabled");
                if ($("#txthide").val() - value.split('-')[1] > 0) {
                    $("#paynum").html(($("#txthide").val() - value.split('-')[1]).toFixed(2));
                } else {
                    $("#paynum").html(0);
                }
                return;
            }
        }

        function getInvoicbyuser() {
            var html = "";
            html += "<option value='0'>请选择</option>";
            $.ajax({
                url: "/api/makeorder/getinvoice.ashx",
                success: function (data) {
                    if (data.CodeId == 0) {
                        return;
                    }
                    $.each(data.data, function (index, val) {
                        html += "<option value='" + val.id + "'>" + val.invoiceHead + "</option>";

                    });
                    $("#ext_invoicetitle").html(html);
                }
            });
        }

        function getCoupon(orderid) {
            var html = "";
            html += "<option value='0'>请选择</option>";
            $.ajax({
                url: "/api/makeorder/getcoupon.ashx?orderid=" + orderid,
                success: function (data) {
                    if (data.CodeId == 0) {
                        return;
                    }
                    $.each(data.Data, function (index, val) {
                        html += " <option value='" + val.Id + "-" + val.Cost + "'>" + val.Name + "(" + val.Cost + "元)</option>";
                    });
                    $("#selectcoupon").html(html);
                }
            });
        }
          function getVouchers(orderid) {
            var html = "";
            html += "<option value='0'>请选择</option>";
            $.ajax({
                url: "/api/makeorder/getvouchers.ashx?orderid=" + orderid,
                success: function (data) {
                    if (data.CodeId == 0) {
                        return;
                    }
                    $.each(data.Data, function (index, val) {
                        html += " <option value='" + val.Id + "-" + val.Cost + "'>"+val.Cost+"元(剩余" + val.Num + "张可用)</option>";
                    });
                    $("#selectvouchers").html(html);
                },
                datatype:"json"
            });
        }
        $(function () {
            $.post("/api/predictPrice.ashx", { "orderid": "<%=Request.QueryString["orderId"] %>" }, function(data) {
                $("#PredictTotalFee").html(data.result);
                $("#Span1").html(data.result + "元；");
                $("#Span2").html(data.startprice + "元；");
                $("#Span3").html(data.km + "公里；");
                $("#Span4").html(parseInt(data.hour / 60) + "小时," + data.hour % 60 + "分钟；");
                $("#Span5").html("（超" + data.overkm + "公里）x（" + data.perkm + "元/公里）=" + (data.overkm * data.perkm).toFixed(2) + "元；");
                $("#Span6").html("（超" + parseInt(data.overhour / 60) + "小时" + parseInt(data.overhour % 60) + "分钟）x（" + data.perhour + "元/分钟）=" + (data.overhour * data.perhour).toFixed(2) + "元；");
                $("#Span7").html("0元");
            });
        });
        function changeType() {
            if ($("#personal").attr("checked") == "checked") {
                $("#personinvoice").show();
                $("#companyinvoice").hide();
                   $("#zengzhiinvoice").hide();
            }else    if ($("#enterprise").attr("checked") == "checked") {
                $("#personinvoice").hide();
                $("#companyinvoice").show();
                $("#zengzhiinvoice").hide();
                $("#invoiceclass").val(2);
            }
        }
        function ChangeInvoiceClass() {
            if ($("#invoiceclass").val() == "2") {
                $("#zengzhiinvoice").hide();
            } else {
                $("#zengzhiinvoice").show();
            }
        }
        function UploadImg() {
            var data = $("#attachment").val();
            $.ajax({
                url:"/api/ajaxfileupload.ashx",
                data: {img:data},
                type:"post",
                success:function() {
                    
                }
            });
        }
    </script>
    <style type="text/css">
        #input_hasnoinvoice
        {
            width: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sub-banner">
        <a class="sub-banner-a" href="" style="background: url(images/001_02.jpg) no-repeat 50% 0;">
            爱易租</a>
    </div>
    <div class="dc-process">
        <div class="step">
            <ul class="dc-step">
                <li class="step-one">1、选择用车方式</li>
                <li class="step-gray">2、选择车型</li>
                <li class="step-gray">3、填写联系人</li>
                <li class="step-gray-end step-orange-end">4、提交订单</li>
            </ul>
        </div>
        <div class="dc-info clearfix">
            <div class="dc-main">
                <div class="section">
                    <h3 class="per-info-til">
                        您选择的用车方式</h3>
                    <ul class="text-ul">
                        <li>用车方式：<%=useway %></li>
                        <% if (useway == "热门线路")
                           {%>
                        <li>出发地点：<%=startplace %></li>
                        <li>出发时间：<%=startDate %></li>
                        <li>目的地点：<%=endplace %></li>
                        <%   }
                           else if (useway == "接机")
                           {%>
                        <li>接机时间：<%=pickuptime %></li>
                        <li>机场名称：<%=airportname %></li>
                        <li>航班信息：<%=flightno %></li>
                        <li>目的地点：<%=endplace %></li>
                        <%   }
                           else if (useway == "送机")
                           {%>
                        <li>出发时间：<%=startDate %></li>
                        <li>出发地点：<%=startplace %></li>
                        <li>机场名称：<%=airportname %></li>
                        <% }
                           else if (useway == "时租")
                           {
                        %>
                        <li>用车时间：<%= startDate %></li>
                        <li>出发地点：<%= startplace %></li>
                        <li>目的地点：<%= endplace %></li>
                        <li>用车时长：<%= usehour %>小时</li>
                        <% }
                           else
                           {%>
                        <li>用车时间：<%= startDate %></li>
                        <li>出发地点：<%= startplace %></li>
                        <li>目的地点：<%= endplace %></li>
                        <li>用车时长：<%= usehour %>小时</li>
                        <%    }%>
                        <li>乘车人：<%=passegername %></li>
                        <li>联系电话：<%=Tephone %></li>
                    </ul>
                </div>
                <div class="section">
                    <h3 class="per-info-til">
                        您选择的车型信息</h3>
                    <ul class="text-ul">
                        <li>车型：<%=cartype %></li>
                        <li>乘客人数：<%=passengernum %>人</li>
                        <li>消费金额：<%=startprice %>元<%=tickinfo %></li>
                        <li>费用包含：<%=feeincludes %></li>
                        <li>超分钟：<%=hourprice %>元/分钟</li>
                        <li>超公里：<%=kiloprice %>元/公里 </li>
                    </ul>
                </div>
                <div class="section">
                    <h3 class="per-info-til">
                        结算信息</h3>
                    <ul class="text-ul">
                        <li>费用预估：<span id="PredictTotalFee"><img src="images/load.gif" /></span>元<br />
                            <div style="background: #F0F0F0; border: 1px solid #ddd; height: 140px; margin-left: 50px;
                                width: 600px; padding: 10px;">
                                <strong>费用总额：</strong><span id="Span1"><img src="images/load.gif" /></span><br />
                                <strong>起步价格：</strong><span id="Span2"><img src="images/load.gif" /></span> <strong>
                                    预计公里：</strong><span id="Span3"><img src="images/load.gif" /></span> <strong>预计用时：</strong><span
                                        id="Span4"><img src="images/load.gif" /></span><br />
                                <strong>超公里费：</strong><span id="Span5"><img src="images/load.gif" /></span><br />
                                <strong>超小时费：</strong><span id="Span6"><img src="images/load.gif" /></span><br />
                                <strong>空驶费用：</strong><span id="Span7"><img src="images/load.gif" /></span> (根据下车地点范围计算)<br />
                                <strong>温馨提示：</strong><span id="Span8">预估费用仅供参考，未考虑实际停车费用、高速过路费用、及堵车等特殊情况。</span>
                            </div>
                        </li>
                        <li>结算账户：<%=name %>(<%=accountType %>)</li>
                        <li><a target="_blank" href="PCenter/MyCoupon.aspx" style="color:#f90;">优惠券：</a><select id="selectcoupon" onchange="changeMoney('$(this).val()')">
                            <option value="0">请选择优惠券</option>
                        </select>&nbsp;&nbsp; 代金券：<select id="selectvouchers" onchange="changeMoneyVouchers('$(this).val()')">
                            <option value="0">请选择代金券</option>
                        </select>&nbsp;&nbsp;&nbsp;&nbsp;注意：优惠券和代金券不可同时使用！ </li>
                        <li>结算信息：<br />
                            <div style="background: #F0F0F0; border: 1px solid #ddd; height: 100px; margin-left: 50px;
                                width: 600px; padding: 10px;">
                                <span style="font-size: 14px;">
                                    <label style="font-weight: bold;">
                                        计费方式</label>（用车结束后按行驶时长、公里数计算相应费用）</span><br />
                                <span class="bold" style="font-size: 14px;">
                                    <label id="type">
                                        <%=useway %></label>价格=<label id="priceInfo"></label><label id="Label1"><strong class="f16 red"><%=startprice %></strong>元</label>+<label
                                            id="hourInfo">（<strong class="f16 red"><%=hourprice %></strong>元/分× 超时长）</label>+<label
                                                id="distanceInfo">（<strong class="f16 red"><%=kiloprice %></strong>元/公里 × 超行驶公里）</label>+<label>其他费用</label>（高速费、停车费、空驶费、夜间服务费）</span><br />
                            </div>
                        </li>
                        <li>
                            <div class="invoice">
                                索要发票：
                                <input type="checkbox" id="getInvoice" /></div>
                            <div class="invoiceInfo" style="display: none;">
                                <div id="radiocontainer" style="margin: 10px;">
                                    <input type="radio" id="input_hasinvoice" name="exitinvoice" checked="checked" onclick="changeInvoiceType()" />使用已有发票
                                    <input type="radio" id="input_hasnoinvoice" name="exitinvoice" onclick="changeInvoiceType()" />添加新发票
                                </div>
                                <div id="invoicecontainer" style="margin-left: 50px;">
                                    <ul>
                                        <li>发票抬头：<select id="ext_invoicetitle" onchange="getinvoice()">
                                            <option value="0">请选择</option>
                                        </select></li>
                                        <li>发票类型：<select id="ext_invoiceclass" disabled="disabled">
                                            <option value="2">普通发票 </option>
                                            <option value="1">增值税专用发票 </option>
                                        </select></li>
                                        <li>邮寄地址：<input type="text" id="ext_invoiceaddress" disabled="disabled" /></li>
                                        <li>发票内容：<select size="1" id="ext_invoicetype" disabled="disabled">
                                            <option value="1">租赁费</option>
                                            <option value="2">租赁服务费</option>
                                            <option value="3">汽车租赁费</option>
                                            <option value="4">代驾服务费</option>
                                        </select>
                                        </li>
                                        <li>邮政编码：<input type="text" id="ext_invoicezipcode" disabled="disabled" /></li>
                                    </ul>
                                </div>
                                <div id="noinvoicecontainer" style="display: none;">
                                    <span style="margin-left: 50px;">
                                        <input type="radio" id="personal" value="0" name="unit" checked="checked" onclick="changeType()" />个人
                                        <input type="radio" id="enterprise" value="1" name="unit" onclick="changeType()" />单位</span>
                                    <ul style="margin-left: 50px;" id="personinvoice">
                                        <li class="clearfix" id="person_name"><span class="invoice_tit">开票人姓名：</span><input
                                            id="username" type="text" maxlength="20" /></li>
                                        <li class="clearfix" id="person_ssn"><span class="invoice_tit">身&nbsp;份&nbsp;证&nbsp;号&nbsp;：</span><input
                                            id="ssn" type="text" style="width: 350px;" maxlength="48" /></li>
                                    </ul>
                                    <ul style="margin-left: 50px;" id="companyinvoice">
                                        <li class="clearfix" id="company_invoiceclass"><span class="invoice_tit">发&nbsp;票&nbsp;种&nbsp;类&nbsp;：</span><select
                                            id="invoiceclass" onchange="ChangeInvoiceClass()">
                                            <option value="2" selected="selected">普通发票 </option>
                                            <option value="1">增值税专用发票 </option>
                                        </select></li>
                                        <li class="clearfix" id="compnay_invoicetype"><span class="invoice_tit">发&nbsp;票&nbsp;内&nbsp;容&nbsp;：</span><select
                                            size="1" id="invoicetype">
                                            <option value="1">租赁费</option>
                                            <option value="2">租赁服务费</option>
                                            <option value="3">汽车租赁费</option>
                                            <option value="4">代驾服务费</option>
                                        </select>
                                        </li>
                                        <li class="clearfix" id="company_invoicetitle"><span class="invoice_tit">发&nbsp;票&nbsp;抬&nbsp;头&nbsp;：</span><input
                                            id="invoicehead" type="text" style="width: 350px;" maxlength="48" /></li>
                                        <li class="clearfix"><span class="invoice_tit">税务登记号：</span><input id="taxpayer"
                                            type="text" style="width: 350px;" maxlength="48" /></li></ul>
                                    <ul id="zengzhiinvoice" style="margin-left: 50px;">
                                        <!--公司发票-->
                                        <li class="clearfix"><span class="invoice_tit">公&nbsp;司&nbsp;地&nbsp;址：</span><input
                                            name="Text_CompAdd" id="Text_CompAdd" type="text" style="width: 350px; float: left;"
                                            maxlength="48" /></li>
                                        <li class="clearfix"><span class="invoice_tit">联&nbsp;系&nbsp;电&nbsp;话：</span><input
                                            name="Text_CompTel" id="Text_CompTel" type="text" maxlength="13" style="float: left;" /></li>
                                        <li class="clearfix"><span class="invoice_tit">开&nbsp;户&nbsp;银&nbsp;行：</span><input
                                            id="Text_CompBank" name="Text_CompBank" type="text" maxlength="20" style="float: left;" /></li>
                                        <li class="clearfix"><span class="invoice_tit">公&nbsp;司&nbsp;账&nbsp;号：</span><input
                                            id="Text_CompAccount" name="Text_CompAccount" type="text" maxlength="30" style="float: left;" /></li>
                                        <li class="clearfix"><span class="invoice_tit">营&nbsp;业&nbsp;执&nbsp;照：</span>
                                            <iframe src="/FileUpLoad.aspx?id=license&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="license" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <li class="clearfix"><span class="invoice_tit">税务登记证:</span>
                                            <iframe src="/FileUpLoad.aspx?id=taxlicense&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="taxlicense" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <li class="clearfix"><span class="invoice_tit">一般纳税人证明：</span>
                                            <iframe src="/FileUpLoad.aspx?id=commontaxpayer&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="commontaxpayer" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <li class="clearfix"><span class="invoice_tit">银行开户许可证：</span>
                                            <iframe src="/FileUpLoad.aspx?id=bankpermission&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="bankpermission" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <li class="clearfix"><span class="invoice_tit">组织机构代码证：</span>
                                            <iframe src="/FileUpLoad.aspx?id=orglicense&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="orglicense" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <li class="clearfix"><span class="invoice_tit">法人身份证：</span>
                                            <iframe src="/FileUpLoad.aspx?id=lawerid&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="lawerid" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <li class="clearfix"><span class="invoice_tit">经办人身份证：</span>
                                            <iframe src="/FileUpLoad.aspx?id=agentid&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="agentid" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <li class="clearfix"><span class="invoice_tit">单位介绍信：</span>
                                            <iframe src="/FileUpLoad.aspx?id=introductmsg&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="introductmsg" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <li class="clearfix"><span class="invoice_tit">开票资料：</span>
                                            <iframe src="/FileUpLoad.aspx?id=resource&folder=invoice" frameborder="0" style="border: 0px;
                                                height: 24px; width: 155px; float: left;"></iframe>
                                            <input type="text" id="resource" readonly="readonly" style="width: 250px; float: left;" />
                                        </li>
                                        <!--公司发票-->
                                    </ul>
                                    <ul style="margin-left: 50px;">
                                        <li class="clearfix"><span class="invoice_tit">邮&nbsp;寄&nbsp;地&nbsp;址&nbsp;：</span><input
                                            type="text" id="noext_invoiceaddress" maxlength="100" /></li>
                                        <li class="clearfix"><span class="invoice_tit">邮&nbsp;政&nbsp;编&nbsp;码&nbsp;：</span><input
                                            type="text" id="noext_invoicezipcode" /></li>
                                    </ul>
                                </div>
                                <div class="clear">
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="of-h pd20">
                    <div class="l">
                        <label>
                            <input id="accept" type="checkbox" checked="checked" /><a href="http://iezu.cn/article.aspx?typeid=29&id=61"
                                target="_blank">同意爱易租用车《服务协议》</a></label></div>
                </div>
                <div class="P_Hint" style="width: 700px; margin: 10px 0px; font-size: 12px;">
                    <em>友情提示：</em>如果您因自身原因取消已派车的订单，会视情况产生手续费。<a href="javascript:;" id="A_ShowRule">查看扣费规则</a><br />
                    <div style="display: none;">
                        <%foreach (var chargeModel in listcharge)
                          {
                              if (!string.IsNullOrEmpty(chargeModel.Description))
                              {
                                  Response.Write(chargeModel.Description);
                              }

                          } %><a href="javascript:;" id="A_HiddenRule">收起</a></div>
                </div>
                <script type="text/javascript">
                    $(document).ready(function () {
                        $("#A_ShowRule").click(function () {
                            $(this).hide();
                            $(".P_Hint span").show();
                            $(".P_Hint div").show();
                        });
                        $("#A_HiddenRule").click(function () {
                            $("#A_ShowRule").show();
                            $(".P_Hint div").hide();
                        });
                    });
                </script>
                <p>
                    <div class="price-total" style="float: right; font-size: 24px;">
                        <strong>订单总额：</strong> <em class="price" id="paynum" style="font-size: 24px;">
                            <%=startprice %></em>元</div>
                    <input type="hidden" value="<%=startprice %>" id="txthide" />
                    <div style="clear: both;">
                    </div>
                </p>
                <p class="yc-type">
                    <input class="yc-btn" onclick="submitOrder() " id="btnSubmitorder" value="下一步，提交订单"
                        type="button" style="border: 0;" />
                </p>
            </div>
        </div>
    </div>
    <form action="/PayOrder.aspx" id="formOrder" method="post">
    <input type="hidden" id="order" runat="server" name="order" />
    </form>
</asp:Content>
