<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="UserAccountDetail.aspx.cs" Inherits="CarAppAdminWebUI.Member.UserAccountDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<style type="text/css">
        .mychat{ margin-right:40px;} 
        .mychat li{ line-height:30px;}
        .mychat .date{ float:right;  color:#a3a3a3; width:150px;}
        .mychat .leave{ background-color:#eaf2ff; height:auto;}
       </style> 

    <div class="adm_20" style="min-width: 700px; height: 100%; margin-left: 0px; padding: 0px;">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" id="detailContainer">
            <tr>
                <td style="width: 100%;" valign="top">
                    <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td class="mytitle" colspan="6">
                                当前位置：会员详细信息
                            </td>
                        </tr>
                        <tr>
                            <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                真实\集团姓名：
                                <%=UserModel.Compname %>
                            </td>
                            <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                昵称：
                                <%=UserModel.Username %>
                            </td>
                            <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                性别：
                                <%=Convert.ToBoolean(UserModel.sex)?"男":"女" %>
                            </td>
                            <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                手机号码：
                                <%=UserModel.Telphone %>
                            </td>
                            <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                固定电话：
                                <%=UserModel.Tel == "" ? "暂无" : UserModel.Tel%>
                            </td>
                            <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                            </td>
                            </>
                            <tr>
                                <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                    账户余额：
                                    <%=UserModel.Balance %>元
                                </td>
                                <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                    积分：
                                    <%=UserModel.score %>分
                                </td>
                                <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                    邮箱地址：
                                    <%=UserModel.Email %>
                                </td>
                                <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                    用户类型：
                                    <%=GetUserType(UserModel.Type) %>
                                </td>
                                <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                    创建人：
                                    <%=UserModel.Creater == "" ? "无" : UserModel.Creater%>
                                </td>
                                <td class="adm_45" align="right" height="30" style="padding-right: 5px;">
                                    注册时间：
                                    <%=UserModel.registTime%>
                                </td>
                            </tr>
                    </table>
                </td>
                <td valign="top" style="padding-left: 15px; width: 35%;">
                </td>
            </tr>
        </table>
        <div class="easyui-tabs" id="tabs">
            <div title="流水记录" style="padding: 10px">
                <table id="gd1">
                </table>
            </div>
            <div title="订单记录" style="padding: 10px">
                <table id="gd2">
                </table>
            </div>
              <div title="资金记录" style="padding: 10px">
                <table id="gd5">
                </table>
            </div>
            <div title="代金券记录" style="padding: 10px">
                <table id="gd3">
                </table>
            </div>
            <div title="优惠券记录" style="padding: 10px">
                <table id="gd4">
                </table>
            </div>
             <div title="评价记录" style="padding: 10px">
                <table id="gd7">
                </table>
            </div>
              <div title="留言记录" style="padding: 10px">
                <table id="gd6">
                </table>
            </div>
            
        </div>

         <div id="rechargewindow" title="充值卡信息" style="width: 420px; height: 150px;">

         <table class="adm_8" style="width:100%;"><tr><td  class="adm_45">充值卡ID：<span id="cardId"></span></td><td  class="adm_45">充值名称：<span id="cardname"></span></td></tr>
         <tr><td  class="adm_45">充值卡面值：<span id="cardcost"></span></td><td  class="adm_45">使用时间：<span id="usetime"></span></td></tr>
             <tr><td  class="adm_45">序列号：<span id="cardsn"></span></td><td  class="adm_45">领卡人：<span id="saleman"></span></td></tr>
          <tr><td  class="adm_45">充卡人：<span id="rechargeman"></span></td><td  class="adm_45">操作人：<span id="creator"></span></td></tr>
   
         </table>

        </div>
        
        <div id="Transwindow" title="用户转账信息" style="width: 420px; height: 150px;">
        <table class="adm_8" style="width:100%;">
         <tr><td  class="adm_45">变动金额：<span id="money"></span></td><td  class="adm_45"><span id="Span2"></span></td></tr>
         <tr><td  class="adm_45">转出账户：<span id="fromTel"></span></td><td  class="adm_45">转入账户：<span id="toTel"></span></td></tr>
         <tr><td  class="adm_45">转出账户姓名：<span id="fromName"></span></td><td  class="adm_45">转入账户姓名：<span id="toName"></span></td></tr>
             
         <tr><td  class="adm_45">操作人：<span id="oprator"></span></td><td  class="adm_45">操作时间：<span id="createTime"></span></td></tr>
    
         </table>
        </div>

    </div>
     <div id="editwindow" title="回复" style="width: 1000px; height: 660px;">
    </div>
      <div id="w" class="easyui-window" title="评价详情" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 500px; height: 350px;">
        <span id="remarkcontainer" style="padding: 10px;"></span>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeGrid();
            bindGrid();
            bindWin();
        });
        function bindWin() {
            $("[id$=window]").window({
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closed: true
            });
        }
        function resizeGrid() {
            var width = $(window).width();
            var height = $(window).height() - $("#detailContainer").height();
            $("#gd1").css("height", height - 60);
            $("#gd2").css("height", height - 60);
            $("#gd1").css("width", width - 20);
            $("#gd2").css("width", width - 20);
            $("#tabs").css("height", height - 20);
            $("#tabs").css("width", width);
            $("#gd3").css("height", height - 60);
            $("#gd3").css("width", width - 20);
            $("#gd4").css("height", height - 60);
            $("#gd4").css("width", width - 20);
            $("#gd5").css("height", height - 60);
            $("#gd5").css("width", width - 20);
            $("#gd6").css("height", height - 60);
            $("#gd6").css("width", width - 20);
            $("#gd7").css("height", height - 60);
            $("#gd7").css("width", width - 20);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gd1').datagrid({
                url: "/Member/UserAccountHandler.ashx?action=logaccountlist&id=<%=UserModel.Id %>",
                method: 'post',

                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns:
                [[
                { field: 'type', title: '存入/支出', formatter: ftype },
                { field: 'datetime', title: '流水时间', formatter: easyui_formatterdate },
                { field: 'money', title: '存入金额（元）', formatter: showmoneys },
                { field: ' ', title: '支出金额（元）', formatter: showmoneyp  },
                { field: 'balance', title: '账户余额（元）' },
                { field: 'action', title: '详细操作',formatter:isgiftcard },

                { field: "orderid", title: "相关订单", formatter: forderid }
                ]]
            });
            $('#gd2').datagrid({
                url: "/Member/UserAccountHandler.ashx?action=logorderlist&id=<%=UserModel.Id %>",
                method: 'post',

                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                frozenColumns: [[
                 { field: "orderid", title: "订单信息", formatter: forderid }
                 ]],
                columns: [[
                { field: 'orderdate', title: '下单时间', formatter: easyui_formatterdate , width:150},
                { field: 'departurecity', title: '出发城市' },
                { field: 'targetcity', title: '目的城市' },
                { field: 'cartype', title: '租车类型' },
                { field: 'ordermoney', title: '订单额（元）' },
                  { field: "unpaidmoney", title: "二次付款金额（元）" },
                   { field: "totalmoney", title: "订单总额（元）" },
                { field: 'passengername', title: '乘车人' }
                ]]
            });
            $('#gd3').datagrid({
                url: "/Activity/VouchersHandler.ashx?action=list&userId=<%=UserModel.Id %>",
                method: 'post',

                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [[
                { field: 'Cost', title: '代金券面值', width: 100 },
                { field: 'StartTime', title: '生效日期', width: 150, formatter: easyui_formatterdate },
                { field: 'EndTime', title: '失效日期', width: 150, formatter: easyui_formatterdate },
                { field: 'Status', title: '状态', width: 100 },
                { field: 'OrderId', title: '对应订单', width: 150, formatter: fOrder },
                { field: 'UseTime', title: '使用时间', width: 150, formatter: formattime }
                ]]
            });
            $('#gd4').datagrid({
                url: "/Member/Couponhandler.ashx?action=UserCouponList&id=<%=UserModel.Id %>",
                method: 'get',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [[
                  { field: 'name', title: '名称', width: 100 },
                { field: 'cost', title: '代金券面值', width: 100 },
               { field: 'startdate', title: '生效日期', width: 150, formatter: easyui_formatterdate },
                  { field: 'deadline', title: '失效日期', width: 150, formatter: easyui_formatterdate },
                { field: 'status', title: '状态', width: 100,formatter:fcouponstatus },
                { field: 'orderid', title: '对应订单', width: 150, formatter: fOrder } 
                ]]
            });
            $('#gd5').datagrid({
                url: "/Activity/FundingHandler.ashx?action=fundinglist&userId=<%=UserModel.Id %>",
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [[
                { field: 'Amount', title: '金额', width: 100 },
                { field: 'InDate', title: '存入时间', width: 150, formatter: easyui_formatterdate },
                { field: 'CreateTime', title: '生效时间', width: 150, formatter: easyui_formatterdate },
                { field: 'ExpirationDate', title: '到期时间', width: 150, formatter: easyui_formatterdate },
                { field: 'Status', title: '状态', width: 100 },
                { field: 'adminName', title: '创建人', width: 100 },
                { field: 'Cost', title: '单券面值', width: 100 },
                { field: 'Num', title: '每月返券数', width: 100 }
                ]]
            });
            $('#gd6').datagrid({
                url: "/Member/UserMessageHandler.ashx?action=list&userId=<%=UserModel.Id %>",
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'content', title: '内容', width: 200, formatter: substr },
                { field: 'leavetime', title: '时间', width: 100, formatter: easyui_formatterdate },
                { field: 'nextID', title: '回复状态', width: 100, formatter: Replystate }
                    ]
                ]
            });

            $('#gd7').datagrid({
                url: "/Member/RemarkHandler.ashx?action=list&userId=<%=UserModel.Id %>",
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'Content', title: '评论内容', width: 100, formatter: substr7 },
                { field: 'Score', title: '评分', width: 100 },
                { field: 'OrderId', title: '相关订单', width: 100, formatter: forderoid }
                    ]
                ]
            });

        }
        //用户评价开始
        function forderoid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a href='javascript:onShowOrder(\"" + value + "\")'>查看相关订单</a>";
            return html;
        }

        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }
        function substr7(value, row, index) {
            var result = "";
            if (value.length > 15) {
                result = value.substr(0, 15) + '...';
            } else {
                result = value;
            }
            return "<a href=\"javascript:showRemarkDetail('" + value + "');\" style=\"text-decoration:underline;\" title='点击查看评论详情'>" + result + "</a>";
        }
        function showRemarkDetail(value) {
            $("#remarkcontainer").text(value);
            $("#w").window("open");
        }

        //用户评价结束


       // <!--用户留言开始-->
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onSearch() {
            $("#gd6").datagrid("options").url = "/Member/UserMessageHandler.ashx?" + $("#schForm").serialize();
            $("#gd6").datagrid("load");
        }
        function showDetailMess(id) {
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Member/UserMessageDetail.aspx?id=' + id);
        }
        function substr(value, row, index) {
            var result = "";
            if (value.length > 15) {
                result = value.substr(0, 15) + '...';
            } else {
                result = value;
            }
            return "<a href=\"javascript:showDetailMess('" + row.id + "');\" style=\"text-decoration:underline;\" title='点击查看评论详情'>" + result + "</a>";
        }
        function Replystate(value, row, index) {
            var html = "";
            if (row.nextID != 0) {
                $.ajax({
                    url: 'UserMessageHandler.ashx',
                    data: { action: "Replystate", id: row.id },
                    type: "post",
                    async: false,
                    success: function (data) {
                        if (data == 1)
                            html = "<span style='color:red'>有新留言，待回复</span>";
                        else
                            html = "<span>已回复</span>";
                    }
                })
            }
            else
                html = "<span style='color:red'>有新留言，待回复</span>";
            return html;
        }
        // <!--用户留言结束-->

        function isgiftcard(value, row, index) {
            if (value == "使用充值卡") {
                return "<a href='#' onclick='showGiftCard(" + row.giftcardsid + ")'>使用充值卡</a>";
            }
            else if (value == "用户转入" || value == "用户转出") {
                return "<a href='#' onclick='showTransInfo(" + row.transid + ")'>" + value + "</a>";
            }
            return value;
        }
        function showTransInfo(id) {
            $.post("/Member/UserAccountHandler.ashx", { "action": "getTransInfo", "transId": id }, function (data) {
                if (data == 0) {
                    alert("无效的转账号")
                    return;
                }
                $('#Transwindow').window('open');
                var model = data[0];

                $("#money").html(model.money + " 元");
                $("#fromTel").html(model.fromTel);
                $("#toTel").html(model.toTel);
                $("#fromName").html(model.fromName);
                $("#toName").html(model.toName);
                if (model.oprator == "用户") {
                    $("#oprator").html("用户(" + model.fromName+")");
                } else {
                    $("#oprator").html("管理员(" + model.oprator+")");
                }

                $("#createTime").html(model.createTime.substr(0, 19).replace('T', ' '));
            }, "json");
        }
        function showGiftCard(id) {
            $.post("/Member/UserAccountHandler.ashx", { "action": "getGiftCard", "giftId": id }, function (data) {
                if (data == 0) {
                    alert("无效的充值号")
                    return;
                }
                $('#rechargewindow').window('open');
                $("#cardId").html(data.Id);
                $("#cardsn").html(data.Sn);
                $("#cardname").html(data.Name);
                $("#cardcost").html(data.Cost + " 元");
                $("#usetime").html(data.useTime.substr(0, 19).replace("T"," "));
                $("#creator").html(data.Created);
                $("#rechargeman").html(data.RechargeMan);
                $("#saleman").html(data.SaleMan);
            }, "json")
        }
        function forderid(value, row, index) {
            return "<a style=\"text-decoration:underline\" href=\"javascript:;\" onclick=\"showDetail('" + value + "')\">" + value + "</a>";

        }
        function showmoneys(value, row, index) {
            if (row.type == "1") {
                return "<span style='color:blue;'>+" + value + "</span>";
            }
            else
                return 0;
        }
        function showmoneyp(value, row, index) {
            if (row.type == "1") {
                return 0;
            }
            else
                return "<span style='color:red;'>-" + row.money + "</span>";
        }

        function fcouponstatus(value, row, index) {
            if (value == 1) {
                return "已使用";
            } else  {
                return "未使用";
            }
        }
        function showDetail(orderid) {
            top.addTab("订单详情(ID:" + orderid + ")", "/Order/OrderDetail.aspx?id=" + orderid, "icon-nav");
        }
        function ftype(value, row, index) {
            if (value == "0") {
                return '<span style="color:red;">支出</span>';
            } else {
                return '<span style="color:blue;">存入</span>';
            }
        }

        function onCancel() {
            top.closeTab('close');
        }


        function fOrder(value, row, index) {
            if (value != "") {
                var html = "<a style='text-decoration:underline;' href='javascript:onShowOrder(\"" + value + "\")'>" + value + "</a> ";
                return html;
            }
            else
                return "";
        }
        function formattime(value, row, index) {
            if (value != null) {
                return value.split("T")[0] + " " + value.split("T")[1].substr(0, 8);
            }
            else
                return "";
        }
        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }
      
    </script>
</asp:Content>
