<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserHobbyAdd.aspx.cs" Inherits="CarAppAdminWebUI.Member.UserHobbyAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="addForm">
        <input type="hidden" id="action" name="action" value="add" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span> 喜好名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="Name" name="Name" />
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span> 喜好图片：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="Image" name="Image" />
                    <iframe src="../FileUpLoad.aspx?id=Image&folder=other&w=100&h=100" frameborder="0"
                                style="border: 0px; height: 43px; width:300px;"></iframe>
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span> 排序(降序排列)：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                        <input class="adm_21" id="Sort" name="Sort" value="0" onkeyup="this.value=this.value.replace(/\D/g,'')"  />
                </td>
            </tr>
        </table>
          <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
        </form>
        <script type="text/javascript">
        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();

                $.post("/Member/UserHobbyHandler.ashx", d, function (data) {
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
        function checkForm() {

            var name = $.trim($("#Name").val());
            if (name == "") {
                showValidateMessage("请填写喜好名称");
                return false;
            }
            return true;
        }

        </script>
</body>
</html>
