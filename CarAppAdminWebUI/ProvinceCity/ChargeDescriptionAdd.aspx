<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChargeDescriptionAdd.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.ChargeDescriptionAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
     <div style="padding: 5px;">
        <form id="addForm">
        <input type="hidden" id="action" name="action" value="add" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
           
            <tr>
            <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addprovinceId" style="width: 100px;" name="provinceId">
                    </select>
                    <select class="adm_21" id="addcityId" style="width: 100px;" name="cityId">
                        <option value="">不限</option>
                    </select>
                    <select class="adm_21" id="addcountyId" style="width: 100px;" name="countyId">
                        <option value="">不限</option>
                    </select>
                </td>
            </tr>

            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    扣费说明：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <input type="hidden" name="Description" id="Description" />

                    <div id="editor" style="height:300px;"></div>
                    <script type="text/javascript">
                        var editor = new baidu.editor.ui.Editor();
                        editor.render("editor");  
                    </script>  
                </td>
            </tr>
 
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="Sort" name="Sort" value="0" onkeyup="this.value=this.value.replace(/\D/g,'')"  type="text" />
                    数值越大越靠前显示
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
    $(function () {
        initCitySelect("addprovinceId", "不限", 0, "");
        citySelectChange("addprovinceId", "addcityId", "addcountyId", "不限");
        citySelectChange("addcityId", "addcountyId", "", "不限");
    });

    function onAddSubmit() {
        if (checkForm()) {
            var d = $("#addForm").serialize();
            $.post("/ProvinceCity/ChargeDescription.ashx", d, function (data) {
                if (data.IsSuccess) {
                    $.messager.alert('消息', '添加成功！', 'info', function () {
                        onClose();
                    });
                } else {
                    $.messager.alert('消息', data.Message, 'error');
                }
            }, "json");
        }
    }
    function checkForm() {

        var Description = $.trim(UE.getEditor('editor').getContent());
        $("#Description").val(Description);

        if (Description == "") {
            alert("扣费说明不能为空");
            return false;
        }
        else if ($("#Sort").val() == "") {
            alert("排序字段不能为空");
            return false;
        }
        return true;

    }
</script>
   
</body>
</html>
