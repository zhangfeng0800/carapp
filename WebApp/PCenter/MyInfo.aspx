<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyInfo.aspx.cs" Inherits="WebApp.PCenter.MyInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/MyInfo.js" type="text/javascript"></script>
    <style type="text/css">
        .Dl_Form { width: 96%; }
        .Dl_Form dt { width: 10%; float: left; min-height: 40px; _height: 40px; text-align: left; font: 12px/36px 'Verdana' , '宋体'; margin-bottom: 5px; }
        .Dl_Form dd { width: 90%; min-height: 40px; _height: 40px; float: left; margin-bottom: 5px; }
        .Dl_Form dd #A_headPic { width: 160px; height: 160px; display: block; margin-bottom: 5px; border: 1px solid #ddd; }
        .Dl_Form dd img { width: 160px; height: 160px; display: block; margin-bottom: 5px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="per-order-til">
        修改账户资料
    </h3>
    <div class="per-line-bg">
        <dl class="Dl_Form">
            <dt>头像：</dt>
            <dd>
                <a id="A_headPic" href="javascript:;">
                    <img id="Img_headPic" alt="" src='<%=thisUserAccount.headPic %>' title="点击更换头像" /></a>
                <iframe id="Iframe_Upload" src="ImgUpload.aspx" frameborder="0" style="height: 0px;
                    width: 0px;"></iframe>
                   
            </dd>
            <dt>
                <%=(thisUserAccount.Type == 0 ? "公司名称" : "真实姓名")%>：</dt>
            <dd>
                <input class="per-input" type="text" value="<%=thisUserAccount.Compname %>" name="name"
                    maxlength="12" /></dd>
            <dt>昵称：</dt>
            <dd>
                <input class="per-input" type="text" value="<%=thisUserAccount.Username %>" name="username"
                    maxlength="16" />
            </dd>
            <dt>性别：</dt>
            <dd style="min-height: 32px; _height: 32px; padding-top: 8px;">
                <input class="" type="radio" name="Radio_Sex" value="True" />&nbsp;男&nbsp;
                <input class="" type="radio" name="Radio_Sex" value="False" />&nbsp;女&nbsp;
                <script type="text/javascript">                    SetRadioValue("Radio_Sex", "<%=thisUserAccount.sex %>");</script>
            </dd>
            <dt>手机：</dt>
            <dd>
                <input class="per-input" type="text" value="<%=thisUserAccount.Telphone %>" name="tel"
                    maxlength="11" /></dd>
            <dt>验证码：</dt>
            <dd>
                <input class="per-input" type="text" value="" name="verifycode"/>
                &nbsp;<a id="A_PostMobileVC" href="javascript:;" style="font: 12px '宋体','Verdana';
                    color: #f90; text-decoration: none;" title="点击发送验证码">获取验证码</a></dd>
            <dt>邮箱：</dt><dd><input class="per-input" type="text" value="<%=thisUserAccount.Email %>"
                name="email" /></dd>
            <dt>
                <input class="yc-btn bank-btn per-button-border" id="Button_Submit" type="button"
                    value="保存" /></dt><dd style="display: none"></dd>
        </dl>
    </div>
   
</asp:Content>
