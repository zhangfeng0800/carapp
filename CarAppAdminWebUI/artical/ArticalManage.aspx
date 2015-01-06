<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ArticalManage.aspx.cs"
    Inherits="CarAppAdminWebUI.artical.ArticalManage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div>
        <form id="form1">
        <table>
            <tr>
                <td class="koobooTableFont">
                    文章所属:
                </td>
                <td>
                    <select name="articalType" id="articalType">
                        <%foreach (var item in articalTypes)
                          {
                              Response.Write("<option value='" + item.ID + "'>" + item.Name + "</option>");
                          } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="koobooTableFont">
                    文章标题:
                </td>
                <td>
                    <input type="text" name="atitle" id="atitle" value="<%=content.title %>" class="koobooInputText"
                        style="width: 600px;" />
                </td>
            </tr>
            <tr>
                <td class="koobooTableFont">
                    文章内容:
                </td>
                <td>
                    <%--<script id="editor" type="text/plain" style="width: 800px; height: 400px;"><%=content.contents %></script>
                    <script type="text/javascript">
                        UE.getEditor("editor");
                    </script>--%>
                    <input type="hidden" name="content" id="content" />
                    <div id="editor" style="width: 800px; height: 400px;">
                    </div>
                    <script type="text/javascript">
                        var editor = new baidu.editor.ui.Editor({ initialContent: '<%=content.contents %>' });
                        editor.render("editor");  
                    </script>
                </td>
            </tr>
            <tr>
                <td class="koobooTableFont">
                    内容摘要:
                </td>
                <td>
                    <textarea rows="5" cols="125" name="mainInfo" id="mainInfo"><%=content.mainInfo %></textarea>
                </td>
            </tr>
            <tr id="image" style="">
                <td>
                    主图上传:
                </td>
                <td>
                    <input id="addimgUrl" class="adm_21 w420" readonly="readonly" name="imgUrl" type="text"
                        value="<%=content.imagePath %>" />
                    <iframe src="../FileUpLoad.aspx?id=addimgUrl&folder=artical" frameborder="0" style="border: 0px;
                        height: 43px; width: 200px;"></iframe>
                    排序编号:
                    <input type="text" value="<%=content.orderNumber %>" name="orderNumber" id="orderNumber"
                        style="width: 100px;" />(按大小降序排列) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 是否发布:
                    <input type="checkbox" id="checkPublish" <%if(content.isPublish == 1){ %> checked="checked"
                        <%} %> />
                </td>
            </tr>
            <%--  <tr class="koobooTableFont">
                <td>
                   排序编号:
                </td>
                <td>
                    <input type="text" value="<%=content.orderNumber %>" name="orderNumber" id="orderNumber"/>
                </td>
            </tr>
            <tr class="koobooTableFont">
                <td>
                   
                </td>
                <td>
                    <input type="checkbox" id="checkPublish"  <%if(content.isPublish == 1){ %> checked="checked"<%} %> />
                </td>
            </tr>--%>
            <tr>
                <td>
                </td>
                <td>
                    <a class="easyui-linkbutton" href="javascript:sendData('<%=Request.QueryString["method"] %>')">
                        保存</a>
                         <a class="easyui-linkbutton" href="javascript:onClose()">
                        取消</a>
                </td>
            </tr>
        </table>
        </form>
    </div>
    <script type="text/javascript">
        function sendData(method) {
            var action = "AddContent";
            if (method == "add") {
                action = "AddContent";
            }
            else if (method == "update") {
                action = "upDateContent";
            }
            var articalType = $("#articalType").val();
            var title = $("#atitle").val();
            var content = UE.getEditor('editor').getContent();
            var mainInfo = $("#mainInfo").val();
            var orderNumber = $("#orderNumber").val();
            var isPublish = 0;
            if ($("#checkPublish").prop("checked")) {
                isPublish = 1;
            }
            var imagePath = $("#addimgUrl").val();


            $.post("../Ajax/ArticalContentController.ashx", { 'action': action, 'ID': '<%=Request.QueryString["contentid"] %>', 'articalType': articalType, 'content': content, 'ispublish': isPublish, 'atitle': title, 'mainInfo': mainInfo, 'orderNumber': orderNumber, 'imagePath': imagePath, 'timestamp': '<%=DateTime.Now.Millisecond %>' }, function (data) {
                if (method == "add") {
                    if (data == 1) {
                        $.messager.alert('消息', '操作成功！', 'info', function () {
                            onClose();
                            onSearch();
                        });
                    } else {
                        $.messager.alert('消息', "添加失败", 'error');
                    }
                }
                else if (method == "update") {
                    if (data == 1) {
                        $.messager.alert('消息', '操作成功！', 'info', function () {
                            onClose();
                            onSearch();
                        });
                    } else {
                        $.messager.alert('消息', "修改失败", 'error');
                    }
                }
            });

        }
    </script>
</body>
</html>
