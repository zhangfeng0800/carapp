<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserMessageDetail.aspx.cs" Inherits="CarAppAdminWebUI.Member.UserMessageDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
       <script type="text/javascript" src="../Static/scripts/jquery-1.4.1.js"></script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
    <ul class="mychat">
    <% for (int i = 0; i < list.Count; i++) {
           if (list[i].type == 1)
           {
           %>
           <li class="leave"><span style=" font-weight:bold;">用户留言：</span><%=list[i].content%>       <span class="date"><%=list[i].leavetime%></span></li>
            <%}
           else
           { 
           %>
           <li class="reply"><span style=" font-weight:bold;">回复内容：</span><%=list[i].content%>       <span class="date"><%=list[i].leavetime%></span></li>
           <%
           }  
       }  
     %>


               <li id="addMess"><input type="text" id="messID" name="messID" value="<%=list[list.Count - 1].id %>"  style=" display:none;" />
               回复内容：<br />
               <textarea id="content" name="content" class="adm_21" rows="" cols="" style="width:60%; height:60px;"></textarea>
             
               <br />
                <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a>  <a class="easyui-linkbutton" href="javascript:onClose()">返回</a>

               </li>

       </ul>

     
    </div>
    </form>
    <script type="text/javascript">
        function onAddSubmit() {
            var content = $("#content").val();
            if(content.trim() == ""){
                $.messager.alert('消息','回复内容不能为空');
                return;
                }
            $.ajax({
                url: 'UserMessageHandler.ashx',
                data: { action: "addmess", messID: $("#messID").val(), content: content },
                type: 'post',
                dataType: 'json',
                success: function(data) {
                    if (data != null) {
                        $.messager.alert('消息', '回复成功！');
                        onSearch();
                        $("#content").val("");
                        $("#messID").val(data.id);
                        $("#addMess").prev().append("<li>回复内容：" + content + "<span class='date'>" + data.leavetime + "</date></li>")
                    }
                },
            });
        }
    </script>
</body>
</html>
