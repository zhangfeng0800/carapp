<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AppLoadEdit.aspx.cs" Inherits="CarAppAdminWebUI.artical.AppLoadEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
       <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
             <input type="hidden" id="Id" name="Id" value="<%=appLoad.Id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span> 状态：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                <select class="adm_21" id="State" name="State">
                    <option value="显示">显示</option>
                    <option value="隐藏">隐藏</option>
                </select>
                    
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span> 图片：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="Image" name="Image" value="<%=appLoad.ImageUrl %>" style="width:350px;" readonly="readonly"  />
                    <iframe src="../FileUpLoad.aspx?id=Image&folder=other&h=1280&w=720" frameborder="0"
                                style="border: 0px; height: 43px; width:300px;"></iframe>
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span> 排序(降序排列)：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                        <input class="adm_21" id="Sort" name="Sort" value="<%=appLoad.Sort %>" onkeyup="this.value=this.value.replace(/\D/g,'')"  />
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span> 版本号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                        <input class="adm_21" id="Version" name="Version" value="<%=appLoad.Version %>" onkeyup="this.value=this.value.replace(/\D/g,'')"  />
                         (安卓客户端会显示版本号最大的图片)
                </td>
            </tr>
        </table>
          <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onEditSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
        </form>
        <script type="text/javascript">
            $(function () {
                $("#State").val("<%=appLoad.State %>")
            })
            function onEditSubmit() {
                var d = $("#editForm").serialize();

                $.post("/artical/AppLoadHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '操作成功！', 'info', function () {
                            onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }

        </script>
</body>
</html>
