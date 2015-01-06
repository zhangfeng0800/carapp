//页面框架设置

function HeightSet(ControlID, SubCount)//设置最小高度，IE6↑ 重要函数(勿删)
{
    var ClientHeight = $(window).height(); // document.documentElement.clientHeight;
    $("#" + ControlID).css("height", (ClientHeight - SubCount) + "px");
}

function Multiple_HeightSet(ParameterStr)//批量设置最小高度
{
    var ParameterArray = ParameterStr.toString().split(';');
    var ParamaterControl;
    for (var i = 0; i < ParameterArray.length; i++) {
        ParamaterControl = ParameterArray[i].split(',');
        HeightSet(ParamaterControl[0], parseInt(ParamaterControl[1]));
    }
}

function SetEqualHeight(Control1ID, Control2ID)//设置相同高度
{
    if (isIE6()) {
        if ($("#" + Control1ID).height() < $("#" + Control2ID).height())
            $("#" + Control1ID).css("height", $("#" + Control2ID).height() + "px");
        else
            $("#" + Control2ID).css("height", $("#" + Control1ID).height() + "px");
    }
    else {
        if ($("#" + Control1ID).height() < $("#" + Control2ID).height())
            $("#" + Control1ID).css("min-height", $("#" + Control2ID).height() + "px");
        else
            $("#" + Control2ID).css("min-height", $("#" + Control1ID).height() + "px");
    }
}

function SetRowHeightCookie()//设置页面高度cookie
{
    CookieAdd('RowCount', parseInt(($("#Div_Right").height() - 120) / 30), '', '');
}

function SetNowLabel()//设置当前功能标签
{
    var NowLabel = 0;
    if (CookieGet('NowLabel') != "")
        NowLabel = parseInt(CookieGet('NowLabel'));
    else
        CookieAdd('NowLabel', NowLabel, '', '')
    CTC('Li_Selected', 'Li_NoSelected', NowLabel, 2, 'Li_LeftCol');
    CTC('Div_Show', 'Div_Hidden', NowLabel, 2, 'ctl00_Div_LeftCol');
}

//样式控制

function TagVisible(LabelID)//打开标签的显示
{
    $("#" + LabelID).css("display", "block");
}

function TagHidden(LabelID)//关闭标签的显示
{
    $("#" + LabelID).css("display", "none");
}

function SPICC(ControlID)//SetPositionInClintCenter//设置居中
{
    $("#" + ControlID).css("top", (($(window).height() - $("#" + ControlID).height()) / 2 + "px"));
    $("#" + ControlID).css("left", (($(window).width() - $("#" + ControlID).width()) / 2 + "px"));
}

//页面参数

function GetQueryString(sProp)//获取URL参数
{
    var re = new RegExp("[&,?]" + sProp + "=([^\\&]*)", "i");
    var a = re.exec(document.location.search);
    if (a == null)
        return "0";
    return a[1];
}

function QSR(Sort, NewValue)//QueryStringReplace页面参数替换
{
    var QueryStr = document.location.search;
    var NewQueryStr = "";
    if (QueryStr.indexOf(Sort + "=") != -1) {
        var StrStart = QueryStr.indexOf(Sort + "=") + Sort.length + 1;
        var SortLength = QueryStr.substring(StrStart).indexOf('&') == -1 ? QueryStr.substring(StrStart).length : QueryStr.substring(StrStart).indexOf('&');
        NewQueryStr = QueryStr.substring(0, StrStart) + NewValue + QueryStr.substring(StrStart + SortLength);
    }
    else {
        if (QueryStr.indexOf("?") != -1)
            NewQueryStr = QueryStr + "&" + Sort + "=" + NewValue;
        else
            NewQueryStr = QueryStr + "?" + Sort + "=" + NewValue;
    }
    return NewQueryStr;
}

