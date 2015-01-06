<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="AuthorizeUserManager.aspx.cs" Inherits="WebApp.PCenter.AuthorizeUserManager" %>
<%@ Import Namespace="Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/SelectDate.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.validate.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnadduser").click(function () {
                if (!Check())
                    return false;
                var Action = "";
                if (GetQueryString("Uid") == "0")
                    Action = "Add";
                else
                    Action = "Update";
                $.post("AuthorizeUserManager.aspx", {
                    Action: Action,
                    Uid: GetQueryString("Uid"),
                    username: $("#mobile").val().Trim(),
                    compname: $("#auth_name").val().Trim(),
                    telphone: $("#mobile").val().Trim(),
                    password: $("#password").val().Trim(),
                    //balance: $("").val().Trim(),
                    //email: $("").val().Trim(),
                    type: GetSelectValue("sel_role"),
                    //pid: $("").val().Trim(),
                    //creater: $("").val().Trim(),
                    //tel: $("").val().Trim(),
                    //isdelete: $("").val().Trim(),
                    deadline: $("#Text_DateLL").val().Trim(),
                    dateRest: GetSelectValue("sel_time"),
                    workday: GetSelectValue("limit_days"),
                    timeLL: GetSelectValue("start_hour"),
                    timeUL: GetSelectValue("end_hour"),
                    costType: GetSelectValue("sel_credit"),
                    costToplimit: $("#uCredits").val(),
                    //balance:$(""),
                    //refurbishTime:$(""),
                    carType: GetCheckboxValue("cartype")
                    //userId:$(""),
                    //status: $("")
                }, function (data) {
                    if (data.Message == "Complete") {
                        alert("提交成功！");
                        window.location.href = "AuthorizeUser.aspx";
                    }
                    else {
                        alert(data.Message);
                    }
                });
            });
            $("#Checkbox_SelectAll").click(function () {
                if ($(this).attr("checked") == "checked") {
                    $("input[name='cartype']").attr("checked", "checked");
                }
                else {
                    $("input[name='cartype']").removeAttr("checked");
                }
            });
        });

        function Check() {
            if ($("#auth_name").val().Trim() == "" || $("#auth_name").val().Trim() == "姓名") {
                alert("请填写被授权人姓名！");
                $("#auth_name").focus();
                return false;
            }
            if (!isChn($("#auth_name").val().Trim())) {
                alert("请用汉字填写被授权人姓名！");
                $("#auth_name").focus();
                return false;
            }
            if ($("#auth_name").val().Trim().length < 2) {
                alert("姓名长度过短！");
                $("#auth_name").focus();
                return false;
            }
            if ($("#mobile").val().Trim() == "") {
                alert("请填写被授权人手机号码！");
                $("#mobile").focus();
                return false;
            }
            if (!isMobile($("#mobile").val().Trim())) {
                alert("被授权人手机号码格式不正确！");
                $("#mobile").focus();
                return false;
            }
            if (GetQueryString("Uid") != "0") {//修改
                if ($("#password").val().Trim().length < 6 && $("#password").val().Trim() != "") {
                    alert("登录密码过短！");
                    $("#password").focus();
                    return false;
                }
                if ($("#repassword").val().Trim() != $("#password").val().Trim()) {
                    alert("两次填写的密码不一致！");
                    $("#repassword").focus();
                    return false;
                }
            } else {//添加
                if ($("#password").val().Trim() == "") {
                    alert("请填写登录密码！");
                    $("#password").focus();
                    return false;
                }
                if ($("#password").val().Trim().length < 6) {
                    alert("登录密码过短！");
                    $("#password").focus();
                    return false;
                }
                if ($("#repassword").val().Trim() != $("#password").val().Trim()) {
                    alert("两次填写的密码不一致！");
                    $("#repassword").focus();
                    return false;
                }
            }
            return true;
        }

        function showRestrict(val, element) {
            if (val == 0) {
                $(element).hide();
            } else {
                $(element).show();
            }
        }
        $(function () {
            if (GetSelectValue("sel_time") != "0")
                showRestrict($("#sel_time").val(), "#s_xz");
            if (GetSelectValue("sel_credit") != "0")
                showRestrict($("#sel_credit").val(), "#s_je");
            $("#sel_time").change(function () {
                showRestrict($("#sel_time").val(), "#s_xz");
            });
            $("#sel_credit").change(function () {
                showRestrict($("#sel_credit").val(), "#s_je");
            });
            $("#btnadduser").click(function () {
                //postAuthorizeUser();
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">    
    <h3 class="per-order-til">授权人管理</h3>
        <div class="row">
            <span class="labelname">被授权人姓名</span> <span class="labelContent">
                <input type="text" name="auth_name" id="auth_name" value="<%= tempUser.Compname %>" class="text" placeholder="姓名"/></span>
        </div>
        <div class="row">
            <div class="labelname">
                被授权人手机号码</div>
            <div class="labelContent">
                <input type="text" name="mobile" id="mobile" value="<%= tempUser.Telphone %>" class="text" maxlength="11" placeholder=""/></div>
        </div>
        <div class="row">
            <div class="labelname">
                登录密码</div>
            <div class="labelContent">
                <input type="password" name="password" id="password" value="" class="text" maxlength="11" placeholder=""/>
                <% if (Request.QueryString["Uid"] != null){ %>
                <span class="Span_Hint">不修改密码请留空</span>
                <% } %>
                </div>
        </div>
        <div class="row">
            <div class="labelname">
                确认登录密码</div>
            <div class="labelContent">
                <input type="password" name="repassword" id="repassword" value="" class="text" maxlength="11" placeholder=""/></div>
        </div>
        <div class="row">
            <label class="labelname" for="sel_role">
                角色</label>
            <select id="sel_role" name="role" disabled="disabled">
                <option value="1">部门经理</option>
                <option value="2">部门员工</option>
            </select>
            <script type="text/javascript">SetSelectValue("sel_role", "<%= tempUser.Type %>")</script>
        </div>
        <div class="row">
            <label class="labelname" for="endTime">
                有效期至</label>
            <input id="Text_DateLL" value="<%= tempRest.Deadline.ToString("yyyy-MM-dd") %>" class="Input_TM W_S H_XXS" type="text" onclick="fPopCalendar(event,this,this)" name="Text_DateLL" onfocus="this.select()" readonly="readonly" />
        </div>
        <div class="row" style="">
            <label class="iblk lh30 w122 ar pr10 labelname">
                用车时间段</label>
            <select id="sel_time" name="sel_time" w="197">
                <option value="1">限制</option>
                <option value="0" selected="selected">不限制</option>
            </select>
            <script type="text/javascript">SetSelectValue("sel_time", "<%= tempRest.DateRest %>")</script>
            <span id="s_xz" style="margin-left: 10px; margin-top: 20px; display: none;"><em style="vertical-align: -5px;
                *vertical-align: middle;">可在</em>
                <select name="limit_days" id="limit_days" w="90">
                    <option value="1">周一～周五</option>
                    <option value="0">周一～周日</option>
                </select>
            <script type="text/javascript">SetSelectValue("limit_days", "<%= tempRest.Workday %>")</script>
                <select name="start_hour" id="start_hour" w="60">
                    <option value="0" selected="selected">0：00</option>
                    <option value="1">1：00</option>
                    <option value="2">2：00</option>
                    <option value="3">3：00</option>
                    <option value="4">4：00</option>
                    <option value="5">5：00</option>
                    <option value="6">6：00</option>
                    <option value="7">7：00</option>
                    <option value="8">8：00</option>
                    <option value="9">9：00</option>
                    <option value="10">10：00</option>
                    <option value="11">11：00</option>
                    <option value="12：00">12：00</option>
                    <option value="13">13：00</option>
                    <option value="14">14：00</option>
                    <option value="15">15：00</option>
                    <option value="16">16：00</option>
                    <option value="17">17：00</option>
                    <option value="18">18：00</option>
                    <option value="19">19：00</option>
                    <option value="20">20：00</option>
                    <option value="21">21：00</option>
                    <option value="22">22：00</option>
                    <option value="23">23：00</option>
                </select>
            <script type="text/javascript">SetSelectValue("start_hour", "<%= tempRest.TimeLL %>")</script>
                <em style="vertical-align: -5px; *vertical-align: middle;">至</em>
                <select name="end_hour" id="end_hour" w="60">
                    <option value="0" selected="selected">0：00</option>
                    <option value="1">1：00</option>
                    <option value="2">2：00</option>
                    <option value="3">3：00</option>
                    <option value="4">4：00</option>
                    <option value="5">5：00</option>
                    <option value="6">6：00</option>
                    <option value="7">7：00</option>
                    <option value="8">8：00</option>
                    <option value="9">9：00</option>
                    <option value="10">10：00</option>
                    <option value="11">11：00</option>
                    <option value="12：00">12：00</option>
                    <option value="13">13：00</option>
                    <option value="14">14：00</option>
                    <option value="15">15：00</option>
                    <option value="16">16：00</option>
                    <option value="17">17：00</option>
                    <option value="18">18：00</option>
                    <option value="19">19：00</option>
                    <option value="20">20：00</option>
                    <option value="21">21：00</option>
                    <option value="22">22：00</option>
                    <option value="23">23：00</option>
                </select>
            <script type="text/javascript">SetSelectValue("end_hour", "<%= tempRest.TimeUL %>")</script>
                <em style="vertical-align: -5px; *vertical-align: middle;">用车</em> </span>
        </div>
        <div class="row">
            <label for="credit_type" class="labelname">
                使用额度</label>
            <select id="sel_credit" name="credit_type" w="197">
                <option selected="selected" value="0">不限制</option>
                <option value="1">每次累计可用</option>
                <option value="2">每月累计可用</option>
            </select>
            <script type="text/javascript">SetSelectValue("sel_credit", "<%= tempRest.CostType %>")</script>
            <span id="s_je" style="display: none;">
                <input name="uCredits" id="uCredits" type="text" class="txt_bg w150" value="<%= tempRest.CostToplimit %>">
                元 </span>
        &nbsp;</div>
        <div class="row">
            <label class="iblk lh30 w122 ar pr10 labelname">可用车型</label>
            <label><input type="checkbox" id="Checkbox_SelectAll" value="1">&nbsp;全选</label>
            <% for (int i = 0, max = carTypeList.Count; i < max; i++){%>
            <label><input type="checkbox" name="cartype" value="<%=carTypeList[i].id %>">&nbsp;<%=carTypeList[i].typeName %></label>
            <% }%>
            <script type="text/javascript">SetCheckboxValue("cartype", "<%=tempRest.CarType %>")</script>
        </div>
        <div class="row">
            <input type="button" value="授权" id="btnadduser" class="yc-btn per-button-border" />
        </div>
        <!--p style="text-indent: 30px; color:#999">友情提示：新添加集团下属账户，默认密码均为"<span style="color:#f00">123456</span>"(不包括引号)，请及时告知该账户使用人尽快修改密码</p-->
</asp:Content>
