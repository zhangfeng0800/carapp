<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FileUpLoad.aspx.cs" Inherits="WebApp.FileUpLoad" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        body
        {
            padding: 0px;
            margin: 0px;
            font-size: 12px;
        }
        *
        {
            margin: 0;
            padding: 0;
        }
        a
        {
            text-decoration: none;
        }
        .btn_addPic
        {
            display: block;
            position: relative;
            width: 140px;
            height: 22px;
            overflow: hidden;
            border: 1px solid #EBEBEB;
            background: none repeat scroll 0 0 #F3F3F3;
            color: #999999;
            cursor: pointer;
            text-align: center;
            float: left;
        }
        .btn_addPic span
        {
            display: block;
            line-height: 22px;
        }
        .btn_addPic em
        {
            background: url(../images/add.png) 0 0;
            display: inline-block;
            width: 18px;
            height: 18px;
            overflow: hidden;
            margin: 0px 5px;
            line-height: 20em;
            vertical-align: middle;
        }
        .btn_addPic:hover em
        {
            background-position: -19px 0;
        }
        .filePrew
        {
            display: block;
            position: absolute;
            top: 0;
            left: 0;
            width: 140px;
            height: 22px;
            font-size: 100px; /* 增大不同浏览器的可点击区域 */
            opacity: 0; /* 实现的关键点 */
            filter: alpha(opacity=0); /* 兼容IE */
        }
    </style>
    <script type="text/javascript">
        function showmessage(id, path) {
            parent.document.getElementById(id).value = path;
            alert('上传成功');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <a href="javascript:void(0);" class="btn_addPic"><span><em>+</em>上传图片</span><asp:FileUpload
        ID="FileUpload" class="filePrew" onchange="javascript:__doPostBack('btnFileUpLoad','')"
        runat="server" /></a>
    <asp:LinkButton ID="btnFileUpLoad" runat="server" Style="display: none;" OnClick="btnFileUpLoad_Click">上传</asp:LinkButton>
        <div><%=Message %></div>
    </form>
</body>
</html>
