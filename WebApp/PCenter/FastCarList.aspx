<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true"
    CodeBehind="FastCarList.aspx.cs" Inherits="WebApp.PCenter.FastCarList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="/Scripts/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <style type="text/css">
        a { cursor: pointer; }
        #goOrderDiv { position: absolute; width: 100%; height: 100%; top: 0px; left: 0px; display: none;}
        #orderForm { position:absolute; width: 550px; height: 460px; background-color: White;left: 38%;top: 25%; }
        #orderFormTable td * { float: left; padding: 2px; }
        #zhezhao{position: absolute; width: 100%; height: 100%; top: 0px; left: 0px;background-color:#000; filter:alpha(opacity:80);opacity:0.8;z-index:0;}
    </style>
    <script src="../Scripts/fastCarList.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form action="/payorder.aspx" method="post" id="orderFormPost">
<input type="hidden" name="orderid" id="orderid" />
</form>
    <%foreach (var item in orders)
      {%>
    <div id="jsonString_<%=item.ID %>" rentcarid="<%=item.rentCarID %>" style="display: none">
        <%=Newtonsoft.Json.JsonConvert.SerializeObject(item)%></div>
    <% } %>
    <table class="order_tb" cellpadding="0" cellspacing="0" border="0">
        <tr class="order_tr">
            <td>名字</td>
            <td>上车地址</td>
            <td>下车地址</td>
            <td>操作</td>
        </tr>
        <%foreach (var item in orders)
          {
              string carusewayName ="";
              if (item.carUseWayID==1)
              {
                  carusewayName = "接机";
              }
              else if (item.carUseWayID==2)
              {
                  carusewayName = "送机";
              }
              else if (item.carUseWayID==3)
              {
                  carusewayName = "时租";
              }
              else if (item.carUseWayID==4)
              {
                  carusewayName = "日租";
              }
              else if (item.carUseWayID==5)
              {
                  carusewayName = "半日租";
              }
              else if (item.carUseWayID==7)
              {
                  carusewayName = "随叫随到";
              }
              %>
        <tr id="<%="orderCar_"+item.ID %>">
            <td>
                <%=item.name + "(" + carusewayName + ")"%></td>
            <td>
                <%=item.upAddress %></td>
            <td>
                <%=item.downAddress %></td>
            <td>
            <%if (item.carUseWayID == 7)
              {%>
                    <a href="javascript:alert('不可编辑')">编辑&nbsp;</a>
            <%  }
              else { %>
                 <a href="/pcenter/fastcar.aspx?id=<%=item.ID %>">编辑&nbsp;</a>
            <%  }%>
                <a href="javascript:DeleteQuickOrderCar('<%=item.ID %>')">删除&nbsp;</a><a
                    href="javascript:GoOrderCar('<%=item.ID %>')">马上订车&nbsp;</a></td>
        </tr>
        <%}%>
    </table>
    <a href="fastcar.aspx" class="person-button"><em>添加快捷订车</em></a>
    <div id="goOrderDiv">
       <div id="zhezhao"></div>
        <div id="orderForm">
            <table class="order_tb" cellpadding="0" cellspacing="0" border="0" id="orderFormTable">
                <tr class="order_tr">
                    <td colspan="4">订单信息补充</td>
                </tr>
                <tr>
                    <td><em>时间</em></td>
                    <td colspan="3" >
                        <input type="text" id="shortDate" readonly="readonly" onclick="WdatePicker()" onfocus="WdatePicker({minDate:'%y-%M-{%d}'})"
                            onchange="dateChange($(this))" />
                        <select id="selectHour">
                            <option>时</option>
                        </select>
                        <select id="selectMinutes">
                            <option>分</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><em>备注</em> </td>
                    <td colspan="3" style="color: red">市区订车提前1小时10分钟；郊县订车提前2小时10分钟。</td>
                </tr>
                <tr>
                    <td><em>乘车人数</em> </td>
                    <td colspan="3">
                        <select id="passangerNumbers">
                        </select>
                    </td>
                </tr>
                 <tr id="order_useHour">
                    <td><em>使用时长</em> </td>
                    <td colspan="3">
                        <select id="useHour">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><em>使用优惠券</em> </td>
                    <td >
                        <select id="useCounpons">
                            <option>请选择...</option>
                        </select>
                    </td>
                    <td><em>使用代金券</em> </td>
                    <td >
                        <select id="useVouchers">
                            <option>请选择...</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><em>特殊要求</em> </td>
                    <td colspan="3">
                        <textarea style="width: 240px; height: 80px;resize:none;" id="remarks;"></textarea>
                    </td>
                </tr>
                <tr>
                    <td><em>本次订单金额</em> </td>
                    <td colspan="3"><em style="color: red; font-weight: 700" id="orderMoney">100元</em>
                    </td>
                </tr>
            </table>
            <a href="javascript:cancelOrder()" class="person-button" style="margin-left: 50px;">
                <em style="width: 100px; text-align: center;">取消</em></a>
            <a href="javascript:SubOrder()" class="person-button" style="margin-left: 70px;"><em
                style="width: 100px; text-align: center;">提交</em></a>
        </div>
    </div>
</asp:Content>
