<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyFunding.aspx.cs" Inherits="WebApp.PCenter.MyFunding" %>
<%@ Import Namespace="System.Data" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            $("#A_ShowRule").click(function () {
                $(this).hide();
                $(".P_Hint div").show();
                $(".P_Hint span").show();
            });
            $("#A_HiddenRule").click(function () {
                $("#A_ShowRule").show();
                $(".P_Hint div").hide();
            });
        });
   //ajax分页
        function GetPage(where) {
            var pageSize = 10;
            var type = $("#type").val();
           
            $(".person-tab-order a").each(function () {
                if ($(this).index() == (type-1)) {
                    $(this).addClass("per-order-active");
                } else {
                    $(this).removeClass("per-order-active");
                }
            });

            var pageIndex = parseInt($("#curpage").val());
            var totalpage =parseInt($("#total").html());
            
            switch (where) {
                case "first":
                    pageIndex = 1;
                    break;
                case "pre":
                    if (pageIndex > 1)
                        pageIndex = pageIndex - 1;
                    else
                        return;
                    break;
                case "next":
                    if (pageIndex < totalpage)
                        pageIndex = pageIndex+1;
                    else
                        return;
                    break;
                case "last":
                    pageIndex = totalpage;
                    break;
                default:
                    pageIndex = parseInt(where);
                    break;
            }

            $.ajax({
                url: "MyFunding.aspx",
                data: { DateLL: $("#Text_DateLL").val(), DateUL: $("#Text_DateUL").val(), pageIndex: pageIndex, Type: type },
                type: "post",
                dataType: "json",
                success: function (data) {
                    var list = data.data;
                    var rowCount = data.rowCount;
                    var html = "<tr class='order_tr'><td>编号</td><td>代金券面值</td><td>生效日期</td> <td>失效日期</td><td>状态</td><td>对应订单</td><td>使用时间</td></tr>";
                    for (i = 0; i < list.length; i++) {
                        html += "<tr><td>" + list[i].Id + "</td><td>" + list[i].Cost + " 元</td><td>" + list[i].StartTime.split("T")[0] + "</td>";
                        html += "<td>" + list[i].EndTime.split("T")[0] + "</td>";
                        html += "<td>" + list[i].Status + "</td><td>";
                        if (list[i].OrderId != "")
                            html += "<a href='MyOrdersInfo.aspx?OrderId=" + list[i].OrderId + "'>" + list[i].OrderId + "</a>";
                        if (list[i].UseTime == null) {
                            html += "</td><td></td></tr>";
                        }
                        else {
                            html += "</td><td>" + list[i].UseTime.split("T")[0] + " "+list[i].UseTime.split("T")[1].substr(0,8) + "</td></tr>";
                        }

                    }

                    $("#curpage").val(pageIndex);
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
                GetPage(pageIndex);
        }
        function showFunding() {
            $("#goOrderDiv").fadeIn(300);
        }
        function cancelFunding() {
            $("#goOrderDiv").fadeOut(300);
        }
        function submit() {
            if (confirm("确认要提交吗？")) {
                var rules = $("#rulesId").val();
            var times = $("#times").val();
            $.post("api/fundingHandler.ashx", {"action":"submit", "rulesId": rules, "times": times }, function (data) {
                if (data == "failure") {
                    alert("数据传递错误!");
                }
                else {
                    alert("恭喜转入成功！点击确定后刷新页面")
                    window.location.reload();
                }
            });
            }
        }
    </script>
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
            height: 400px;
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <div class="article clearfix">
        
        <span class="fleft" style="font: bold 14px/30px 'arial','宋体'; color: #999; ">活动余额：<em
            class="price-num"><%=FundingMoney %></em>元</span> <a href="javascript:void()" onclick="showFunding()" style="margin-left:10px;"
                class="person-button"><em>申请存费返券活动</em></a>
</div>
   <div class="P_Hint">
        <em>活动简介：</em>存车费每月可免费返赠代金券。  <a href="javascript:;" id="A_ShowRule">查看详情</a><br />
        <div style="display:none;">
        如您在爱易租账户中的资金长时间不用，即可申请返赠代金劵，只需将账户资金转入定期账户中（金额和时间由您根据自己的情况确定），即可得到相应的代金券。代金劵不能与优惠劵同时使用，每次限用一张。请关注您的代金券账户，在代金券的有效期内使用。了解更多详情请咨询客服：0311-85119999。
        <a href="javascript:;" id="A_HiddenRule">收起</a></div>
    </div>
    <div class="article article-padding">
        <h3 class="per-order-til">
            记录<a href="MyFundingList.aspx" target="_blank" style="font-size:12px; font-weight:normal; float:right; margin-right:10px;">查看更多</a></h3>
       
              <table id="fundingList"  class="order_tb" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td>
                    金额
                </td>
                <td>存入日期</td>
                <td>
                    到期日期
                </td>
                <td>
                    生效日期
                </td>
                <td>
                    状态
                </td>
                <td>
                    退款日期
                </td>
                <td>
                    每月返券数
                </td>
                <td>
                    单券面值
                </td>
            </tr>
            <%foreach (DataRow row in fundingList.Rows)
            {
                %>
                <tr><td><%=row["Amount"]%>元</td><td><%=Convert.ToDateTime(row["InDate"]).ToString("yyyy-MM-dd")%> </td>
                 <td><%=Convert.ToDateTime(row["ExpirationDate"]).ToString("yyyy-MM-dd")%></td><td><%=Convert.ToDateTime(row["CreateTime"]).ToString("yyyy-MM-dd")%></td>
               <td><%=row["Status"] %></td><td><%=row["OutDate"].ToString() == "" ? "" : Convert.ToDateTime(row["OutDate"]).ToString("yyyy-MM-dd")%></td>
                <td><%=row["Num"] %></td><td><%=row["Cost"]%></td></tr>
                <%
            } %>
        </table>
    </div>
    <div class="article article-padding per-border-none">
        <h3 class="per-til-h3">
            我的代金券</h3>
        <div class="person-tab-order">
            <a style="width:88px; text-align:center;" href="javascript:$('#type').val('1');GetPage(1);" class="per-order-active">可用（<%=vouCount.Rows[0]["unUse"]%>）</a> 
            <a style="width:88px; text-align:center;" href="javascript:$('#type').val('2');GetPage(1);">
                已用（<%=vouCount.Rows[0]["used"]%>）</a> 
            <a style="width:88px; text-align:center;" href="javascript:$('#type').val('3');GetPage(1);">失效（<%=vouCount.Rows[0]["expired"]%>）</a>
                <input style=" display:none;" id="type" value="1" />           
        </div>
        <div style=" height:auto;">
        <table id="acList"  class="order_tb" cellpadding="0" cellspacing="0" border="0">
            <tr class="order_tr">
                <td>
                    编号
                </td>
                 <td>代金券面值</td>
                <td>
                    生效日期
                </td>
                <td>
                    失效日期
                </td>
               
                <td>
                    状态
                </td>
                <td>
                    对应订单
                </td>
                <td>
                    使用时间
                </td>
            </tr>
            <%foreach (DataRow row in vouchers.Rows)
            {
                %>
                <tr><td><%=row["Id"] %></td><td><%=row["Cost"] %> 元</td><td><%=Convert.ToDateTime(row["StartTime"]).ToString("yyyy-MM-dd")%></td><td><%=Convert.ToDateTime(row["EndTime"]).ToString("yyyy-MM-dd")%></td><td><%=row["Status"] %></td>
                <td><%=row["OrderId"] %></td><td><%=row["UseTime"].ToString() == "" ? "" : Convert.ToDateTime(row["UseTime"]).ToString("yyyy-MM-dd HH:mm:ss")%></td><td></td></tr>
                <%
            } %>
        </table>
        </div>
        <div id="pager" style="text-align:center; <%if(totalPage<=1){%> display:none;<% }%>  ">
        <a style="cursor:pointer;" onclick="GetPage('first')">首页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('pre')">上一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('next')">下一页</a>&nbsp;&nbsp;
        <a style="cursor:pointer;" onclick="GetPage('last')">末页</a>&nbsp;&nbsp;

        当前页：<input id="curpage" style="width:20px;" value="1" onkeyup="value=value.replace(/\D/g,'')" /><button type="button" onclick="GoPage()">跳</button> &nbsp;&nbsp;&nbsp;&nbsp;共<span id="total"><%=totalPage%></span>页
        </div>
    </div>
      <div id="goOrderDiv">
        <div id="zhezhao">
        </div>
        <div id="orderForm">
            <table class="order_tb" cellpadding="0" cellspacing="0" border="0" id="orderFormTable">
                <tr class="order_tr">
                    <td colspan="2">
                        存费免费赠券活动
                    </td>
                </tr>
                <tr>
                    <td style="width:60px;">
                        <em>账户余额</em>
                    </td>
                    <td>
                     <span><%=userMoney %>元</span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>转入金额</em>
                    </td>
                    <td>
                        <%if (list.Count == 0) { Response.Write("<span>对不起，存费赠券活动1000元起,如果想参加此活动，请先给账户充值</span>"); }
                       else { %>
                         <select id="rulesId" name="rulesId" style=" height:25px;">
                    
                     <%foreach (var rules in list) { %>
                          <option value="<%=rules.Id %>"><%=rules.ReferencePrice %>元（每月返<%=rules.Cost %>元券<%=rules.Num %>张）</option>  
                        <%} %>
                    </select>
                       <%}
                         %>
                    </td>
                </tr>
                <tr>
                    <td>
                        <em>转入期限</em>
                    </td>
                    <td>
                       <select id="times" name="times">
                       <option value="1">1个月</option>
                         <option value="2">2个月</option>
                           <option value="3">3个月</option>
                             <option value="6">6个月</option>
                               <option value="9">9个月</option>
                                 <option value="12">1年</option>
                                   <option value="24">2年</option>
                       </select>
                    </td>
                </tr>
               
            </table>
            <span style=" font-size:12px; color:red;">注意：提交后，转入资金将被冻结，时间到期后，自动返回到用户账户余额</span>
            <br />
            <a href="javascript:submit()" class="person-button" style="margin-left: 65px;">
                <em style="width: 80px; text-align: center;">提交</em></a>
            <a href="javascript:cancelFunding()" class="person-button" style="margin-left: 10px;">
                <em style="width: 80px; text-align: center;">关闭</em></a>
        </div>
    </div>
</asp:Content>
