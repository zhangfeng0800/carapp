<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="MyAccount.aspx.cs" Inherits="WebApp.PCenter.MyAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        a
        {
            cursor: pointer;
        }
        #goOrderDiv
        {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0px;
            left: 0px;
            display: none;
        }
        #orderForm
        {
            position: absolute;
            width: 350px;
            height: 350px;
            background-color: White;
            left: 38%;
            top: 25%;
            padding: 10px;
        }
        #orderFormTable td *
        {
            float: left;
            padding: 2px;
        }
        #zhezhao
        {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0px;
            left: 0px;
            background-color: #000;
            filter: alpha(opacity:80);
            opacity: 0.8;
            z-index: 0;
        }
    </style>
    <script src="../Scripts/SelectDate.js" type="text/javascript"></script>
    <script type="text/javascript">
        function compareTime(a, b) {
            if (a == "" || b == "") {
                return false;
            }
            var arr = a.split("-");
            var starttime = new Date(arr[0], arr[1], arr[2]);
            var starttimes = starttime.getTime();

            var arrs = b.split("-");
            var lktime = new Date(arrs[0], arrs[1], arrs[2]);
            var lktimes = lktime.getTime();

            if (starttimes > lktimes) {
                return false;
            } else {
                return true;
            }
        }
        $(document).ready(function () {
            $("#Button_Query").click(function () {
                if (!compareTime($("#Text_DateLL").val(), $("#Text_DateUL").val())) {
                    alert("开始时间应小于结束时间");
                    return false;
                }
                GetPage(0);
            });
        });

        //ajax分页
        function GetPage(where) {
            var pageSize = 5;
            var type = $("#type").val();
            var Type = 0;
            if (type == "true")
                Type = 1;
            else if (type == "false")
                Type = 2;
            $(".person-tab-order a").each(function () {
                if ($(this).index() == Type) {
                    $(this).addClass("per-order-active");
                } else {
                    $(this).removeClass("per-order-active");
                }
            });

            var pageIndex = parseInt($("#curpage").val());
            var totalpage =parseInt($("#total").html());
            
            switch (where) {
                case "first":
                    pageIndex = 0;
                    break;
                case "pre":
                    if (pageIndex > 1)
                        pageIndex = pageIndex - 2;
                    else
                        return;
                    break;
                case "next":
                    if (pageIndex < totalpage)
                        pageIndex = pageIndex;
                    else
                        return;
                    break;
                case "last":
                    pageIndex = totalpage - 1;
                    break;
                default:
                    pageIndex = parseInt(where);
                    break;
            }

            $.ajax({
                url: "MyAccount.aspx",
                data: { DateLL: $("#Text_DateLL").val(), DateUL: $("#Text_DateUL").val(), UserID: GetSelectValue("Select_Member"), pageIndex: pageIndex, Type: type },
                type: "post",
                dataType: "json",
                success: function (data) {
                    var list = data.data;
                    var rowCount = data.rowCount;
                    var html = "<tr class='order_tr'><td>流水号</td><td>流水时间</td><td>收入（元）</td><td>支出（元）</td><td>账户余额（元）</td><td>操作</td><td>订单号</td></tr>";
                    for (i = 0; i < list.length; i++) {

                        var arr = list[i].Datetime.split("T"); //组合时间展示格式
                        var date = arr[0].split("-");
                        var time = arr[1].substring(0, 8);

                        html += "<tr><td>" + list[i].AccountNumber + "</td><td>" + date[0] + "-" + date[1] + "-" + date[2] + " " + time + "</td>";
                        if (list[i].Type == 1)//表示收入
                            html += "<td>+" + list[i].Money + "</td>";
                        else
                            html += "<td>+0</td>";
                        if (list[i].Type == 0)
                            html += "<td>-" + list[i].Money + "</td>";
                        else
                            html += "<td>-0</td>";
                        html += "<td>" + list[i].Balance + "</td>";
                        if (list[i].TransId != 0 && list[i].TransId != null) {
                            html += "<td> <a href='javascript:showTransInfo(" + list[i].TransId + ")'>" + list[i].Action + "</a></td><td>";
                        }
                        else {
                            html += "<td>" + list[i].Action + "</td><td>";
                        }
                        if (list[i].OrderId != "")
                            html += "<a href='MyOrdersInfo.aspx?OrderId=" + list[i].OrderId + "'>" + list[i].OrderId + "</a>";
                        html += "</td></tr>";
                    }

                    $("#curpage").val(pageIndex + 1);
                    if (rowCount / pageSize > parseInt(rowCount / pageSize))
                        $("#total").html(parseInt(rowCount / pageSize) + 1);
                    else
                        $("#total").html(parseInt(rowCount / pageSize));
                    $("#acList").html(html);
                    if (rowCount > pageSize)
                        $("#pager").show();
                    else {
                        $("#pager").hide();
                    }

                },
                error: function (data) {
                    alert("error");
                }
            })
        }
        function GoPage() {
            var pageIndex = $("#curpage").val();
            var totalpage = parseInt($("#total").html());
            if (pageIndex < 1 || pageIndex > totalpage) {
                alert("对不起，页码超出范围！");
                return;
            }
            else
                GetPage(pageIndex-1);
        }
        function showTransInfo(id) {    
            $.post("api/TransHandler.ashx", { "action": "getTransData", "id": id }, function (data) {
                if (data.StatusCode == 1) {
                    var model = data.Data;
                    $("#money").html(model.money + " 元");
                    $("#fromTel").html(model.fromTel);
                    $("#toTel").html(model.toTel);
                    $("#fromName").html(model.fromName);
                    $("#toName").html(model.toName);            
                    $("#oprator").html(model.oprator);
                    $("#createTime").html(model.createTime.substr(0, 19).replace('T', ' '));
                    $("#goOrderDiv").fadeIn(300);
                }
                else {
                    alert(data.Message);
                }
            }, "json");
        }
        function cancelDriver() {
            $("#goOrderDiv").fadeOut(300);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="article clearfix">
    <div style=" float:left; height:100px; width:100px; border:1px solid #ccc; ">
        <img height="100px" width="100px" src='<%= string.IsNullOrEmpty(userAccount.headPic)?"/headPic/HeadPic.gif":userAccount.headPic %>' />
    </div>
    <div style=" margin-top:15px; float:left; margin-left:10px; line-height:40px;">
        <span style="font: bold 16px/30px 'arial','宋体'; color: #999;">欢迎您，<a style="color: #f90;" href="MyInfo.aspx"><%=userAccount.Compname %></a><span style="font-size:14px; margin-left:30px;">级别：<a style="color: #f90;" href="/Score.aspx"><%=level.Name%></a>&nbsp;&nbsp;积分：<a style="color: #f90;" href="/Score.aspx"><%=userAccount.score%></a></span></span><br /><span class="fleft" style="font: bold 14px/30px 'arial','宋体'; color: #999; margin-top:10px;">账户余额：<em
            class="price-num"><%=UB.GetMaster(userAccount.Id).Balance.ToString("0.00")%></em>元</span>
            <a href="MyAccountRecharge.aspx" style="margin-top:10px;"
                class="person-button"><em>在线充值</em></a> <a href="MyGiftCardGet.aspx" class="person-button" style="margin-top:10px;">
                    <em>充值卡充值</em></a> <a style="margin-top:10px;" href="MyCouponGet.aspx" class="person-button"><em>兑换优惠券</em></a>

                    <%if (userAccount.isvip == "是") { 
                      %><a style="margin-top:10px;" href="UserTransMoney.aspx" class="person-button"><em>用户转账</em></a><%
                      } %>
    </div>
    </div>
    <div class="article article-padding">
        <h3 class="per-order-til">
            流水记录查询</h3>
        <div class="per-order-bg">
            流水时间：
            <input id="Text_DateLL" class="Input_TM W_S H_XXS" type="text" onclick="fPopCalendar(event,this,this)"
                onfocus="this.select()" readonly="readonly" />
            至
            <input id="Text_DateUL" class="Input_TM W_S H_XXS" type="text" onclick="fPopCalendar(event,this,this)"
                onfocus="this.select()" readonly="readonly" />
            人员：
            <select id="Select_Member">
                <% for (int i = 0, max = UserList.Count; i < max; i++)
                   { %>
                <option value="<%=UserList[i].Id%>">
                    <%=UserList[i].Compname%></option>
                <%}%>
            </select>
            <script type="text/javascript">                SetSelectValue('Select_Member', GetQueryString('UserId'))</script>
            <input class="per-btn-chaxun" type="button" value="查询" id="Button_Query" />
        </div>
    </div>
    <div class="article article-padding per-border-none">
        <h3 class="per-til-h3">
            账户流水</h3>
        <div class="person-tab-order">
            <a style="width:88px; text-align:center;" href="javascript:$('#type').val('null');GetPage(0);" class="per-order-active">全部（<%=TypeArray[0] %>）</a> 
            <a style="width:88px; text-align:center;" href="javascript:$('#type').val('true');GetPage(0);">
                存入（<%=TypeArray[1] %>）</a> 
            <a style="width:88px; text-align:center;" href="javascript:$('#type').val('false');GetPage(0);">支出（<%=TypeArray[2] %>）</a>
                <input style=" display:none;" id="type" />
                
               
        </div>
        <div style=" height:200px;">
        <table id="acList"  class="order_tb" cellpadding="0" cellspacing="0" border="0">
            <tr class="order_tr">
                <td>
                    流水号
                </td>
                <td>
                    流水时间
                </td>
                <td>
                    收入（元）
                </td>
                <td>
                    支出（元）
                </td>
                <td>
                    账户余额（元）
                </td>
                <td>
                    操作
                </td>
                <td>
                    订单号
                </td>
            </tr>
            <% for (int i = 0, max = AccoList.Count; i < max; i++)
               { %>
            <tr>
                <td>
                    <%=AccoList[i].AccountNumber %>
                </td>
                <td>
                    <%=AccoList[i].Datetime.ToString("yyyy-MM-dd HH:mm:ss") %>
                </td>
                <td>
                    +<%=AccoList[i].Type==Common.PayType.Income ? AccoList[i].Money:0%></td>
                <td>
                    -<%=AccoList[i].Type==Common.PayType.Pay ? AccoList[i].Money : 0%></td>
                <td>
                    <%=AccoList[i].Balance %>
                </td>
                <td>
                    <%if (AccoList[i].Action == "用户转入" || AccoList[i].Action == "用户转出")
                      { 
                      %>
                      <a  href="javascript:showTransInfo(<%=AccoList[i].TransId %>)"><%=AccoList[i].Action%></a>
                      <%
                        }
                      else
                      { Response.Write(AccoList[i].Action); }%>
                </td>
                <td>
                    <%if (AccoList[i].OrderId != "")
                      { %>
                    <a href="MyOrdersInfo.aspx?OrderId=<%=AccoList[i].OrderId%>">
                        <%=AccoList[i].OrderId%></a>
                    <%}%>
                </td>
            </tr>
            <% } %>
        </table>
        </div>
        <div id="pager" style="text-align:center; <%if(totalPage<=1){%> display:none;<% }%>  ">
        <a style="cursor:pointer;" onclick="GetPage('first')">首页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('pre')">上一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('next')">下一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('last')">末页</a>&nbsp;&nbsp;

        当前页：<input id="curpage" style="width:20px;" value="1" onkeyup="value=value.replace(/\D/g,'')" /><button type="button" onclick="GoPage()">跳</button> &nbsp;&nbsp;&nbsp;&nbsp;共<span id="total"><%=totalPage%></span>页
        </div>
     <%--   <script type="text/javascript">PageSet(5, <%=MaxCount %>);</script>--%>
    </div>

      <div id="goOrderDiv">
        <div id="zhezhao">
        </div>
        <div id="orderForm">
            <table class="order_tb" cellpadding="0" cellspacing="0" border="0" id="orderFormTable">
                <tr class="order_tr">
                    <td colspan="4">
                        转账信息
                    </td>
                </tr>
                 <tr>
                    <td>
                        <em>变动金额</em>
                    </td>
                    <td>
                        <span id="money"></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>转出账户</em>
                    </td>
                    <td>
                        <span id="fromTel"></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>转出账户姓名</em>
                    </td>
                    <td>
                        <span id="fromName"></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>转入账户</em>
                    </td>
                    <td>
                      <span id="toTel"></span>
                    </td>
                </tr>
                <tr id="order_useHour">
                    <td>
                        <em>转入账户姓名</em>
                    </td>
                    <td>
                       <span id="toName"></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>操作人</em>
                    </td>
                    <td>
                        <span id="oprator"></span>
                    </td>
                </tr>
                    <tr>
                    <td>
                        <em>操作时间</em>
                    </td>
                    <td>
                        <span id="createTime"></span>
                    </td>
                </tr>
    
            </table>
            <br />
            <a href="javascript:cancelDriver()" class="person-button" style="margin-left: 115px;">
                <em style="width: 100px; text-align: center;">关闭</em></a>
        </div>
    </div>

</asp:Content>
