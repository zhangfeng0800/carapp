<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RechargeActivityAdd.aspx.cs"
    Inherits="CarAppAdminWebUI.Activity.RechargeActivityAdd" %>

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
                    <span class="field-validation-valid">*</span>活动名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addname" name="name" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>充值金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    
                     <input class="adm_21" id="addminMoney" name="minMoney" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>赠送金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <input class="adm_21" id="addmoney" name="money" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>开始时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addstartDate" onclick="WdatePicker()" name="startDate" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>结束时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="adddeadline" onclick="WdatePicker()" name="deadline" type="text" />
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
                $.post("/Activity/RechargeActivityHandler.ashx", d, function (data) {
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
                showValidateMessage("请填写活动名称");
                return false;
            }
            if (name.length >= 20) {
                showValidateMessage("活动名称不能超过20个汉字");
                return false;
            }

            var money = $.trim($("#addmoney").val());
            if (money == "") {
                showValidateMessage("请填写充值金额");
                return false;
            }
            if (!num(money)) {
                showValidateMessage("充值金额只能是数字");
                return false;
            }

            var minMoney = $.trim($("#addminMoney").val());
            if (minMoney == "") {
                showValidateMessage("请填写赠送金额");
                return false;
            }
            if (!num(minMoney)) {
                showValidateMessage("赠送金额只能是数字");
                return false;
            }

            var startDate = $.trim($("#addstartDate").val());
            if (startDate == "") {
                showValidateMessage("请填写开始时间");
                return false;
            }

            var deadline = $.trim($("#adddeadline").val());
            if (deadline == "") {
                showValidateMessage("请填写结束时间");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
