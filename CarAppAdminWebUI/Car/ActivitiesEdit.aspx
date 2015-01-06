<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ActivitiesEdit.aspx.cs"
    Inherits="CarAppAdminWebUI.Car.ActivitiesEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="id" name="id" value="<%=Model.id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>活动城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editprovinceId" style="width: 100px;" name="provinceId">不限
                    </select>
                    <select class="adm_21" id="editcityId" style="width: 100px;" name="cityId">
                     
                    </select>
                    <select class="adm_21" id="editcountyId" style="width: 100px;" name="countyId">
                      
                    </select>
                </td>
            </tr>
              <tr><td  class="adm_45" align="right" height="30" width="22%">活动类型：</td>
             <td  class="adm_42" width="78%" colspan="3"><select id="isArticle" name="isArticle"  class="adm_21" >
            <option value="0">车辆优惠</option>
            <option value="1">文章优惠</option>
            </select>
            
            </td></tr>


            <tr id="tr_editrentCar">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>用车方式：
                </td>
                <td class="adm_42" width="40%" colspan="3">
                    <select class="adm_21" id="editrentCar" style="width: 40%;" name="rentCar">
                        <option value="">请选择</option>
                    </select>
                </td>
            </tr>
            <tr style="display: none" id="lineContainer">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>路线名称：
                </td>
                <td class="adm_42" width="40%" colspan="3">
                    <select class="adm_21" id="editlinename" style="width: 40%;" name="editlinename">
                        <option value="">请选择</option>
                    </select>
                </td>
            </tr>
            <tr id="tr_relatedcars">
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>相关车辆：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="relatedcars" style="width: 96%;" name="relatedcars">
                        <option value="">请选择</option>
                    </select>
                </td>
            </tr>

            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    活动描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <textarea class="adm_21" id="editdescription" style="width: 96%; height: 50px;" name="description"
                        type="text"><%=Model.description %></textarea>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>排序：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editordernum" value="<%=Model.ordernum %>" name="ordernum"
                        value="0" type="text" />
                    数值越大越靠前显示
                </td>
            </tr>
            <%--<tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>开始时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editstarttime" value="<%=Model.starttime %>" onFocus="WdatePicker({isShowClear:false,readOnly:true})" name="starttime"
                        type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>结束时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editendtime" value="<%=Model.endtime %>" onFocus="WdatePicker({isShowClear:false,readOnly:true})" name="endtime"
                        type="text" />
                </td>
            </tr>--%>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    相关图片：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="editimgurl" value="<%=Model.imgurl %>" readonly="readonly" style="width: 300px;" name="imgurl"
                                    type="text" />（图片在列表页面展示）
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iframe src="/FileUpLoad.aspx?id=editimgurl&folder=Activities&w=100&h=100" frameborder="0" style="border: 0px;
                                    height: 43px;"></iframe>   &nbsp;<a target="_blank" style="color:blue;" href="../Images/imgPosition/activityList.jpg">图片位置</a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    是否焦点图：
                </td>
                <td>
                  &nbsp;&nbsp;<input id="isFocus" name="isFocus" type="checkbox" value="1" <%if(Model.IsFocus==1){ %>checked="checked" <%} %>  onclick="visiFocusimg()" />
                  （焦点图会在安卓客户端首页展示）
                </td>
                <td colspan="2" style=" padding-left:100px;">
                是否置顶：<input id="isTop" name="isTop" type="checkbox"  value="1" <%if(Model.IsTop==1){ %>checked="checked" <%} %>  />
                是否隐藏：<input id="isHide" name="isHide" type="checkbox"  value="1" <%if(Model.IsHide==1){ %>checked="checked" <%} %>  /></td>
            </tr>
            
            <tr id="ImgFocus" <%if(Model.IsFocus==0){ %>style="display:none;" <%} %> >
            <td class="adm_45" align="right" height="30" width="22%">
                    焦点图图片：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="Imgfocus" readonly="readonly" style="width: 300px;" name="imgfocus"  value="<%=Model.Imgfocus %>"
                                    type="text" />&nbsp;<a target="_blank" style="color:blue;" href="../Images/imgPosition/activityFocus.jpg">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iframe src="/FileUpLoad.aspx?id=Imgfocus&folder=Activities&w=720&h=200" frameborder="0" style="border: 0px;
                                    height: 43px;"></iframe>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

             <tr id="tr_content">
                <td class="adm_45" align="right" height="30" width="22%">
                    链接地址：
                </td>
                 <td class="adm_42" width="78%" colspan="3"><input id="contentUrl" name="contentUrl" value="<%=Model.ContentUrl %>" readonly="readonly" class="adm_21" style=" width:250px" /></td>
            </tr>
            <tr id="tr_contetnrul">
                <td class="adm_45" align="right" height="30" width="22%">
                    文章内容：
                </td>
                 <td class="adm_42" width="78%" colspan="3">
                 <%--  <script id="editor" type="text/plain" style=" height:400px;"><%=Model.Content %></script>
                    <script type="text/javascript">
                        UE.getEditor("editor");
                    </script>--%>
                    <input type="hidden" name="content" id="content" />

                    <div id="editor"></div>
                    <script type="text/javascript">
                        var editor = new baidu.editor.ui.Editor({ initialContent: '<%=Model.Content %>' });
                        editor.render("editor");
                    </script>  
                 </td>
            </tr>
 

        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script type="text/javascript">

 

        $(function () {

          <%if(Model.provinceId!=""){ %>
            initCitySelect("editprovinceId", "不限", 0, "<%=Model.provinceId %>");
            initCitySelect("editcityId", "不限", "<%=Model.provinceId %>", "<%=Model.cityId %>");
            initCitySelect("editcountyId", "不限", "<%=Model.cityId %>", "<%=Model.countyId %>");
            citySelectChange("editprovinceId", "editcityId", "editcountyId", "不限");
            citySelectChange("editcityId", "editcountyId", "", "不限");
             <%} else{ %>

            initCitySelect("editprovinceId", "不限", 0, "");
            citySelectChange("editprovinceId", "editcityId", "editcountyId", "不限");
            citySelectChange("editcityId", "editcountyId", "", "不限"); 
            <%} %>

             $("#isArticle option[value='<%=Model.IsArticle %>']").prop("selected",true)
             
             <%if (Model.IsArticle == 1)
              { %>
                $("#tr_editrentCar").hide();
                    $("#tr_relatedcars").hide();
                    $("#tr_content").show();
                    $("#tr_contetnrul").show();
              <%}else{%>
                $("#tr_editrentCar").show();
                    $("#tr_relatedcars").show();
                    $("#tr_content").hide();
                    $("#tr_contetnrul").hide();
              <%} %>

              $("#isArticle").change(function () {

                if ($(this).val() == 1) {
                    $("#tr_editrentCar").hide();
                    $("#tr_relatedcars").hide();
                    $("#tr_content").show();
                    $("#tr_contetnrul").show();
                }
                else {
                    $("#tr_editrentCar").show();
                    $("#tr_relatedcars").show();
                    $("#tr_content").hide();
                    $("#tr_contetnrul").hide();
                }
            })

//          initRentCar("<%=Model.countyId %>", "<%=Model.RentCarId %>|<%=Model.carusewayId %>");
            $("#editcountyId").change(function () {
                $("#editrentCar").empty();
                $("#editrentCar").append('<option value="">请选择</option>');
            });
            $("#editcityId").change(function () {
                $("#editrentCar").empty();
                $("#editrentCar").append('<option value="">请选择</option>');
            });
            $("#editcountyId").change(function () {
                initUseWay($(this).val());

            });
            $("#editrentCar").change(function() {
                if ($(this).val() != 6) {
                    $("#lineContainer").hide();
                    getCars($("#editcountyId").val(), $(this).val());
                } else {
                    $("#lineContainer").show();
                    $("#relatedcars option:gt(0)").remove();
                    getHotLine($("#editcountyId").val());
                }
            });
            $("#editlinename").change(function() {
                getCarType($("#editcountyId").val(), $(this).val());
            });

            <%if(Model.countyId!=""){ %>
            showLineContainer(<%=Model.carusewayId %>);
            initUseWay(<%=Model.countyId %>,<%=Model.carusewayId %>);   
            <%} %>
            
        });

         function visiFocusimg(obj) {
            if ($("#editForm #isFocus").prop("checked")) {
                $("#ImgFocus").fadeIn();
            }
            else {
                $("#ImgFocus").fadeOut();
            }
        }

        function getHotLine(cityid,selected) {
            if (cityid == "") {
                $("#editlinename").html("<option value='0'>请选择</option>");
                return;
            }
            $.ajax({
                url: "/car/ActivitiesHandler.ashx?action=hotlist&cityid=" + cityid,
                success: function (data) {
                    var html = "<option value='0'>请选择</option>";
                    if (data.CodeId == 0) {
                        $.messager.alert("提示信息", "暂无此类型线路");

                    } else {
                        for (var i = 0; i < data.Data.length; i++) {
                            html += "<option value='" + data.Data[i].id + "'>" + data.Data[i].name + "</option>";
                        }

                    }
                    $("#editlinename").html(html);
                    if (selected) {
                        $("#editlinename").val(selected);
                    }
                }
            });
        }
        //获取热门线路的方法
        function getCarType(cityid, hotlineid,selected) {
            if (cityid == "" || hotlineid == "0") {
                $("#relatedcars").html("<option value='0'>请选择</option>");
                return;
            }
            $.ajax({
                url: "/car/ActivitiesHandler.ashx?action=typelist&cityid=" + cityid + "&hotlineid=" + hotlineid,
                success: function (data) {
                    var html = "<option value='0'>请选择</option>";
                    if (data.CodeId == 0) {
                        $.messager.alert("提示信息", "暂无此类型线路");

                    } else {
                        for (var i = 0; i < data.Data.length; i++) {
                            html += "<option value='" + data.Data[i].id + "'>" + data.Data[i].typeName + "[" + data.Data[i].linetype + " 起步价" + data.Data[i].price + "，" + data.Data[i].feeIncludes + "]</option>";
                        }

                    }
                    $("#relatedcars").html(html);
                    if (selected) {
                        $("#relatedcars").val(selected);
                    }
                }
            });
        }
        ///获取除热门路线外的路线的方法
        function getCars(cityid, useid,selected) {
            if (useid == "0") {
                $("#relatedcars").html("<option value='0'>请选择</option>");
                return;
            }
            if(cityid == "")
                return;
            $.ajax({
                url: "/car/ActivitiesHandler.ashx?action=carlist&cityid=" + cityid + "&usewayid=" + useid,
                success: function (data) {
                    var html = "<option value='0'>请选择</option>";
                    if (data.CodeId == 0) {
                        $.messager.alert("提示信息", "此城市暂未开通服务");

                    } else {
                        for (var i = 0; i < data.Data.length; i++) {
                            html += "<option value='" + data.Data[i].rentCarID + "'>" + data.Data[i].typeName + "[" + data.Data[i].feeIncludes + "]" + "</option>";
                        }

                    }
                    $("#relatedcars").html(html);
                   if (selected) {
                           $("#relatedcars").val(selected);
                   }
                }

            });
        }

      <%if(Model.countyId!=""){ %>
        function  showLineContainer(val) {
            if (val == 6) {
                $("#lineContainer").show();
                getHotLine(<%=Model.countyId %>,<%=rentModel.hotLineID %>);
                   getCarType(<%=Model.countyId %>,<%=rentModel.hotLineID %>,<%=Model.RentCarId %>);
            } else {
                 $("#lineContainer").hide();
                getCars(<%=Model.countyId %>, <%=Model.carusewayId %>, <%=rentModel.id %>);
            }
        }
        <%} %>

        function initUseWay(val,selected) {
            if (val == "") {
                $("#editrentCar").html("<option value='0'>请选择</option>");
                return;
            }
            $.ajax({
                url: "/car/ActivitiesHandler.ashx?action=waylist&cityid=" + val,
                success: function (data) {

                    var html = "<option value='0'>请选择</option>";
                    if (data.CodeId == 0) {
                        $.messager.alert("提示信息", "此城市暂未开通服务");

                    } else {

                        for (var i = 0; i < data.Data.length; i++) {
                            html += "<option value='" + data.Data[i].carusewayID + "'>" + data.Data[i].carusewayName + "</option>";
                        }

                    }
                    $("#editrentCar").html(html);
                    if (selected) {
                           $("#editrentCar").val(selected);
                    }
                 
                }

            });
        }

      
        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/Car/ActivitiesHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '修改成功！', 'info', function () {
                            onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }
        //校验表单
        function checkForm() {
//            /*城市*/
//            var countyId = $.trim($("#editcountyId").val());
//            if (countyId == "") {
//                showValidateMessage("请选择城市");
//                return false;
//            }

            if ($("#isArticle").val() == 0) {
                /*相关车辆*/
                var rentCar = $.trim($("#editrentCar").val());
                if (rentCar == "") {
                    showValidateMessage("请选择相关线路车辆");
                    return false;
                }
            }
              else {
                var content = $.trim(UE.getEditor('editor').getContent());
                $("#content").val(content);
                if (content == "") {
                    showValidateMessage("请填写文章内容");
                    return false;
                }
            }
            /*活动描述*/
            var description = $.trim($("#editdescription").val());
            if (description.length >= 200) {
                showValidateMessage("描述信息长度不能大于200");
                return false;
            }

            /*排序*/
            var ordernum = $.trim($("#editordernum").val());
            if (ordernum == "") {
                showValidateMessage("请填写排序信息");
                return false;
            }
            if (!pnum(ordernum)) {
                showValidateMessage("排序信息只能是正整数");
                return false;
            }

            if ($("#addForm #isFocus").prop("checked")) {
                if ($("#Imgfocus").val() == "") {
                    showValidateMessage("焦点图图片不能为空");
                    return false;
                }
            }

            /*开始时间*/
            /*var starttime = $.trim($("#editstarttime").val());
            if (starttime == "") {
            showValidateMessage("请填写开始时间");
            return false;
            }*/

            /*结束时间*/
            /*var endtime = $.trim($("#editendtime").val());
            if (endtime == "") {
            showValidateMessage("请填写结束时间");
            return false;
            }*/

            return true;
        }

