<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AirPortAdd.aspx.cs" Inherits="CarAppAdminWebUI.Air.AirPortAdd" %>

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
                <td class="adm_45" align="right" height="30" width="10%">
                    <span class="field-validation-valid">*</span>所在城市：
                </td>
                <td class="adm_42" width="90%" colspan="3">
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
                <td class="adm_45" align="right" height="30" width="10%">
                    <span class="field-validation-valid">*</span>机场名称：
                </td>
                <td class="adm_42" width="90%" colspan="3">
                    <input class="adm_21" id="addairportName" name="airportName" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="10%">
                    <span class="field-validation-valid">*</span>位置标注：
                </td>
                <td class="adm_42" width="90%" colspan="3">
                    经度：<input class="adm_21" id="addlng" style="width: 100px;" name="lng" type="text" /> 
                    纬度：<input class="adm_21" id="addlat" style="width: 100px;" name="lat" type="text" /> 可以在地图中点击选择
                    <div id="baidumap" style="width: 100%;height: 330px; margin-top: 10px;"></div>
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
            initCitySelect("addprovenceID", "请选择", 0, "");
            citySelectChange("addprovenceID", "addcityId1", "addcityId", "请选择");
            citySelectChange("addcityId1", "addcityId", null, "请选择");
            // 百度地图API功能
            var map = new BMap.Map("baidumap");
            map.centerAndZoom("石家庄", 4);
            map.enableScrollWheelZoom();
            map.addControl(new BMap.NavigationControl()); 
            map.addEventListener("click", function (e) {
                $("#addlng").val(e.point.lng);
                $("#addlat").val(e.point.lat);
            });
        });

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
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
            var cityId = $.trim($("#addcityId").val());
            if (cityId == "") {
                showValidateMessage("请选择城市");
                return false;
            }

            var airportName = $.trim($("#addairportName").val());
            if (airportName == "") {
                showValidateMessage("请填写名称");
                return false;
            }
            if (airportName.length >= 25) {
                showValidateMessage("机场名称不能超过25个字");
                return false;
            }

            var lng = $.trim($("#addlng").val());
            if (lng == "") {
                showValidateMessage("请选择经纬度信息");
                return false;
            }

            var lat = $.trim($("#addlat").val());
            if (lat == "") {
                showValidateMessage("请选择经纬度信息");
                return false;
            }

            return true;
        }

    </script>
</body>
</html>
