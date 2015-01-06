<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DownwindDeduction.aspx.cs" Inherits="CarAppAdminWebUI.Order.DownwindDeduction" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
   <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%" style=" line-height:30px;">
             <tr>
                <td class="adm_45" align="center" height="30" width="25%">
                    设置用户取消顺风车订单时的扣款比例(司机出发前)
                 </td>
            </tr>
            <tr>
                <td class="adm_45" align="center" height="30" width="25%">
                 扣除 <input id="percent" name="percent" style="width:60px;" value='<%=lotery.Rows[0]["money"] %>' />%
                 </td>
            </tr>
    </table>

    <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
    </p>

    <script type="text/javascript">
        function onAddSubmit() {
            if (confirm("确认要提交吗？")) {
                $.post("/Order/DownwindHandler.ashx", { "action": "setdeduction", "percent": $("#percent").val() }, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '修改成功！', 'info', function () {
                            window.location.reload();
                            onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }
    </script>
</body>
</html>
