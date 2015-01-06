<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServiceCityItemAdd.aspx.cs"
    Inherits="CarAppAdminWebUI.ProvinceCity.ServiceCityItemAdd" %>

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
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>开通城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addprovenceID" name="provenceID">
                    </select>
                    <select class="adm_21" id="addcityId1" name="cityId1">
                        <option value="">请选择</option>
                    </select>
                    <select class="adm_21" id="addcityId" name="cityId">
                        <option value="">请选择</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>服务方式：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="addcarUseWaySpan"></span><span class="field-validation-valid" data-valmsg-for="addcarUseWay"
                        data-valmsg-replace="true"></span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    是否热门城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input type="radio" name="ishotcity" value="1"/>是 <input type="radio" checked="checked" name="ishotcity" value="0"/>否
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
            initCarUseWay();
        });

        function initCarUseWay() {
            $.get("/Ajax/GetAllCarUseWay.ashx", null, function (data) {
                var pro = "";
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Id != 6) {
                        pro += '<input name="carUseWay" value="' + data[i].Id + '" type="checkbox" />' + data[i].Name + "  ";
                    }
                }
                $("#addcarUseWaySpan").append(pro);
            }, "json");
        }

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.post("/ProvinceCity/ServiceCityHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        var message = "服务开通成功！";
                        if (data.Message != "") {
                            message = data.Message;
                        }
                        $.messager.alert('消息', message, 'info', function () {
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

            return true;
        }
    </script>
</body>
</html>
