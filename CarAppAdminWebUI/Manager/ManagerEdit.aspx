<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManagerEdit.aspx.cs" Inherits="CarAppAdminWebUI.Manager.ManagerEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="id" name="id" value="<%=Model.AdminId %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>用户名：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editadminName" value="<%=Model.AdminName %>" name="adminName" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>新密码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input type="hidden" name="oldpassword" value="<%=Model.AdminPassword %>" />
                    <input class="adm_21" id="editadminPassword" name="adminPassword" type="password" /> 如不修改密码不填写即可
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>确认新密码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editreadminPassword" name="readminPassword" type="password" />
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>电话：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editPhone" value="<%=Model.Phone %>" name="Phone" type="text" />
                </td>
            </tr>
               <tr>
             <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid"></span>工号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="Jobnumber" name="Jobnumber" type="text" value="<%=Model.JobNumber %>" /><span>当前最大工号：<%=maxjobnumber%></span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>所属用户组：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editadminGroupsId" name="adminGroupsId">
                        <option value="">请选择</option>
                        <option value="1">超级管理员</option>
                        <option value="2">客服</option>
                           <option value="3">微信管理员</option>
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
        $(function() {
            $("#editadminGroupsId").val('<%=Model.AdminGroupsId %>');
        });
        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
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
            var adminName = $.trim($("#editadminName").val());
            if (adminName == "") {
                showValidateMessage("请填写用户名");
                return false;
            }

            var adminPassword = $.trim($("#editadminPassword").val());

            var readminPassword = $.trim($("#editreadminPassword").val());
            if (adminPassword != readminPassword) {
                showValidateMessage("两次输入的密码不一致");
                return false;
            }

            var adminGroupsId = $.trim($("#editadminGroupsId").val());
            if (adminGroupsId == "") {
                showValidateMessage("请选择所属权限组");
                return false;
            }

            var phone = $.trim($("#editPhone").val());
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
