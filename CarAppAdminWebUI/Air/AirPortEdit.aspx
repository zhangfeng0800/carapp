<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AirPortEdit.aspx.cs" Inherits="CarAppAdminWebUI.Air.AirPortEdit" %>
<%@ Import Namespace="NPOI.SS.Formula.Functions" %>

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
                <td class="adm_45" align="right" height="30" width="10%">
                    <span class="field-validation-valid">*</span>所在城市：
                </td>
                <td class="adm_42" width="90%" colspan="3">
                    <select class="adm_21" id="editprovenceID" style="width: 100px;" name="provenceID">
                    </select>
                    <select class="adm_21" id="editcityId1" style="width: 100px;" name="cityId1">
                    </select>
                    <select class="adm_21" id="editcityId" style="width: 100px;" name="cityId">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="10%">
                    <span class="field-validation-valid">*</span>机场名称：
                </td>
                <td class="adm_42" width="90%" colspan="3">
                    <input class="adm_21" id="editairportName" name="airportName" value="<%=Model.AirPortName %>" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="10%">
                    <span class="field-validation-valid">*</span>位置标注：
                </td>
                <td class="adm_42" width="90%" colspan="3">
                    经度：<input class="adm_21" id="editlng" style="width: 100px;" value="<%=Model.Lng %>" name="lng" type="text" /> 
                    纬度：<input class="adm_21" id="editlat" style="width: 100px;" value="<%=Model.Lat %>" name="lat" type="text" /> 可以在地图中点击选择
                    <div id="editbaidumap" style="width: 100%;height: 330px; margin-top: 10px;"></div>
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
        $(function () {
            initCitySelect("editprovenceID", "请选择", 0, "<%=Model.ProvenceID %>");
            initCitySelect("editcityId1", "请选择", "<%=Model.ProvenceID %>", "<%=Model.CityId %>");
            initCitySelect("editcityId", "请选择", "<%=Model.CityId %>", "<%=Model.countyId %>");
            citySelectChange("editprovenceID", "editcityId1", "editcityId", "请选择");
            citySelectChange("editcityId1", "editcityId", null, "请选择");

            // 百度地图API功能
            var map = new BMap.Map("editbaidumap");
            map.centerAndZoom("石家庄", 4);
            map.enableScrollWheelZoom();
            map.addControl(new BMap.NavigationControl());
            map.addEventListener("click", function (e) {
                $("#editlng").val(e.point.lng);
                $("#editlat").val(e.point.lat);
            });
        });

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/Air/SaveAirPort.ashx", d, function (data) {
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
            var provenceId = $.trim($("#editprovenceID").val());

            if (cityId == "") {
                showValidateMessage("请选择城市");
                return false;
            }

            var airportName = $.trim($("#editairportName").val());
            if (airportName == "") {
                showValidateMessage("请填写名称");
                return false;
            }
            if (airportName.length >= 25) {
                showValidateMessage("机场名称不能超过25个字");
                return false;
            }

            var lng = $.trim($("#editlng").val());
            if (lng == "") {
                showValidateMessage("请选择经纬度信息");
                return false;
            }

            var lat = $.trim($("#editlat").val());
            if (lat == "") {
                showValidateMessage("请选择经纬度信息");
                return false;
            }

            return true;
        }

    </script>
</body>
</html>
