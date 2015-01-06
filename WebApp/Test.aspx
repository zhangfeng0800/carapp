<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="WebApp.Test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="js/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $.getJSON("http://api.map.baidu.com/geocoder/v2/?ak=kYvztiBTS4EKotMmUMyLt0dy&output=json&address=石家庄市政府&city=石家庄",
          function (json) {
              alert(json);
          });
        });
      
    </script>
    
    <script charset="Shift_JIS" src="http://chabudai.sakura.ne.jp/blogparts/honehoneclock/honehone_clock_tr.js"></script>
    </head>
<body>
    <form id="form1" runat="server">
    <div>
   手机号： <asp:TextBox runat="server" ID="txtPhone"></asp:TextBox>

    发送内容：<asp:TextBox runat="server" ID="txtContent"></asp:TextBox>

    <asp:Button runat="server" ID="btnSend" Text="发送" onclick="btnSend_Click" />
    <asp:Label runat="server" ID="lblMsgid"></asp:Label>
    </div>

    <div>
    <asp:TextBox runat="server" ID="txtMsgid"></asp:TextBox>
    <asp:Button runat="server" ID="btnSearch" Text="查询报告" onclick="btnSearch_Click" />

    <asp:Label runat="server" ID="lblResult"></asp:Label>

    <input onkeyup="this.value=this.value.replace(/^\d+(?:\.\d{3}|$)/)" />
    </div>
    </form>
</body>
</html>
