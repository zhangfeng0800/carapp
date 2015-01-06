<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarInfoEdit.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarInfoEdit" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="id" name="id" value="<%=Model.Id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>所属地区：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editprovenceID" style="width: 100px;" name="provenceID">
                    </select>
                    <select class="adm_21" id="editcityId1" style="width: 100px;" name="cityId1">
                        <option value="">请选择</option>
                    </select>
                    <select class="adm_21" id="editcityId" style="width: 100px;" name="cityId">
                        <option value="">请选择</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>车辆类型：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editcarTypeId" name="carTypeId">
                    </select>
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>服务方式：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editCarUseWay" name="CarUseWay">
                        <option value="">请选择</option>
                        <option value="A">热门线路</option>
                        <option value="B">其他</option>
                    </select>
                </td>
            </tr>
            <tr id="edithotLineTr" style="display: none;">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>服务热门线路：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <div id="edithotLineDiv">
                    </div>
                    <a href="javascript:void(0);" onclick="onAddHotLine()">添加关联的热门线路</a>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>车牌号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editcarNo" name="carNo" value="<%=Model.CarNo %>" type="text" maxlength="10" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>手机号码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="edittelPhone" value="<%=Model.telPhone %>" name="telPhone" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <%--<input class="adm_21" id="editname" name="name" value="<%=Model.Name %>" type="text" />--%>

                    <select id="addname"  name="BrandId" style="width: 200px;">
                      <%foreach (DataRow row  in brands.Rows)
                        {%>
                        <option value='<%=row["id"] %>'><%=row["brandName"]%></option>
                        <%} %>
                    </select>

                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    状态：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editcarWorkStatus" name="carWorkStatus">
                        <option value="">请选择</option>
                        <option value="1">工作中</option>
                        <option value="2">离开或请假</option>
                        <option value="3">可以接单/空闲中</option>
                        <option value="4">已出发</option>
                        <option value="5">已经就位</option>
                        <option value="6">订单已接取</option>
                        <option value="8">租出</option>
                        <option value="9">借出</option>
                        <option value="7">其它</option>
                    </select>
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script type="text/javascript">
        var index = 0;
        $(function () {


            initCarType();
            $("#addname").val("<%=Model.BrandId %>");
            //initCarbrand("addname", "<%=Model.BrandId %>");

            initCitySelect("editprovenceID", "请选择", 0, "<%=Model.ProvinceId %>");
            initCitySelect("editcityId1", "请选择", "<%=Model.ProvinceId %>", "<%=Model.CityId %>");
            initCitySelect("editcityId", "请选择", "<%=Model.CityId %>", "<%=Model.CountyId %>");
            citySelectChange("editprovenceID", "editcityId1", "editcityId", "请选择");
            citySelectChange("editcityId1", "editcityId", null, "请选择");
            $("#editCarUseWay").val('<%=Model.CarUseWay %>');
            $("#editcarWorkStatus").val("<%=Model.carWorkStatusId %>");
            var ishotline = '<%=Model.CarUseWay %>';
            if (ishotline == "A") {
                $("#edithotLineTr").show();
                initHotLine();
            } else {
                $("#edithotLineTr").hide();
            }
            $("#editCarUseWay").change(function () {
                var v = $(this).val();
                if (v == "A") {
                    $("#edithotLineTr").show();
                } else {
                    $("#edithotLineTr").hide();
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

        function initHotLine() {
            var json = '<%=hotlineJson %>';
            var obj = eval(json);
            for (var i = 0; i < obj.length; i++) {
                var html = '<div id="div_' + index + '">';
                html += '<select class="adm_21" id="editprovenceID' + index + '" style="width: 100px;" onchange="selectChange1(' + index + ')">';
                html += '</select> ';
                html += '<select class="adm_21" id="editcityID1' + index + '" style="width: 100px;" onchange="selectChange2(' + index + ')">';
                html += '<option value="">请选择</option>';
                html += '</select> ';
                html += '<select class="adm_21" id="editcityID' + index + '" style="width: 100px;" onchange="selectChange3(' + index + ')">';
                html += '<option value="">请选择</option>';
                html += '</select> ';
                html += '<select class="adm_21" id="edithotline' + index + '" name="hotline">';
                html += '<option value="">请选择</option>';
                html += '</select> ';
                html += '<a href="javascript:void(0);" onclick="removeHot(' + index + ')">移除</a>';
                html += '</div>';
                initCitySelect("editprovenceID" + index, "请选择", 0, obj[i].provinceID);
                initCitySelect("editcityID1" + index, "请选择", obj[i].provinceID, obj[i].cityID);
                initCitySelect("editcityID" + index, "请选择", obj[i].cityID, obj[i].CountyId);
                initServiceCity(obj[i].CountyId, obj[i].id, index);
                $("#edithotLineDiv").append(html);
                index++;
            }
        }

        function initServiceCity(pid,val,ind) {
            if (pid != "") {
                $.get("/Car/CarInfoHandler.ashx?action=servicecitylist", { "pid": pid }, function (data) {
                    $("#edithotline" + ind).empty();
                    $("#edithotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].id + '>';
                        pro += data[i].cityName + "-" + data[i].HotlineName;
                        pro += '</option>';
                    }
                    $("#edithotline" + ind).append(pro);
                    $("#edithotline" + ind).val(val);
                }, "json");
                
            } else {
                $("#edithotline" + ind).empty();
                $("#edithotline" + ind).append('<option value="">请选择</option>');
            }
        }

        function initCarType() {
            $.get("/Ajax/GetCarType.ashx", null, function (data) {
                $("#editcarTypeId").empty();
                var pro = "";
                pro += '<option value="">请选择车辆类型</option>';
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].id + '>';
                    pro += data[i].typeName;
                    pro += '</option>';
                }
                $("#editcarTypeId").append(pro);
                $("#editcarTypeId").val('<%=Model.CarTypeId %>');
            }, "json");
        }

        function onAddHotLine() {
            var length = $("[name=hotline]").size();
            if (length >= 5) {
                $.messager.alert("消息", "最多只能关联5条线路", "info");
                return;
            }
            var html = '<div id="div_' + index + '">';
            html += '<select class="adm_21" id="editprovenceID' + index + '" style="width: 100px;" onchange="selectChange1(' + index + ')">';
            html += '</select> ';
            html += '<select class="adm_21" id="editcityID1' + index + '" style="width: 100px;" onchange="selectChange2(' + index + ')">';
            html += '<option value="">请选择</option>';
            html += '</select> ';
            html += '<select class="adm_21" id="editcityID' + index + '" style="width: 100px;" onchange="selectChange3(' + index + ')">';
            html += '<option value="">请选择</option>';
            html += '</select> ';
            html += '<select class="adm_21" id="edithotline' + index + '" name="hotline">';
            html += '<option value="">请选择</option>';
            html += '</select> ';
            html += '<a href="javascript:void(0);" onclick="removeHot(' + index + ')">移除</a>';
            html += '</div>';
            initCitySelect("editprovenceID" + index, "请选择", 0, "");
            $("#edithotLineDiv").append(html);
            index++;
        }

        function removeHot(idx) {
            $("#div_" + idx).remove();
        }

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
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
        //校验表单
        function checkForm() {
            var cityId = $.trim($("#editcityId").val());
            if (cityId == "") {
                showValidateMessage("请选择城市");
                return false;
            }

            var carTypeId = $.trim($("#editcarTypeId").val());
            if (carTypeId == "") {
                showValidateMessage("请选择车辆类型");
                return false;
            }

            var CarUseWay = $.trim($("#editCarUseWay").val());
            if (CarUseWay == "") {
                showValidateMessage("请选择用车方式");
                return false;
            }

            var carNo = $.trim($("#editcarNo").val());
            if (carNo == "") {
                showValidateMessage("请填写车牌号");
                return false;
            }

            var telPhone = $.trim($("#edittelPhone").val());
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
            var pid = $("#editprovenceID" + ind).val();
            if (pid != "") {
                $.get("/Ajax/GetCitys.ashx", { "pid": pid }, function (data) {
                    $("#editcityID1" + ind).empty();
                    $("#editcityID1" + ind).append('<option value="">请选择</option>');
                    $("#editcityID" + ind).empty();
                    $("#editcityID" + ind).append('<option value="">请选择</option>');
                    $("#edithotline" + ind).empty();
                    $("#edithotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].codeid + '>';
                        pro += data[i].cityname;
                        pro += '</option>';
                    }
                    $("#editcityID1" + ind).append(pro);
                }, "json");
            } else {
                $("#editcityID1" + ind).empty();
                $("#editcityID1" + ind).append('<option value="">请选择</option>');
                $("#editcityID" + ind).empty();
                $("#editcityID" + ind).append('<option value="">请选择</option>');
                $("#edithotline" + ind).empty();
                $("#edithotline" + ind).append('<option value="">请选择</option>');
            }
        }

        function selectChange2(ind) {
            var pid = $("#editcityID1" + ind).val();
            if (pid != "") {
                $.get("/Ajax/GetCitys.ashx", { "pid": pid }, function (data) {
                    $("#editcityID" + ind).empty();
                    $("#editcityID" + ind).append('<option value="">请选择</option>');
                    $("#edithotline" + ind).empty();
                    $("#edithotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].codeid + '>';
                        pro += data[i].cityname;
                        pro += '</option>';
                    }
                    $("#editcityID" + ind).append(pro);
                }, "json");
            } else {
                $("#editcityID" + ind).empty();
                $("#editcityID" + ind).append('<option value="">请选择</option>');
                $("#edithotline" + ind).empty();
                $("#edithotline" + ind).append('<option value="">请选择</option>');
            }
        }

        function selectChange3(ind) {
            var pid = $("#editcityID" + ind).val();
            if (pid != "") {
                $.get("/Car/CarInfoHandler.ashx?action=servicecitylist", { "pid": pid }, function (data) {
                    $("#edithotline" + ind).empty();
                    $("#edithotline" + ind).append('<option value="">请选择</option>');
                    var pro = "";
                    for (var i = 0; i < data.length; i++) {
                        pro += '<option value=' + data[i].id + '>';
                        pro += data[i].cityName + "-" + data[i].HotlineName;
                        pro += '</option>';
                    }
                    $("#edithotline" + ind).append(pro);
                }, "json");
            } else {
                $("#edithotline" + ind).empty();
                $("#edithotline" + ind).append('<option value="">请选择</option>');
            }
        }
    </script>
</body>
</html>
