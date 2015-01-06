<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FundingRefund.aspx.cs" Inherits="CarAppAdminWebUI.Activity.FundingRefund" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
      <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="amountspan"><%=fundingDt.Rows[0]["Amount"] %></span>元
                  <%--  <%if (fundingDt.Rows[0]["ClerkId"].ToString() == "0") { %>
                   <br /> <span style=" color:Red;">此资金为客户通过线上方式转入，强制退款后需要线下退款给客户</span>  
                    <%}%>--%>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>存入时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="Indatespan"><%=Convert.ToDateTime(fundingDt.Rows[0]["Indate"]).ToString("yyyy-MM-dd")%></span>
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>到期时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="yearspan"><%=Convert.ToDateTime(fundingDt.Rows[0]["ExpirationDate"]).ToString("yyyy-MM-dd")%></span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>用户账号信息：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="useraccountspan">真实姓名：<%=fundingDt.Rows[0]["compname"]%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    手机号码：<%=fundingDt.Rows[0]["telphone"]%>
                    </span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>规则：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <span id="fundrulesspan">
                     每月返券数：<%=fundingDt.Rows[0]["Num"] %>张&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单券面值：<%=fundingDt.Rows[0]["Cost"]%>元
                     </span>
                </td>
            </tr>
        </table>
         <p style="text-align: center;">
         <span style="color:red;">请认真核对资金信息，退款后将停止下月以后的所有代金券！在此点击退款，活动资金不会自动转入用户账户，需要线下退款处理</span><br />
                <a class="easyui-linkbutton" href="javascript:onSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>

                <input type="hidden"  value="<%=fundingDt.Rows[0]["Id"] %>" id="fundingId"/>
        </p>

        <script type="text/javascript">
            function onSubmit() {
                if (confirm("确认要退款吗？")) {
                    $.post("/Activity/FundingHandler.ashx", { "action": "fundingRefund", "id": $("#fundingId").val() }, function (data) {
                        if (data.IsSuccess) {
                            $.messager.alert('消息', '退款成功！', 'info', function () {
                                onClose();
                            });
                        }
                        else {
                            $.messager.alert('消息', data.Message, 'error');
                        }
                    }, "json")
                }
            }
        </script>
</body>
</html>
