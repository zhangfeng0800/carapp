<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TypeMana.aspx.cs" Inherits="CarAppAdminWebUI.artical.TypeMana" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 20px;">
        <input id="ID" value="<%=artical.ID %>" style="display: none;" />
        <table>
            <tr style="height: 40px;">
                <td>
                    栏目名称：
                </td>
                <td>
                    <input type="text" id="name" name="name" value="<%=artical.Name %>" />(长度2-40)
                </td>
                <td>
                    是否需要主图：
                </td>
                <td>
                    <input type="checkbox" id="hasImage" name="hasImage" <%if(artical.hasImage==1){ %>
                        checked="checked" <%} %> />
                </td>
            </tr>
            <tr style="height: 40px;">
                <td>
                    排序：
                </td>
                <td>
                    <input id="sort" name="sort" value="<%=artical.sort %>" style="width: 60px;" onkeyup="this.value=this.value.replace(/\D/g,'')" />
                    （按大小降序排列）
                </td>
                <td>
                    是否首页展示：
                </td>
                <td>
                    <input type="checkbox" id="indexShow" name="indexShow" <%if(artical.indexShow==1){ %>
                        checked="checked" <%} %> />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <a href="javascript:onSub()" class="easyui-linkbutton">保存</a> <a href="javascript:onClose()"
                        class="easyui-linkbutton">取消</a>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript">
        function onSub() {
            if ($("#name").val() == "") {
                alert("名字不能为空");
                return;
            }
            var action = "addType";
            if ($("#ID").val() != "" && $("#ID").val() != "0")
                action = "updateType";

            var hasImg = 0;
            var indexShow = 0;
            if ($("#hasImage").prop("checked"))
                hasImg = 1;
            if ($("#indexShow").prop("checked"))
                indexShow = 1;
            var sort = 0;
            if ($("#sort").val() != "")
                sort = $("#sort").val();

            $.ajax({
                url: 'ArticalHandler.ashx',
                type: 'post',
                data: { 'action': action, 'typeID': $("#ID").val(), 'name': $("#name").val(), hasImage: hasImg, indexShow: indexShow, sort: sort },
                success: function (data) {
                    if (data == 1) {
                        $.messager.alert('消息', '保存成功！');
                        onSearch();
                        onClose();
                    } else {
                        $.messager.alert('消息', data);
                    }
                }
            });

        }
    </script>
</body>
</html>
