<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarRemarkAdd.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarRemarkAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="addForm">
        <input type="hidden" id="action" name="action" value="add" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    备注信息：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <textarea id="content" name="content" cols="60" rows="5"></textarea>（最大长度100）
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    排序：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input id="sort" name="sort" value="0" style="width: 67px; height: 21px;" onkeyup="this.value=this.value.replace(/\D/g,'')" />（从大到小排列）
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
                $.post("/Car/remarkhandler.ashx", d, function (data) {
                    if (data.resultcode == 0) {
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
            var content = $.trim($("#content").val());

            if (content == "") {
                $("[data-valmsg-for=content]").html("请填写车牌名称");
                return false;
            } else {
                $("[data-valmsg-for=content]").html("");
            }
            if (content.length >100) {
                showValidateMessage("备注信息不能大于100个汉字");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
