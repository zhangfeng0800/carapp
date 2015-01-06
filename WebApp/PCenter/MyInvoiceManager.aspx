<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyInvoiceManager.aspx.cs" Inherits="WebApp.PCenter.MyInvoiceManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/MySite.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            SetSelectValue("content", '<%=invoice.InvoiceType %>');
            SetSelectValue("Iclass", '<%=invoice.invoiceClass %>');
            SetCompInfo();
            $("#Iclass").change(function () {
                SetCompInfo();
            });

            $("#personal").attr("checked", "checked");
            $("#personinvoice").show();
            $("#companyinvoice").hide();
            $("#zengzhiinvoice").hide();
            $("#invoiceclass").val(2);
        });

        function SetCompInfo() {
            if ($("#Iclass").val() == "1")
                $(".Li_CompInfo").show();
            else
                $(".Li_CompInfo").hide();
        }
        function checkNull() {
            //            if ($("input[name='title']").val() == "") {
            //                alert("发票抬头不能为空");
            //                return false;
            //            } else if ($("input[name='title']").val().length > 50) {
            //                alert("发票抬头长度不能超过50个字符");
            //                return false;
            //            }
            //            if ($("#Iclass").val() == "1") {
            //                if ($("#Text_TaxpayerID").val() == "") {
            //                    alert("纳税人识别号不能为空");
            //                    return false;
            //                }
            //                if ($("#Text_CompAdd").val() == "") {
            //                    alert("公司地址不能为空");
            //                    return false;
            //                }
            //                if ($("#Text_CompTel").val() == "") {
            //                    alert("联系电话不能为空");
            //                    return false;
            //                }
            //                if (!isPhone($("#Text_CompTel").val())) {
            //                    alert("联系电话格式有误");
            //                    return false;
            //                }
            //                if ($("#Text_CompBank").val() == "") {
            //                    alert("开户行不能为空");
            //                    return false;
            //                }
            //                if ($("#Text_CompAccount").val() == "") {
            //                    alert("公司账户不能为空");
            //                    return false;
            //                }
            //            }
            //            if ($("#Iclass").val() == "-1") {
            //                alert("请选择发票种类");
            //                return false;
            //            }
            //            if ($("#address").val() == "") {
            //                alert("邮寄地址不能为空");
            //                return false;
            //            }
            //            if ($("input[name='zipCode']").val() == "") {
            //                alert("邮政编码不能为空");
            //                return false;
            //            }
            //            if (!isZipcode($("input[name='zipCode']").val())) {
            //                alert("邮政编码格式错误");
            //                return false;
            //            }
            //            $("#Button_Submit").attr("disabled", "disabled");
            //            $("#sendData").submit();
            var posdata;
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
                    licence: $("#license").val(),
                    taxlicense: $("#taxlicense").val(),
                    commontaxpayer: $("#commontaxpayer").val(),
                    bankpermission: $("#bankpermission").val(),
                    orglicense: $("#orglicense").val(),
                    lawerid: $("#lawerid").val(),
                    agentid: $("#agentid").val(),
                    introductmsg: $("#introductmsg").val(),
                    resource: $("#resource").val()
                };
            }
            posdata.address = $("#noext_invoiceaddress").val();
            posdata.zipcode = $("#noext_invoicezipcode").val();
            posdata.action = "add";
            posdata.ordermessage = "";
            posdata.orderId = $("#ContentPlaceHolder1_order").val();
            posdata.ordermoney = $("#paynum").text();
            posdata.couponId = $("#selectcoupon").val();
            posdata.isinvoice = 0;
            posdata.invoiceid = 0;
            posdata.vouchersId = $("#selectvouchers").val();
            posdata.invoice = invoiceType;
            $.ajax({
                url: "/api/invoicehandler.ashx",
                data: posdata,
                type: "post",
                success: function (data) {
                    if (data.resultcode == 0) {
                        alert("请登录");
                        window.location.href = "/login.aspx";
                    } else if (data.resultcode == -1) {
                        alert("添加失败");
                    } else {
                        alert("添加成功");
                        window.location.href = "/pcenter/MyInvoice.aspx";
                    }
                }, error: function () {
                    alert("添加失败");
                }
            });
        }
        function changeType() {
            if ($("#personal").attr("checked") == "checked") {
                $("#personinvoice").show();
                $("#companyinvoice").hide();
                $("#zengzhiinvoice").hide();
                $("#invoiceclass").val(2);
            } else {
                $("#personinvoice").hide();
                $("#companyinvoice").show();
                $("#zengzhiinvoice").hide();
                $("#invoiceclass").val(2);
            }
        }
        function ChangeInvoiceClass() {
            if ($("#invoiceclass").val() == 2) {
                $("#zengzhiinvoice").hide();
            } else {
                $("#zengzhiinvoice").show();
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <h3 class="per-order-til">
                发票信息</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <form action="MyInvoiceManager.aspx" method="post" id="sendData">
                <input type="hidden" value="upDate" name="event" />
                <input type="hidden" value="<%=FormMethod %>" name="formMethod" />
                <input type="hidden" value="<%=Request.QueryString["id"] %>" name="updateid" />
                <ul style="margin-left: 60px;">
                    <li>
                        <input type="radio" id="personal" value="0" name="unit" checked="checked" onclick="changeType()" />个人
                        <input type="radio" id="enterprise" value="1" name="unit" onclick="changeType()" />单位
                    </li>
                </ul>
                <ul class="per-ul" id="personinvoice">
                    <li id="person_name"><span class="per-name-style" style="width: 100px;">开票人姓名：</span><input
                        id="username" type="text" maxlength="20"></li>
                    <li id="person_ssn"><span class="per-name-style" style="width: 100px;">身份证号：</span><input
                        id="ssn" type="text" style="width: 350px;" maxlength="48"></li>
                </ul>
                <ul class="per-ul" id="companyinvoice">
                    <li id="company_invoiceclass"><span class="per-name-style" style="width: 100px;">发&nbsp;票&nbsp;种&nbsp;类&nbsp;：</span><select
                        id="invoiceclass" onchange="ChangeInvoiceClass()">
                        <option value="2" selected="selected">普通发票 </option>
                        <option value="1">增值税专用发票 </option>
                    </select></li>
                    <li id="compnay_invoicetype"><span class="per-name-style" style="width: 100px;">发&nbsp;票&nbsp;内&nbsp;容&nbsp;：</span><select
                        size="1" id="invoicetype">
                        <option value="1">租赁费</option>
                        <option value="2">租赁服务费</option>
                        <option value="3">汽车租赁费</option>
                        <option value="4">代驾服务费</option>
                    </select>
                    </li>
                    <li id="company_invoicetitle"><span class="per-name-style" style="width: 100px;">发&nbsp;票&nbsp;抬&nbsp;头&nbsp;：</span><input
                        id="invoicehead" type="text" style="width: 350px;" maxlength="48" /></li>
                    <li><span class="per-name-style" style="width: 100px;">税务登记号： </span>
                        <input id="taxpayer" type="text" style="width: 350px;" maxlength="48" /></li>
                </ul>
                <ul id="zengzhiinvoice" class="per-ul">
                    <!--公司发票-->
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">公&nbsp;司&nbsp;地&nbsp;址&nbsp;：</span><input
                        name="Text_CompAdd" id="Text_CompAdd" type="text" style="width: 350px;" maxlength="48"></li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">联&nbsp;系&nbsp;电&nbsp;话&nbsp;：</span><input
                        name="Text_CompTel" id="Text_CompTel" type="text" maxlength="13"></li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">开&nbsp;户&nbsp;银&nbsp;行&nbsp;：</span><input
                        id="Text_CompBank" name="Text_CompBank" type="text" maxlength="20"></li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">公&nbsp;司&nbsp;账&nbsp;号&nbsp;：</span><input
                        id="Text_CompAccount" name="Text_CompAccount" type="text" maxlength="30"></li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">营&nbsp;业&nbsp;执&nbsp;照&nbsp;：</span>
                        <iframe src="/FileUpLoad.aspx?id=license&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="license" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">税务登记证：</span>
                        <iframe src="/FileUpLoad.aspx?id=taxlicense&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="taxlicense" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">一般纳税人证明：</span>
                        <iframe src="/FileUpLoad.aspx?id=commontaxpayer&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="commontaxpayer" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">银行开户许可证：</span>
                        <iframe src="/FileUpLoad.aspx?id=bankpermission&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="bankpermission" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">组织机构代码证：</span>
                        <iframe src="/FileUpLoad.aspx?id=orglicense&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="orglicense" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">法人身份证：</span>
                        <iframe src="/FileUpLoad.aspx?id=lawerid&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="lawerid" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">经办人身份证：</span>
                        <iframe src="/FileUpLoad.aspx?id=agentid&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="agentid" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">单位介绍信：</span>
                        <iframe src="/FileUpLoad.aspx?id=introductmsg&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="introductmsg" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">开票资料：</span>
                        <iframe src="/FileUpLoad.aspx?id=resource&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="resource" readonly="readonly" style="width: 250px; float:left;" />
                    </li>
                    <!--公司发票-->
                </ul>
                <ul class="per-ul">
                    <li><span class="per-name-style" style="width: 100px;">邮&nbsp;寄&nbsp;地&nbsp;址&nbsp;：</span><input
                        type="text" id="noext_invoiceaddress" maxlength="100" /></li>
                    <li><span class="per-name-style" style="width: 100px;">邮&nbsp;政&nbsp;编&nbsp;码&nbsp;：</span><input
                        type="text" id="noext_invoicezipcode" /></li>
                    <li class="per-button-padding">
                        <input class="yc-btn bank-btn per-button-border" type="button" value="保存" onclick="checkNull()" /></li>
                </ul>
                <%--<ul class="per-ul">
                    <li><span class="per-name-style" style="width: 80px;">*发票种类：</span>
                        <select id="Iclass" name="Iclass">
                            <option value="<%=Convert.ToInt32(Model.Enume.InvoiceClass.普通发票) %>">普通发票</option>
                            <option value="<%=Convert.ToInt32(Model.Enume.InvoiceClass.增值税专用发票) %>">增值税专用发票</option>
                        </select></li>
                    <li><span class="per-name-style" style="width: 80px;">*发票抬头：</span>
                        <input type="text" name="title" value="<%=invoice.InvoiceHead %>" maxlength="50" /></li>
                    <li><span class="per-name-style" style="width: 80px;">*发票内容：</span>
                        <select id="content" name="content">
                            <option value="<%=Convert.ToInt32(Model.Enume.InvoiceType.租赁费) %>">租赁费</option>
                            <option value="<%=Convert.ToInt32(Model.Enume.InvoiceType.租赁服务费) %>">租赁服务费</option>
                            <option value="<%=Convert.ToInt32(Model.Enume.InvoiceType.汽车租赁费) %>">汽车租赁费</option>
                            <option value="<%=Convert.ToInt32(Model.Enume.InvoiceType.代驾服务费) %>">代驾服务费</option>
                        </select></li>
                    <!--公司发票-->
				    <li class="Li_CompInfo"><span class="per-name-style" style="width: 80px;">*纳税标识：</span>
					    <input class="input_style" name="Text_TaxpayerID" id="Text_TaxpayerID" type="text" value="<%=invoice.TaxpayerID%>" maxlength="20"></li>
				    <li class="Li_CompInfo"><span class="per-name-style" style="width: 80px;">*公司地址：</span>
					    <input class="input_style" style="width: 350px;" name="Text_CompAdd" id="Text_CompAdd" type="text" value="<%=invoice.CompAdd%>" maxlength="48"></li>
				    <li class="Li_CompInfo"><span class="per-name-style" style="width: 80px;">*联系电话：</span>
					    <input class="input_style" id="Text_CompTel" name="Text_CompTel" type="text" value="<%=invoice.CompTel%>" maxlength="13"></li>
				    <li class="Li_CompInfo"><span class="per-name-style" style="width: 80px;">*开户行：</span>
					    <input class="input_style" id="Text_CompBank" name="Text_CompBank" type="text" value="<%=invoice.CompBank%>" maxlength="20"></li>
				    <li class="Li_CompInfo"><span class="per-name-style" style="width: 80px;">*公司账号：</span>
					    <input class="input_style" id="Text_CompAccount" name="Text_CompAccount" type="text" value="<%=invoice.CompAccount%>" maxlength="30"></li>
                    <!--公司发票-->
                    <li><span class="per-name-style" style="width: 80px;">*邮寄地址：</span>
                        <input type="text" name="address" style="width: 350px;" value="<%=invoice.InvoiceAdress==null?invoice.InvoiceAdress:invoice.InvoiceAdress.Trim() %>" id="address" maxlength="100" /></li>
                    <li><span class="per-name-style" style="width: 80px;">*邮政编码：</span>
                        <input type="text" name="zipCode" value="<%=invoice.InvoiceZipCode==null?invoice.InvoiceZipCode:invoice.InvoiceZipCode.Trim() %>" maxlength="6" /></li>
                           <li><label id="error" style="color:Red"></label> </li>
                    <li class="per-button-padding">
                        <input class="yc-btn bank-btn per-button-border" type="button" value="保存" onclick="checkNull()" /></li>
                </ul>--%>
                </form>
            </div>
        </div>
    </div>
</asp:Content>
