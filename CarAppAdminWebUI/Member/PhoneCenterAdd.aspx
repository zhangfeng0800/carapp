<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PhoneCenterAdd.aspx.cs"
    Inherits="CarAppAdminWebUI.Member.PhoneCenterAdd" %>

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
                    <span class="field-validation-valid">*</span>所属编组：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="groupid" name="groupid">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>坐席号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="exten" name="exten">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>用户名：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addadminName" name="adminName" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>密码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addadminPassword" name="adminPassword" type="password" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>确认密码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addreadminPassword" name="readminPassword" type="password" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>电话：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addPhone" name="Phone" type="text" />
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
                $.post("/Manager/ManagerHandler.ashx", d, function (data) {
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
            var adminName = $.trim($("#addadminName").val());
            if (adminName == "") {
                showValidateMessage("请填写用户名");
                return false;
            }

            var adminPassword = $.trim($("#addadminPassword").val());
            if (adminPassword == "") {
                showValidateMessage("请填写密码");
                return false;
            }

            var readminPassword = $.trim($("#addreadminPassword").val());
            if (adminPassword != readminPassword) {
                showValidateMessage("两次输入的密码不一致");
                return false;
            }

            var adminGroupsId = $.trim($("#addadminGroupsId").val());
            if (adminGroupsId == "") {
                showValidateMessage("请选择所属权限组");
                return false;
            }

            var phone = $.trim($("#addPhone").val());
            if (phone == "") {
                showValidateMessage("请填写电话");
                return false;
            }

            if (!ismobile(phone)) {
                showValidateMessage("请填写正确的电话号码");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
