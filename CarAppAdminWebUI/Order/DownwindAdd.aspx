<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DownwindAdd.aspx.cs" Inherits="CarAppAdminWebUI.Order.DownwindAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
       <form id="addForm">
        <input type="hidden" id="action" name="action" value="addwindOrder" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%" style=" line-height:30px;">
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>单价：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addamount" name="amount" type="text" maxlength="10" style=" font-size:20px; width:100px;" onkeyup="this.value=this.value.replace(/\D/g,'')"   />元
                </td>
            </tr>
              <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>座位数：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addPassengernum" name="Passengernum" type="text" maxlength="10" style=" font-size:20px; width:100px;" onkeyup="this.value=this.value.replace(/\D/g,'')"   />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>预定出发时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    
                     <input class="adm_21 Wdate" id="addDepartureTime" name="DepartureTime" type="text"   onfocus="WdatePicker({minDate:'%y-%M-#{%d+1}',dateFmt:'yyyy-MM-dd HH:mm'})" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>选择车型：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <select class="easyui-combogrid adm_21" style="width: 150px" id="addrentcar" name="rentcar"   ></select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>上车地点：<!---->
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <select class="adm_21" id="addprovinceId"  name="provinceId"></select>
                    <select class="adm_21" id="addcityId"  name="cityId"></select>
                    <select class="adm_21" id="addcountyId" name="countyId"></select>
                    &nbsp;&nbsp;
                    <input class="adm_21" id="addstartAddress" name="startAddress" type="text"  value=""  style="width:300px;" onkeyup="showFloatLayer($(this).val(),'#addcityId','0','#startAddress','#startpoint','#addstartAddress','#addstartAddressDetail')"  />
                    
                    <input style="display:none;" id="addstartAddressDetail" name="startAddressDetail" type="text" style="width:200px;" />
                    <input type="hidden" name="startpoint" id="startpoint" value=""  />
                        
                      <div  style="background: #fff; border: 1px solid #ddd; height: auto;
                            display: none; width: 300px; position: absolute; top: 200px; left: 440px;z-index:1000;" id="startAddress"></div>
                </td>
            </tr>
                <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>下车地点：<!---->
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addprovinceIde"  name="provinceIde"></select>
                    <select class="adm_21" id="addcityIde" name="cityIde"></select>
                    <select class="adm_21" id="addcountyIde"  name="countyIde"></select>
                      &nbsp;&nbsp;
                      <input class="adm_21" id="addendAddress" name="endAddress" type="text" value="" style="width:300px;" onkeyup="showFloatLayer($(this).val(),'#addcityIde','0','#endAddressdiv','#endpoint','#addendAddress','#addendAddressDetail')"  />
                       <input style="display:none;" id="addendAddressDetail" name="endAddressDetail" type="text" style="width:200px;" />
                           <input type="hidden" name="endpoint" id="endpoint" value=""  />
                       
                             <div style="background: #fff; border: 1px solid #ddd; height: auto;
                            display: none; width: 300px; position: absolute; top: 240px; left: 440px;z-index:1000;" id="endAddressdiv"></div>  
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>选择用户账号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <select class="easyui-combogrid adm_21" style="width: 150px" id="useraccount" name="useraccount"></select>
                </td>
            </tr>
         
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>

        
     <div id="useraccounttoolbar" style="padding: 5px; height: auto">
        <div>
            用户姓名:
            <input type="text" id="addcompname" name="compname" />
            手机号码:
            <input type="text" id="addtelphone" name="telphone" />       
            <input type="button" onclick="onUseraccountSearch()" value="搜索" />
        </div>
    </div>

      <div id="rentcartoolbar" style="padding: 5px; height: auto">
        <div>
           省市县：
           <select id="addprovince"></select>
           
           <select id="addcity">
            <option value="">不限</option>
           </select>
           <select id="addcounty">
            <option value="">不限</option>
           </select>
            <input type="button" onclick="onRentSearch()" value="搜索" />
        </div>
    </div>


        <script type="text/javascript">

            $(function () {
                bindcombogrid();
                bindrentcar();

                initCitySelect("addprovinceId", "请选择", 0, "");
                citySelectChange("addprovinceId", "addcityId", "addcountyId", "请选择");
                citySelectChange("addcityId", "addcountyId", "", "请选择");

                initCitySelect("addprovinceIde", "请选择", 0, "");
                citySelectChange("addprovinceIde", "addcityIde", "addcountyIde", "请选择");
                citySelectChange("addcityIde", "addcountyIde", "", "请选择");

                initCitySelect("addprovince", "不限", 0, "");
                citySelectChange("addprovince", "addcity", "addcounty", "不限");
                citySelectChange("addcity", "addcounty", "", "不限");
            });
            function onAddSubmit() {
                if (confirm("确认要提交吗？") && checkform()) {
                    var d = $("#addForm").serialize();
                    $.post("/Order/DownwindHandler.ashx", d, function (data) {
                        if (data.IsSuccess) {
                            $.messager.alert('消息', '添加成功！', 'info', function () {
                                window.location.reload();
                                //onClose();
                            });
                        } else {
                            $.messager.alert('消息', data.Message, 'error');
                        }
                    }, "json");
                }
            }

            function setStart() {
                alert(1);
                var g = $('#addrentcar').combogrid('grid');
                var r = g.datagrid('getSelected');
                console.log(r);
            }

            //绑定下拉列表框
            function bindcombogrid() {
                var width = $(window).width();
                $("#useraccount").combogrid({
                    width: 1000,
                    panelWidth: 1000,
                    idField: 'id',
                    panelHeight: 400,
                    textField: 'compname',
                    url: '/Member/UserAccountHandler.ashx?action=list&accountclass=-1&username=&realname=' + $("#addcompname").val() + '&telphone=' + $("#addtelphone").val() + "&isvip=",
                    method: 'post',
                    pagination: true,
                    pageList: [15, 30, 45, 60],
                    pageSize: 15,
                    columns: [[
                { field: 'compname', title: '集团 / 个人名称', formatter: fusername },
                { field: 'username', title: '昵称', width: 100, width: 100 },
                { field: 'telphone', title: '手机号码', width: 100 },
                { field: 'balance', title: '账户余额（元）', width: 100, sortable: true },
                { field: 'email', title: '邮箱地址', width: 100 },
                { field: "registtime", title: "注册时间", width: 100, formatter: easyui_formatterdate, sortable: true },
                { field: 'type', title: '用户类型', width: 100, formatter: ftype },
                { field: 'creater', title: '创建人', width: 100 }
                ]],
                    fitColumns: true,
                    toolbar: '#useraccounttoolbar',
                    onLoadSuccess: function (data) {
                        $('#useraccount').combogrid('setValue', '206');
                        $('#useraccount').combogrid('setText', '梁琳');
                        
                    }

                });

                
                
            }

            function onUseraccountSearch() {
                bindcombogrid();
            }
            function fusername(value, row, index) {
                var html = "<a style='text-decoration:underline;' href='javascript:onShow(" + row.id + ")'>" + value + "</a> ";
                return html;
            }
            /* formatter */
            function ftype(value, row, index) {
                var array = new Array("集团管理员", "部门管理员", "集团员工", "个人会员");
                return array[value];
            }

            //绑定下拉列表框
            function bindrentcar() {
                var province = $("#addprovince").val();
                if (province == null) {
                    province = "";
                }
                var width = $(window).width();
                $("#addrentcar").combogrid({
                    width: 1000,
                    panelWidth: 1000,
                    idField: 'id',
                    panelHeight: 400,
                    textField: 'carTypeName',
                    url: "/Car/RentCarHandler.ashx?action=list&caruseway=8&provenceID=" + province + "&cityId=" + $("#addcity").val() + "&areaId=" + $("#addcounty").val() + "&sIsDelete=0",
                    method: 'post',
                    pagination: true,
                    pageList: [15, 30, 45, 60],
                    pageSize: 15,
                    columns: [[
                { field: 'id', title: '编号', width: 100 },
                { field: 'cityName', title: '所属城市', width: 100 },
                { field: 'carTypeName', title: '车辆类型名称', width: 100 },
                { field: 'brandName', title: '包含品牌', width: 300 },
                { field: 'isDelete', title: '状态', width: 100, formatter: fstatus }
                ]],
                    fitColumns: true,
                    toolbar: '#rentcartoolbar',
                    onHidePanel: function () {
                        var g = $('#addrentcar').combogrid('grid');
                        var r = g.datagrid('getSelected');

                        initCitySelect("addprovinceId", "请选择", 0, r.provenceId);
                        initCitySelect("addcityId", "请选择", r.provenceId, r.cityID);
                        initCitySelect("addcountyId", "请选择", r.cityID, r.countyId);
                    }  
                });

            }
            function fstatus(value, row, index) {
                var status = new Array("正常", "<span style='color:red;'>已删除</span>", "<span style='color:red;'>暂停</span>");
                return status[value];
            }

            function onRentSearch() {
                bindrentcar();
            }


            function checkform() {
                if ($("#addamount").val() == "") {
                    showValidateMessage("请填写单价");
                    return false;
                }
                else if ($("#addPassengernum").val() == "") {
                    showValidateMessage("请填写座位数");
                    return false;
                }
                else if ($("#addDepartureTime").val() == "") {
                    showValidateMessage("请填写预定出发时间");
                    return false;
                }
                else if ($("#addrentcar").combogrid('getValue') == "") {
                    showValidateMessage("请选择车型");
                    return false;
                }
                else if ($('#startpoint').val() == "") {
                    showValidateMessage("请填写有效上车地址");
                    return false;
                }
                else if ($('#endpoint').val() == "") {
                    showValidateMessage("请填写有效下车地址");
                    return false;
                }
                return true;
            }

            function showFloatLayer(q, region, ishot, element, lnglatContainer, positionContainer, detailPositionContainer) {
                $.ajax({
                    url: "/ajax/baiduplaceapi.ashx",
                    type: "post",
                    data: { q: q, region: $(region).find("option:selected").text(), ishot: ishot },
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
                $(postionContainer).val(val[0] + "，" + val[1]);
                //$(detailPositionContainer).val(val[1]);
                $(parentElement).hide();
                $(parentElement).html("");
            }


    </script>
</body>
</html>
