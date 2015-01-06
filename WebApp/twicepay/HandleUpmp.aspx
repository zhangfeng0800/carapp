<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HandleUpmp.aspx.cs" Inherits="WebApp.twicepay.HandleUpmp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no" name="viewport" id="viewport" /><meta name="format-detection" content="telephone=no"/>
</head>
<body>
    <div class="menu">
        <h3 class="til">
            爱易租订单支付</h3>
    </div>
    <div style=" text-align:center; margin-top:15px;">
<%--  <embed type="application/x-unionpayplugin"
uc_plugin_id="unionpay"
height="53"
width="178" paydata="<%=paydata %>">
</embed>--%>

<a href="uppay://uppayservice/?style=token&paydata=<%=paydata %>">
<img src="../images/upmpay.png" height="53" width="178" alt="银联手机支付"/></a>
 
 <div style=" font-size:12px; color:Red; width:178px; margin-left:auto; margin-right:auto;" >如果您首次使用银联支付，请先点击下面链接下载支付控件
        <a style="color:Blue;font-size:14px;" href="http://mobile.unionpay.com/getclient?platform=android&type=securepayplugin">Android</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a style="color:Blue;font-size:14px;" href="http://mobile.unionpay.com/getclient?platform=ios&type=securepayplugin">IOS</a>
        </div>

</div>
</body>
</html>
