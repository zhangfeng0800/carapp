<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SettingConfig.aspx.cs" Inherits="CarAppAdminWebUI.SysConfig.SettingConfig" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="/Static/scripts/jquery.min.js"></script>
    <!--   EasyUI Start-->
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Static/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="/Static/easyui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="/Static/scripts/easyui.formatter.expend.js"></script>
    <script type="text/javascript" src="/Static/scripts/easyui.validator.expend.js"></script>
    <!--   EasyUI End-->
    <script type="text/javascript" src="/Static/My97DatePicker/WdatePicker.js"></script>
    <link type="text/css" href="/Static/styles/admin.css" rel="stylesheet" />
    <script type="text/javascript" src="/Static/scripts/common.js"></script>
    <script type="text/javascript" src="/Static/scripts/validator.js"></script>
    <script type="text/javascript" src="/Static/scripts/city.js"></script>
    <style type="text/css">
        td input
        {
            margin-left: 0 !important;
        }
        /* 因为admin.css 里的 td input 样式会使 combogrid 下拉框错位 所以加下面的样式 */
        .combobox-item
        {
            height: 20px;
        }
        /*EassyUI 下拉框第一项为空时,撑开第一项 */
        .ke-dialog-body .tabs
        {
            height: 0px;
            border: 0px;
        }
        /*KindEdit 的图片上传选择框和EasyUI样式冲突 */
        .datagrid-cell
        {
            white-space: normal !important;
        }
        /*easyui列自动换行*/
        .datagrid-row-selected
        {
            background: #E9F9F9 !important;
        }
        .field-validation-valid
        {
            color: Red;
        }
    </style>
</head>
<body>
    <div style="padding: 5px;">
        <form id="addForm" method="POST" action="/SysConfig/SettingConfig.aspx">
        <input type="hidden" id="action" name="action" value="update" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>网页标题：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" name="title" value="<%=model.PageTitle%>" type="text" />
                     
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>网页描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" name="description" value="<%=model.PageDescription %>"   type="text"/>
                  
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>关键字：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" name="keywords" value="<%=model.PageKeywords %>"   type="text" />
                  
                </td>
            </tr>
               <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>备案号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" name="icp" value="<%=model.ICP %>" type="text" />
                 
                </td>
            </tr>
               <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>版权信息：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" name="copyright" value="<%=model.CopyRight %>" type="text" /> 
                </td>
            </tr>
        </table> <p style="text-align: center;">
            <button class="easyui-linkbutton"  type="submit">确认提交</button>
        </p>
        </form>
       
    </div>
      
</body>
</html>
