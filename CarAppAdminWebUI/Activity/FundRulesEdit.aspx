<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FundRulesEdit.aspx.cs" Inherits="CarAppAdminWebUI.Activity.FundRulesEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
     <div>
    <form id="editForm">
        <input type="hidden" id="action" name="action" value="editrules" />
        <input type="hidden" id="id" name="id" value=<%=rules.Id %> />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>规则名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editname" name="name" type="text" value="<%=rules.Name %>" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>单券面值：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    
                     <input class="adm_21" id="editcost" name="cost" type="text"  value="<%=rules.Cost %>"/>元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>每月返券数：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <input class="adm_21" id="editnum" name="num" type="text" value="<%=rules.Num %>" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid"></span>建议金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editReferencePrice" name="referencePrice" type="text" value="<%=rules.ReferencePrice %>" /><span style=" color:Red;">建议金额为0将不为前台网站用户显示，否则用户可以使用此规则线上存入金额</span>
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onEditSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script type="text/javascript">
        function onEditSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/Activity/FundingHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '修改成功！', 'info', function () {
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
                showValidateMessage("请填写规则名称");
                return false;
            }
            if (name.length >= 20) {
                showValidateMessage("规则名称不能超过20个汉字");
                return false;
            }

            var money = $.trim($("#editcost").val());
            if (money == "") {
                showValidateMessage("请填写单券金额");
                return false;
            }
            if (!num(money)) {
                showValidateMessage("单券金额只能是数字");
                return false;
            }

            var addnum = $.trim($("#editnum").val());
            if (addnum == "") {
                showValidateMessage("请填写每月生成数量");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
