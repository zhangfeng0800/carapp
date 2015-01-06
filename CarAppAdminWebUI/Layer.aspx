<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Layer.aspx.cs" Inherits="CarAppAdminWebUI.Layer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>无标题文档</title>
    <script type="text/javascript" src="/Static/scripts/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Static/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Static/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="/Static/easyui/locale/easyui-lang-zh_CN.js"></script>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <script src="Static/scripts/easyui.formatter.expend.js" type="text/javascript"></script>
    <script src="Static/My97DatePicker/moment.min.js" type="text/javascript"></script>
    <script src="Static/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <link type="text/css" href="Static/styles/admin.css" rel="stylesheet" />
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=P0IuySP2OeqbIxwu0H5qjfR6"></script>
    <script type="text/javascript" language="javascript" src="http://webapi.amap.com/maps?v=1.3&key=e0abc49d577d64ee80d968f7705765a3"></script>
    <script type="text/javascript">
        var jiejidate; 
        function getDefaultCity(telphone,province,city,town,caruse) { 
            $.ajax({
                url:"/ajax/GetDefaultCarInfo.ashx?telphone="+telphone,
                success:function(data) {
                    if (data.resultcode != 0) {
                        var provinceid = data.provinceid;
                        var provincename = data.provincename;
                        var cityname = data.cityname;
                        var cityid = data.cityid;
                        var citylist = data.citylist;
                        var townlist = data.townlist;
                        var caruselist = data.caruselist;
                        $(province).val(provinceid);
                        var cityhtml = "";
                        $.each(citylist, function(index, val) {
                            cityhtml += "<option value='"+val.cityid+"'>"+val.cityname+"</option>";
                        });
                        $(city).html(cityhtml);
                        $(city).val(cityid);
                        var townhtml = "";
                        $.each(townlist, function(index, val) {
                            if (index == 0) {
                                townhtml +=  "<option selected='selected' value='"+val.townid+"'>"+val.townname+"</option>";
                                $("#towntype").val(val.type);
                                if (val.type == 2) {
                                  jiejidate=  moment().add(75, "minutes").format("YYYY-MM-D HH:mm:00");

                                } else {
                                 jiejidate=  moment().add(135, "minutes").format("YYYY-MM-D HH:mm:00");
                                }
                                
                            } else {
                                townhtml +=  "<option value='"+val.townid+"'>"+val.townname+"</option>";
                            }
                    
                        });
                    
                           
                            
                        $(town).html(townhtml);
                        if (caruse) {
                            var carusehtml = "<option value=''>请选择</option>";
                            $.each(caruselist, function(index, val) {
                                carusehtml += "<option value='" + val.carusewayID + "'>" + val.carusewayName + "</option>";
                            });
                            $(caruse).html(carusehtml);
                        }
            
                    }
                }
            });
        }

        function getDefaultCityInfo(caruseway) {
            var cityid = $("#city").val();
            var provinceid = $("#province").val();
            var townid = $("#town").val();
            $.ajax({
                url:"/ajax/getdefaultcarinfo.ashx",
                data: {defaultinfo:"1",provinceid:provinceid,cityid:cityid,caruseway:caruseway,townid:townid},
                type:"post",
                async:false,
                success:function(data) {
                    if (data.resultcode == 0) {
                        return;
                    } else {
                        var cityhtml = "";
                        var townhtml = "";
                        var airporthtml = "";
                        if (caruseway == "1") {
                      
                            $.each(data.citydata, function(index, val) {
                                cityhtml += "<option value='" + val.codeid + "'>" + val.cityname + "</option>";
                            });
                            $("#txt_jieji_mudicity").html(cityhtml);
                            $.each(data.towndata, function(index, val) {
                                townhtml += "<option value='" + val.codeid + "'>" + val.cityname + "</option>";
                            });
                            $("#txt_jieji_muditown").html(townhtml);
                            $("#txt_jieji_mudicity").val(cityid);
                            $("#txt_jieji_muditown").val(townid);
                            $("#txt_jieji_mudiprovince").val(provinceid);
                        } else if(caruseway=="2") {
                       
                            $.each(data.citydata, function(index, val) {
                                cityhtml += "<option value='" + val.codeid + "'>" + val.cityname + "</option>";
                            });
                            $("#txt_songji_mudicity").html(cityhtml);
                            $.each(data.towndata, function(index, val) {
                                townhtml += "<option value='" + val.codeid + "'>" + val.cityname + "</option>";
                            });
                            $.each(data.airportdate, function(index, val) {
                                airporthtml += "<option value='" + val.id + "'>" + val.airportName + "</option>";
                            });
                            $("#txt_songji_airport").html(airporthtml);
                            $("#txt_songji_muditown").html(townhtml);
                            $("#txt_songji_mudicity").val(cityid);
                            $("#txt_songji_muditown").val(townid);  
                            $("#txt_songji_mudiprovince").val(provinceid);
                        }else if (caruseway == "3" || caruseway == "4" || caruseway == "5") {
                         
                            $.each(data.citydata, function(index, val) {
                                cityhtml += "<option value='" + val.codeid + "'>" + val.cityname + "</option>";
                            });
                            $("#txt_rizu_mudicity").html(cityhtml);
                            $.each(data.towndata, function(index, val) {
                                townhtml += "<option value='" + val.codeid + "'>" + val.cityname + "</option>";
                            });
                         
                            $("#txt_rizu_muditown").html(townhtml);
                            $("#txt_rizu_mudicity").val(cityid);
                            $("#txt_rizu_muditown").val(townid);                                
                            $("#txt_rizu_mudiprovince").val(provinceid);
                        } 
                        else if (caruseway == "7") {
                         
                            $.each(data.citydata, function(index, val) {
                                cityhtml += "<option value='" + val.codeid + "'>" + val.cityname + "</option>";
                            });
                            $("#txt_timely_mudicity").html(cityhtml);
                            $.each(data.towndata, function(index, val) {
                                townhtml += "<option value='" + val.codeid + "'>" + val.cityname + "</option>";
                            });
                         
                            $("#txt_timely_muditown").html(townhtml);
                            $("#txt_timely_mudicity").val(cityid);
                            $("#txt_timely_muditown").val(townid);                                
                            $("#txt_timely_mudiprovince").val(provinceid);
                        } 
                    }
                }
            });
        
        }
        function  clearInput() {
            $("#txt_jieji_startdate").val("");
            $("#txt_songji_startdate").val("");
            $("#txt_rizu_startdate").val("");
            $("#txt_hotline_startdate").val("");
            $("#txt_jieji_mudiplace").val("");
            $("#txt_jieji_mudiplacedetail").val("");
            $("#txt_jieji_endpoint").val("");
            $("#txt_songji_placeinfo").val("");
            $("#txt_songji_detailplace").val("");
            $("#txt_songji_startpoint").val("");
            $("#txt_rizu_placeinfo").val("");
            $("#txt_rizu_startpoint").val("");
            $("#txt_rizu_detailplace").val("");
            $("#txt_rizu_mudiplace").val("");
            $("#txt_rizu_mudiplacedetail").val("");
            $("#txt_rizu_endpoint").val("");
            $("#txt_hotline_startplace").val("");
            $("#txt_hotline_startpoint").val("");
            $("#txt_hotline_startplacedetail").val("");
            $("#txt_hotline_endplaceinfo").val("");
            $("#txt_hotline_endplacedetail").val("");
            $("#txt_hotline_endpoint").val("");
            $("#hourContainer").hide();
            $("#txt_timely_placeinfo").val("");
            $("#txt_timely_startpoint").val("");
            $("#txt_timely_placeinfodetail").val("");
            $("#txt_timely_mudiplace").val("");
            $("#txt_timely_mudiplacedetail").val("");
            $("#txt_timely_endpoint").val("");
            $("#txt_timely_startdate").val("");
            $("#txt_hotline_startdate").val("");
            $("#txt_rizu_startdate").val("");
            $("#txt_jieji_startdate").val("");
            $("#txt_songji_startdate").val("");
        }
        $(function () {
            bindWin();

        
            $("#btnnext").show();
            $("#jieji").hide();
            $("#songji").hide();
            $("#rizu").hide();
            $("#hotline").hide();
            $("#placeinfo").hide();
            $("#hints").hide();
            $("#timely").hide();
            $("#passangerContainer").hide();
            clearInput();
            getAddress("province", "0", "#province");
            getDefaultCity('<%=Telphone %>','#province','#city','#town','#caruseway');
            $("#province").change(function() {
                $("#town").html("<option value=''>请选择</option>");
                $("#caruseway").html("<option value=''>请选择</option>");
                if ($(this).val() != "") {
                    getAddress("city", $(this).val(), "#city");
                } else {
                    $("#city").html("<option value=''>请选择</option>"); 
                }
            });
            $("#city").change(function() {
                if ($(this).val() == "") {
                    $("#caruseway").html("<option value=''>请选择</option>");
                    $("#city").html("<option value=''>请选择</option>");
                } else {
                    getAddress("town", $(this).val(), "#town");
                }
            });
            $("#town").change(function() {
                if ($(this).val() == "") {
                    $("#caruseway").html("<option value=''>请选择</option>");
                } else {
                    getAddress("caruse", $(this).val(), "#caruseway");
                }
            });
            $("#caruseway").change(function() {
                if ($("#caruseway").val() != "6") {
                    if ($("#caruseway").val() == "" || $("#town").val() == "") {
                        alert("请选择完整信息");
                        return;
                    }
                    $("#linetypeContainer").hide();
                    $("#routeContainer").hide();
                    $('#carinfo').combogrid({
                        panelWidth:450,
                        idField:'rentCarID',
                        textField:'typeName',
                        fitColumns: false,
                        url:"/ajax/getplaceapi.ashx?action=selectcar&useid="+$("#caruseway").val()+"&id="+$("#town").val(),
                        columns:[[
                            {field:"rentCarID",title:"编号"},
                            {field:'typeName',title:'车辆类型'},
                            {field:'startPrice',title:'起步价（元）'},
                            {field:'discountprice',title:'折扣价（元）'},
                            {field:'feeIncludes',title:'费用包含'},
                            { field: "kiloPrice", title: "超公里费（元/公里）" },
                            {field:"hourPrice",title:"超时费（元/分钟）"},
                            {field:"passengerNum",title:"可乘人数"}
                        ]]
                    });
                } else {
                    $("#linetypeContainer").show();
                    $("#routeContainer").show();
                    if ($("#town").val() == "") {
                        alert("请选择完整信息");
                        return;
                    }
                    $.ajax({
                        url:"/ajax/getplaceapi.ashx?action=hotline&countyid="+$("#town").val(),
                        success:function(data) {
                            if (data.resultcode == 1) {
                                var html = "<option value=''>请选择</option>";
                                $.each(data.data, function(index, val) {
                                    html += "<option value='" + val.id + "'>" + val.name + "</option>";
                                });
                                $("#routename").html(html);
                            } else {
                                $("#routename").html("<option value=''>请选择</option>");
                            }
                        }
                    });
                }
                if ($(this).val() == 3 || $(this).val() == 4 || $(this).val() == 5) {
                    $("#hourContainer").show(); 
                    var html = "";
                    if ($(this).val() == 3) {
                       
                        for (var i = 1; i < 9; i++) {
                            html += "<option value='" + i + "'>" + i + "</option>";
                        }
                    }else if ($(this).val() == 4) {
                        html = "<option value='8'>8</option>";;
                    }else if ($(this).val() == 5) {
                        html = "<option value='4'>4</option>";;
                    }
                    $("#usehour").html(html);
                } else {
                    $("#hourContainer").hide();
                }
            });
            $("#routename").change(function() {
                if ($("#town").val() == "" || $("#routename").val() == "") {
                    alert("请选择完整信息");   
                    return;
                }
                $.ajax({
                    url:"/ajax/getplaceapi.ashx?action=linetype&cityid="+$("#town").val()+"&hotlineid="+$("#routename").val(),
                    success:function(data) {
                        if (data.resultcode == "0") {
                            $("#linetype").html("<option value=''>请选择</option>");
                        } else {
                            var html = "<option value=''>请选择</option>";
                            $.each(data.data, function(index, val) {
                                html += "<option value='"+val.isoneway+"'>"+val.name+"</option>";
                            });
                            $("#linetype").html(html);
                        }
                    }
                });
            });
            $("#linetype").change(function() {
                if ($("#town").val() == "" || $("#routename").val() == "" || $("#linetype").val() == "") {
                    alert("请选择完整信息");   
                    return;
                }
                $('#carinfo').combogrid({
                    panelWidth:550,
                    value:"请选择",
                    idField:'rentCarID', 
                    textField:'typeName',
                    fitColumns: false,
                    url:"/ajax/getplaceapi.ashx?action=selectcar&useid=6&cityid="+$("#town").val()+"&hotlineid="+$("#routename").val()+"&linetype="+$("#linetype").val(),
                    columns:[[
                        {field:"rentCarID",title:"编号"},
                        {field:'typeName',title:'车辆类型'},
                        {field:'startPrice',title:'起步价（元）'},
                        {field:'discountprice',title:'折扣价（元）'},
                        {field:'feeIncludes',title:'费用包含'},
                        { field: "kiloPrice", title: "超公里费（元/公里）" },
                        {field:"hourPrice",title:"超时费（元/分钟）"},
                        {field:"passengerNum",title:"可乘人数"}
                    ]]
                });
            });
            <%if (UserModel != null)
        {%>
            $('#gd1').datagrid({
                url: "/Member/UserAccountHandler.ashx?action=logaccountlist&id=<%=UserModel.Id%>",
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                height:400,
                frozenColumns: [[
                    { field: 'accountnumber', title: '流水号' }
                ]],
                columns:
                [[
                    { field: 'type', title: '存入/支出', formatter: ftype },
                    { field: 'datetime', title: '流水时间', formatter: easyui_formatterdate },
                    { field: 'money', title: '发生变动的金额（元）' },
                    { field: 'balance', title: '账户余额（元）' },
                    { field: 'action', title: '详细操作' },
                    { field: "orderid", title: "相关订单" }
                ]]
            });
            $('#gd2').datagrid({
                url: "/Member/UserAccountHandler.ashx?action=logorderlist&id=<%=UserModel.Id %>",
                method: 'post',
                height:400,
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                frozenColumns: [[
                    { field: "orderid", title: "订单信息" }
                ]],
                columns: [[
                    { field: 'orderdate', title: '下单时间', formatter: easyui_formatterdate },
                    { field: 'departurecity', title: '出发城市' },
                    { field: 'targetcity', title: '目的城市' },
                    { field: 'cartype', title: '租车类型' },
                    {field:"caruseway",title:"用车方式"},
                    { field: 'ordermoney', title: '订单额（元）' },
                    { field: "unpaidmoney", title: "二次付款金额（元）" },
                    { field: "totalmoney", title: "订单总额（元）" },
                    { field: 'passengername', title: '乘车人' },
                    {field:"orderstatusid",title:"订单状态",formatter:forderStatusId}
                ]]
            }); 
            function forderStatusId(value, row, index) {
                var status = new Array("等待付款", "等待服务", "服务中", "服务结束", "服务取消", "订单完成", "司机等待", "<span style='color:red;'>等待派车</span>", "二次付款中", '司机已经出发', '司机已经就位', "订单已经接取");
                return status[value - 1];
            }
            <%}%>
            $("#btnregister").click(function () {
                if ($("#username").val() == "" || $("#telphone").val() == "") {
                    alert("请填写完整信息");
                    return;
                }
                var mobileReg = /^1\d{10}$/gi;
                if (mobileReg.test($("#telphone").val()) == false) {
                    $.messager.alert("提示信息","手机号格式错误");
                    return false;
                }
                $.ajax({
                    url: "/ajax/register.ashx",
                    type: "post",
                    data: { telphone: $("#telphone").val(), type: $("#usertype").val(), name: $("#username").val(),sex:$("#sex").val(),querystring:'<%=queryString %>' },
                    success: function (data) {
                        if (data.resultcode == 0) {
                            $.messager.alert('提示信息',data.msg);
                        } else {
                            window.location.href = data.location;
                        }
                    }
                });
            });
        });
        function getAddress(action,id,element) {
            $.ajax({
                url:"/ajax/getplaceapi.ashx?action="+action+"&id="+id,
                type:"get",
                async:false,
                success: function(data) {
                    $(element).html("");
                    var html = "";
                    html += "<option value=''>请选择</option>";
                    if (data.resultcode == 1) {
                        $.each(data.data, function(index, val) {
                            html += "<option value='" + val.id + "'>" + val.name + "</option>";
                        });
                        if (action == "caruse") {
                            $("#towntype").val(data.type);
                               if (data.type == 2) {
                                  jiejidate=  moment().add(75, "minutes").format("YYYY-MM-D HH:mm:00");

                                } else {
                                 jiejidate=  moment().add(135, "minutes").format("YYYY-MM-D HH:mm:00");
                                }
                            
                        }
                      
                    } 
                    $(element).html(html);
                }
            });
        }
        function ftype(value, row, index) {
            if (value == "0") {
                return '<span style="color:red;">支出</span>';
            } else {
                return '<span style="color:blue;">存入</span>';
            }
        }
        function  getAllAddress(type,id,element) {
            $.ajax({
                url:"/ajax/getplaceapi.ashx?type="+type+"&id="+id,
                type:"get",
                async:false,
                success: function(data) {
                    $(element).html("");
                    var html = "";
                    html += "<option value=''>请选择</option>";
                    if (data.resultcode == 1) {
                        $.each(data.data, function(index, val) {
                            html += "<option value='" + val.id + "'>" + val.name + "</option>";
                        });
                        $(element).html(html);
                    }
                }
            });
        }

        function  getAirportAddress(airportType,id,element) {
            $.ajax({
                url:"/ajax/getplaceapi.ashx?airporttype="+airportType+"&id="+id,
                type:"get",
                async:false,
                success: function(data) {
                    $(element).html("");
                    var html = "";
                    html += "<option value=''>请选择</option>";
                    if (data.resultcode == 1) {
                        $.each(data.data, function(index, val) {
                     
                            html += "<option value='" + val.id + "'>" + val.name + "</option>";
                      
                          
                        });
                        $(element).html(html);
                    }
                }
            });
        }
        function  showAddressContainer(val) {
        
            if ($("#province").val() == "" || $("#city").val() == "" || $("#town").val() == ""||$("#caruseway").val()=="") {
                $.messager.alert("提示信息","请填写完整信息");
                return;
            }  
            var g = $('#carinfo').combogrid('grid');	 
            var r = g.datagrid('getSelected');
            if (!r) {
                $.messager.alert("提示信息","请填写完整信息");
                return;
            }
            $("#txtrentcarid").val($('#carinfo').combogrid('getValue'));
            var result = checkCanOrder($('#carinfo').combogrid('getValue'));
            if (!result) {
                return ;}
        
            $("#jieji").hide();
            $("#songji").hide();
            $("#rizu").hide();
            $("#hotline").hide();
            $("#cityinfo").hide();
            $("#txtrentcarid").val($('#carinfo').combogrid('getValue'));
            $("#passangerContainer").show();
            $("#placeinfo").show();
          
            var passengerNum = r.passengerNum;
            var html = "";
            for (var i = 1; i < passengerNum+1; i++) {
                html+= "<option value='"+i+"'>"+i+"</option>";
            }
            $("#passengernum").html(html);
            if (val == 1) {
                $("#jieji").show();
                $("#txt_jieji_cityinfo").val($("#province option:selected").text()+$("#city option:selected").text()+$("#town option:selected").text());
                $.ajax({
                    url:"/ajax/getplaceapi.ashx",
                    type:"post",
                    data: {action:"airport",cityid:$("#town").val()},
                    success:function(data) {
                        if (data.resultcode == 0) {
                            $("#txt_jieji_airport").html("<option value=''>请选择</option>");
                            return;
                        }
                        var html = "";
                        $.each(data, function(index, value) {
                            html += "<option value='"+value.Id+"'>"+value.AirPortName+"</option>";
                        });
                        $("#txt_jieji_airport").html(html);
                    }
                });
                getAllAddress("province", "0", "#txt_jieji_mudiprovince");
                $("#txt_jieji_mudiprovince").change(function() {
                    if ($(this).val() != "") {
                        getAllAddress("city", $(this).val(), "#txt_jieji_mudicity");
                    } else {
                        $("#txt_jieji_mudicity").html("<option value=''>请选择</option>"); 
                    }
                    $("#txt_jieji_mudiplace").val("");
                    $("#txt_jieji_mudiplacedetail").val("");
                });
                $("#txt_jieji_mudicity").change(function() {
                    if ($(this).val() == "") {
                        $("#txt_jieji_muditown").html("<option value=''>请选择</option>");
                    } else {
                        getAllAddress("town", $(this).val(), "#txt_jieji_muditown");
                    }
                    $("#txt_jieji_mudiplace").val("");
                    $("#txt_jieji_mudiplacedetail").val("");
                });
            }else if (val == 2) {
                $("#txt_songji_cityinfo").val($("#province option:selected").text()+$("#city option:selected").text()+$("#town option:selected").text());
                $("#songji").show();
                getAirportAddress("province", "0", "#txt_songji_mudiprovince");
                $("#txt_songji_mudiprovince").change(function() {
                    if ($(this).val() != "") {
                        getAirportAddress("city", $(this).val(), "#txt_songji_mudicity");
                    } else {
                        $("#txt_songji_mudicity").html("<option value=''>请选择</option>"); 
                    }
                });
                $("#txt_songji_mudicity").change(function() {
                    if ($(this).val() == "") {
                        $("#txt_songji_muditown").html("<option value=''>请选择</option>");
                    } else {
                        getAirportAddress("town", $(this).val(), "#txt_songji_muditown");
                    }
                });
                $("#txt_songji_muditown").change(function() {
                    if ($(this).val() == "") {
                        $("#txt_songji_airport").html("<option value=''>请选择</option>");
                    } else {
                        getAirportAddress("airport", $(this).val(), "#txt_songji_airport");
                    }
                });
            }else if (val == 3 || val == 4 || val == 5) {
                $("#rizu").show();
                $("#txt_rizu_cityinfo").val($("#province option:selected").text()+$("#city option:selected").text()+$("#town option:selected").text());
                getAllAddress("province", "0", "#txt_rizu_mudiprovince");
                $("#txt_rizu_mudiprovince").change(function() {
                    if ($(this).val() != "") {
                        getAllAddress("city", $(this).val(), "#txt_rizu_mudicity");
                    } else {
                        $("#txt_rizu_mudicity").html("<option value=''>请选择</option>"); 
                    }
                    $("#txt_rizu_mudiplace").val("");
                    $("#txt_rizu_mudiplacedetail").val("");
                });
                $("#txt_rizu_mudicity").change(function() {
                    if ($(this).val() == "") {
                        $("#txt_rizu_muditown").html("<option value=''>请选择</option>");
                    } else {
                        getAllAddress("town", $(this).val(), "#txt_rizu_muditown");
                    }
                    $("#txt_rizu_mudiplace").val("");
                    $("#txt_rizu_mudiplacedetail").val("");
                });
            }
            else if (val == 6) {
                if ($("#routename").val() == "" || $("#linetype").val() == "") {
                    alert("请填写完整信息");
                    return;
                }
                $("#hotline").show();
                $("#txt_hotline_startcity").val($("#province option:selected").text()+$("#city option:selected").text()+$("#town option:selected").text());
                $.ajax({
                    url:"/ajax/getplaceapi.ashx?action=hotplace&rentcarid="+$("#txtrentcarid").val(),
                    success:function(data) {
                        if (data.resultcode == "0") {
                            $("#txt_hotline_mudicityinfo").val("");
                        } else {
                            $("#txt_hotline_mudicityinfo").val(data.data);
                            $("#txt_hotline_city").val(data.city);
                        }
                    }
                });
            } else if (val==7) {
                $("#timely").show();
                $("#txt_timely_startcity").val($("#province option:selected").text()+$("#city option:selected").text()+$("#town option:selected").text());
                getAllAddress("province", "0", "#txt_timely_mudiprovince");
                $("#txt_timely_mudiprovince").change(function() {
                    if ($(this).val() != "") {
                        getAllAddress("city", $(this).val(), "#txt_timely_mudicity");
                    } else {
                        $("#txt_timely_mudicity").html("<option value=''>请选择</option>"); 
                    }
                    $("#txt_timely_mudiplace").val("");
                    $("#txt_timely_mudiplacedetail").val("");
                });
                $("#txt_timely_mudicity").change(function() {
                    if ($(this).val() == "") {
                        $("#txt_timely_muditown").html("<option value=''>请选择</option>");
                    } else {
                        getAllAddress("town", $(this).val(), "#txt_timely_muditown");
                    }
                    $("#txt_timely_mudiplace").val("");
                    $("#txt_timely_mudiplacedetail").val("");
                });
            }
            else {
                $("#placeinfo").hide();
            }
            getDefaultCityInfo(val);
            $("#placeinfo").show();
          
        }

        function showFloatLayer(q,region,ishot,element,lnglatContainer,positionContainer,detailPositionContainer) {
            $.ajax({
                url:"/ajax/baiduplaceapi.ashx",
                type:"post",
                data: {q:q,region:region,ishot:ishot},
                success:function(data) {
                    var dataResult = "";
                    if (data.resultcode == 0) {
                        $(element).html("");
                    } else { 
                        $(element).show();
                        $.each(data.results, function(index, val) {
                            if (val.name && val.address) {
                                dataResult += "<div onclick='clickToHide(\""+element+"\","+index+",\""+lnglatContainer+"\",\""+positionContainer+"\",\""+detailPositionContainer+"\")' style=\"padding:5px;\" position=\"" + val.location.lng + "," + val.location.lat + "\")\' id=\"p" + index + "\"><a id=\"anchor"+index+"\" href=\"javascript:;\">" + val.name + "，" + val.address + "<a></div>";
                            }
                        });
                        $(element).html(dataResult);
                    }
                }
            });
        }
        function onMouseoutFloatLayer(container) {
            $(container).hide();
            $(container).html("");
        }

        function onMouseOverFloatLayer(container) {
            $(container).show(); 
        }
        function clickToHide(parentElement,id,lnglatContainer,postionContainer,detailPositionContainer) {
          
            $(lnglatContainer).val($("#p"+id).attr("position"));
            var val = $("#anchor" + id).text().split('，');
            $(postionContainer).val(val[0]);
            $(detailPositionContainer).val(val[1]); 
            $(parentElement).hide();
            $(parentElement).html("");
        }
        

        function gethour(dt, element) {
            var type = $("#towntype").val();
            var ar = [];
            var now = moment().format("YYYY-MM-DD");
            if (now == dt) {
                if (moment().get("hour") > 22 && moment().get("hour") < 8) {
                } else { 
                    if (type == 2) {
                        var hour = moment().add("hours", 1).add("minutes", 10).hour();
                        for (var k = hour; k < 24; k++) {
                            ar.push(k);
                        }
                    } else {
                        var hour = moment().add("hours", 2).add("minutes", 10).hour();
                        for (var i = hour; i < 24; i++) {
                            ar.push(i);
                        }
                    }
                }
            } else {
                for (var i = 0; i < 24; i++) {
                    ar.push(i);
                }
            }
            var html = "";
            html += "<option value=''>时</option>";
            for (var j = 0; j < ar.length; j++) {
                html += "<option value='" + ar[j] + "'>" + ar[j] + "</option>";
            }

            $(element).html(html);
        }
        function gettimelyhour(dt, element) {
            var ar = [];
            var now = moment().format("YYYY-MM-DD");
            if (now == dt) {
                var hour = moment().add("hours",0).add("minutes", 5).hour();
                for (var k = hour; k < 24; k++) {
                    ar.push(k);
                }
            } else {
                for (var i = 0; i < 24; i++) {
                    ar.push(i);
                }
            }
            var html = "";
            html += "<option value=''>时</option>";
            for (var j = 0; j < ar.length; j++) {
                html += "<option value='" + ar[j] + "'>" + ar[j] + "</option>";
            }

            $(element).html(html);
        }
        function gettimelyMinutes(dt,hour, element) {
            var now = moment().format("YYYY-MM-DD");
            var ar = [];
            if (dt == now) {
                if (hour == moment().add("minutes", 1).hour()) {
                    var minute = moment().add("minutes", 1).minute();
                    var yushu = 5 - minute % 5;
                    for (var i = minute + yushu; i < 60; i += 5) {
                        ar.push(i);
                    }
                } else {
                    for (var j = 0; j < 60; j += 5) {
                        ar.push(j);
                    }
                }
            } else {
                for (var j = 0; j < 60; j += 5) {
                    ar.push(j);
                }
            }
            var html = "";
            html += "<option value=''>分</option>";
            for (var k = 0; k < ar.length; k++) {
                html += "<option value='" + ar[k] + "'>" + ar[k] + "</option>";
            }
            $(element).html(html);
        }
        function getMinutes(hour, elminute) {
            var type = $("#towntype").val();
            var ar = [];
            if (type == 2) {

                if (hour == moment().add("hours", 1).add("minutes", 10).hour()) {
                    var minute = moment().add("hours", 1).add("minutes", 10).minute();
                    var yushu = 5 - minute % 5;
                    for (var i = minute + yushu; i < 60; i += 5) {
                        ar.push(i);
                    }
                } else {
                    for (var i = 0; i < 60; i += 5) {
                        ar.push(i);
                    }
                }
            } else {
                if (hour == moment().add("hours", 2).add("minutes", 10).hour()) {
                    var minute = moment().add("hours", 2).add("minutes", 10).minute();
                    var yushu = 5 - minute % 5;
                    for (var i = minute + yushu; i < 60; i += 5) {
                        ar.push(i);
                    }
                } else {
                    for (var i = 0; i < 60; i += 5) {
                        ar.push(i);
                    }
                }
            }
            var html = "";
            html += "<option value=''>分</option>";
            for (var i = 0; i < ar.length; i++) {
                html += "<option value='" + ar[i] + "'>" + ar[i] + "</option>";
            }
            $(elminute).html(html);
        }

        function makeOrder(usewayid) {
            var mobileReg = /^1\d{10}$/gi;
            if (mobileReg.test($("#passengertelphone").val()) == false) {
                $.messager.alert("提示信息","手机号格式错误");
                return false;
            }
            if (!confirm("确认提交订单吗?")) {
                return false;
            }
            var data;
            if (usewayid == 1) {

                data = {
                    airportid: $("#txt_jieji_airport").val(),
                    airportname: $("#txt_jieji_airport option:selected").text(),
                    starttime: $("#txt_jieji_startdate").val(),
                    targetcityid: $("#txt_jieji_muditown").val(),
                    endplace: $("#txt_jieji_mudiplace").val(),
                    endplacedetail: $("#txt_jieji_mudiplacedetail").val(),
                    endpoint: $("#txt_jieji_endpoint").val()
                }; 
                if (data.airportid==""||data.targetcityid==""||data.endplace==""||data.endplacedetail==""||data.endpoint=="") {
                    $.messager.alert("提示信息","请填写完整信息");
                    return false;
                }
                if ($("#txt_jieji_startdate").val() == "" || $("#txt_jieji_starthour").val() == "" || $("#txt_jieji_starMinute").val() == "") {
                    $.messager.alert("提示信息","请填写完整时间");
                    return false;
                }
            }else if (usewayid == 2) {
              
                data = {
                    airportid: $("#txt_songji_airport").val(),
                    airportname: $("#txt_songji_airport option:selected").text(),
                    startplace: $("#txt_songji_placeinfo").val(),
                    startplacedetail: $("#txt_songji_detailplace").val(),
                    startpoint: $("#txt_songji_startpoint").val(),
                    starttime: $("#txt_songji_startdate").val() ,
                    targetcityid: $("#txt_songji_muditown").val()
                }; 
                if ( data.airportid==""|| data.startplace==""|| data.startplacedetail==""||data.startpoint==""||data.targetcityid =="") {
                    $.messager.alert("提示信息","请填写完整信息");
                    return false;
                }
                if ($("#txt_songji_startdate").val()==""||$("#txt_songji_starthour").val()==""||$("#txt_songji_startMinute").val()=="") {
                    $.messager.alert("提示信息","请填写完整信息");
                    return false;
                }
            }else if (usewayid==3||usewayid==5||usewayid==4) {

                data = {
                    startplace: $("#txt_rizu_placeinfo").val(),
                    startplacedetail: $("#txt_rizu_detailplace").val(),
                    startpoint: $("#txt_rizu_startpoint").val(),
                    starttime: $("#txt_rizu_startdate").val(),
                    endplace: $("#txt_rizu_mudiplace").val(),
                    endplacedetail: $("#txt_rizu_mudiplacedetail").val(),
                    endpoint: $("#txt_rizu_endpoint").val(),
                    targetcityid: $("#txt_rizu_muditown").val()
                };
                if (data.startplace==""||data.startplacedetail==""||data.startpoint==""||data.endplace==""||data.endplacedetail==""||data.endpoint==""||data.targetcityid=="") {
                    $.messager.alert("提示信息","请填写完整信息");
                    return false;
                }
                if ($("#txt_rizu_startdate").val() == "" ||$("#txt_rizu_starthour").val()=="" || $("#txt_rizu_startMinute").val()=="") {
                    $.messager.alert("提示信息","请填写完整信息");
                    return false;
                }
            } else if(usewayid==6) {
                data = {
                    startplace: $("#txt_hotline_startplace").val(),
                    startplacedetail: $("#txt_hotline_startplacedetail").val(),
                    startpoint: $("#txt_hotline_startpoint").val(),
                    starttime: $("#txt_hotline_startdate").val(),
                    endplace: $("#txt_hotline_endplaceinfo").val(),
                    endplacedetail: $("#txt_hotline_endplacedetail").val(),
                    endpoint: $("#txt_hotline_endpoint").val()
                };
                if (data.startplace==""||data.startplacedetail==""||data.startpoint==""||data.endplace==""||data.endplacedetail==""||data.endpoint=="") {
                    $.messager.alert("提示信息","请填写完整信息","info");
                    return false;
                }if ($("#txt_hotline_startdate").val()== "" ||$("#txt_hotline_starthour").val() == "" || $("#txt_hotline_starMinute").val()=="") {
                    $.messager.alert("提示信息","请填写完整时间");
                    return false;
                }
            } else if (usewayid ==7) {
                data = {
                    startplace: $("#txt_timely_placeinfo").val(),
                    startplacedetail: $("#txt_timely_placeinfodetail").val(),
                    startpoint: $("#txt_timely_startpoint").val(),
                    starttime: $("#txt_timely_startdate").val(),
                    endplace: $("#txt_timely_mudiplace").val(),
                    endplacedetail: $("#txt_timely_mudiplacedetail").val(),
                    endpoint: $("#txt_timely_endpoint").val(),
                    targetcityid: $("#txt_timely_muditown").val()
                };
                if (data.startplace==""||data.startplacedetail==""||data.startpoint==""||data.endplace==""||data.endplacedetail==""||data.endpoint==""||data.targetcityid=="") {
                    $.messager.alert("提示信息","请填写完整信息");
                    return false;
                }
            }
            data.rentcarid = $("#txtrentcarid").val();
            data.passenername = $("#passenger").val();
            data.telphone = $("#passengertelphone").val();
            data.passengernum = $("#passengernum").val();
            data.others = $("#others").val();
            data.usewayid = usewayid;
            data.startcityid = $("#town").val();
            data.action = "makeorder";
            data.usertelphone = $("#telcontainer").text();
            data.useHour = $("#usehour").val();
            data.querystring = '<%=queryString %>';
            data.ismsg = $("#ismsg").prop("checked");
            data.ordernum = $('#ordernum').numberspinner('getValue');
            if (data.passenername == "" || data.passengernum == "" || data.telphone == "") {
                $.messager.alert("提示信息","请填写完整信息");
                return false;
            }
            $.ajax({
                url:"/order/orderhandler.ashx",
                data:data,
                type:"post",
                success:function(result) {
                    var objJson = $.parseJSON(result);
                    if (objJson.resultcode == 0) {
                        alert(objJson.msg);
                    } else {
                        window.location.href = "/confirmpage.aspx?orderid=" + objJson.orderid+"&querystring="+objJson.querystring;
                    }
                }
            });
        }

        function  getPassengerList() {
            var telphone = '<%=Telphone%>';
            $.ajax({
                url:"/ajax/getpassenger.ashx?telphone="+telphone+"&action=list",
                success:function(data) {
                    if (data.resultcode == 0) {
                        return;
                    } else {
                        $("#floatLayer_passenger").show();
                        var dataResult = "";
                        $.each(data.data, function(index, val) {
                            dataResult += "<div onclick=\"clickToChoose("+index+")\"   style=\"padding:5px;\" id=\"div_p_" + index + "\"><a  id=\"anchor" + index + "\" href=\"javascript:;\">" + val.ContactName + "，" + val.TelePhone + "</a></div>";
                        });
                        $("#floatLayer_passenger").html(dataResult);
                    }
                }
            });
        }
        function keyUpPassengername(name) {
            var telphone = '<%=Telphone%>';
            $.ajax({
                url:"/ajax/getpassenger.ashx",
                data: {action:"filter",telphone:telphone,contactName:name},
                type:"post",
                success:function(data) {
                    if (data.resultcode == 0) {
                        $("#floatLayer_passenger").hide();
                        return;
                    } else {
                        $("#floatLayer_passenger").show();
                        var dataResult = "";
                        $.each(data.data, function(index, val) {
                            dataResult += "<div onclick=\"clickToChoose("+index+")\"   style=\"padding:5px;\" id=\"div_p_" + index + "\"><a  id=\"anchor" + index + "\" href=\"javascript:;\">" + val.ContactName + "，" + val.TelePhone + "</a></div>";
                        });
                        $("#floatLayer_passenger").html(dataResult);
                    }
                }
            });
        }
 

        function clickToChoose(index) {
            var result= $("#anchor"+index).text();
            $("#passenger").val(result.split('，')[0]);
            $("#passengertelphone").val(result.split('，')[1]);
            $("#floatLayer_passenger").hide();
            $("#floatLayer_passenger").html("");
        }

        function  onPassengerChange() {
            $("#floatLayer_passenger").hide();
        }

        function  clickToReturn() {
            $("#cityinfo").show();
            $("#placeinfo").hide();
            $("#passangerContainer").hide();
        }

        function callback(telphone) {
            $.ajax({
                url:"/ajax/callback.ashx?callee="+telphone+"&caller=<%=Exten %>&timestamp="+Date.parse(new Date()),
                success: function(data) {
                    if (data.resultcode == 0) {
                        $.messager.alert("提示信息","回呼失败");
                    } else {
                        $.messager.alert('提示信息',"操作成功");
                    }
                }
            });
        }
        function checkCanOrder(rentcarid) {
            var result;
            $.ajax({
                url:"/ajax/CheckAccountBalance.ashx",
                type:"post",
                async:false,
                data: {telphone:'<%=Telphone %>',rentcarid:rentcarid,ordernum: $('#ordernum').numberspinner('getValue')},
                success:function(data) {
                    if (data.resultcode == 0) {
                        
                        alert(data.msg);
                        result= false;
                    }else if (data.resultcode==1) { 
                        $("#hints").hide();
                        result=true;
                    }else if (data.resultcode == -1) {
                        $("#ordermoney").text(data.ordermoney+'元*'+ $('#ordernum').numberspinner('getValue')+'笔='+(data.ordermoney*$('#ordernum').numberspinner('getValue'))+'元');
                        $("#balance").text(data.currentbalance);
                        $("#hints").show();
                    
                        result=false;
                    }
                }
            });
            return result;
        }
    </script>
    <style>
        .floatLayer div a:hover
        {
            background-color: #dddddd;
        }
    </style>
