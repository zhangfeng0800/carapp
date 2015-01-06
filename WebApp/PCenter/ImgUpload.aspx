<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImgUpload.aspx.cs" Inherits="WebApp.PCenter.ImgUpload" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title></title>

        <script type="text/javascript">
            function ImgUpload() {
                document.getElementById("FormUpload").submit();
            }
            function SetParentImgUrl(Url) {
                window.parent.SetImgUrl(Url);//这里参数不要变动，否则父页面判断会错误
            }
        </script>
    </head>
    <body>
        <input type="button" id="Button_ParentSet" onclick="ParentSet()" />
        <form runat="server" action="ImgUpload.aspx" method="post" enctype="multipart/form-data" id="FormUpload">
            <input type="hidden" value="ImgUpload" name="Hidden_Upload" />
            <input type="file" name="File_Img" onchange="ImgUpload()" onpropertychange=onchange />
        </form>
    </body>
</html>
