<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LevelEdit.aspx.cs" Inherits="CarAppAdminWebUI.Member.LevelEdit" %>

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
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>级别名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editname" name="name" value="<%=Model.Name %>" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>会员类型：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input name="usertype" value="3" type="radio" checked="checked" />个人用户
                    <input name="usertype" value="0" type="radio" />集团用户
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>积分区间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editscoreLL" value="<%=Model.ScoreLL %>" name="scoreLL" type="text" onkeyup="this.value=this.value.replace(/\D/g,'')"  />-<input class="adm_21" id="editscoreUL" value="<%=Model.ScoreUL %>" name="scoreUL" type="text" onkeyup="this.value=this.value.replace(/\D/g,'')"  />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>折扣率：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editdiscount" value="<%=Model.Discount %>" name="discount" type="text" onkeyup="this.value=this.value.replace(/\D/g,'')"  /> 0-100之间的数字
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editorder" value="<%=Model.Order %>" name="order" type="text"  onkeyup="this.value=this.value.replace(/\D/g,'')"  />
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
            var type = '<%=Model.UserType %>';
            $("input[value='" + type + "']").attr("checked", "checked");
        });

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/Member/LevelHandler.ashx", d, function (data) {
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
                showValidateMessage("请填写级别名称");
                return false;
            }
            if (name.length > 25) {
                showValidateMessage("级别名称不能多于25个汉字");
                return false;
            }

            var scoreLl = $.trim($("#editscoreLL").val());
            if (scoreLl == "") {
                showValidateMessage("请填写积分下限");
                return false;
            }
            if (!num(scoreLl)) {
                showValidateMessage("请输入有效的积分下限");
                return false;
            }
            
            var scoreUl = $.trim($("#editscoreUL").val());
            if (scoreUl == "") {
                showValidateMessage("请填写积分上限");
                return false;
            }
            if (!num(scoreUl)) {
                showValidateMessage("请输入有效的积分上限");
                return false;
            }
            if (parseInt(scoreUl) <= parseInt(scoreLl)) {
                showValidateMessage("积分上限不能小于等于积分下限");
                return false;
            }

            var discount = $.trim($("#editdiscount").val());
            if (discount == "") {
                showValidateMessage("请填写折扣率");
                return false;
            }
            if (!betweennum(discount,0,100)) {
                showValidateMessage("请输入一个有效的折扣率");
                return false;
            }

            var order = $.trim($("#editorder").val());
            if (order == "") {
                showValidateMessage("请填写排序级别");
                return false;
            }
            if (!num(order)) {
                showValidateMessage("排序级别只能是数字");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
