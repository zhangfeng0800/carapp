<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GiftCardsAdd.aspx.cs" Inherits="CarAppAdminWebUI.Member.GiftCardsAdd" %>

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
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addname" name="name" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>面值：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addCost" name="Cost" type="text" />
                </td>
            </tr>
          
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>领卡人：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select id="saleManId" name="saleManId">
                    <% foreach (var model in list)
{
  %><option value="<%=model.Id %>"><%=model.Name %></option><%
} %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>操作人：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="Text2" name="count" type="text" disabled="disabled" value="<%=User.Identity.Name %>" />
                </td>
            </tr>
              <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>生成数量：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addCount" name="count" value="100" type="text" onkeyup="changeNumber()" /> 卡的序号将从 <span id="numberBegin"><%=numberMax%></span> 到 <span id="numberEnd"><%=(numberMax+99)%></span>
                    <input type="hidden" name="numberBegin" value="<%=numberMax%>" />
                </td>
            </tr>
                          <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>用户使用限制：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select id="cardType" name="cardType">
                     <option value="0">不限制</option>
                     <option value="1">每个用户限用一张</option>
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
        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.messager.progress({
                    title: '操作中',
                    msg: '<span style="color:red;">警告：正在生成中，请勿关闭此窗口...</span>',
                    text: ""
                });
                $.post("/Member/GiftCardsHandler.ashx", d, function (data) {
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
        function changeNumber() {
            var numberend = parseInt($("#numberBegin").html()) + parseInt($("#addCount").val()) - 1;
            
            $("#numberEnd").html(numberend);
        }
        //校验表单
        function checkForm() {
            var name = $.trim($("#addname").val());
            if (name == "") {
                showValidateMessage("请填写充值卡名称");
                return false;
            }
            if (name.length > 16) {
                showValidateMessage("充值卡名称不能多于16个汉字");
                return false;
            }

            var cost = $.trim($("#addCost").val());
            if (cost == "") {
                showValidateMessage("请填写充值卡面值");
                return false;
            }
            if (!pnum(cost)) {
                showValidateMessage("请输入有效的充值卡面值");
                return false;
            }
            if (cost > 10000) {
                showValidateMessage("充值卡面值不能大于10000元");
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
            if (count > 100000) {
                showValidateMessage("一次只能生成100000张充值卡");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
