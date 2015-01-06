<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="OrderSentCar.aspx.cs" Inherits="CarAppAdminWebUI.Order.OrderSentCar" %>

<%@ Import Namespace="Model" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <div class="adm_20">
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="adm_45" align="right" height="30" width="15%">
                    乘车人：
                </td>
                <td class="adm_42" width="25%">
                    <%=orderModel.Rows[0]["passengername"] %>
                </td>
                <td class="adm_45" align="right" height="30" width="15%">
                    乘车人电话：
                </td>
                <td class="adm_42" width="25%">
                    <%=orderModel.Rows[0]["passengerphone"] %>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="15%">
                    预约出发时间：
                </td>
                <td class="adm_42" width="40%">
                    <%=orderModel.Rows[0]["departuretime"] %>
                </td>
                <td class="adm_45" align="right" height="30" width="15%">
                    用车类型：
                </td>
                <td class="adm_42" width="25%">
                    <%=orderModel.Rows[0]["typename"] %>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="15%">
                    服务方式：
                </td>
                <td class="adm_42" width="25%" colspan="3">
                    <%=orderModel.Rows[0]["carusewayname"] %>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="15%">
                    上车地址：
                </td>
                <td class="adm_42" width="40%" colspan="3">
                 <%=startplace %>
                    <%=orderModel.Rows[0]["startaddress"] %>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="15%">
                    下车地址：
                </td>
                <td class="adm_42" width="40%" colspan="3">
                    <%=orderModel.Rows[0]["provincename"].ToString() + orderModel.Rows[0]["cityname"].ToString() + orderModel.Rows[0]["townname"].ToString()%>
                    <%=orderModel.Rows[0]["arriveaddress"] %>
                </td>
                <%-- <td class="adm_45" align="right" height="30" width="15%">
                    下车地址：
                </td>
                <td class="adm_42" width="40%">
                
                </td>--%>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="15%">
                    备注：
                </td>
                <td class="adm_42" width="25%" colspan="3">
                    <%=orderModel.Rows[0]["remarks"] %>
                </td>
            </tr>
        </table>
    </div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                可用车辆(此列表仅供参考)
            </td>
        </tr>
    </table>
    <div id="sentcartoolbar" style="padding: 5px; height: auto">
        <div>
            所属城市:
            <select id="province" style="width:200px">
                <option value="">不限</option>
                <%
                    for (int i = 0; i < cityInfo.Rows.Count; i++)
                    {
                        if (cityInfo.Rows[i]["cityname"].ToString().Trim() == startplace)
                        {%>
                <option selected="selected" value="<%=cityInfo.Rows[i]["townid"].ToString() %>"><%=cityInfo.Rows[i]["cityname"].ToString().Trim()%></option>
                <%}
                       else
                       {
                %>
                <option value="<%=cityInfo.Rows[i]["townid"].ToString() %>"><%=cityInfo.Rows[i]["cityname"].ToString().Trim()%></option>
                <%
                       }
                   }
                %>
            </select>
            <input type="hidden" id="orderid" name="orderid" value="<%=Request.QueryString["id"].ToString() %>" />
            服务类型:
            <select id="rc_type" style="width: 100px">
                <option value="">不限</option>
                <option value="A">热门线路</option>
                <option value="B">其他</option>
            </select>
            车辆状态:
            <select id="rc_carstatustype" style="width: 100px">
                <option value="">不限</option>
                <option value="1">工作中</option>
                <option value="2">离开或请假</option>
                <option value="3" selected="selected">可以接单/空闲中</option>
                <option value="4">已出发</option>
                <option value="5">已经就位</option>
                <option value="6">订单已接取</option>
                    <option value="8">租出</option>
            </select>
            车辆类型:
            <select id="rc_cartype" style="width: 100px">
                <option value="">不限</option>
                <% foreach (var m in list)
                   {
                       if (m.typeName.Trim() == orderModel.Rows[0]["typename"].ToString().Trim())
                       {%>
                <option value="<%=m.id %>" selected="selected"><%=m.typeName %></option>
                <%}
                       else
                       {%>
                <option value="<%=m.id %>"><%=m.typeName %></option><%}
                %>
                <%
                   } %>
            </select>
           车牌号： <input type="text" name="carno"  id="carno" style="width: 50px;"/>
            <input type="button" onclick="onRentCarSearch()" value="搜索" />
        </div>
    </div>
    <div style="padding-top: 5px;">
        <table border="0" cellpadding="0" cellspacing="0" width="95%">
            <tr>
                <td style="width: 100%; padding-left: 5px;" valign="top">
                    <table id="gd1">
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div id="postionlist" class="easyui-window" title="车辆信息" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 500px; height: 200px;">
    </div>
    <!--toolbar-->
    <!--toolbar-->
    <script type="text/javascript" src="/Static/artDialog/jquery.artDialog.js?skin=blue"></script>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
         
        });
        function resizeTable() {
            var height = ($(window).height() - 180);
            $("#gd1").css("height", height); 
        }
      
        function fordercount(value, rows, index) {
        if (rows.CountOrder == 0) {
            return value;
        }
            return "<b style=\"color:red\">"+value+"("+rows.CountOrder+")</b>";
        }
        function fcaruseway(value,row,index) {
            if (value == "A") {
                return '热门线路';
            } else {
                return '其它';
            }
        }
        function fid(value,row,index) {
            return '<a href="javascript:void(0);" onclick="onCarTable(\'' + row.Id + '\')">查看行程</a>';
        }

        function getSeachText() {
            var rcType = $("#rc_type").val();
            var rcCartype = $("#rc_cartype option:selected").text();
            var townid = $("#province  option:selected").text();
            if (townid == '不限') {
                townid = '';
            }
            if (rcCartype == '不限') {
                rcCartype = '';
            }
            var rcCarstatustype = $("#rc_carstatustype").val();
            var d = "townid="+townid+"&type=" + rcType + "&cartype=" + rcCartype + "&carstatus=" + rcCarstatustype+"&id=<%=Request.QueryString["id"] %>&carno="+$("#carno").val();
            return d;
        }

        function onRentCarSearch() {
            var d = getSeachText();
               $("#gd1").datagrid("options").url = "/Order/OrderHandler.ashx?action=carlist&" +d;
               $("#gd1").datagrid("load");
        }

        /* 车辆行程 */
        function onCarTable(id) {
            art.dialog({
                width: '800px',
                title: '车辆行程信息(从现在开始)',
                content: ' <iframe style="border:0px;width:850px; height:500px;" frameborder="0" src="/Car/CarTable.aspx?id=' + id + '"></iframe>',
                padding: 0,
                zIndex:8000000
            });
        }

        //绑定数据表格
        function bindGrid() {
            $('#gd1').datagrid({
                url: "/Order/OrderHandler.ashx?action=carlist&"+getSeachText(),
                method: 'post',
                title: "可用车辆列表",
                pageList: [10, 30, 45, 60],
                pageSize: 10,
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                toolbar:"sentcartoolbar",
                height: 500,

                columns: [
                    [  { field: 'action', title: '操作', formatter: faction,width:100 },
                        { field: "Id", title: "查看行程", width: 100, formatter: fid },
                        { field: 'carWorkStatus', title: '状态', formatter: fstatus, width: 90 },
                        { field: 'CarNo', title: '车牌', width: 100, formatter: fordercount },
                          { field: 'CarType', title: '车辆类型', width: 100, formatter: fordercount },
                           { field: 'CarUseWay', title: '用车方式', width: 100, formatter: fcaruseway },
                        { field: 'Name', title: '名称', width: 150 },
                        { field: 'telPhone', title: '车辆电话', width: 100 },
//                    {field:"Distance",title:"距离出发地（km）",width:100},
                        { field: 'DriverName', title: '司机姓名', width: 100 },
                        { field: 'DriverPhone', title: '司机电话', width: 100 },
                         { field: 'Vid', title: '当前位置', width:450,formatter:fcurrentposition}
//                         { field: 'GpsTime', title: 'GPS上传时间', width:150 }
                    ]
                ] 
           });
            
        }
        function fcurrentposition(value,row,index) {
        if (value == "") {
            return "暂无GPS信息";
        }
            return "<a href='javascript:onShowCurrentPosition(\""+value+"\");'>[点击查看]<a>";
        }
        function onShowCurrentPosition(value) {
        $("#postionlist").html("数据加载中");
            $('#postionlist').window('open');
            $.get("/order/orderhandler.ashx?action=currentposition&vid=" + value, function(data) {
                if (data.resultcode == 0) {
                    $("#postionlist").html(data.msg);
                }else {
                    var html = "";
                    html += "<ul style='padding:0;margin:0;'>";
                    html += "<li><b>当前位置：</b>"+data.data.calist[0].position+"</li>";
                    html += "<li><b> 位置时间：</b>"+data.data.calist[0].gpstime+"</li>"; 
                    html += "</ul>";
                       $("#postionlist").html(html);
                }
            }, "json");
        }
        function fcaruseway(value, row, index) {
            if (value == "A") {
                return "热门路线";
            } else {
                return "其它";
            }
        }
        function fstatus(value,row,index) {
            var arr = new Array("工作中", "离开或请假", "空闲中", "已出发", "已经就位", "订单已接取","","租出");
            return arr[value - 1];
        }

        function faction(value,row,index) {
            return '<a href="javascript:void(0);" onclick="RunAction(\'' + row.Id + '\')">点击派车</a>';
        }

        function onSelect(id) {
            $('#carid').combogrid('setValue', id);
        }

        function onSubmit(){
            var carid =  $('#carid').combogrid('getValue');
            if (carid == "") {
                showValidateMessage("请选择要派遣的车辆");
                return;
            }
            var grid=$("#carid").combogrid("grid");
            var row = grid.datagrid('getSelected');
            var orderCarTypeId = '<%=carTypeId %>';
            if (orderCarTypeId != row.CarTypeId) {
                $.messager.confirm("提示", "你选派的车辆和订单预订车辆类型不符，你确定要执行此操作么？", function(r) {
                    if (r) {
                        RunAction(carid);
                    }
                });
            } else {
                RunAction(carid);
            }
        }

        function RunAction(carid) {
            $.messager.confirm("提示信息", "确认派车吗？", function(r) {
            if (r) {
                  var d = { "action": "sentcar", "id": "<%=Request.QueryString["id"] %>", "carid": carid };
                  $.post("/Order/OrderHandler.ashx", d, function(data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', "车辆派遣成功", 'info', function() {
                            onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
              
            });

        }
    </script>
</asp:Content>
