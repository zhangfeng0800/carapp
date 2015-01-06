<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CarAppAdminWebUI.Default" %>

<%@ Import Namespace="System.Runtime.Remoting.Services" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>管理系统V1.0</title>
    <style>
        body
        {
            min-width: 800px;
        }
    </style>
    <link type="text/css" href="/Static/Styles/style.css" rel="stylesheet" />
    <script type="text/javascript" src="/Static/Scripts/jquery.min.js"></script>
    <script src="/Static/center/Scripts/jquery.signalR-1.1.4.min.js" type="text/javascript"></script>
    <script src="/Signalr/Hubs"></script>
    <script src="/Static/center/Scripts/artDialog4.1.7/jquery.artDialog.source.js?skin=default"
        type="text/javascript"></script>
    <!--   EasyUI Start-->
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Static/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="/Static/easyui/locale/easyui-lang-zh_CN.js"></script>
    <% if (Model.AdminGroupsId == 1)
       {
    %>
    <script type="text/javascript" src="/Static/scripts/nav.js"></script>
    <%
       }
       else if (Model.AdminGroupsId == 2)
       {
    %>
    <script type="text/javascript" src="/Static/scripts/csnav.js"></script>
    <%
       }
       else
       { %>
    <script type="text/javascript" src="/Static/scripts/wxnav.js"></script>
    <%} %>
    <script src="/Static/Scripts/outlook2.js" type="text/javascript"></script>
    <script src="/Static/scripts/admin.js" type="text/javascript"></script>
    <script type="text/javascript" src="/Static/jPlayer/jquery.jplayer.min.js"></script>
    <style type="text/css">
        .navlist
        {
            padding-left: 10px;
        }
        .tabs-icon
        {
            left: 0px !important;
        }
        .icon-nav
        {
            background: url("Static/images/icon.gif") no-repeat scroll 8px -824px transparent;
            display: -moz-inline-box;
            display: inline-block;
            width: 30px;
            height: 21px;
        }
    </style>
    <% if (Model.AdminGroupsId == 2)
       {
    %>
    <script type="text/javascript">

        $(function () {
            $("#jplay").jPlayer({
                ready: function (event) { $(this).jPlayer("setMedia", { mp3: "/Static/mp3/message.mp3" }); },
                swfPath: "/Static/jPlayer",
                supplied: "mp3"
            });
            setInterval(GetMessage, 30000);
            setInterval(postData, 5000);
            //            setInterval(showSendCarMessage, 60000);
            setInterval(showAlarm, 30000);
        });
        function postData() {
            $.ajax({
                url: "/ajax/updateExtenTime.ashx",
                data: { exten: "<%=Exten %>" },
                type: "post",
                success: function (data) {
                    if (data.resultcode == 0) {
                        $("#textContainer").text(data.text);
                    } else {

                    }
                }
            });
        }
        function showAlarm() {
            $.ajax({
                url: "/order/orderhandler.ashx?action=orderalarm",
                type: "get",
                success: function (data) {
                    var html = "<h4 style=\"margin:0px;\">尚未派车订单";
                    html += data.sendcarnum;
                    html += "个</h4>";

                    html += "<UL class='someUL'>";
                    if (data.resultcode == 0) {

                    } else {
                        for (var i = 0; i < data.sendcardata.length; i++) {
                            html += "<LI><a href='javascript:onShowOrder(\"" + data.sendcardata[i].orderId + "\");'>" + data.sendcardata[i].orderId + "</a></LI>";
                        }
                        if (data.sendcardata.length % 2 > 0) {
                            html += "<li></li>";
                        }
                        html += "<li><h4 style=\"margin:0px;\">尚未就位订单";
                        html += data.ontinplacenum;
                        html += "个</h4><li> ";
                        for (var i = 0; i < data.notplacedata.length; i++) {
                            html += "<LI><a href='javascript:onShowOrder(\"" + data.notplacedata[i].orderId + "\");'>" + data.notplacedata[i].orderId + "</a></LI>";
                        }
                        html += "</UL>";
                        var datacount = data.sendcarnum + data.ontinplacenum;
                        $.messager.show({
                            title: '预约订单提示信息',
                            msg: html,
                            showType: 'show',
                            timeout: 25000,
                            width: 400,
                            height: (datacount / 2) * 40,
                            draggable: false,
                            style: {
                                left: 460,
                                right: '',
                                top: '',
                                bottom: -document.body.scrollTop - document.documentElement.scrollTop
                            }
                        });
                    }
                }
            });
        }
    </script>
    <% } %>
    <script type="text/javascript">
        //修改密码开始
        function bindWin() {
            $("[id$=window]").window({
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closed: true
            });
        }
        $(function () {
            bindWin();
        });
        function updatepwd() {
            $('#updatepwdwindow').window('open');

        }
        function subupdatepwd() {
            if ($("#newpwd").val() == "") {
                $.messager.show({
                    title: '错误提示',
                    msg: '<span style="color:red;">*新密码不能为空</span>',
                    showType: 'fade',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                return false;
            }
            else if ($("#newpwd").val() != $("#newpwdc").val()) {
                $.messager.show({
                    title: '错误提示',
                    msg: '<span style="color:red;">*两次输入的密码不一致</span>',
                    showType: 'fade',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                return false;
            }
            $.post("/Manager/ManagerHandler.ashx", { "action": "editpwd", "oldpwd": $("#oldpwd").val(), "newpwd": $("#newpwd").val() }, function (data) {
                if (data.IsSuccess) {
                    alert("修改成功!");
                    $('#updatepwdwindow').window('close');
                }
                else {
                    $.messager.show({ title: '错误提示', msg: '<span style="color:red;">*' + data.Message + '</span>', showType: 'fade', style: { right: '', top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                    });
                }
            }, "json");
        }
        //修改密码结束

        function checkInOut(groupid, exten, action) {
            $.ajax({
                url: "/member/phonecenterhandler.ashx",
                type: "post",
                data: { groupid: groupid, exten: exten, action: action },
                success: function (data) {
                    if (data.resultcode == 1) {
                        $("#textContainer").text(data.text);
                        alert("操作成功");
                    } else {
                        alert("操作失败");
                    }
                }
            });
        }
        function refresh() {
            var myiframe = document.getElementById("ifrname");
            myiframe.src = myiframe.src;
        }

        artDialog.notice = function (options) {
            var opt = options || {},
                api, aConfig, hide, wrap, top,
                duration = 800;

            var config = {
                id: 'Notice',
                left: '30%',
                fixed: true,
                drag: true,
                resize: false,
                follow: null,
                lock: false,
                init: function (here) {
                    api = this;
                    aConfig = api.config;
                    wrap = api.DOM.wrap;
                    top = parseInt(wrap[0].style.top);
                    hide = top + wrap[0].offsetHeight;

                    wrap.css('top', hide + 'px')
                        .animate({ top: top + 'px' }, duration, function () {
                            opt.init && opt.init.call(api, here);
                        });
                },
                close: function (here) {
                    wrap.animate({ top: hide + 'px' }, duration, function () {
                        opt.close && opt.close.call(this, here);
                        aConfig.close = $.noop;
                        api.close();
                    });

                    return false;
                }
            };

            for (var i in opt) {
                if (config[i] === undefined) config[i] = opt[i];
            };

            return artDialog(config);
        };

        var pushHub = $.connection.pushHub;
        pushHub.client.notice = function (message) {
            var msg = message;
            var id = msg.substring(msg.indexOf("caller") + 6, msg.lastIndexOf("caller"));
            var telphone = msg.substring(msg.indexOf("telphone") + 9, msg.indexOf('&'));

            if (id == '<%=Exten %>') {
                $("#txt_telphone").val(telphone.split(',')[0]);
                art.dialog.notice({
                    title: '当前坐席号<%=Exten %>',
                    width: 1000, // 必须指定一个像素宽度值或者百分比，否则浏览器窗口改变可能导致artDialog收缩
                    content: message,
                    height: 700,
                    time: 0
                });

            } else {
                return;
            }
        }
        $.connection.hub.start();

        function callback(telphone) {
            var regex = /^1\d{10,11}$/gi;
            if (!regex.test(telphone)) {
                alert("手机号格式错误");
                return;
            }
            $.ajax({
                url: "/ajax/callback.ashx?callee=" + telphone + "&caller=<%=Exten %>&timestamp=" + Date.parse(new Date()),
                success: function (data) {
                    if (data.resultcode == 0) {
                        alert("回呼失败");
                    } else {
                        alert("操作成功");
                    }
                }
            });
        }
       
    </script>
    <script language="JavaScript">
<!--

        var CapsLockValue = 0;
        var check;
        function setVariables() {
            tablewidth = 630;  // logo width, in pixels
            tableheight = 20;  // logo height, in pixels
            if (navigator.appName == "Netscape") {
                horz = ".left";
                vert = ".top";
                docStyle = "document.";
                styleDoc = "";
                innerW = "window.innerWidth";
                innerH = "window.innerHeight";
                offsetX = "window.pageXOffset";
                offsetY = "window.pageYOffset";
            }
            else {
                horz = ".pixelLeft";
                vert = ".pixelTop";
                docStyle = "";
                styleDoc = ".style";
                innerW = "document.body.clientWidth";
                innerH = "document.body.clientHeight";
                offsetX = "document.body.scrollLeft";
                offsetY = "document.body.scrollTop";
            }
        }
        function checkLocation() {
            if (check) {
                objectXY = "softkeyboard";
                var availableX = eval(innerW);
                var availableY = eval(innerH);
                var currentX = eval(offsetX);
                var currentY = eval(offsetY);
                x = availableX - tablewidth + currentX;
                //y=availableY-tableheight+currentY;
                y = currentY;
                evalMove();
            }
            setTimeout("checkLocation()", 0);
        }
        function evalMove() {
            eval(docStyle + objectXY + styleDoc + vert + "=" + y);
        } //欢迎来到站长特效网，我们的网址是www.zzjs.net，很好记，zz站长，js就是js特效，本站收集大量高质量js代码，还有许多广告代码下载。
        self.onError = null;
        currentX = currentY = 0;
        whichIt = null;
        lastScrollX = 0; lastScrollY = 0;
        NS = (document.layers) ? 1 : 0;
        IE = (document.all) ? 1 : 0;
        function heartBeat() {
            if (IE) { diffY = document.body.scrollTop; diffX = document.body.scrollLeft; }
            if (NS) { diffY = self.pageYOffset; diffX = self.pageXOffset; }
            if (diffY != lastScrollY) {
                percent = .1 * (diffY - lastScrollY);
                if (percent > 0) percent = Math.ceil(percent);
                else percent = Math.floor(percent);
                if (IE) document.all.softkeyboard.style.pixelTop += percent;
                if (NS) document.softkeyboard.top += percent;
                lastScrollY = lastScrollY + percent;
            }
            if (diffX != lastScrollX) {
                percent = .1 * (diffX - lastScrollX);
                if (percent > 0) percent = Math.ceil(percent);
                else percent = Math.floor(percent);
                if (IE) document.all.softkeyboard.style.pixelLeft += percent;
                if (NS) document.softkeyboard.left += percent;
                lastScrollX = lastScrollX + percent;
            }
        }
        function checkFocus(x, y) {
            stalkerx = document.softkeyboard.pageX;
            stalkery = document.softkeyboard.pageY;
            stalkerwidth = document.softkeyboard.clip.width;
            stalkerheight = document.softkeyboard.clip.height;
            if ((x > stalkerx && x < (stalkerx + stalkerwidth)) && (y > stalkery && y < (stalkery + stalkerheight))) return true;
            else return false;
        }
        function grabIt(e) {
            check = false;
            if (IE) {
                whichIt = event.srcElement;
                while (whichIt.id.indexOf("softkeyboard") == -1) {
                    whichIt = whichIt.parentElement;
                    if (whichIt == null) { return true; }
                }
                whichIt.style.pixelLeft = whichIt.offsetLeft;
                whichIt.style.pixelTop = whichIt.offsetTop;
                currentX = (event.clientX + document.body.scrollLeft);
                currentY = (event.clientY + document.body.scrollTop);
            } else {
                window.captureEvents(Event.MOUSEMOVE);
                if (checkFocus(e.pageX, e.pageY)) {
                    whichIt = document.softkeyboard;
                    StalkerTouchedX = e.pageX - document.softkeyboard.pageX;
                    StalkerTouchedY = e.pageY - document.softkeyboard.pageY;
                }
            }
            return true;
        }
        function moveIt(e) {
            if (whichIt == null) { return false; }
            if (IE) {
                newX = (event.clientX + document.body.scrollLeft);
                newY = (event.clientY + document.body.scrollTop);
                distanceX = (newX - currentX); distanceY = (newY - currentY);
                currentX = newX; currentY = newY;
                whichIt.style.pixelLeft += distanceX;
                whichIt.style.pixelTop += distanceY;
                if (whichIt.style.pixelTop < document.body.scrollTop) whichIt.style.pixelTop = document.body.scrollTop;
                if (whichIt.style.pixelLeft < document.body.scrollLeft) whichIt.style.pixelLeft = document.body.scrollLeft;
                if (whichIt.style.pixelLeft > document.body.offsetWidth - document.body.scrollLeft - whichIt.style.pixelWidth - 20) whichIt.style.pixelLeft = document.body.offsetWidth - whichIt.style.pixelWidth - 20;
                if (whichIt.style.pixelTop > document.body.offsetHeight + document.body.scrollTop - whichIt.style.pixelHeight - 5) whichIt.style.pixelTop = document.body.offsetHeight + document.body.scrollTop - whichIt.style.pixelHeight - 5;
                event.returnValue = false;
            } else {
                whichIt.moveTo(e.pageX - StalkerTouchedX, e.pageY - StalkerTouchedY);
                if (whichIt.left < 0 + self.pageXOffset) whichIt.left = 0 + self.pageXOffset;
                if (whichIt.top < 0 + self.pageYOffset) whichIt.top = 0 + self.pageYOffset;
                if ((whichIt.left + whichIt.clip.width) >= (window.innerWidth + self.pageXOffset - 17)) whichIt.left = ((window.innerWidth + self.pageXOffset) - whichIt.clip.width) - 17;
                if ((whichIt.top + whichIt.clip.height) >= (window.innerHeight + self.pageYOffset - 17)) whichIt.top = ((window.innerHeight + self.pageYOffset) - whichIt.clip.height) - 17;
                return false;
            }
            return false;
        }
        function dropIt() {
            whichIt = null;
            if (NS) window.releaseEvents(Event.MOUSEMOVE);
            return true;
        }
        if (NS) {
            window.captureEvents(Event.MOUSEUP | Event.MOUSEDOWN);
            window.onmousedown = grabIt;
            window.onmousemove = moveIt;
            window.onmouseup = dropIt;
        }
        if (IE) {
            document.onmousedown = grabIt;
            document.onmousemove = moveIt;
            document.onmouseup = dropIt;
        }
        if (NS || IE) action = window.setInterval("heartBeat()", 1);
        document.write('    <DIV align=center id=\"softkeyboard\" name=\"softkeyboard\" style=\"position:relative; width:180px; z-index:180;display:none\">');
        document.write('  <table width=\"180\" border=\"0\" align=\"center\" cellpadding=\"3\" cellspacing=\"1\" bgcolor=\"#95b8e7\" style=\"position:absolute;left:309px;top:46px;\">');
        document.write('    <FORM name=Calc action=\"\" method=post autocomplete=\"off\">');
        document.write('      <INPUT type=hidden value=ok name=action2>');
        document.write('      <tr><td align=\"left\" bgcolor=\"#95b8e7\" align=\"center\">  ');
        document.write('          <input class=button type=button value=\"清空\" name=\"Submit222\" onclick=\"clearkeyboard()\"/> ');
        document.write('          <input class=button type=button value=\"完成\" name=\"Submit222\" onclick=\"closekeyboard()\"/> </td>');
        document.write('      </tr>');
        document.write('      <tr> ');
        document.write('        <td align=\"center\" bgcolor=\"#FFFFFF\" align=\"center\"> <table align=\"center\" width=\"98%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">');
        document.write('            <tr align=\"left\" valign=\"middle\"> ');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'1\');\" value=\" 1 \"></td>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'2\');\" value=\" 2 \"></td>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'3\');\" value=\" 3 \"></td>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'4\');\" value=\" 4 \"></td>');
        document.write('</tr>');
        document.write('<tr>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'5\');\" value=\" 5 \"></td>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'6\');\" value=\" 6 \"></td>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'7\');\" value=\" 7 \"></td>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'8\');\" value=\" 8 \"></td>');
        document.write('</tr>');
        document.write('<tr>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'9\');\" value=\" 9 \"></td>');
        document.write('              <td> ');
        document.write('                <input type=button onclick=\"addValue(\'0\');\" value=\" 0 \"></td>');

        document.write('              <td><input name=\"button10\" type=button value=\"X\" onclick=\"setpassvalue();\"> ');
        document.write('              </td>');

        document.write('              <td> </td>');
        document.write('            </tr>');

        document.write('          </table></td>');
        document.write('      </tr>');
        document.write('    </FORM>');
        document.write('  </table>');
        document.write('</DIV>');

        function addValue(newValue) {
            $("#txt_telphone").val($("#txt_telphone").val() + newValue.toString());
        }
        //实现BackSpace键的功能
        function setpassvalue() {
            var longnum = $("#txt_telphone").val().length;

            $("#txt_telphone").val($("#txt_telphone").val().substr(0, longnum - 1));
        }
        //输入完毕
        function OverInput(theForm) {
            eval("var theForm=" + theForm + ";");
            //m_pass.mempass.value=Calc.password.value;
            theForm.value = Calc.password.value;
            //alert(theForm.value);
            //theForm.value=m_pass.mempass.value;
            softkeyboard.style.display = "none";
            Calc.password.value = "";
        }
        //关闭软键盘
        function closekeyboard() {
            $("#softkeyboard").hide();

        }
        function clearkeyboard() {
            $("#txt_telphone").val("");
        }
        //显示软键盘
        function showkeyboard() {
            softkeyboard.style.display = "block";
        }
        //欢迎来到站长特效网，我们的网址是www.zzjs.net，很好记，zz站长，js就是js特效，本站收集大量高质量js代码，还有许多广告代码下载。
        //设置是否大写的值
        function setCapsLock() {
            if (CapsLockValue == 0) {
                CapsLockValue = 1
                Calc.showCapsLockValue.value = "当前是大写 ";
            }
            else {
                CapsLockValue = 0
                Calc.showCapsLockValue.value = "当前是小写 ";
            }
        }
        //-->
        var curEditName
        curEditName = "form1.Password";
    </script>
</head>
<body class="easyui-layout" style="overflow-y: hidden" scroll="no">
    <form id="form1" runat="server">
    <noscript>
        <div style="position: absolute; z-index: 100000; height: 2046px; top: 0px; left: 0px;
            width: 100%; background: white; text-align: center;">
            <img src="Static/images/noscript.gif" alt='抱歉，请开启脚本支持！' />
        </div>
    </noscript>
    <div region="north" split="true" border="false" style="overflow: hidden; height: 60px;
        background: #385893 0 0 no-repeat; line-height: 60px; color: #fff; font-family: Verdana, 微软雅黑,黑体">
        <span style="padding-left: 30px; font-size: 20px; margin-top: 20px;">管理系统V1.0</span>
        <span style="float: right; padding-right: 20px;" class="head">欢迎
            <%=User.Identity.Name %>
            [<a href="Logout.aspx" id="loginOut" style="color: White; text-decoration: underline;">安全退出</a>]
        </span><span style="float: right; margin-right: 20px;" class="head"><a href="http://www.iezu.cn"
            target="_blank" id="A1" style="color: White; text-decoration: underline;">预览网站</a>
        </span><span style="float: right; margin-right: 20px;" class="head"><a href="javascript:updatepwd()"
            id="A2" style="color: White; text-decoration: underline;">修改密码</a> </span>
        <div id="updatepwdwindow" title="修改密码" style="width: 300px; height: 150px;">
            <table class="adm_8" style="width: 100%;">
                <tr>
                    <td class="adm_45">
                        旧密码：
                    </td>
                    <td class="adm_45">
                        <input id="oldpwd" type="password" style="width: 100px;" />
                    </td>
                </tr>
                <tr>
                    <td class="adm_45">
                        新密码：
                    </td>
                    <td class="adm_45">
                        <input id="newpwd" type="password" style="width: 100px;" />
                    </td>
                </tr>
                <tr>
                    <td class="adm_45">
                        确认新密码：
                    </td>
                    <td class="adm_45">
                        <input id="newpwdc" type="password" style="width: 100px;" />
                    </td>
                </tr>
                <tr>
                    <td class="adm_45" colspan="2">
                        <center>
                            <a href="javascript:subupdatepwd()" class="easyui-linkbutton">确认</a></center>
                    </td>
                </tr>
            </table>
        </div>
        <%

            if (Model.AdminGroupsId == 2)
            {%>
        <span style="float: right; padding-right: 20px;" class="head" id="checkout">坐席号[<%=Exten %>]
            当前状态[<a id="textContainer" href="javascript:;" onclick="checkInOut(0,<%=Exten %>,'checkinout')"
                style="color: white;"><%=Status%></a>] </span><span style="margin-left: 100px;" class="head"
                    id="Span1">被叫号：
                    <input type="text" width="80" style="border: 0px; border-bottom: 1px solid #385893;"
                        id="txt_telphone" onclick="showkeyboard($('#txt_telphone').val())" />
                    <input type="button" value="拨号" onclick="callback($('#txt_telphone').val())" />
                    <%--<div align="center" style="background: red;position: relative; width: 300px; height: 300px; z-index: 180; display: block;" name="softkeyboard" id="softkeyboard">
                        <table width="180" border="0" bgcolor="#FF9900" align="center" cellspacing="1" cellpadding="3"
                            style="position: absolute; left: 0px; top:-20px;">
                            <form autocomplete="off" method="post" action="" name="Calc">
                            </form>
                            <input type="hidden" name="action2" value="ok">
                            <tbody>
                                <tr>
                                    <td bgcolor="#FF9900" align="left">
                                        <input type="text" name="password" value="" size="20" class="td1b">
                                        <input type="button" onclick="OverInput(curEditName);" name="Submit3" value="完成"
                                            class="button">
                                        <input type="button" onclick="closekeyboard(curEditName);" name="Submit222" value="关闭"
                                            class="button">
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#FFFFFF" align="center">
                                        <table width="98%" border="0" align="center" cellspacing="0" cellpadding="0">
                                            <tbody>
                                                <tr valign="middle" align="left">
                                                    <td>
                                                        <input type="button" value=" 1 " onclick="addValue('1');">
                                                    </td>
                                                    <td>
                                                        <input type="button" value=" 2 " onclick="addValue('2');">
                                                    </td>
                                                    <td>
                                                        <input type="button" value=" 3 " onclick="addValue('3');">
                                                    </td>
                                                    <td>
                                                        <input type="button" value=" 4 " onclick="addValue('4');">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input type="button" value=" 5 " onclick="addValue('5');">
                                                    </td>
                                                    <td>
                                                        <input type="button" value=" 6 " onclick="addValue('6');">
                                                    </td>
                                                    <td>
                                                        <input type="button" value=" 7 " onclick="addValue('7');">
                                                    </td>
                                                    <td>
                                                        <input type="button" value=" 8 " onclick="addValue('8');">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input type="button" value=" 9 " onclick="addValue('9');">
                                                    </td>
                                                    <td>
                                                        <input type="button" value=" 0 " onclick="addValue('0');">
                                                    </td>
                                                    <td>
                                                        <input type="button" onclick="setpassvalue();" value="X" name="button10">
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>--%>
                </span>
        <%}
        %>
    </div>
    <div region="south" split="true" style="height: 30px; background: #D2E0F2;">
        <div class="footer" id="footer">
            Copyright © 2014 河北方润汽车租赁有限公司版权所有</div>
    </div>
    <div region="west" split="true" title="导航菜单" style="width: 180px;" id="west">
        <div id="nav" class="easyui-accordion" fit="true" border="false">
            <!--  导航内容 -->
        </div>
    </div>
    <div id="mainPanle" region="center" style="background: #eee; overflow-y: hidden">
        <div id="tabs" class="easyui-tabs" fit="true" border="false">
            <div title="系统首页" style="overflow: hidden;" id="home">
                <iframe scrolling="auto" frameborder="0" style="width: 100%; height: 100%;" src="Main.aspx">
                </iframe>
            </div>
        </div>
    </div>
    <div id="mm" class="easyui-menu" style="width: 150px;">
        <div id="tabupdate">
            刷新</div>
        <div class="menu-sep">
        </div>
        <div id="close">
            关闭</div>
        <div id="closeall">
            全部关闭</div>
        <div id="closeother">
            除此之外全部关闭</div>
        <div class="menu-sep">
        </div>
        <div id="closeright">
            当前页右侧全部关闭</div>
        <div id="closeleft">
            当前页左侧全部关闭</div>
        <div class="menu-sep">
        </div>
        <div id="exit">
            退出</div>
    </div>
    <div id="n-masklayer" class="window-mask" style="display: none">
    </div>
    <div id="w-masklayer" class="window-mask" style="display: none">
    </div>
    <div id="s-masklayer" class="window-mask" style="display: none">
    </div>
    <div id="jplay">
    </div>
    </form>
</body>
</html>
<script type="text/javascript" src="/Static/scripts/Common.yui.js"></script>
<script type="text/javascript">
    //    function CloseAndRefresh(newTitle, newUrl) {
    //        var oldTab = $("li.tabs-selected span.tabs-title").text();
    //        if ($('#tabs').tabs('exists', newTitle)) {
    //            $('#tabs').tabs('select', newTitle);
    //            var currTab = $('#tabs').tabs('getTab', newTitle);
    //            var iframe = $(currTab.panel('options').content);
    //            var src = iframe.attr('src');
    //            $('#tabs').tabs('update', { tab: currTab, options: { content: createFrame(src)} });
    //        }
    //        else {
    //            addTab(newTitle, newUrl, null);
    //        }
    //        setTimeout('$("#tabs").tabs("close", "' + oldTab + '")', 10);
    //    }
    function changeTab() {

    }
    //    function CloaseCurrTab() {
    //        var tabTitle = $("li.tabs-selected span.tabs-title").text();
    //        setTimeout('$("#tabs").tabs("close", "' + tabTitle + '")', 10);
    //    }
    //    function OpenMaskLayer() {
    //        var nPannel = $(".panel.layout-panel.layout-panel-north.layout-split-north");
    //        var wPannel = $(".panel.layout-panel.layout-panel-west.layout-split-west");
    //        var sPannel = $(".panel.layout-panel.layout-panel-south.layout-split-south");
    //        $("#n-masklayer").css("width", nPannel.css("width"));
    //        $("#n-masklayer").css("height", nPannel.height() + $(".tabs-header.tabs-header-noborder").height() + 10);
    //        $("#n-masklayer").css("left", nPannel.css("left"));
    //        $("#n-masklayer").css("top", nPannel.css("top"));
    //        $("#n-masklayer").css("z-index", 8999);
    //        $("#n-masklayer").css("display", "block");

    //        $("#w-masklayer").css("width", wPannel.css("width"));
    //        $("#w-masklayer").css("height", wPannel.css("height"));
    //        $("#w-masklayer").css("left", wPannel.css("left"));
    //        $("#w-masklayer").css("top", wPannel.css("top"));
    //        $("#w-masklayer").css("z-index", 8999);
    //        $("#w-masklayer").css("display", "block");

    //        $("#s-masklayer").css("width", sPannel.css("width"));
    //        $("#s-masklayer").css("height", sPannel.css("height"));
    //        $("#s-masklayer").css("left", sPannel.css("left"));
    //        $("#s-masklayer").css("top", sPannel.css("top"));
    //        $("#s-masklayer").css("z-index", sPannel.css("8999"));
    //        $("#s-masklayer").css("display", "block");
    //    }
    //    function CloseMaskLayer() {
    //        $("#n-masklayer").css("display", "none");
    //        $("#w-masklayer").css("display", "none");
    //        $("#s-masklayer").css("display", "none");
    //    }
    $(function () {
        //        $("#tabs").tabs({
        //            onSelect: function (title, index) {
        //                if (title == "订单信息管理") {
        //                    var tab = $('#tabs').tabs('getSelected');
        //                    if (tab && tab.find('iframe').length > 0) {
        //                        var refreshifram = tab.find('iframe')[0];
        //                        var refreshurl = refreshifram.src;
        //                        refreshifram.contentWindow.location.href = refreshurl;
        //                    }
        //                }
        //            }
        //        }
        //        );
    });
    function GetMessage() {
        $.get("/Ajax/MessageHandler.ashx?action=ordersmessage", null, function (result) {
            if (result.IsSuccess) {
                //addTab("订单信息管理", "/Order/OrderList.aspx", "icon-nav");
                $("#jplay").jPlayer("play");
                $.messager.show({
                    title: '提示信息',
                    msg: '<div style=\"text-align:center;vertical-align:middle\">新订单通知</div>',
                    showType: 'show',
                    timeout: 30000,
                    width: 300,
                    height: 150
                });
            }
        }, "json");
    }
    function onShowOrder(id) {
        top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
    }
    function showSendCarMessage() {
        $.get("/order/orderhandler.ashx?action=SendCarList", null, function (result) {
            var html = "<UL class='someUL'>";
            var datacount = 0;
            if (result.resultcode == 1) {
                $.each(result.data, function (index, val) {
                    html += "<LI><a href='javascript:onShowOrder(\"" + val.OrderId + "\");'>" + val.OrderId + "</a></LI>";
                });
                datacount = result.data.length;
                html += "</UL>";
                $.messager.show({
                    title: '派车未接单提示',
                    msg: html,
                    showType: 'show',
                    timeout: 58000,
                    width: 400,
                    height: (datacount / 2 + 1) * 28,
                    draggable: false,
                    style: {
                        left: 160,
                        right: '',
                        top: '',
                        bottom: -document.body.scrollTop - document.documentElement.scrollTop
                    }
                });
            }


        }, "json");
    }

  
</script>
<style>
    .someUL
    {
        margin: 0;
        padding: 0;
    }
    .someUL li
    {
        position: relative;
        float: left;
        width: 150px;
        text-overflow: ellipsis;
        white-space: nowrap;
        height: 22px;
        line-height: 22px;
        list-style: none;
        margin-right: 4px;
        overflow: hidden;
    }
</style>