function QSRBU(Sort, NewValue, URL)//QueryStringReplaceByURL页面参数替换
{
    var QueryStr = URL;
    var NewQueryStr = "";
    if (QueryStr.indexOf(Sort + "=") != -1) {
        var StrStart = QueryStr.indexOf(Sort + "=") + Sort.length + 1;
        var SortLength = QueryStr.substring(StrStart).indexOf('&') == -1 ? QueryStr.substring(StrStart).length : QueryStr.substring(StrStart).indexOf('&');
        NewQueryStr = QueryStr.substring(0, StrStart) + NewValue + QueryStr.substring(StrStart + SortLength);
    }
    else {
        if (QueryStr.indexOf("?") != -1)
            NewQueryStr = QueryStr + "&" + Sort + "=" + NewValue;
        else
            NewQueryStr = QueryStr + "?" + Sort + "=" + NewValue;
    }
    return NewQueryStr;
}

//控件控制start//Radio和Checkbox都是用name做参数，其他的控件用ID。

function SetValue(ControlID, Value)//给控件设置值
{
    $("#" + ControlID).val(decodeURIComponent(Value));
}

///------------------------------Select

function SetSelectValue(ControlID, SelectValue)//select选中项设置(测试通过)
{
    $("#" + ControlID).val(SelectValue);
}

function GetSelectValue(ControlID)//select获取选中项的值(测试通过)
{
    return ($("#" + ControlID).val());
}

///------------------------------Radio

function SetRadioValue(ControlName, Value)//radio选中项设置
{
    $("[name=\"" + ControlName + "\"][value=\"" + Value + "\"]").attr("checked", "checked");
}

function GetRadioValue(ControlName)//radio获取选中项的值(测试通过)
{
    return ($("[name=\"" + ControlName + "\"]:checked").val());
}

///------------------------------Checkbox

function SetCheckboxValue(ControlName, ItemsStr)//checkebox选中项设置
{
    var CheckItemArray = ItemsStr.split(',');
    for (var i = 0, max = CheckItemArray.length; i < max; i++) {
        $("[name=\"" + ControlName + "\"][value=\"" + CheckItemArray[i] + "\"]").attr("checked", "checked");
    }
}

function SetChckboxByBinary(CheckboxName, CheckValue) {
    $("[name='" + CheckboxName + "']").each(function () {
        if (($(this).val() & CheckValue) != 0)
            $(this).attr("checked", "checked");
    });
}

function SetCheckboxAllItem(ControlName)//checkebox选中项设置
{
    $("[name=\"" + ControlName + "\"]").attr("checked", "checked");
}

function GetCheckboxValue(ControlName)//checkebox获取选中项的值(测试通过)
{
    var CheckboxValue = "";
    $("[name=" + ControlName + "]:checked").each(function () {
        CheckboxValue += "," + $(this).val();
    });
    if (CheckboxValue.length > 1)
        CheckboxValue = CheckboxValue.substring(1);
    return (CheckboxValue);
}

function CheckboxAllSelected(ControlName)//checkebox选中所有复选框
{
    $("[name=\"" + ControlName + "\"]").attr("checked", 'checked');
}

function CheckboxUnSelected(ControlName)//checkebox反选所有复选框
{
    $("[name=" + ControlName + "]").each(function () {
        if ($(this).attr("checked"))
            $(this).removeAttr("checked");
        else
            $(this).attr("checked", 'checked');
    });
}

//控件控制end

function RefreshImg(TagID)//刷新图片
{
    var DateStr = new Date;
    $(TagID).attr("src", QSRBU('r', DateStr.getMilliseconds(), $(TagID).attr("src")));
}

String.prototype.Trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

//分页设置

function PageSet(ArtCount, MaxCount) {
    var PreviousPage = parseInt(GetQueryString("Previous")); //之前文章数
    if (isNaN(PreviousPage))
        PreviousPage = 0;
    document.write("<p class=\"P_Page\">");
    document.write("<a id=\"PreviousPage\" " + PageLinkSet(PreviousPage - ArtCount, PreviousPage, MaxCount) + ">上一页</a>");
    for (var i = ((PreviousPage - ArtCount * 3) < 0 ? 0 : (PreviousPage - ArtCount * 3)); i < MaxCount && i < (PreviousPage + ArtCount * 4); i = i + ArtCount)
        document.write("<a " + PageLinkSet(i, PreviousPage, MaxCount) + ">" + parseInt(i / ArtCount + 1) + "</a>");
    document.write("<a id=\"NextPage\" " + PageLinkSet(PreviousPage + ArtCount, PreviousPage, MaxCount) + ">下一页</a>");
    document.write("</p>");
}

