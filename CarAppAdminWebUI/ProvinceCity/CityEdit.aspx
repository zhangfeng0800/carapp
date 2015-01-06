<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CityEdit.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.CityEdit" %>
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
        <input type="hidden" id="id" name="id" value="<%=Model.CodeId %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>上级城市编号：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="editparentid" value="<%=Model.ParentId %>" name="parentid" type="text" /> 省级城市此处请填写0
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>城市名称：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="editcityName" value="<%=Model.CityName %>" name="cityName" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>城市编码：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="editcodeid" value="<%=Model.CodeId %>" name="codeid" type="text"  />
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="sort" value="<%=Model.Sort %>" name="sort" type="text"  /> 按排序大小降序排列
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
                var d = $("#editForm").serialize();
                $.post("/ProvinceCity/CityHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '编辑成功！', 'info', function () {
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
            var parentid = $.trim($("#editparentid").val());
            if (parentid == "") {
                showValidateMessage("请填写上级城市编码");
                return false;
            }

            var cityName = $.trim($("#editcityName").val());
            if (cityName == "") {
                showValidateMessage("请填写城市名称");
                return false;
            }
            if (cityName.length > 15) {
                showValidateMessage("城市名称不允许超过15个字符");
                return false;
            }

            var codeid = $.trim($("#editcodeid").val());
            if (codeid == "") {
                showValidateMessage("请填写城市编码");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
