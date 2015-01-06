<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarUseWayEdit.aspx.cs"
    Inherits="CarAppAdminWebUI.Car.CarUseWayEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <link rel="stylesheet" type="text/css" href="/Static/uploadify/uploadify.css" />
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="id" name="id" value="<%=Request.QueryString["id"] %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    原名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <%=Model.Name %>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>服务名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editname" name="name" value="<%=Model.Name %>" type="text" />
                    <span class="field-validation-valid" data-valmsg-for="editname" data-valmsg-replace="true">
                    </span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>服务描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <textarea class="adm_21" style="width: 96%;" id="description" name="description"><%=Model.Description %></textarea>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                   服务图标：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="editimgurl" readonly="readonly" style="width: 300px;" name="imgUrl" value="<%=Model.ImgUrl %>" type="text" />  
                            </td>
                        </tr>
                        <tr>
                           <td>
                                <iframe src="/FileUpLoad.aspx?id=editimgurl&folder=CarUseWay&h=80&w=80" frameborder="0" style="border: 0px;height: 43px; width:280px;">
                                </iframe>
                                  &nbsp;<a style="color:blue;" target="_blank"  href="../Images/imgPosition/caruseway.jpg">图片位置</a>
                            </td> 
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script type="text/javascript">

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/Car/SaveCarUseWay.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '操作成功！', 'info', function () {
                            onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }
        //校验表单
        function checkForm() {
            var name = $.trim($("#editname").val());
            if (name == "") {
                showValidateMessage("服务名称不能为空");
                return false;
            }

            var description = $.trim($("#description").val());
            if (description == "") {
                showValidateMessage("服务描述不能为空");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
