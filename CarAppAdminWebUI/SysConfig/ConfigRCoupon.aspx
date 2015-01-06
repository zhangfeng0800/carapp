<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfigRCoupon.aspx.cs"
    Inherits="CarAppAdminWebUI.SysConfig.ConfigRCoupon" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="/Static/scripts/jquery.min.js"></script>
    <!--   EasyUI Start-->
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Static/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="/Static/easyui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="/Static/scripts/easyui.formatter.expend.js"></script>
    <script type="text/javascript" src="/Static/scripts/easyui.validator.expend.js"></script>
    <!--   EasyUI End-->
    <script type="text/javascript" src="/Static/My97DatePicker/WdatePicker.js"></script>
    <link type="text/css" href="/Static/styles/admin.css" rel="stylesheet" />
    <script type="text/javascript" src="/Static/scripts/common.js"></script>
    <script type="text/javascript" src="/Static/scripts/validator.js"></script>
    <script type="text/javascript" src="/Static/scripts/city.js"></script>
    <style type="text/css">
        td input
        {
            margin-left: 0 !important;
        }
        /* 因为admin.css 里的 td input 样式会使 combogrid 下拉框错位 所以加下面的样式 */
        .combobox-item
        {
            height: 20px;
        }
        /*EassyUI 下拉框第一项为空时,撑开第一项 */
        .ke-dialog-body .tabs
        {
            height: 0px;
            border: 0px;
        }
        /*KindEdit 的图片上传选择框和EasyUI样式冲突 */
        .datagrid-cell
        {
            white-space: normal !important;
        }
        /*easyui列自动换行*/
        .datagrid-row-selected
        {
            background: #E9F9F9 !important;
        }
        .field-validation-valid
        {
            color: Red;
        }
    </style>
</head>
<body>
    <div style="padding: 5px;">
        <form id="addForm">
        <input type="hidden" id="action" name="action" value="ConfigRCoupon" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>送优惠券金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" name="key1" value="<%=Common.SystemConfig.注册送优惠券金额 %>" type="hidden" />
                    <input class="adm_21" id="value1" name="value1" value="<%=val1 %>" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>送优惠券使用限制：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" name="key2" value="<%=Common.SystemConfig.注册送优惠券限额 %>" type="hidden" />
                    <input class="adm_21" id="value2" name="value2" value="<%=val2 %>" type="text" />元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>送优惠券名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" name="key3" value="<%=Common.SystemConfig.注册送优惠券名称 %>" type="hidden" />
                    <input class="adm_21" id="value3" name="value3" value="<%=val3 %>" type="text" />
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a>
        </p>
    </div>
    <script type="text/javascript">

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.post("/SysConfig/ConfigHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '操作成功！', 'info');
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }
        //校验表单
        function checkForm() {
            var value1 = $.trim($("#value1").val());
            if (value1 == "") {
                showValidateMessage("请输入注册派送的优惠券金额");
                return false;
            }
            if (!num(value1)) {
                showValidateMessage("请输入一个有效的金额");
                return false;
            }
            if (value1 > 10000) {
                showValidateMessage("注册就送的优惠券金额不能大于10000元");
                return false;
            }

            var value2 = $.trim($("#value2").val());
            if (value2 == "") {
                showValidateMessage("请输入注册派送的优惠券使用限制");
                return false;
            }
            if (!num(value2)) {
                showValidateMessage("请输入一个有效的使用限制");
                return false;
            }
            if (value2 > 10000) {
                showValidateMessage("注册就送的优惠券使用限制不能大于10000元");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
