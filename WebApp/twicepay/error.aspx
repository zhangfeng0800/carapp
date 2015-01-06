<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="error.aspx.cs" Inherits="WebApp.error" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no"
        name="viewport" id="viewport" />
    <meta name="format-detection" content="telephone=no" />
    <title>页面错误</title>
    <script src="/DirverMoble/js/jquery-1.6.4.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="/DirverMoble/css/css.css"/>
    <script type="text/javascript">
        function replace(url) {
            window.location.replace(url);
        }
        $(function () {
            $("body").dblclick(function () {
                $("#inerror").show();
            });
        });
    </script>
</head>
<body>
    <div class="menu">
        <%--<a href="javascript:replace('myorder.aspx')">&lt;返回</a>--%>
        <h3 class="til">
            订单页面错误</h3>
    </div>
    <div class="content">
        <h3 class="til">
            页面错误</h3>
        <ul>
            <li>
                抱歉，没有此订单！如有疑问，请联系客服</li>
        </ul>
        <div style="height:60px">
        
      <%--  <a href="javascript:replace('myorder.aspx')" class="btn" id="inerror" style="background-color: #b00606;width:50%;float:left;display:none">
            我遇到了紧急情况</a>--%>
            </div>
     <%--   <a href="javascript:replace('myorder.aspx')" class="btn" id="setOut">确认</a>--%>
     <a href="tel:031166009696" class="btn" id="call">给客服打电话</a>
    </div>
</body>
</html>