</head>
<body>
<div style=" height:30px;">
    <span style=" float:right; margin-right:20px; margin-top:10px;"><a target="_blank" href="Order/MapRentCar.aspx">车辆位置查看</a></span>
    </div>
    <div class="container easyui-tabs">



    


        <div class="wrap" title="用户信息">
            <div class="wrap_bg">
                <%
                    if (UserModel == null)
                    {%><span class="uc_info"><strong>用户姓名：</strong><em class="font_red">未知用户</em>
                </span><span class="uc_info"><strong>来电号码:</strong><a href="javascript:;" onclick="callback('<%=Telphone %>')"><%=Telphone %>[点击回拨]</a>
                </span>
                <%}
                    else
                    {%>
                <span class="uc_info"><strong>集团/个人名称:</strong><%=UserModel.Compname %>&nbsp;&nbsp;<%=GetSex(UserModel.sex) %></span><span
                    class="uc_info"><strong> 昵称:</strong><%=UserModel.Username %>
                </span><span class="uc_info"><strong>会员号码:</strong><span id="telcontainer" title="点击回拨"
                    style="color: red; cursor: pointer;" onclick="callback($(this).text())"><%=UserModel.Telphone %></span><span
                        style="cursor: pointer; color: red;" title="点击回拨" onclick="callback($('#telcontainer').text())">[点击回拨]</span>
                </span><span class="uc_info"><strong>来电号码:</strong><span id="callernum" style="color: blue;"
                    onclick="callback($(this).text())"><%=caller %></span> <span style="cursor: pointer;
                        color: blue;" title="点击回拨" onclick="callback($('#callernum').text())">[点击回拨]</span>
                </span><span class="uc_info"><strong>账户余额：</strong><em class="font_red"><%=UserModel.Balance %>元</em>
                </span><span class="uc_info"><strong>邮箱地址：</strong><em class="font_red"><%=UserModel.Email %></em>
                </span>
                <%
                        if (LevelModel != null)
                        {
                            Response.Write("<span class=\"uc_info\"><strong>用户等级：</strong><em class=\"font_red\">" + LevelModel.Name + "</em></span>");
                        }
                %>
                <% }
                %>
            </div>
            <div class="easyui-tabs" id="tabs">
                <div title="流水记录" style="padding: 10px">
                    <table id="gd1">
                    </table>
                </div>
                <div title="订单记录" style="padding: 10px">
                    <table id="gd2">
                    </table>
                </div>
            </div>
        </div>
        <%

            if (UserModel == null)
            {%>
        <div class="wrap" title="用户注册">
            <div class="wrap_bg">
                <p class="form_items">
                    <span>用户类型</span>
                    <select style="width: 200px;" id="usertype" onchange="changeTitle()">
                        <option value="3">个人账户</option>
                        <option value="0">企业账户</option>
                    </select>
                </p>
                <p class="form_items">
                    <span id="titlename">真实姓名</span>
                    <input class="in_border" type="text" id="username" />
                </p>
                <p class="form_items">
                    性&nbsp;&nbsp;&nbsp;&nbsp;别
                    <select id="sex">
                        <option value="true">男</option>
                        <option value="false">女</option>
                    </select>
                </p>
                <p class="form_items">
                    <span>手机号码</span>
                    <input class="in_border" type="text" value="<%=Telphone %>" id="telphone" />
                </p>
                <p class="form_items">
                    <input class="reg_btn" type="button" value="注册" id="btnregister" />
                </p>
            </div>
        </div>
        <%}%>
        <div title="在线订车" style="padding: 10px;">
            <div class="wrap" id="cityinfo">
                <h3>
                    用车信息</h3>
                <div class="wrap_bg">
                    <p class="form_items">
                        用车省份
                        <select id="province">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items">
                        用车城市
                        <select id="city">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items">
                        用车区县
                        <select id="town">
                            <option>请选择</option>
                        </select>
                        <input type="hidden" name="towntype" id="towntype" />
                    </p>
                    <p class="form_items">
                        用车方式
                        <select id="caruseway">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items" id="hourContainer">
                        用车时长
                        <select id="usehour">
                            <option value="0">0</option>
                        </select>
                    </p>
                    <p class="form_items" id="routeContainer">
                        路线名称
                        <select id="routename">
                            <option value="">请选择</option>
                        </select>
                    </p>
                    <p class="form_items" id="linetypeContainer">
                        路线类型
                        <select id="linetype">
                            <option value="">请选择</option>
                        </select>
                    </p>
                    <p class="form_items">
                        选择车辆
                        <select id="carinfo" class="easyui-combogrid" style="width: 450px">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items">
                        订单数量
                        <input class="easyui-numberspinner" value="1" data-options="min:1,max:10,required:true"
                            id="ordernum" name="ordernum" style="width: 120px;"></input>
                        <span id="hints">当前订单金额<span id="ordermoney" style="color: red"></span>，账户余额<span
                            id="balance" style="color: red"></span>，账户余额不足！</span>
                    </p>
                    <p class="form_items">
                        <input class="reg_btn" type="submit" value="下一步" id="btnnext" onclick="showAddressContainer($('#caruseway').val())" />
                    </p>
                </div>
            </div>
            <div class="wrap" id="placeinfo">
                <h3>
                    乘车信息</h3>
                <div class="wrap_bg" id="jieji">
                    <p class="form_items">
                        出发城市
                        <input class="in_border" type="text" id="txt_jieji_cityinfo" readonly="readonly" />
                    </p>
                    <p class="form_items">
                        机场名称
                        <select id="txt_jieji_airport">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items">
                        出发时间
                        <input id="txt_jieji_startdate" style="width:200px;" class="in_border Wdate" type="text"
                            readonly="readonly" onclick="WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                            onfocus="WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'});" />
                        <%--<input id="txt_jieji_startdate" style="width: 187px;" class="in_border Wdate" type="text" readonly  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                             onfocus="var jiejidate=getMinDatetime($('#towntype').val(),'#txt_jieji_startdate');WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'});" />--%>
                        <%--   <select id="txt_jieji_starthour" onchange="getMinutes($(this).val(),'#txt_jieji_starMinute')">
                            <option value="">时</option>
                        </select>时
                        <select id="txt_jieji_starMinute">
                            <option value="">分</option>
                        </select>分--%>
                    </p>
                    <p class="form_items">
                        目的城市
                        <select id="txt_jieji_mudiprovince">
                            <option>请选择</option>
                        </select>
                        <select id="txt_jieji_mudicity">
                            <option>请选择</option>
                        </select>
                        <select id="txt_jieji_muditown">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items" style="position: relative;">
                        目的地址<input type="text" style="width: 400px;" name="txt_jieji_mudiplace" id="txt_jieji_mudiplace"
                            class="in_border" onkeyup="showFloatLayer($(this).val(),$('#txt_jieji_mudicity option:selected').text(),'0','#jieji_floatLayer','#txt_jieji_endpoint','#txt_jieji_mudiplace','#txt_jieji_mudiplacedetail')" />
                        <input type="hidden" name="txt_jieji_endpoint" id="txt_jieji_endpoint" />
                        <a href="javascript:SelectAddress('jiejie',$('#txt_jieji_mudicity').find('option:selected').text())">
                            百度地图选址</a>
                        <a href="javascript:SelectAddressAmap('jiejie',$('#txt_jieji_mudicity').find('option:selected').text())">
                            高德地图选址</a>
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: auto;
                            z-index: 99999; display: none; width: 300px; position: absolute; top: 348px;
                            left: 78px;" id="jieji_floatLayer">
                        </div>
                    </p>
                    <p>
                        补充地址
                        <input type="text" style="width: 400px;" class="in_border" name="txt_jieji_mudiplacedetail"
                            id="txt_jieji_mudiplacedetail" /></p>
                </div>
                <div class="wrap_bg" id="songji">
                    <p class="form_items">
                        出发城市
                        <input class="in_border" type="text" id="txt_songji_cityinfo" readonly="readonly" />
                    </p>
                    <p class="form_items">
                        出发地址<input type="text" class="in_border" style="width: 500px;" name="txt_songji_placeinfo"
                            id="txt_songji_placeinfo" onkeyup="showFloatLayer($(this).val(),$('#city option:selected').text(),'0','#songji_floatLayer','#txt_songji_startpoint','#txt_songji_placeinfo','#txt_songji_detailplace')" />
                        <input type="hidden" name="txt_songji_startpoint" id="txt_songji_startpoint" />
                        <a href="javascript:SelectAddress('songjis',$('#city option:selected').text())">百度地图选址</a>
                        <a href="javascript:SelectAddressAmap('songjis',$('#city option:selected').text())">
                            高德地图选址</a>
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: auto;
                            z-index: 99999; display: none; width: 300px; position: absolute; top: 198px;
                            left: 78px;" id="songji_floatLayer">
                        </div>
                    </p>
                    <p class="form_items">
                        补充地址
                        <input class="in_border in_width" type="text" id="txt_songji_detailplace" style="width: 500px;" />
                    </p>
                    <p class="form_items">
                        出发时间
                        <input class="in_border"   type="text" readonly onclick="WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                            onfocus="WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'});" id="txt_songji_startdate"
                            style="width: 200px;" />
                    </p>
                    <p class="form_items">
                        目的城市
                        <select id="txt_songji_mudiprovince">
                            <option>请选择</option>
                        </select>
                        <select id="txt_songji_mudicity">
                            <option>请选择</option>
                        </select>
                        <select id="txt_songji_muditown">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items">
                        机场名称
                        <select id="txt_songji_airport">
                            <option>请选择</option>
                        </select>
                    </p>
                </div>
                <div class="wrap_bg" id="rizu">
                    <p class="form_items">
                        出发城市
                        <input class="in_border" type="text" id="txt_rizu_cityinfo" readonly="readonly" />
                    </p>
                    <p class="form_items">
                        出发地点
                        <input type="text" class="in_border" style="width: 500px;" name="txt_rizu_placeinfo"
                            id="txt_rizu_placeinfo" onkeyup="showFloatLayer($(this).val(),$('#city option:selected').text(),'0','#rizu_floatLayer','#txt_rizu_startpoint','#txt_rizu_placeinfo','#txt_rizu_detailplace')" />
                        <input type="hidden" name="txt_rizu_startpoint" id="txt_rizu_startpoint" />
                        <a href="javascript:SelectAddress('rizus',$('#city option:selected').text())">百度地图选址</a>
                         <a href="javascript:SelectAddressAmap('rizus',$('#city option:selected').text())">
                            高德地图选址</a>
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: auto;
                            z-index: 99999; display: none; width: 300px; position: absolute; top: 198px;
                            left: 78px;" id="rizu_floatLayer">
                        </div>
                    </p>
                    <p class="form_items">
                        补充地址
                        <input class="in_border in_width" type="text" id="txt_rizu_detailplace" />
                    </p>
                    <p class="form_items">
                        出发时间
                        <input class="in_border" class="in_border" type="text" style="width: 200px;" readonly 
                        onclick="WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                            onfocus="WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'});" 
                        id="txt_rizu_startdate" />
                       
                    </p>
                    <p class="form_items">
                        目的城市
                        <select id="txt_rizu_mudiprovince">
                            <option>请选择</option>
                        </select>
                        <select id="txt_rizu_mudicity">
                            <option>请选择</option>
                        </select>
                        <select id="txt_rizu_muditown">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items">
                        下车地址
                        <input type="text" class="in_border" style="width: 500px;" name="txt_rizu_mudiplace"
                            id="txt_rizu_mudiplace" onkeyup="showFloatLayer($(this).val(),$('#txt_rizu_mudicity option:selected').text(),'0','#rizu_Mudi_floatLayer','#txt_rizu_endpoint','#txt_rizu_mudiplace','#txt_rizu_mudiplacedetail')" />
                        <input type="hidden" name="txt_rizu_endpoint" id="txt_rizu_endpoint" />
                        <a href="javascript:SelectAddress('rizue',$('#txt_rizu_mudicity').find('option:selected').text())">
                            百度地图选址</a>
                             <a href="javascript:SelectAddressAmap('rizue',$('#txt_rizu_mudicity').find('option:selected').text())">
                            高德地图选址</a>
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: auto;
                            z-index: 99999; display: none; width: 300px; position: absolute; top: 348px;
                            left: 78px;" id="rizu_Mudi_floatLayer">
                        </div>
                    </p>
                    <p class="form_items">
                        详细地址
                        <input type="text" name="txt_rizu_mudiplacedetail" id="txt_rizu_mudiplacedetail"
                            style="width: 500px;" class="in_border" />
                    </p>
                </div>
                <div class="wrap_bg" id="hotline">
                    <p class="form_items">
                        出发城市
                        <input class="in_border" type="text" id="txt_hotline_startcity" readonly="readonly" />
                    </p>
                    <p class="form_items">
                        出发地点<input type="text" class="in_border" style="width: 500px;" name="txt_hotline_startplace"
                            id="txt_hotline_startplace" onkeyup="showFloatLayer($(this).val(),$('#city option:selected').text(),'0','#hotline_start_floatLayer','#txt_hotline_startpoint','#txt_hotline_startplace','#txt_hotline_startplacedetail')" />
                        <input type="hidden" name="txt_hotline_startpoint" id="txt_hotline_startpoint" />
                        <a href="javascript:SelectAddress('hotlines',$('#city option:selected').text())">百度地图选址</a>
                         <a href="javascript:SelectAddressAmap('hotlines',$('#city option:selected').text())">
                            高德地图选址</a>
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: auto;
                            z-index: 99999; display: none; width: 300px; position: absolute; top: 198px;
                            left: 78px;" id="hotline_start_floatLayer">
                        </div>
                    </p>
                    <p class="form_items">
                        补充地址
                        <input class="in_border in_width" type="text" id="txt_hotline_startplacedetail" style="width: 500px;" />
                    </p>
                    <p class="form_items">
                        出发时间
                        <input class="in_border" type="text" style="width: 200px;" readonly onclick="WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                            onfocus="WdatePicker({minDate:jiejidate,dateFmt:'yyyy-MM-dd HH:mm:ss'});"
                            id="txt_hotline_startdate" />
                        
                    </p>
                    <p class="form_items">
                        目的城市
                        <input class="in_border in_width" type="text" id="txt_hotline_mudicityinfo" readonly="readonly" />
                        <input id="txt_hotline_city" type="hidden" />
                    </p>
                    <p class="form_items">
                        下车地址
                        <input type="text" class="in_border" style="width: 500px;" name="txt_hotline_endplaceinfo"
                            id="txt_hotline_endplaceinfo" onkeyup="showFloatLayer($(this).val(),$('#routename').val(),'1','#hotline_end_floatLayer','#txt_hotline_endpoint','#txt_hotline_endplaceinfo','#txt_hotline_endplacedetail')" />
                        <input type="hidden" name="txt_hotline_endpoint" id="txt_hotline_endpoint" />
                        <a href="javascript:SelectAddress('hotlinee',$('#txt_hotline_city').val())">百度地图选址</a>
                         <a href="javascript:SelectAddressAmap('hotlinee',$('#txt_hotline_city').val())">
                            高德地图选址</a>
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: auto;
                            z-index: 99999; display: none; width: 300px; position: absolute; top: 348px;
                            left: 78px;" id="hotline_end_floatLayer">
                        </div>
                    </p>
                    <p>
                        补充地址
                        <input type="text" style="width: 500px;" class="in_border" name="txt_hotline_endplacedetail"
                            id="txt_hotline_endplacedetail" /></p>
                </div>
                <div class="wrap_bg" id="timely">
                    <p class="form_items">
                        出发城市
                        <input class="in_border" type="text" id="txt_timely_startcity" readonly="readonly" />
                    </p>
                    <p class="form_items">
                        出发地点
                        <input type="text" class="in_border" style="width: 500px;" name="txt_timely_placeinfo"
                            id="txt_timely_placeinfo" onkeyup="showFloatLayer($(this).val(),$('#city option:selected').text(),'0','#timelyFloatLayer','#txt_timely_startpoint','#txt_timely_placeinfo','#txt_timely_placeinfodetail')" />
                        <input type="hidden" name="txt_timely_startpoint" id="txt_timely_startpoint" />
                        <a href="javascript:SelectAddress('timelys',$('#city option:selected').text())">百度地图选址</a>
                          <a href="javascript:SelectAddressAmap('timelys',$('#city option:selected').text())">
                            高德地图选址</a>
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: auto; z-index: 99999;
                            display: none; width: 300px; position: absolute; top: 198px; left: 78px;" id="timelyFloatLayer">
                        </div>
                    </p>
                    <p class="form_items">
                        补充地址
                        <input class="in_border in_width" type="text" id="txt_timely_placeinfodetail" />
                    </p>
                    <p class="form_items" style="display: none;">
                        出发时间
                        <input class="in_border" class="in_border" type="text" readonly="readonly" style="width: 200px;"
                            onchange="gettimelyhour($(this).val(), '#txt_timely_starthour')" onfocus="WdatePicker({minDate:'%y-%M-{%d}',dateFmt:'yyyy-MM-dd HH:mm'})"
                            id="txt_timely_startdate" />
                        <%--  <select id="txt_timely_starthour" onchange="gettimelyMinutes($('#txt_timely_startdate').val(),$(this).val(),'#txt_timely_startMinute')">
                            <option value="">时</option>
                        </select>时
                        <select id="txt_timely_startMinute">
                            <option value="">分</option>
                        </select>分--%>
                    </p>
                    <p class="form_items">
                        目的城市
                        <select id="txt_timely_mudiprovince">
                            <option>请选择</option>
                        </select>
                        <select id="txt_timely_mudicity">
                            <option>请选择</option>
                        </select>
                        <select id="txt_timely_muditown">
                            <option>请选择</option>
                        </select>
                    </p>
                    <p class="form_items">
                        下车地址
                        <input type="text" class="in_border" style="width: 500px;" name="txt_timely_mudiplace"
                            id="txt_timely_mudiplace" onkeyup="showFloatLayer($(this).val(),$('#txt_timely_mudicity option:selected').text(),'0','#timelymudiFloatLayer','#txt_timely_endpoint','#txt_timely_mudiplace','#txt_timely_mudiplacedetail')" />
                        <input type="hidden" name="txt_timely_endpoint" id="txt_timely_endpoint" />
                        <a href="javascript:SelectAddress('timelye',$('#txt_timely_mudicity').find('option:selected').text())">
                            百度地图选址</a>

                          <a href="javascript:SelectAddressAmap('timelye',$('#txt_timely_mudicity').find('option:selected').text())">
                            高德地图选址</a>
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: auto; z-index: 99999;
                            display: none; width: 300px; position: absolute; top: 348px; left: 78px;" id="timelymudiFloatLayer">
                        </div>
                    </p>
                    <p class="form_items">
                        详细地址
                        <input type="text" name="txt_timely_mudiplacedetail" id="txt_timely_mudiplacedetail"
                            style="width: 500px;" class="in_border" />
                    </p>
                </div>
                <input type="hidden" name="txtrentcarid" id="txtrentcarid" />
            </div>
            <div class="wrap" id="passangerContainer">
                <h3>
                    乘车人信息</h3>
                <div class="wrap_bg" style="position: relative;">
                    <form action="" method="">
                    <p class="form_items">
                        乘&nbsp;车&nbsp;人
                        <input class="in_border" type="text" id="passenger" value="<%=UserModel==null?"":UserModel.Compname %>"
                            onkeyup="keyUpPassengername($(this).val())" onfocus="getPassengerList()" />
                        <input type="checkbox" id="ismsg" checked="checked" />是否短信通知乘车人
                        <div class="floatLayer" style="background: #fff; border: 1px solid #ddd; height: 200px;
                            overflow: scroll; display: none; width: 320px; position: absolute; top: 40px;
                            left: 50px;" id="floatLayer_passenger">
                        </div>
                    </p>
                    <p class="form_items">
                        手&nbsp;机&nbsp;号
                        <input class="in_border in_width" type="text" id="passengertelphone" value="<%=UserModel==null?"":UserModel.Telphone %>" />
                    </p>
                    <p class="form_items">
                        乘车人数
                        <select id="passengernum">
                        </select>
                    </p>
                    <p class="form_items">
                        特殊要求
                        <input class="in_border in_width" type="text" id="others" />
                    </p>
                    <p class="form_items">
                        <input class="reg_btn" type="button" onclick="makeOrder($('#caruseway').val())" value="提交订单"
                            style="display: inline" />
                        <input class="reg_btn" type="button" onclick="clickToReturn()" value="返回" style="display: inline" />
                    </p>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div id="addwindow" title="地图选址" style="width: 1000px; height: 850px; margin-top:50px;">
    </div>
    <script type="text/javascript">

        function bindWin() {
            $("[id$=window]").window({
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closed: true
            });
        }

        function SelectAddress(id, city) {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/LayerAddressSelect.aspx?controlId=' + id + "&cityName=" + city);
        }
        function SelectAddressAmap(id, city) {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/LayerAddressSelectAmap.aspx?controlId=' + id + "&cityName=" + city);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
        }
    </script>
</body>
</html>
