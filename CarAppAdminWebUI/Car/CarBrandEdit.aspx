<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarBrandEdit.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarBrandEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="id" name="id" value="<%=Model.id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>品牌名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editbrandName" name="brandName" value="<%=Model.brandName %>" type="text" />
                    <span class="field-validation-valid" data-valmsg-for="editbrandName" data-valmsg-replace="true">
                    </span>

                     &nbsp;&nbsp;&nbsp;&nbsp;排序：<input id="sort" name="sort" value="<%=Model.Sort %>" style=" width:30px;"  onkeyup="this.value=this.value.replace(/\D/g,'')" />（从大到小排列）
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    品牌描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <textarea class="adm_21" style="width: 96%;" id="editdescription" name="description"><%=Model.Description %></textarea>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    品牌图片(大)：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="editimgUrl" readonly="readonly" style="width: 300px;" name="imgUrl" value="<%=Model.ImgUrl %>" type="text" />
                               &nbsp;<a target="_blank" style="color:blue;" href="../Images/imgPosition/carbrandDefault.jpg">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                           <td>
                                <iframe src="/FileUpLoad.aspx?id=editimgUrl&folder=CarBrand&w=300" frameborder="0" style="border: 0px;height: 43px;">
                                </iframe>
                            </td> 
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    品牌图片(小)：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="editsimgurl" readonly="readonly" style="width: 300px;" name="simgurl" value="<%=Model.SImgUrl %>" type="text" />
                                （暂时没用）
                            </td>
                        </tr>
                        <tr>
                           <td>
                                <iframe src="/FileUpLoad.aspx?id=editsimgurl&folder=CarBrand&w=100&h=75" frameborder="0" style="border: 0px;height: 43px;">
                                </iframe>
                            </td> 
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    品牌描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <% string guid = Guid.NewGuid().ToString(); %>
                    <script id="editcarbrandcontainer<%=guid %>" name="content" type="text/plain"><%=Model.MoreDescript %></script>
                    <script type="text/javascript">
                        var editeditor = UE.getEditor('editcarbrandcontainer<%=guid %>');
                    </script>   
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
                $.post("/Car/SaveCarBrand.ashx", d, function (data) {
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
            var brandName = $.trim($("#editbrandName").val());
            var imgUrl = $.trim($("#editimgUrl").val());

            if (brandName == "") {
                $("[data-valmsg-for=editbrandName]").html("请填写车牌名称");
                return false;
            } else {
                $("[data-valmsg-for=editbrandName]").html("");
            }
            if (brandName.length > 15) {
                showValidateMessage("品牌名称不能大于15个汉字");
                return false;
            }

            var description = $.trim($("#editdescription").val());
            if (description.length > 150) {
                showValidateMessage("品牌描述不能多于150个汉字");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
