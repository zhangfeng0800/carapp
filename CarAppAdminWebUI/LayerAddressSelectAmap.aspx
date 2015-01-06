<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LayerAddressSelectAmap.aspx.cs" Inherits="CarAppAdminWebUI.LayerAddressSelectAmap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="http://developer.amap.com/Public/css/demo.Default.css" />
      <script type="text/javascript" language="javascript" src="http://webapi.amap.com/maps?v=1.3&key=e0abc49d577d64ee80d968f7705765a3"></script>
    
</head>
<body>
 <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="10%">
                    <span class="field-validation-valid">*</span>所选地址：
                </td>
                <td class="adm_42" width="90%" colspan="3">
                   <input class="adm_21" id="address" style="width:250px;" /><input id="addressDetail" />  <span style=" float:right; margin-right:20px;"><a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a></span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="10%">
                    <span class="field-validation-valid">*</span>位置标注：
                </td>
                <td class="adm_42" width="90%" colspan="3">
                    经度：<input class="adm_21" id="addlng" style="width: 100px;" name="lng" type="text" /> 
                    纬度：<input class="adm_21" id="addlat" style="width: 100px;" name="lat" type="text" /> 可以在地图中点击选择拖拽
                    <div id="iCenter" style="height:500px;"></div>
                </td>
            </tr>
        </table>
        <p style="text-align: center;">
        <input type="hidden" id="theconrol" value="<%=controlId %>" />
        </p>

        <script type="text/javascript" language="javascript">
            var mapObj;
            //初始化地图对象，加载地图
            function mapInit() {
                mapObj = new AMap.Map("iCenter", {
                    rotateEnable: true,
                    dragEnable: true,
                    zoomEnable: true,
                    //二维地图显示视口
                    view: new AMap.View2D({
                        center: new AMap.LngLat(114.51486, 38.042306), //地图中心点
                        zoom: 13 //地图显示的缩放级别
                    })
                });
             

                AMap.event.addListener(mapObj, 'complete', function () {
                    placeSearch();
                });

                AMap.event.addListener(mapObj, 'click', function (data) {
                    mapObj.clearMap(); //清楚所有覆盖物 先清除上一个位置     
                    $("#addlng").val(data.lnglat.lng);
                    $("#addlat").val(data.lnglat.lat);
                    
                    geocoder(data.lnglat.lng, data.lnglat.lat);

                    var marker = new AMap.Marker({
                        position: new AMap.LngLat(data.lnglat.lng, data.lnglat.lat),
                        draggable: true, //点标记可拖拽
                        cursor: 'move',  //鼠标悬停点标记时的鼠标样式
                        raiseOnDrag: true//鼠标拖拽点标记时开启点标记离开地图的效果
                    });
                    AMap.event.addListener(marker, 'dragend', function (data) {
                        $("#addlng").val(data.lnglat.lng);
                        $("#addlat").val(data.lnglat.lat);
                        geocoder(data.lnglat.lng, data.lnglat.lat);
                    });
                    marker.setMap(mapObj);
                });

            }

            function placeSearch() {
                var MSearch;
                mapObj.plugin(["AMap.PlaceSearch"], function () {
                    MSearch = new AMap.PlaceSearch({ //构造地点查询类
                        pageSize: 10,
                        pageIndex: 1,
                        city: "021" //城市
                    });
                    AMap.event.addListener(MSearch, "complete", keywordSearch_CallBack); //返回地点查询结果
                    MSearch.search('<%=address %>'); //关键字查询
                });
            }
            function keywordSearch_CallBack(data) {
                if (data.info != "OK") {
                    alert(data.info);
                    return;
                }
                var loaction = data.poiList.pois[0].location;
                mapObj.setCenter(new AMap.LngLat(loaction.lng, loaction.lat));
            }

            function geocoder(lng, lat) {
                var lnglatXY = new AMap.LngLat(lng, lat);
                var MGeocoder;
                //加载地理编码插件
                mapObj.plugin(["AMap.Geocoder"], function () {
                    MGeocoder = new AMap.Geocoder({
                        radius: 1000,
                        extensions: "all"
                    });
                    //返回地理编码结果 
                    AMap.event.addListener(MGeocoder, "complete", geocoder_CallBack);
                    //逆地理编码
                    MGeocoder.getAddress(lnglatXY);
                });
            }
            function geocoder_CallBack(data) {
                if (data.info != "OK") {
                    alert(data.info);
                    return;
                }
                console.log(data);
                $("#address").val(data.regeocode.formattedAddress);
                if (data.regeocode.pois.length > 0) {
                    $("#addressDetail").val(data.regeocode.pois[0].name);
                }
                
            }

            $(function () {
                mapInit();
            });

            function onAddSubmit() {
                var id = $("#theconrol").val();
                switch (id) {
                    case "jiejie":
                        $("#txt_jieji_mudiplace").val($("#address").val());
                        $("#txt_jieji_mudiplacedetail").val($("#addressDetail").val());
                        $("#txt_jieji_endpoint").val($("#addlng").val() + "," + $("#addlat").val());
                        break;
                    case "songjis":
                        $("#txt_songji_placeinfo").val($("#address").val());
                        $("#txt_songji_detailplace").val($("#addressDetail").val());
                        $("#txt_songji_startpoint").val($("#addlng").val() + "," + $("#addlat").val());
                        break;
                    case "rizus":
                        $("#txt_rizu_placeinfo").val($("#address").val());
                        $("#txt_rizu_detailplace").val($("#addressDetail").val());
                        $("#txt_rizu_startpoint").val($("#addlng").val() + "," + $("#addlat").val());
                        break;
                    case "rizue":
                        $("#txt_rizu_mudiplace").val($("#address").val());
                        $("#txt_rizu_mudiplacedetail").val($("#addressDetail").val());
                        $("#txt_rizu_endpoint").val($("#addlng").val() + "," + $("#addlat").val());
                        break;
                    case "hotlines":
                        $("#txt_hotline_startplace").val($("#address").val());
                        $("#txt_hotline_startplacedetail").val($("#addressDetail").val());
                        $("#txt_hotline_startpoint").val($("#addlng").val() + "," + $("#addlat").val());
                        break;
                    case "hotlinee":
                        $("#txt_hotline_endplaceinfo").val($("#address").val());
                        $("#txt_hotline_endplacedetail").val($("#addressDetail").val());
                        $("#txt_hotline_endpoint").val($("#addlng").val() + "," + $("#addlat").val());
                        break;
                    case "timelys":
                        $("#txt_timely_placeinfo").val($("#address").val());
                        $("#txt_timely_placeinfodetail").val($("#addressDetail").val());
                        $("#txt_timely_startpoint").val($("#addlng").val() + "," + $("#addlat").val());
                        break;
                    case "timelye":
                        $("#txt_timely_mudiplace").val($("#address").val());
                        $("#txt_timely_mudiplacedetail").val($("#addressDetail").val());
                        $("#txt_timely_endpoint").val($("#addlng").val() + "," + $("#addlat").val());
                        break;

                }



                onClose();
            }
</script>


</body>
</html>
