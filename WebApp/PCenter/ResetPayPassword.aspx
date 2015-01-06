<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="ResetPayPassword.aspx.cs" Inherits="WebApp.PCenter.ResetPayPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript" src="../Scripts/forgetPayPwd.js"></script>
<style type="text/css">
.Span_Hint
{
    color:#f00;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <h3 class="per-order-til">
                重新设置支付密码</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <ul class="per-ul">
                    <li>
                        <span class="per-name-style" style="width: 80px;"><span class="Span_Hint">*</span>支付密码：</span>
                        <input class="in-border" type="password" id="newPW" style=" width:200px;" /><span style="color:#f00">&nbsp;(支付密码必须为6位数字，此密码也为电话订车密码。)</span>
                    </li>
                    <li>
                        <span class="per-name-style" style="width: 80px;"><span class="Span_Hint">*</span>确认密码：</span>
                        <input class="in-border" type="password" id="confirmPW"  style=" width:200px;"  />
                    </li>
                    <li>
                        <span class="per-name-style" style="width: 80px;"><span class="Span_Hint">*</span>短信验证码：</span>
                        <input class="in-border" type="text" id="txtVerify" name="txtVerify"  style=" width:200px;"  />
                        &nbsp;<a id="A_PostMobileVC" href="javascript:;" style="font: 12px '宋体','Verdana'; color: #f90; text-decoration: none;" title="点击发送验证码">获取验证码</a>
                    </li>
                    <li class="per-button-padding">
                        <input class="yc-btn bank-btn per-button-border" id="Button_Submit" type="button" value="提交修改"/>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>
