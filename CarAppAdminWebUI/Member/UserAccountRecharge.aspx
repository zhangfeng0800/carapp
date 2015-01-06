<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserAccountRecharge.aspx.cs" Inherits="CarAppAdminWebUI.Member.UserAccountRecharge" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
        <div style="padding: 5px;">
        <form id="rechargeForm">
        <input type="hidden" id="action" name="action" value="rechargeMoney" />
        <input type="hidden" id="id" name="id" value="<%=Model.Id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    用户名：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <%=Model.Compname %>
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    账号余额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <%=Model.Balance %> 元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>充值卡号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="rechargeNo" name="rechargeNo" type="text" />
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
                var d = $("#rechargeForm").serialize();
                $.post("/Member/UserAccountHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', data.Message, 'info', function () {
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
            var password = $.trim($("#rechargeNo").val());
            if (password == "") {
                showValidateMessage("请输入充值卡号");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