function PageLinkSet(SetLink, PreviousPage, MaxCount) {
    if (SetLink == PreviousPage || SetLink < 0 || SetLink >= MaxCount)
        return "class=\"A_Selected\"";
    else
        return "href=\"" + QSR("Previous", SetLink.toString()) + "\"";
}

//获取日期

function getDate() {
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (month.toString().length == 1) {  //或者用if (eval(month) <10) {month="0"+month}
        month = '0' + month;
    }
    if (day.toString().length == 1) {
        day = '0' + day;
    }
    return date.getFullYear() + '年' + month + '月' + day + '日' + '　' + '星期' + '日一二三四五六'.charAt(date.getDay());
}

function Time() {
    $("#Span_Time").text(getDate());
    setInterval("$(\"#Span_Time\").innerHTML=getDate();", 1000);
}

function GetHourMinute(intValue) {
    var Hour = parseInt(intValue / 60).toString();
    Hour = (Hour.length == 1 ? "0" : "") + Hour;
    var Minute = (intValue % 60).toString();
    Minute = (Minute.length == 1 ? "0" : "") + Minute;
    return (Hour + ":" + Minute);
}

function parseIntByTime(timeValue) {
    var Hour = parseInt(timeValue.split(':')[0]) * 60;
    var Minute = parseInt(timeValue.split(':')[1]);
    return (Hour + Minute);
}

//检测函数

function isChn(ChnStr)//中文
{
    var ChnReg = /[^\u4E00-\u9FA5]/;
    return !ChnReg.test(ChnStr);
}

function isZipcode(ZipCodeStr)//邮编
{
    var ZipcodeReg = /^\d{6}$/;
    return ZipcodeReg.test(ZipCodeStr);
}

function isNum(NumStr)//数字
{
    var NumReg = /^\d+$/;
    if (NumReg.test(NumStr)) {
        if (parseInt(NumStr) < 2000000000)
            return true;
        else
            return false;
    }
    else
        return false;
}

function isMobile(MobileStr)//手机号码
{
    var MobileReg = /^1\d{10}$/;
    return MobileReg.exec(MobileStr);
}

function isPhone(PhoneStr)//电话号码
{
    var PhoneReg = /^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$/;
    return PhoneReg.exec(PhoneStr);
}

function isEmail(EmailStr)//邮箱地址
{
    return EmailStr.match(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/);
}

function isIE6()//判断是否为IE6
{
    if ($.browser.msie && $.browser.version == "6.0")
        return true;
    else
        return false;
}

//重载页面

function Reload() {
    //history.go(0);
    //location.reload();
    location = location;
    //location.assign(location);
    //document.execCommand('Refresh');
    //window.navigate(location);
    //location.replace(location);
    //document.URL=location.href;
}

//cookie设置

function CookieAdd(Name, Value, Path, Expires)//添加cookie
{
    if (Expires != '')
        document.cookie = Name + "=" + escape(Value) + "; path=/" + Path + "; expires=" + Expires;
    else
        document.cookie = Name + "=" + escape(Value) + "; path=/" + Path;
}

function CookieGet(Name)//获取指定名称的cookie的值
{
    if (document.cookie.length > 0) {
        Num_Start = document.cookie.indexOf(Name + "=");
        if (Num_Start != -1) {
            Num_Start = Num_Start + Name.length + 1;
            Num_End = document.cookie.indexOf(";", Num_Start); //indexOf可能有问题
            if (Num_End == -1)
                Num_End = document.cookie.length;
            return unescape(document.cookie.substring(Num_Start, Num_End));
        }
    }
    return "";
}

function CookieDel(Name, Path)//删除cookie
{
    //获取当前时间
    var date = new Date();
    //将date设置为过去的时间 
    date.setTime(date.getTime() - 1);
    //document.cookie = Name + "=''; expires=" + date.toGMTString();
    document.cookie = Name + "=''; path=/" + Path + "; expires=" + date.toGMTString();
}