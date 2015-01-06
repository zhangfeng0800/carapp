<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TravelthemeAdd.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.TravelthemeAdd" %>

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
                    <span class="field-validation-valid">*</span>主题名称：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="addname" name="name" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="addsortorder" name="sortorder" value="0" type="text" />
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
                $.post("/ProvinceCity/TravelthemeHandler.ashx", d, function (data) {
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
            var name = $.trim($("#addname").val());
            if (name == "") {
                showValidateMessage("请填写主题名称");
                return false;
            }
            if (name.length>50) {
                showValidateMessage("主题名称长度不能超过50字");
                return false;
            }

            var sortorder = $.trim($("#addsortorder").val());
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
