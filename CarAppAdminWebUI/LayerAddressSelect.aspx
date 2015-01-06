<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LayerAddressSelect.aspx.cs" Inherits="CarAppAdminWebUI.LayerAddressSelect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
          
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
                    <div id="allmap" style="height:500px;"></div>
                </td>
            </tr>
        </table>
        <p style="text-align: center;">
        <input type="hidden" id="theconrol" value="<%=controlId %>" />
        </p>
   


       <script type="text/javascript">

       $(function(){
            // 百度地图API功能
           var map = new BMap.Map("allmap");
           map.centerAndZoom(new BMap.Point(<%=location %>), 13);
           map.enableScrollWheelZoom();
           map.addControl(new BMap.NavigationControl()); 
           var myGeo = new BMap.Geocoder();
           map.addEventListener("click", function (e) {
               var point = new BMap.Point(e.point.lng, e.point.lat);
               $("#addlng").val(e.point.lng);
               $("#addlat").val(e.point.lat);
               map.clearOverlays();
               var myMk = new BMap.Marker(point, { title: "" });
               myMk.enableDragging();

               //标注拖拽方法
               myMk.addEventListener("dragend", function (e) {
                   $("#addlng").val(e.point.lng);
                   $("#addlat").val(e.point.lat);
                   myGeo.getLocation(new BMap.Point(e.point.lng, e.point.lat), function (result) {
                       if (result) {
                           if (result.surroundingPois.length > 0) {
                               $("#address").val(result.address);
                               $("#addressDetail").val(result.surroundingPois[0].title);
                           }
                           else {
                               $("#address").val(result.address);
                               $("#addressDetail").val("");
                           }
                       }
                   });
               })
               map.addOverlay(myMk); //添加标注   

               myGeo.getLocation(point, function (result) {
                   if (result) {
                       if (result.surroundingPois.length > 0) {
                           $("#address").val(result.address);
                           $("#addressDetail").val(result.surroundingPois[0].title);
                       }
                       else {
                           $("#address").val(result.address);
                           $("#addressDetail").val("");
                       }
                   }
               });

           });
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
