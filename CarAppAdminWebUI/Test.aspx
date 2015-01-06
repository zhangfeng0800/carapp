<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="CarAppAdminWebUI.Test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=P0IuySP2OeqbIxwu0H5qjfR6"></script>

    <style type="text/css">
	html{height:100%}
	body{height:100%;margin:0px;padding:0px}
	#controller{width:100%; border-bottom:3px outset; height:30px; filter:alpha(Opacity=100); -moz-opacity:1; opacity:1; z-index:10000; background-color:lightblue;}
	#allmap{height:100%}
</style>  
</head>
<body>
    
    <div id="controller" align="center">
		<input id="play" type="button" value="播放" onclick="play();" />
		<input id="pause" type="button" value="暂停" onclick="pause();" />
        <input id="reset" type="button" value="重置" onclick="reset()" />
	</div>
   <div id="allmap"></div>

   


<script type="text/javascript">

   

    // 百度地图API功能
    var map = new BMap.Map("allmap");
    map.centerAndZoom(new BMap.Point(114.54731, 38.030315), 15);

//    var myIcon = new BMap.Icon("Mario.png", new BMap.Size(32, 70), {    //小车图片
//        //offset: new BMap.Size(0, -5),    //相当于CSS精灵
//        imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
//    });

    var pts = [
	new BMap.Point(114.54731, 38.030315), new BMap.Point(114.54831, 38.030315),
	new BMap.Point(114.54931, 38.030315), new BMap.Point(114.55031, 38.030315),
    new BMap.Point(114.55131, 38.031415), new BMap.Point(114.55131, 38.032515),
	new BMap.Point(114.55031, 38.033615), new BMap.Point(114.55131, 38.034815),
    new BMap.Point(114.55231, 38.035915), new BMap.Point(114.55231, 38.036015),
	new BMap.Point(114.55331, 38.037715), new BMap.Point(114.55431, 38.038315),
    new BMap.Point(114.55531, 38.037715), new BMap.Point(114.55631, 38.038315),
    new BMap.Point(114.55731, 38.037715), new BMap.Point(114.55831, 38.038315),
    new BMap.Point(114.55931, 38.037715), new BMap.Point(114.56031, 38.038315),
    new BMap.Point(114.56131, 38.037715), new BMap.Point(114.56231, 38.038315)
    ];
    var paths = pts.length;    //获得有几个点

    var polyline = new BMap.Polyline(pts, { strokeColor: "blue", strokeWeight: 6, strokeOpacity: 0.5 }); //把坐标点用折线划到地图上
    map.addOverlay(polyline);

    var carMk = new BMap.Marker(pts[0], { title: "车" });
    map.addOverlay(carMk);
    var timer;
    var nowi = 0;
    ///更新地图坐标
    function resetMkPoint(i) {
            carMk.setPosition(pts[i]); //更新坐标
            carMk.setTitle("经度：" + pts[i].lng + " 纬度：" + pts[i].lat); //给title赋值经纬度
            if (i < paths) {
                timer = setTimeout(function () {
                    i++;
                    nowi++;
                    resetMkPoint(i);
                }, 100);
            }
            if (i > 0) {
                var polyline1 = new BMap.Polyline([pts[i - 1], pts[i]], { strokeColor: "red", strokeWeight: 1, strokeOpacity: 0.5 }); //汽车每经过一点，则连线此点和它的上一个点
                map.addOverlay(polyline1);
            }
        }



    function play() {
        resetMkPoint(nowi);
    }
    function pause() {
        if (timer) {
            window.clearTimeout(timer);
        }
    }
    function reset() {
        nowi = 0;
        carMk.setPosition(pts[nowi]); //更新坐标
        carMk.setTitle("经度：" + pts[nowi].lng + " 纬度：" + pts[nowi].lat); //给title赋值经纬度
    }
</script>


</body>

</html>
