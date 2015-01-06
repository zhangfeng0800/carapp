﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderEdit.aspx.cs" Inherits="CarAppAdminWebUI.Order.OrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="id" name="id" value="<%=Model.orderId %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    上车地址：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editstartAddress" value="<%=Model.startAddress %>" name="startAddress" style="width:300px;"
                        type="text" onkeyup="showFloatLayer($(this).val(),'<%=startCityName %>','0','#startAddress','#startpoint','#editstartAddress','#placedetail')"
                          <%if(caruseway==1){
                        %>
                        readonly="readonly"
                        <%
                        } %> /><br />

                         <input type="hidden" name="startpoint" id="startpoint" value="<%=Model.mapPoint %>"  />
                        
                         <div class="startAddress" style="background: #fff; border: 1px solid #ddd; height: auto;
                            display: none; width: 300px; position: absolute; top: 60px; left: 136px;z-index:1000;" id="startAddress"></div>
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    上车补充地址：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input type="text" style="width: 300px;" class="in_border" name="placedetail" id="placedetail" value="<%=Model.startAddressDetail %>" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    下车地址：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editarriveAddress" value="<%=Model.arriveAddress.Contains("，") ? Model.arriveAddress.Split('，')[0] : Model.arriveAddress %>" name="arriveAddress"
                        type="text" onkeyup="showFloatLayer($(this).val(),'<%=endCityName %>','0','#endAddressdiv','#endpoint','#editarriveAddress','#enddetail')" style=' width:300px;' 
                        <%if(caruseway==2){
                        %>
                        readonly="readonly"
                        <%
                        } %> />
                         
                          <input type="hidden" name="endpoint" id="endpoint" value="<%=Model.EndPosition %>"  />
                       
                             <div class="startAddress" style="background: #fff; border: 1px solid #ddd; height: auto;
                            display: none; width: 300px; position: absolute; top: 135px; left: 136px;z-index:1000;" id="endAddressdiv"></div>  
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    下车补充地址：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <input type="text" style="width: 300px;" class="in_border" name="enddetail" id="enddetail" value="<%=Model.arriveAddress.Contains("，") ? Model.arriveAddress.Split('，')[1] : Model.arriveAddress %>" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>乘车人姓名：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editpassengerName" value="<%=Model.passengerName %>" name="passengerName"
                        type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>乘车人电话：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editpassengerPhone" value="<%=Model.passengerPhone %>"
                        name="passengerPhone" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>预约时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21 Wdate" id="editdepartureTime" value="<%=Model.departureTime %>"
                        onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" name="departureTime" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>订单状态：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editorderStatusID" name="orderStatusID" disabled="disabled">
                        <option value="">请选择</option>
                        <option value="1">等待确认</option>
                        <option value="2">等待服务</option>
                        <option value="3">服务中</option>
                        <option value="4">服务结束</option>
                        <option value="5">服务取消</option>
                        <option value="6">订单完成</option>
                        <option value="7">司机等待</option>
                        <option value="8">等待派车</option>
                        <option value="9">二次付款</option>
                        <option value="10">司机已经出发</option>
                        <option value="11">司机已经就位</option>
                        <option value="12">订单已经接取</option>
                    </select>
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onEditSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script type="text/javascript">
        $(function () {
            $("#editorderStatusID").val('<%=Model.orderStatusID %>');
        });
        function onEditSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/Order/OrderHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '操作成功！', 'info', function () {
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

            var departureTime = $.trim($("#editdepartureTime").val());
            if (departureTime == "") {
                showValidateMessage("请填写出发时间");
                return false;
            }

            var passengerName = $.trim($("#editpassengerName").val());
            if (passengerName == "") {
                showValidateMessage("请填写乘车人姓名");
                return false;
            }

            var passengerPhone = $.trim($("#editpassengerPhone").val());
            if (passengerPhone == "") {
                showValidateMessage("请填写乘车人电话");
                return false;
            }
            if (!ismobile(passengerPhone)) {
                showValidateMessage("请填写一个有效的乘车人电话");
                return false;
            }

            var orderStatusID = $.trim($("#editorderStatusID").val());
            if (orderStatusID == "") {
                showValidateMessage("请选择订单状态");
                return false;
            }

            return true;
        }

        function showFloatLayer(q, region, ishot, element, lnglatContainer, positionContainer, detailPositionContainer) {
            $.ajax({
                url: "/ajax/baiduplaceapi.ashx",
                type: "post",
                data: { q: q, region: region, ishot: ishot },
                success: function (data) {
                    var dataResult = "";
                    if (data.resultcode == 0) {
                        $(element).html("");
                    } else {
                        $(element).show();
                        $.each(data.results, function (index, val) {
                            if (val.name && val.address) {
                                dataResult += "<div onclick='clickToHide(\"" + element + "\"," + index + ",\"" + lnglatContainer + "\",\"" + positionContainer + "\",\"" + detailPositionContainer + "\")' style=\"padding:5px;\" position=\"" + val.location.lng + "," + val.location.lat + "\")\' id=\"p" + index + "\"><a id=\"anchor" + index + "\" href=\"javascript:;\">" + val.name + "，" + val.address + "<a></div>";
                            }
                        });
                        $(element).html(dataResult);
                    }
                }
            });
        }
        function clickToHide(parentElement, id, lnglatContainer, postionContainer, detailPositionContainer) {
            $(lnglatContainer).val($("#p" + id).attr("position"));
            var val = $("#anchor" + id).text().split('，');
            $(postionContainer).val(val[0]);
            $(detailPositionContainer).val(val[1]);
            $(parentElement).hide();
            $(parentElement).html("");
        }

    </script>
</body>
</html>