//        function initRentCar($v, $val) {
//            $.get("/Car/ActivitiesHandler.ashx", { "action": "rentcarlist", "v": $v }, function (data) {
//                var pro = "";
//                for (var i = 0; i < data.length; i++) {
//                    pro += '<option value=' + data[i].id + '|' + data[i].carusewayID + '>';
//                    pro += "[起步价" + data[i].DiscountPrice + "] " + data[i].cityName + " " + data[i].CarUseWayName + "" + data[i].carTypeName + " " + data[i].feeIncludes;
//                    pro += '</option>';
//                }
//                $("#editrentCar").append(pro);
//                $("#editrentCar").val($val);
//            }, "json");
//        }

//        function onRentCarChange() {
//            $("#editrentCar").append('<option value="">请选择</option>');
//            var $v = $("#editcountyId").val();
//            if ($v != "") {
//                $.get("/Car/ActivitiesHandler.ashx", { "action": "rentcarlist", "v": $v }, function (data) {
//                    if (data.length == 0) {
//                        $.messager.alert("信息", "此城市暂无任何运营车辆信息", "info");
//                    } else {
//                        var pro = "";
//                        for (var i = 0; i < data.length; i++) {
//                            pro += '<option value=' + data[i].id + '|' + data[i].carusewayID + '>';
//                            pro += "[起步价" + data[i].DiscountPrice + "] " + data[i].cityName + " " + data[i].CarUseWayName + "" + data[i].carTypeName + " " + data[i].feeIncludes;
//                            pro += '</option>';
//                        }
//                        $("#editrentCar").append(pro);
//                    }
//                }, "json");
//            }
//        }
    </script>
</body>
</html>
