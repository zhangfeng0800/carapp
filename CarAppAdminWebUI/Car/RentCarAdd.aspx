<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RentCarAdd.aspx.cs" Inherits="CarAppAdminWebUI.Car.RentCarAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="addForm">
        <input type="hidden" id="action" name="action" value="add" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>所属省份：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addprovenceID" style="width: 100px;" name="provenceID">
                    </select>
                    <select class="adm_21" id="addcityId1" style="width: 100px;" name="cityId1">
                        <option value="">请选择</option>
                    </select>
                    <select class="adm_21" id="addcityId" style="width: 100px;" name="cityId">
                        <option value="">请选择</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>用车方式：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addcarusewayid" name="carusewayID" onchange="hideall()">
                    </select>
                </td>
            </tr>
            <tr id="hotlinetr" style="display: none;">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>热门线路：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addhotLineID" name="hotLineID">
                    </select>
                    <input name="isoneway" type="radio" checked="checked" value="1" />单程
                    <input name="isoneway" type="radio" value="0" />往返
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>车辆类型：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addcarTypeID" name="carTypeID">
                    </select>
                </td>
            </tr>
            <tr id="addstart">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>套餐价：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addstartPrice" name="startPrice" type="text" />元/次起
                </td>
            </tr>
            <tr id="addDiscount">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>打折价：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addDiscountPrice" name="DiscountPrice" type="text" />元/次起
                </td>
            </tr>
            <tr id="addinclude">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>套餐价描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    含<input class="adm_21" id="addincludeKm" style="width: 100px" name="includeKm" type="text" />公里
                    <input class="adm_21" id="addincludeHour" style="width: 100px" name="includeHour"
                        type="text" />小时
                    <input class="adm_21" id="addincludeM" style="width: 100px" name="includeM" type="text" />分钟
                </td>
            </tr>
            <tr id="addkilo">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>超公里价：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addkiloPrice" name="kiloPrice" type="text" />元/公里
                </td>
            </tr>
            <tr id="addhour">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>超分钟价：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addhourPrice" name="hourPrice" type="text" />元/分钟
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    车辆品牌：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="addcarbrandspan"></span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    备注信息：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <%--<textarea cols="50" rows="10" id="others" name="others"></textarea>--%>
                    <select id="others" name="others" style="width: 500px;">
                        <option value="0">暂无</option>
                        <%
                            for (int i = 0; i < data.Rows.Count; i++)
                            {%>
                        <option value="<%=data.Rows[i]["id"] %>">
                            <%=data.Rows[i]["content"] %></option>
                        <%}
                        %>
                    </select>
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onAddSubmit()">确认提交并继续添加</a> <a class="easyui-linkbutton" href="javascript:onClose()">
                    取消</a>
        </p>
    </div>
    <script type="text/javascript">

        $(function () {
            initCitySelect("addprovenceID", "请选择", 0, "");
            selectChange("addprovenceID", "addcityId1");
            selectChange("addcityId1", "addcityId");
            $("#addcarTypeID").append('<option value="">请选择车辆类型</option>');
            $("#addcarusewayid").append('<option value="">请选择用车方式</option>');
            $("#addhotLineID").append('<option value="">请选择热门线路</option>');
            selectCarUseWay();
            selectHotLine();
            initCarType();
            initCarBrand();
        });

        function hideall() {
            if ($("#addcarusewayid").val() == 8) {
                $("#addstart").css("display", "none");
                $("#addstartPrice").val("0");
                $("#addDiscount").css("display", "none");
                $("#addDiscountPrice").val("0");
                $("#addinclude").css("display", "none");
                $("#addincludeKm").val("0");
                $("#addincludeHour").val("0");
                $("#addincludeM").val("0");
                $("#addkilo").css("display", "none");
                $("#addkiloPrice").val("0");
                $("#addhour").css("display", "none");
                $("#addhourPrice").val("0");
            }
            else {
                $("#addstart").css("display", "table-row");
                $("#addDiscount").css("display", "table-row");
                $("#addinclude").css("display", "table-row");
                $("#addkilo").css("display", "table-row");
                $("#addhour").css("display", "table-row");
            }
           
        }

        function initCarBrand() {
            $.get("/Car/RentCarHandler.ashx", { "action": "carbrand" }, function (data) {
                var pro = "";
                for (var i = 0; i < data.length; i++) {
                    pro += '<input name="carbrand" value="' + data[i].id + '" type="checkbox" />' + data[i].brandName + "  ";
                }
                $("#addcarbrandspan").append(pro);
            }, "json");
        }

        function selectChange(actionSelect, targetSelect) {
            $("#" + actionSelect).change(function () {
                $("#" + targetSelect).hide();
                var pid = $(this).val();
                if (pid != "") {
                    $.get("/Ajax/GetCitys.ashx", { "pid": pid }, function (data) {
                        $("#" + targetSelect).show();
                        $("#" + targetSelect).empty();
                        $("#" + targetSelect).append('<option value="">请选择</option>');
                        var pro = "";
                        for (var i = 0; i < data.length; i++) {
                            pro += '<option value=' + data[i].codeid + '>';
                            pro += data[i].cityname;
                            pro += '</option>';
                        }
                        $("#" + targetSelect).append(pro);
                    }, "json");
                }
            });
        }

        function selectCarUseWay() {
            $.get("/Car/RentCarHandler.ashx", { "action": "caruseway" }, function (data) {
                var pro = "";
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].Id + '>';
                    pro += data[i].Name;
                    pro += '</option>';
                }
                $("#addcarusewayid").append(pro);
            }, "json");
        }

        function initCarType() {
            $.get("/Ajax/GetCarType.ashx", null, function (data) {
                $("#addcarTypeID").empty();
                var pro = "";
                pro += '<option value="">请选择车辆类型</option>';
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].id + '>';
                    pro += data[i].typeName;
                    pro += '</option>';
                }
                $("#addcarTypeID").append(pro);
            }, "json");
        }

        function selectHotLine() {
            $("#addcarusewayid").change(function () {
                $("#addhotLineID").empty();
                $("#hotlinetr").hide();
                $("#addhotLineID").append('<option value="">请选择热门线路</option>');
                var id = $(this).val();
                if (id == 6) {
                    $("#hotlinetr").show();
                    $.get("/Car/RentCarHandler.ashx", { "action": "hotline" }, function (data) {
                        var pro = "";
                        for (var i = 0; i < data.length; i++) {
                            pro += '<option value=' + data[i].id + '>';
                            pro += data[i].name;
                            pro += '</option>';
                        }
                        $("#addhotLineID").append(pro);
                    }, "json");
                }
            });
        }

        function onSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
               // d.others = $("#others").combobox("getText");
                $.post("/Car/RentCarHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '添加成功！', 'info', function () {
                            onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.post("/Car/RentCarHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '添加成功！', 'info', function () {
                            onSearch();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }
        function gtzero(value) {
            return /^\d+/.test(value) && value >= 0;
        }
        //校验表单
        function checkForm() {
            var addcityId = $.trim($("#addcityId").val());
            if (addcityId == "") {
                showValidateMessage("请选择城市");
                return false;
            }

            var addcarusewayid = $.trim($("#addcarusewayid").val());
            if (addcarusewayid == "") {
                showValidateMessage("请选择用车方式");
                return false;
            }

            if (addcarusewayid == "6") {
                var addhotLineId = $.trim($("#addhotLineID").val());
                if (addhotLineId == "") {
                    showValidateMessage("请选择热门线路");
                    return false;
                }
            }

            var addcarTypeId = $.trim($("#addcarTypeID").val());
            if (addcarTypeId == "") {
                showValidateMessage("请选择车辆类型");
                return false;
            }

            //起步价
            var addstartPrice = $.trim($("#addstartPrice").val());
            if (addstartPrice == "") {
                showValidateMessage("起步价不能为空");
                return false;
            }
            if (!num(addstartPrice)) {
                showValidateMessage("起步价请输入一个有效的金额");
                return false;
            }
            if (addstartPrice > 10000) {
                showValidateMessage("起步价不能大于10000");
                return false;
            }

            //打折价
            var DiscountPrice = $.trim($("#addDiscountPrice").val());
            if (DiscountPrice == "") {
                showValidateMessage("打折价不能为空");
                return false;
            }
            if (!num(DiscountPrice)) {
                showValidateMessage("起步价请输入一个有效的金额");
                return false;
            }
            if (DiscountPrice > 10000) {
                showValidateMessage("打折价不能大于10000元");
                return false;
            }

            //includeM
            var tempM = $.trim($("#addincludeM").val());
            var includeM;
            if (tempM == "") {
                includeM = 0;
            } else {
                includeM = tempM;
            }
            if (!num(includeM)) {
                showValidateMessage("包含分钟输入无效");
                return false;
            }
            if (includeM > 60) {
                showValidateMessage("包含分钟不能大于60");
                return false;
            }

            var includeKm = $.trim($("#addincludeKm").val());
            if (includeKm == "") {
                showValidateMessage("请输入描述包含公里数");
                return false;
            }
            if (!num(includeKm)) {
                showValidateMessage("包含公里数无效");
                return false;
            }

            //超公里
            var addkiloPrice = $.trim($("#addkiloPrice").val());
            if (addkiloPrice == "") {
                showValidateMessage("超公里价格不能为空");
                return false;
            }
            if (!num(addkiloPrice)) {
                showValidateMessage("超公里请输入一个有效的金额");
                return false;
            }
            if (addkiloPrice > 1000) {
                showValidateMessage("超公里价不能大于1000元");
                return false;
            }

            //超小时
            var addhourPrice = $.trim($("#addhourPrice").val());
            if (addhourPrice == "") {
                showValidateMessage("超时价格不能为空");
                return false;
            }
            if (!num(addhourPrice)) {
                showValidateMessage("超时请输入一个有效的金额");
                return false;
            }
            if (addhourPrice > 1000) {
                showValidateMessage("超时价不能大于1000元");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
