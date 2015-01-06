<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SalesManEdit.aspx.cs" Inherits="CarAppAdminWebUI.Member.SalesManEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
     <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
           <input type="hidden" id="Id" name="Id" value="<%=model.Id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>用户名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editname" name="name" type="text" value="<%=model.Name %>" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editSort" name="sort" type="text" value="<%=model.Sort %>" />
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
                $.post("/Member/SalesManHandler.ashx", d, function (data) {
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
                showValidateMessage("请填写用户名称");
                return false;
            }
            var sort = $.trim($("#editSort").val());
            if (sort == "") {
                showValidateMessage("请填写排序字段");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
