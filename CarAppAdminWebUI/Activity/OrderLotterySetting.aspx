<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="OrderLotterySetting.aspx.cs" Inherits="CarAppAdminWebUI.Activity.OrderLotterySetting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <div id="firstStep">
    <form id="addForm">
        <input type="hidden" id="action" name="action" value="updatelotterysetting" />
                <input type="hidden" id="id" name="id" value="<%=Request.QueryString["id"].ToString() %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>优惠券金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="money" name="money" value="<%=data.Rows[0]["money"].ToString().Trim() %>" type="text" maxlength="10" style=" font-size:20px;color:Red; height:30px; width:150px;" onkeyup="this.value=this.value.replace(/\D/g,'')"   />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>开始时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    
                     <input class="adm_21" id="starttime" name="starttime"  value="<%=DateTime.Parse(data.Rows[0]["starttime"].ToString()).ToString("yyyy-MM-dd") %>" readonly="readonly" type="text" onclick="WdatePicker()" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>结束时间： 
                </td>
                <td class="adm_42" width="78%" colspan="3">
                      <input class="adm_21" id="endtime" readonly="readonly" name="endtime" type="text" onclick="WdatePicker()"  value="<%=DateTime.Parse(data.Rows[0]["endtime"].ToString()).ToString("yyyy-MM-dd") %>"/>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>客户端按钮文字：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <input class="adm_21" style="width: 200px" id="buttontext" name="buttontext"  value="<%=data.Rows[0]["buttontext"].ToString() %>"/>
                </td>
            </tr>
          
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:submitsetting()">提交</a>  
        </p>
    </div>
    <script>
        function submitsetting() {
            $.ajax({
                url: "/Activity/LotteryHandler.ashx?"+$("#addForm").serialize(),
                success:function(data) {
                    if (data.resultcode == 1) {
                        $.messager.alert("提示信息", "操作成功");
                    } else {
                        $.messager.alert("提示信息", data.msg);
                    }
                }
            });
        }
    </script>
</asp:Content>
