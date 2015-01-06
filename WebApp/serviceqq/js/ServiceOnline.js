$(document).ready(function () {
    setTimeout(function () { $(".ser_main").show(); }, 100);
    $(".ser_box").mouseover(function () {
        if ($(".ser_box").css("right") != "0px")
            $(".ser_box").animate({ right: "0px" },100);
    });
    $(".ser_box").mouseleave(function () {
        if ($(".ser_box").css("right") == "0px")
            $(".ser_box").animate({ right: "-135px" }, 100);
        return false;
    });
    $(window).scroll(function () {
        if (isIE6()) {
            $(".ser_box").animate({ top: (80 + $(window).scrollTop()) + "px" }, 0);
        }
    });
});

function isIE6()//判断是否为IE6
{
    if ($.browser.msie && $.browser.version == "6.0")
        return true;
    else
        return false;
}