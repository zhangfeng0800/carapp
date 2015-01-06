<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HandleOrderPay.aspx.cs" Inherits="WebApp.HandleOrderPay" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Scripts/jquery-2.0.3.js" type="text/javascript"></script>
    <script type="text/javascript">
    <%if(MerId!="")
      {%>
       $(function () {
            $("#upop").submit();
        })
      <%}%>  
    </script>
</head>
<body>

    <form id="upop" action="https://payment.chinapay.com/pay/TransGet" METHOD="POST"> 
    <input type=hidden name="MerId" value="<%=MerId%>"/> 
    <input type=hidden name="OrdId" value="<%=OrderId %>"/> 
　　<input type=hidden name="TransAmt" value="<%=Amount %>"/> 
　　<input type=hidden name="CuryId" value="<%=CuryId %>"/> 
　　<input type=hidden name="TransDate" value="<%=Date %>"/>
　　<input type=hidden name="TransType" value="0001"/><!--交易类型 0001（消费）  002（退货）-->
　　<input type=hidden name="Version" value="20070129"/><!--版本-->
    <input type=hidden name="BgRetUrl" value="<%=BackUrl %>"/> 
    <input type=hidden name="PageRetUrl" value="<%=BackUrl %>"/>
　　<input type=hidden name="GateId" value="">
　　<input type=hidden name="Priv1" value="<%=Idext %>">
　　<input type=hidden name="ChkValue" value="<%=SignStr %>">
    </form>

</body>
</html>
