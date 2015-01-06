<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServiceCityHotLineEdit.aspx.cs"
    Inherits="CarAppAdminWebUI.ProvinceCity.ServiceCityHotLineEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="edithotlineForm">
        <input type="hidden" id="action" name="action" value="onEditHotLine" />
        <input type="hidden" id="id" name="id" value="<%=Id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>类型图片：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="editimgurl" readonly="readonly" value="<%=ImgUrl %>" style="width: 300px;" name="imgUrl" type="text" />
                                 &nbsp;<a target="_blank" href="../Images/imgPosition/ServiceCityListDefault.jpg" style="color:blue;">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                           <td>
                                <iframe src="/FileUpLoad.aspx?id=editimgurl&folder=HotLine&w=150&h=100" frameborder="0" style="border: 0px;height: 43px;">
                                </iframe>
                            </td> 
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script type="text/javascript">
        function onSubmit() {
            var d = $("#edithotlineForm").serialize();
            $.post("/ProvinceCity/ServiceCityHandler.ashx", d, function (data) {
                if (data.IsSuccess) {
                    var message = "操作成功！";
                    if (data.Message != "") {
                        message = data.Message;
                    }
                    $.messager.alert('消息', message, 'info', function () {
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
