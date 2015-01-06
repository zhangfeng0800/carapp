<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyInvoiceEdit.aspx.cs" Inherits="WebApp.PCenter.MyInvoiceEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <h3 class="per-order-til">
                发票信息</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <form action="MyInvoiceManager.aspx" method="post" id="sendData">
                <input type="hidden" value="upDate" name="event" />
                <input type="hidden" value="<%=Request.QueryString["id"] %>" id="updateid" />
                <input type="hidden" value="<%=data.Rows[0]["type"] %>" id="type" />
                <input type="hidden" value="<%=data.Rows[0]["invoiceclass"] %>" id="invoiceclassContainer" />
                <%
                    if (data.Rows[0]["type"].ToString() == "个人")
                    {%>
                <script>
                    $(function () {
                        $("#btnsave").click(function () {
                            submitPersonInvoice();
                        });
                    });
                    function submitPersonInvoice() {
                        var data = {
                            username: $("#username").val(),
                            ssn: $("#ssn").val(),
                            address: $("#noext_invoiceaddress").val(),
                            zipcode: $("#noext_invoicezipcode").val(),
                            type: "0",
                            invoiceid: $("#updateid").val(),
                            action: "edit"
                        }
                        $.ajax({
                            url: "/api/invoicehandler.ashx",
                            data: data,
                            type: "post",
                            success: function (val) {
                                if (val.resultcode == 0) {
                                    alert("请登录");
                                    window.location.href = "/login.aspx";
                                }
                                else if (val.resultcode == -1) {
                                    alert(val.msg);
                                } else {
                                    alert(val.msg);
                                    window.location.href = "/pcenter/myinvoice.aspx";
                                }
                            },
                            error: function () {
                                alert("操作失败");
                            }
                        });

                    }
                </script>
                <ul class="per-ul" id="personinvoice">
                    <li id="person_name"><span class="per-name-style" style="width: 100px;">开票人姓名：</span><input
                        id="username" type="text" maxlength="20" value="<%=data.Rows[0]["invoicehead"].ToString() %>"></li>
                    <li id="person_ssn"><span class="per-name-style" style="width: 100px;">身份证号：</span><input
                        id="ssn" type="text" style="width: 350px;" maxlength="48" value="<%=data.Rows[0]["cardno"].ToString() %>"></li>
                </ul>
                <% }
                    else if (data.Rows[0]["type"].ToString() == "单位")
                    {%>
                <script>
                     $(function () {
                        $("#btnsave").click(function () {
                            submitCompanyInvoice();
                        });
                    });
                    function submitCompanyInvoice() {
                        var posdata;
                        posdata = {
                            invoiceClass: $("#invoiceclass").val(),
                            invoiceType: $("#invoicetype").val(),
                            invoiceHead: $("#invoicehead").val(),
                            TaxpayerID: $("#taxpayer").val(),
                            invoiceid: $("#updateid").val(),
                            action: "edit",
                            address: $("#noext_invoiceaddress").val(),
                            zipcode: $("#noext_invoicezipcode").val(),
                        };
                        if (<%=data.Rows[0]["invoiceclass"] %>==1) {
                           
                            posdata.invoiceType = $("#invoicetype").val();
                            posdata.invoiceHead = $("#invoicehead").val();
                            posdata.TaxpayerID = $("#taxpayer").val();
                            posdata.CompAdd = $("#Text_CompAdd").val();
                            posdata.CompTel = $("#Text_CompTel").val();
                            posdata.CompBank = $("#Text_CompBank").val();
                            posdata.CompAccount = $("#Text_CompAccount").val();
                            posdata.licence = $("#license").val();
                            posdata.taxlicense = $("#taxlicense").val();
                            posdata.commontaxpayer = $("#commontaxpayer").val();
                            posdata.bankpermission = $("#bankpermission").val();
                            posdata.orglicense = $("#orglicense").val();
                            posdata.lawerid = $("#lawerid").val();
                            posdata.agentid = $("#agentid").val();
                            posdata.introductmsg = $("#introductmsg").val();
                            posdata.resource = $("#resource").val(); 
                            posdata.type = 1;
                        } else {
                            posdata.type = 2;
                        }
                        $.ajax({
                            url: "/api/invoicehandler.ashx",
                            data: posdata,
                            type: "post",
                            success: function (val) {
                                if (val.resultcode == 0) {
                                    alert("请登录");
                                    window.location.href = "/login.aspx";
                                }
                                else if (val.resultcode == -1) {
                                    alert(val.msg);
                                } else {
                                    alert(val.msg);
                                    window.location.href = "/pcenter/myinvoice.aspx";
                                }
                            },
                            error: function () {
                                alert("操作失败");
                            }
                        });
                    }
                </script>
                <ul class="per-ul" id="companyinvoice">
                    <li id="compnay_invoicetype"><span class="per-name-style" style="width: 100px;">发&nbsp;票&nbsp;内&nbsp;容&nbsp;：</span><select
                        size="1" id="invoicetype">
                        <option value="1">租赁费</option>
                        <option value="2">租赁服务费</option>
                        <option value="3">汽车租赁费</option>
                        <option value="4">代驾服务费</option>
                    </select>
                    </li>
                    <li id="company_invoicetitle"><span class="per-name-style" style="width: 100px;">发&nbsp;票&nbsp;抬&nbsp;头&nbsp;：</span><input
                        id="invoicehead" type="text" style="width: 350px;" maxlength="48" value="<%=data.Rows[0]["invoicehead"] %>" /></li>
                    <li><span class="per-name-style" style="width: 100px;">税务登记号： </span>
                        <input id="taxpayer" type="text" style="width: 350px;" maxlength="48" value="<%=data.Rows[0]["taxpayerid"] %>" /></li>
                </ul>
                <%
                        if (data.Rows[0]["invoiceclass"].ToString() == "1")
                        {%>
                <ul id="zengzhiinvoice" class="per-ul">
                    <!--公司发票-->
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">公&nbsp;司&nbsp;地&nbsp;址&nbsp;：</span><input
                        name="Text_CompAdd" id="Text_CompAdd" type="text" style="width: 350px;" maxlength="48"
                        value="<%=data.Rows[0]["compadd"] %>"></li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">联&nbsp;系&nbsp;电&nbsp;话&nbsp;：</span>
                        <input name="Text_CompTel" id="Text_CompTel" type="text" maxlength="13" value="<%=data.Rows[0]["comptel"] %>" /></li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">开&nbsp;户&nbsp;银&nbsp;行&nbsp;：</span>
                        <input id="Text_CompBank" name="Text_CompBank" type="text" maxlength="20" value="<%=data.Rows[0]["compbank"] %>" /></li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">公&nbsp;司&nbsp;账&nbsp;号&nbsp;：</span>
                        <input id="Text_CompAccount" name="Text_CompAccount" type="text" maxlength="30" value="<%=data.Rows[0]["compaccount"] %>" /></li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">营&nbsp;业&nbsp;执&nbsp;照&nbsp;：</span>
                        <iframe src="/FileUpLoad.aspx?id=license&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px;float:left;"></iframe>
                        <input type="text" id="license" readonly="readonly" style="width: 250px;float:left;" value="<%=data.Rows[0]["businesslicence"] %>" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">税务登记证：</span>
                        <iframe src="/FileUpLoad.aspx?id=taxlicense&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px;float:left;"></iframe>
                        <input type="text" id="taxlicense" readonly="readonly" style="width: 250px;float:left;" value="<%=data.Rows[0]["taxpaylicence"] %>" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">一般纳税人证明：</span>
                        <iframe src="/FileUpLoad.aspx?id=commontaxpayer&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px;float:left;"></iframe>
                        <input type="text" id="commontaxpayer" readonly="readonly" style="width: 250px; float:left;"
                            value="<%=data.Rows[0]["commontaxpaylicence"] %>" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">银行开户许可证：</span>
                        <iframe src="/FileUpLoad.aspx?id=bankpermission&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px;float:left;"></iframe>
                        <input type="text" id="bankpermission" readonly="readonly" style="width: 250px;float:left;"
                            value="<%=data.Rows[0]["bankaccountpermission"] %>" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">组织机构代码证：</span>
                        <iframe src="/FileUpLoad.aspx?id=orglicense&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="orglicense" readonly="readonly" style="width: 250px; float:left;" value="<%=data.Rows[0]["OrgCodeLicence"] %>" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">法人身份证：</span>
                        <iframe src="/FileUpLoad.aspx?id=lawerid&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="lawerid" readonly="readonly" style="width: 250px; float:left;" value="<%=data.Rows[0]["legalpersoncard"] %>" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">经办人身份证：</span>
                        <iframe src="/FileUpLoad.aspx?id=agentid&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="agentid" readonly="readonly" style="width: 250px; float:left;" value="<%=data.Rows[0]["agentcard"] %>" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">单位介绍信：</span>
                        <iframe src="/FileUpLoad.aspx?id=introductmsg&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="introductmsg" readonly="readonly" style="width: 250px; float:left;" value="<%=data.Rows[0]["InstrduceEnvelope"] %>" />
                    </li>
                    <li class="clearfix"><span class="per-name-style" style="width: 100px;">开票资料：</span>
                        <iframe src="/FileUpLoad.aspx?id=resource&folder=invoice" frameborder="0" style="border: 0px;
                            height: 43px; width: 155px; float:left;"></iframe>
                        <input type="text" id="resource" readonly="readonly" style="width: 250px; float:left;" value="<%=data.Rows[0]["invoiceresource"] %>" />
                    </li>
                    <!--公司发票-->
                </ul>
                <% }
                %>
                <% }
                %>
                <ul class="per-ul">
                    <li><span class="per-name-style" style="width: 100px;">邮&nbsp;寄&nbsp;地&nbsp;址&nbsp;：</span><input
                        type="text" id="noext_invoiceaddress" maxlength="100" value="<%=data.Rows[0]["invoiceadress"] %>" /></li>
                    <li><span class="per-name-style" style="width: 100px;">邮&nbsp;政&nbsp;编&nbsp;码&nbsp;：</span><input
                        type="text" id="noext_invoicezipcode" value="<%=data.Rows[0]["invoicezipcode"] %>" /></li>
                    <li class="per-button-padding">
                        <input class="yc-btn bank-btn per-button-border" type="button" value="保存" id="btnsave" /></li>
                </ul>
                </form>
            </div>
        </div>
    </div>
</asp:Content>
