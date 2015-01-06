<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CityAdd.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.CityAdd" %>

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
                    <span class="field-validation-valid">*</span>上级城市编号：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="addparentid" name="parentid" type="text" /> 省级城市此处请填写0
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>城市名称：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="addcityName" name="cityName" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>城市编码：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="addcodeid" name="codeid" type="text"  />
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="sort"  name="sort" type="text"  /> 按排序大小降序排列
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

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.post("/ProvinceCity/CityHandler.ashx", d, function (data) {
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
        //校验表单
        function checkForm() {
            var parentid = $.trim($("#addparentid").val());
            if (parentid == "") {
                showValidateMessage("请填写上级城市编码");
                return false;
            }

            var cityName = $.trim($("#addcityName").val());
            if (cityName == "") {
                showValidateMessage("请填写城市名称");
                return false;
            }
            if (cityName.length > 15) {
                showValidateMessage("城市名称不允许超过15个汉字");
                return false;
            }

            var codeid = $.trim($("#addcodeid").val());
            if (codeid == "") {
                showValidateMessage("请填写城市编码");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
