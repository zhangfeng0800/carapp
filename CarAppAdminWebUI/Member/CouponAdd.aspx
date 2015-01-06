<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CouponAdd.aspx.cs" Inherits="CarAppAdminWebUI.Member.CouponAdd" %>

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
                    <span class="field-validation-valid">*</span>名称：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="addName" name="Name" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>面值：
                </td>
                <td class="adm_42" width="70%" colspan="3">
                    <input class="adm_21" id="addCost" name="Cost" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30">
                    <span class="field-validation-valid">*</span>有效期：
                </td>
                <td class="adm_42" colspan="3">
                    <input class="adm_21 Wdate" id="addStartdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="Startdate" type="text" />-<input class="adm_21 Wdate"
                        id="addDeadline" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'addStartdate\')}'})" name="Deadline" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30">
                    <span class="field-validation-valid">*</span>需要订单消费金额：
                </td>
                <td class="adm_42" colspan="3">
                    <input class="adm_21" id="addRestrictions" name="Restrictions" type="text" />
                    不限制请填写0
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30">
                    <span class="field-validation-valid">*</span>生成数量：
                </td>
                <td class="adm_42" colspan="3">
                    <input class="adm_21" id="addCount" name="count" value="100" type="text" />
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
                $.messager.progress({
                    title: '操作中',
                    msg: '<span style="color:red;">警告：正在生成中，请勿关闭此窗口...</span>',
                    text:""
                });
                $.post("/Member/CouponHandler.ashx", d, function (data) {
                    $.messager.progress('close');
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

            var name = $.trim($("#addName").val());
            if (name == "") {
                showValidateMessage("请填写优惠券名称");
                return false;
            }
            if (name.length > 50) {
                showValidateMessage("优惠券名称不能超过50个汉字");
                return false;
            }

            var cost = $.trim($("#addCost").val());
            if (cost == "") {
                showValidateMessage("请填写优惠券面值");
                return false;
            }
            if (!pnum(cost)) {
                showValidateMessage("请输入有效的优惠券面值");
                return false;
            }
            if (cost > 1000) {
                showValidateMessage("优惠券面值不能大于1000元");
                return false;
            }

            var startdate = $.trim($("#addStartdate").val());
            if (startdate == "") {
                showValidateMessage("请填写有效期开始时间");
                return false;
            }

            var deadline = $.trim($("#addDeadline").val());
            if (deadline == "") {
                showValidateMessage("请填写有效期结束时间");
                return false;
            }

            var restrictions = $.trim($("#addRestrictions").val());
            if (restrictions == "") {
                showValidateMessage("请填写使用限制");
                return false;
            }
            if (!num(restrictions)) {
                showValidateMessage("使用限制只能是数字");
                return false;
            }

            var count = $.trim($("#addCount").val());
            if (count == "") {
                showValidateMessage("请填写生成数量");
                return false;
            }
            if (!pnum(count)) {
                showValidateMessage("生成数量只能是正整数");
                return false;
            }
            if (count>100) {
                showValidateMessage("一次最多只能生成100张优惠券");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
