<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TravelthemeEdit.aspx.cs"
    Inherits="CarAppAdminWebUI.ProvinceCity.TravelthemeEdit" %>

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
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>主题名称：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="editname" name="name" value="<%=Model.Name %>" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="editsortorder" name="sortorder" value="<%=Model.SortOrder %>"
                        type="text" />
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
                $.post("/ProvinceCity/TravelthemeHandler.ashx", d, function (data) {
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
            var name = $.trim($("#editname").val());
            if (name == "") {
                showValidateMessage("请填写主题名称");
                return false;
            }
            if (name.length > 50) {
                showValidateMessage("主题名称长度不能超过50字");
                return false;
            }

            var sortorder = $.trim($("#editsortorder").val());
            if (sortorder == "") {
                showValidateMessage("请填写排序信息");
                return false;
            }
            if (!num(sortorder)) {
                showValidateMessage("排序信息只能是数字");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
