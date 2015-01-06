<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarInfoAdd.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarInfoAdd" %>
<%@ Import Namespace="System.Data" %>

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
                    <span class="field-validation-valid">*</span>所属地区：
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
                    <span class="field-validation-valid">*</span>车辆类型：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addcarTypeId" name="carTypeId">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>服务方式：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addCarUseWay" name="CarUseWay">
                        <option value="">请选择</option>
                        <option value="A">热门线路</option>
                        <option value="B">其他</option>
                    </select>
                </td>
            </tr>
            <tr id="hotLineTr" style="display: none;">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>服务热门线路：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <div id="hotLineDiv">
                    </div>
                    <a href="javascript:void(0);" onclick="onAddHotLine()">添加关联的热门线路</a>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>车牌号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addcarNo" name="carNo" type="text" maxlength="10" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>手机号码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addtelPhone" name="telPhone" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <%-- <input class="adm_21" id="addname" name="name" type="text" />--%>
                    <select id="addname" name="brandId">
                  <%foreach (DataRow row  in brands.Rows)
                        {%>
                        <option value='<%=row["id"] %>'><%=row["brandName"]%></option>
                        <%} %>
                    </select>
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a>  <a class="easyui-linkbutton" href="javascript:onAddSubmitAdd()">提交并继续添加</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script type="text/javascript">
        var index = 0;
        $(function () {

            //initCarbrand("addname", "");
            initCarType();
            initCitySelect("addprovenceID", "请选择", 0, "");
            citySelectChange("addprovenceID", "addcityId1", "addcityId", "请选择");
            citySelectChange("addcityId1", "addcityId", null, "请选择");
            $("#addCarUseWay").change(function () {
                var v = $(this).val();
                if (v == "A") {
                    $("#hotLineTr").show();
                } else {
                    $("#hotLineTr").hide();
                }
            });
        });

        /*取到车型列表*/
        function initCarbrand(name, defalutvalue) {
            $.post("/Ajax/GetCarBrand.ashx", null, function (data) {
                for (var i = 0; i < data.length; i++) {
                    if (defalutvalue == data[i].id) {
                        $("#" + name).append("<option value='" + data[i].id + "' selected='selected'>" + data[i].brandName + "</option>");
                    }
                    else {
                        $("#" + name).append("<option value='" + data[i].id + "'>" + data[i].brandName + "</option>");
                    }
                }
            }, "json");
        }


        function initCarType() {
            $.get("/Ajax/GetCarType.ashx", null, function (data) {
                $("#addcarTypeId").empty();
                var pro = "";
                pro += '<option value="">请选择车辆类型</option>';
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].id + '>';
                    pro += data[i].typeName;
                    pro += '</option>';
                }
                $("#addcarTypeId").append(pro);
            }, "json");
        }

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.post("/Car/CarInfoHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '操作成功！', 'info', function () {
                            onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }

        function onAddSubmitAdd() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.post("/Car/CarInfoHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '操作成功！', 'info', function () {
                            onSearch();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }
        
        function onAddHotLine() {
            var length = $("[name=hotline]").size();
            if (length >= 5) {
                $.messager.alert("消息", "最多啊只能关联5条线路","info");
                return;
            }
            var html = '<div id="div_' + index + '">';
            html += '<select class="adm_21" id="addprovenceID' + index + '" style="width: 100px;" onchange="selectChange1('+index+')">';
            html += '</select> ';
            html += '<select class="adm_21" id="addcityID1' + index + '" style="width: 100px;" onchange="selectChange2(' + index + ')">';
            html += '<option value="">请选择</option>';
            html += '</select> ';
            html += '<select class="adm_21" id="addcityID' + index + '" style="width: 100px;" onchange="selectChange3(' + index + ')">';
            html += '<option value="">请选择</option>';
            html += '</select> ';
            html += '<select class="adm_21" id="addhotline' + index + '" name="hotline">';
            html += '<option value="">请选择</option>';
            html += '</select> ';
            html += '<a href="javascript:void(0);" onclick="removeHot(' + index + ')">移除</a>';
            html += '</div>';
            initCitySelect("addprovenceID" + index, "请选择", 0, "");
            $("#hotLineDiv").append(html);
            index++;
        }

        function removeHot(idx) {
            $("#div_" + idx).remove();
        }


        //校验表单
        function checkForm() {
            var cityId = $.trim($("#addcityId").val());
            if (cityId == "") {
                showValidateMessage("请选择城市");
                return false;
            }

            var carTypeId = $.trim($("#addcarTypeId").val());
            if (carTypeId == "") {
                showValidateMessage("请选择车辆类型");
                return false;
            }

            var CarUseWay = $.trim($("#addCarUseWay").val());
            if (CarUseWay == "") {
                showValidateMessage("请选择用车方式");
                return false;
            }

            var carNo = $.trim($("#addcarNo").val());
            if (carNo == "") {
                showValidateMessage("请填写车牌号");
                return false;
            }

            var telPhone = $.trim($("#addtelPhone").val());
            if (telPhone == "") {
                showValidateMessage("请输入车辆对应的手机号码");
                return false;
            }
            if (!ismobile(telPhone)) {
                showValidateMessage("请输入有效的手机号码");
                return false;
            }

            return true;
        }

        function selectChange1(ind) {
            var pid = $("#addprovenceID" + ind).val();
            if (pid != "") {
                $.get("/Ajax/GetCitys.ashx", { "pid": pid }, function (data) {
                    $("#addcityID1" + ind).empty();
                    $("#addcityID1" + ind).append('<option value="">请选择</option>'); 
                    $("#addcityID" + ind).empty();
                    $("#addcityID" + ind).append('<option value="">请选择</option>');
                    $("#addhotline" + ind).empty();
                    $("#addhotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].codeid + '>';
                        pro += data[i].cityname;
                        pro += '</option>';
                    }
                    $("#addcityID1" + ind).append(pro);
                }, "json");
            } else {
                $("#addcityID1" + ind).empty();
                $("#addcityID1" + ind).append('<option value="">请选择</option>');
                $("#addcityID" + ind).empty();
                $("#addcityID" + ind).append('<option value="">请选择</option>');
                $("#addhotline" + ind).empty();
                $("#addhotline" + ind).append('<option value="">请选择</option>');
            }
        }

        function selectChange2(ind) {
            var pid = $("#addcityID1" + ind).val();
            if (pid != "") {
                $.get("/Ajax/GetCitys.ashx", { "pid": pid }, function (data) {
                    $("#addcityID" + ind).empty();
                    $("#addcityID" + ind).append('<option value="">请选择</option>');
                    $("#addhotline" + ind).empty();
                    $("#addhotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].codeid + '>';
                        pro += data[i].cityname;
                        pro += '</option>';
                    }
                    $("#addcityID" + ind).append(pro);
                }, "json");
            } else {
                $("#addcityID" + ind).empty();
                $("#addcityID" + ind).append('<option value="">请选择</option>');
                $("#addhotline" + ind).empty();
                $("#addhotline" + ind).append('<option value="">请选择</option>');
            }
        }

        function selectChange3(ind) {
            var pid = $("#addcityID" + ind).val();
            if (pid != "") {
                $.get("/Car/CarInfoHandler.ashx?action=servicecitylist", { "pid": pid }, function (data) {
                    $("#addhotline" + ind).empty();
                    $("#addhotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].id + '>';
                        pro += data[i].cityName + "-" + data[i].HotlineName;
                        pro += '</option>';
                    }
                    $("#addhotline" + ind).append(pro);
                }, "json");
            } else {
                $("#addhotline" + ind).empty();
                $("#addhotline" + ind).append('<option value="">请选择</option>');
            }
        }
    </script>
</body>
</html>
