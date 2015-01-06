var Interval;

$(document).ready(function () {
    for (var i = 0; i < 2; i++)
        $(".Div_CarInfo ul").append($(".Div_CarInfo ul").html());
    IntervalStart();
    $(".Div_CarInfo ul li p").click(function () {
        //        window.location.href = $(".Div_CarInfo ul li p").closest("li").children("a").attr("href");
        window.location.href = $(this).prev("a").attr("href");
    });
    $(".Div_CarInfo ul li").mouseover(function () {
        clearInterval(Interval);
        $(this).children("p").show();
        $(this).children("p").animate({ height: "80px" }, "fast");
        var index = $(this).index();
        $(".Div_CarInfo ul li").each(function () {
            if ($(this).index() != index) {
                tempTag = $(this);
                tempTag.children("p").hide();
                $(this).children("p").animate({ height: "0px" });
            }
        });
    });
    $(".Div_CarInfo ul li").mouseout(function () {
        IntervalStart();
    });
})

function IntervalStart() {
    Interval = setInterval(function () {
        var topIndex = parseInt($(".Div_CarInfo ul").css("top").replace('px', ''));
        if (-(topIndex - 190) >= $(".Div_CarInfo ul").height())
            $(".Div_CarInfo ul").css("top", "0px");
        else
            $(".Div_CarInfo ul").animate({ top: (topIndex - 190) + "px" },"slow");
    }, 4000);
}