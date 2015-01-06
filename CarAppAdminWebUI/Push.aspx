<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Push.aspx.cs" Inherits="CarAppAdminWebUI.Push" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>消息推送管理</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="txt_msg" runat="server"></asp:TextBox>
        <asp:Button ID="btn_Send"
            runat="server" Text="广播消息" onclick="btn_Send_Click" />
    </div>
    </form>
</body>
</html>

