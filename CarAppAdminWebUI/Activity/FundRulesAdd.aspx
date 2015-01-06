<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FundRulesAdd.aspx.cs" Inherits="CarAppAdminWebUI.Activity.FundRulesAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div>
    <form id="addForm">
        <input type="hidden" id="action" name="action" value="addrules" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>规则名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addname" name="name" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>单券面值：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    
                     <input class="adm_21" id="addcost" name="cost" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>每月返券数：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <input class="adm_21" id="addnum" name="num" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid"></span>建议金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addReferencePrice" name="referencePrice" type="text" value="0" /><span style=" color:Red;">建议金额为0将不为前台网站用户显示，否则用户可以使用此规则线上存入金额</span>
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
                $.post("/Activity/FundingHandler.ashx", d, function (data) {
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
                showValidateMessage("请填写规则名称");
                return false;
            }
            if (name.length >= 20) {
                showValidateMessage("规则名称不能超过20个汉字");
                return false;
            }

            var money = $.trim($("#addcost").val());
            if (money == "") {
                showValidateMessage("请填写单券金额");
                return false;
            }
            if (!num(money)) {
                showValidateMessage("单券金额只能是数字");
                return false;
            }

            var addnum = $.trim($("#addnum").val());
            if (addnum == "") {
                showValidateMessage("请填写每月生成数量");
                return false;
            }

            return true;
        }
    </script>

</body>
</html>
