<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HotLineTraveltheme.aspx.cs"
    Inherits="CarAppAdminWebUI.ProvinceCity.HotLineTraveltheme" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="themeForm">
        <input type="hidden" id="action" name="action" value="settheme" />
        <input type="hidden" id="id" name="id" value="<%=Request.QueryString["id"] %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    关联主题：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="Linetheme" name="Linetheme">
                    </select>
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
        $(function () {
            initLinetheme();
        });

        function initLinetheme() {
            var v = '<%=Values %>';
            $('#Linetheme').combotree({
                width:300,
                url: '/ProvinceCity/HotLineList.ashx?action=tlist',
                multiple:true,
                checkbox:true,
                cascadeCheck: true,
                onLoadSuccess: function (data) {
                    if (v != '') {
                        $('#Linetheme').combotree("setValues", [<%=Values %>]);
                    }
                } 
            });
        }

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#themeForm").serialize();
                $.post("/ProvinceCity/SaveHotLine.ashx", d, function (data) {
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
            return true;
        }
    </script>
</body>
</html>
