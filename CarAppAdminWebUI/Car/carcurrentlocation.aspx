<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="carcurrentlocation.aspx.cs"
    Inherits="CarAppAdminWebUI.Car.carcurrentlocation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        html
        {
            height: 100%;
        }
        body
        {
            height: 100%;
            margin: 0px;
            padding: 0px;
        }
        #controller
        {
            width: 100%;
            border-bottom: 3px outset;
            height: 30px;
            filter: alpha(Opacity=100);
            -moz-opacity: 1;
            opacity: 1;
            z-index: 10000;
            background-color: lightblue;
        }
        #allmap
        {
            height: 100%;
            margin-top: 100px;
        } 
    </style>
</head>
<body>
    <div id="allmap">
    </div>
    <script type="text/javascript">

        $(function () {
            CarLocationInfo();
        });
        function CarLocationInfo() {
            $.get("/Car/CarLocationHandler.ashx", { "action": "currentlocation", "r": Math.random(), vid: "<%=vid %>" }, function (data) {
                var html = "<table>";
                if (data.resultcode == 0) {
                    html += "<tr><td style=\"width:100px;\"><b>当前位置</b></td><td style=\"width:400px;\">" + data.data.position + "</td></tr>";
                    html += "<tr><td style=\"width:100px;\"><b>当前经度</b></td><td style=\"width:400px;\">" + data.data.lng + "</td></tr>";
                    html += "<tr><td><b>当前纬度</b></td><td>" + data.data.lat + "</td></tr>";
                    html += "<tr><td><b>GPS时间</b></td><td>" + data.data.gpstime + "</td></tr>";
                } else {
                    html = "尚未获取gps信息";
                }
                html += "</table>";
                $("#allmap").html(html);
            }, "json");
        } 
    </script>
</body>
</html>
