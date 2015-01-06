<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminRegister.aspx.cs"
    Inherits="CarAppAdminWebUI.Member.AdminRegister" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="padding: 5px;">
        <form id="addForm">
        <input type="hidden" id="action" name="action" value="add" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr style="display: none;">
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>用户类型：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                     <select style="width: 200px;" id="usertype"  >
                        <option value="3" selected="selected">个人账户</option>
                        <option value="0">企业账户</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>真实姓名：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="in_border" type="text" id="username" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30">
                    <span class="field-validation-valid">*</span>性别：
                </td>
                <td class="adm_42" colspan="3">
                    <select id="sex">
                        <option value="true" selected="selected">男</option>
                        <option value="false">女</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30">
                    <span class="field-validation-valid">*</span>手机号码：
                </td>
                <td class="adm_42" colspan="3">
                    <input class="in_border" type="text" id="telphone1" />
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script>
        function onAddSubmit() {

            if ($("#username").val() == "" || $("#telphone1").val() == "") {
                console.log($("#username").val());
                console.log($("#telphone1").val());
                alert("请填写完整信息");
                return;
            }
            var mobileReg = /^1\d{10}$/gi;
            if (mobileReg.test($("#telphone1").val()) == false) {
                $.messager.alert("提示信息", "手机号格式错误");
                return;
            }
            $.ajax({
                url: "/ajax/register.ashx",
                type: "post",
                data: { telphone: $("#telphone1").val(), type:3, name: $("#username").val(), sex: $("#sex").val() },
                success: function (data) {
                    if (data.resultcode == 0) {
                        $.messager.alert('提示信息', data.msg);
                    } else {
                        onClose();
                    }
                }
            });
        } 
    </script>
    </form>
</body>
</html>
