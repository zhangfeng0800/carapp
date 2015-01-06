<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="moduleadd.aspx.cs" Inherits="CarAppAdminWebUI.Manager.moduleadd" %>

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
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>上级模块名称：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="parentid" name="parentid" type="text" style="text-align: center;"
                        value="0" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>模块名称：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="modulename" name="modulename" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>链接地址：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input id="linkurl" value="01" name="linkurl" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="sort" name="sort" type="text" value="0" />
                    按排序大小降序排列
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>是否可见：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="isvisible" name="isvisible" type="checkbox" checked="checked" />
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
            $('#parentid').combotree({
                url: '/manager/modulehandler.ashx?action=combox',
                required: true
            });
            initTree();
        });

        function initTree() {
            $('#linkurl').combotree({
                url: '/manager/ModuleHandler.ashx?action=tree',
                required: true,
                width: 300,
                onClick: function (node) {
                   if (node.text.indexOf(".aspx") > -1) {
                       return true;
                   } else {
                       return false;
                   }
                }
            });
            $('#linkurl').combotree('setValue', '');
        }
        function onAddSubmit() {
            if (checkForm()) {
                $.ajax({
                    url: "/manager/modulehandler.ashx",
                    data: $("#addForm").serialize(),
                    type: "post",
                    success: function (data) {
                        if (data.IsSuccess == false) {
                            $.messager.alert("提示信息", data.Message);

                        } else {
                            $.messager.alert("提示信息", data.Message);
                            onClose();
                        }
                    }
                });
            }
        }

        function checkForm() {
            if ($.trim($("#modulename").val()) == "") {
                $.messager.alert("提示信息", "请输入模块名称");
                return false;
            }
            if (!num($("#sort").val())) {
                $.messager.alert("提示信息", "请输入数字");
                return false;
            }
            return true;
        }
        
      
    </script>
</body>
</html>
