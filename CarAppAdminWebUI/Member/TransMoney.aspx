<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransMoney.aspx.cs" Inherits="CarAppAdminWebUI.Member.TransMoney" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>用户转账</title>
</head>
<body>
    <form id="transform" runat="server">
    <%if (GroupID == 1)
      { %>
    <div>
    <input type="hidden" id="action" name="action" value="transmoney" />
      <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span> 转出账户手机：
                </td>
                <td class="adm_42" width="80%" colspan="3">
                     <input class="adm_21" type="text" id="fromUser" name="fromUser" onblur="getuserinfo(this)" />
                        <label id="fromUserInfo" style="color:Red;">（输入后提示）</label>
                </td>
            </tr>
              <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span> 转入账户手机：
                </td>
                <td class="adm_42" width="80%" colspan="3">
                     <input class="adm_21" type="text" id="toUser" name="toUser" onblur="getuserinfo(this)" />
                    <label id="toUserInfo" style="color:Red;"></label>
                </td>
            </tr>
               <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span> 转账金额：
                </td>
                <td class="adm_42" width="80%" colspan="3">
                    <input class="adm_21" type="text" name="money" id="money" />(保留两位小数)
                </td>
            </tr>
              <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span> 备注：
                </td>
                <td class="adm_42" width="80%" colspan="3">
                   <textarea class="adm_21" id="remark" rows="3" name="remark"></textarea>
                </td>
            </tr>
  </table>
      <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>

    </div>
    <%}
      else {%> 
      只有管理员可以使用此功能
      <%}
         %>
    
    </form>

    <script type="text/javascript">
        function getuserinfo(obj) {
            $.post("/Member/UserAccountHandler.ashx", { "action": "getuserinfo", "telphone": $(obj).val() }, function (data) {
                if (data.resultcode == 1) {
                    $(obj).next().html(data.msg);
                }
                else {
                    $(obj).next().html("真实姓名：" + data.data.Compname);
                }
            }, "json");
        }
        function onAddSubmit() {
            var d = $("#transform").serialize();
            $.messager.confirm("提示", "你确定要执行此操作么？", function (r) {
                if (r) {
                    $.post("/Member/UserAccountHandler.ashx", d, function (data) {
                        if (data.IsSuccess) {
                            $.messager.alert('提示', '恭喜,转账成功!');
                            onClose();
                        }
                        else {
                            $.messager.alert('提示', '失败' + data.Message);
                        }
                    },"json");
                }
            })
        }
    </script>
</body>
</html>
