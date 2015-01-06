<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="AccountStatistics.aspx.cs" Inherits="CarAppAdminWebUI.Statistics.AccountStatistics" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
 <script src="../Static/My97DatePicker/moment.min.js" type="text/javascript"></script>
 <form id="schForm">
    <input id="action" name="action" value="accountstatistics" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">

             <span class="input_blo"><span class="input_text">用户姓名</span> <span class="">
                    <input class="adm_21" id="compname" name="compname" type="text" value="" style="width:80px;" />
                </span></span>
                <span class="input_blo"><span class="input_text">手机号码</span> <span class="">
                    <input class="adm_21" id="telphone" name="telphone" type="text" value="" style="width:80px;" />
                </span></span>

                 <span class="input_blo"><span class="input_text">日期</span> <span class="">
                    <input class="adm_21 Wdate" style=" width:80px;" id="dates" name="dates"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" value="<%=DateTime.Now.ToString("yyyy-MM-01") %>"  />-
                    <input class="adm_21 Wdate" style=" width:80px;" id="datee" name="datee"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" type="text" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                </span></span>
                  <span class="input_blo"><span class="input_text">
                 <select id="timesel" onchange="search()">
                <option value="">不限</option>
                 <option value="day">本日</option>
                 <option value="month">本月</option>
                 <option value="year">本年</option>
                </select>
                 </span></span>

                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>

                
            </div>

        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>

     <div id="num" class="easyui-window" title="各金额中奖次数" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"

    </div>

    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();
        });
        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        function bindWin() {
            $("[id$=window]").window({
                modal: true,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closed: true
            });
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Member/AccountHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                showFooter: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "用户充值信息   (点击净充值，赠送金额，总充值，总消费可以排序)",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'compname', title: '用户姓名', width: 100, formatter: fusername },
                { field: 'telphone', title: '手机号码', width: 100 },
                { field: '银联无卡支付', title: '银联无卡支付', width: 100, sortable: true },
                { field: '银联手机支付', title: '银联手机支付', width: 100 ,sortable: true},
                { field: '支付宝充值', title: '支付宝充值', width: 100 ,sortable: true},
                { field: '网银充值', title: '网银充值', width: 100 ,sortable: true},         
                { field: '易宝手机支付', title: '易宝手机支付', width: 100 ,sortable: true},
                { field: '易宝PC支付', title: '易宝PC支付', width: 100 ,sortable: true},
                
                { field: '使用充值卡', title: '使用充值卡', width: 100, sortable: true },

                { field: '充值送车费', title: '充值送车费', width: 100, sortable: true },
                { field: '微信分享摇奖活动', title: '微信分享摇奖活动', width: 100, sortable: true },

                { field: '支付订单', title: '支付订单', width: 100, sortable: true },
                { field: '二次付款', title: '二次付款', width: 100, sortable: true },
                { field: '订单退款', title: '订单退款', width: 100, sortable: true },
                 { field: '存费赠券活动', title: '存费赠券活动', width: 100, sortable: true },
                { field: '存费赠券退款', title: '存费赠券退款', width: 100 },
               
                { field: '净充值', title: '净充值', width: 100, sortable: true },


                { field: '赠送金额', title: '赠送金额', width: 100, sortable: true },
                { field: '总充值', title: '总充值', width: 120, sortable: true },
                { field: '总消费', title: '总消费', width: 120, sortable: true },
                ]
                ]
            });
        }


        function fusername(value, row, index) {
            var html = "<a style='text-decoration:underline;' href='javascript:onShow(" + row.id + ")'>" + value + "</a> ";
            return html;
        }
        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }


        function search() {
            var day = moment().format("YYYY-MM-DD");
            if ($("#timesel").val() == "day") {    
                $("#dates").val(day);
                $("#datee").val(day);
                onSearch();
            } else if ($("#timesel").val() == "month") {
                $("#dates").val(moment().format("YYYY-MM-01"));
                $("#datee").val(day);
                onSearch();
            }
            else if ($("#timesel").val() == "year") {

                $("#dates").val(moment().format("YYYY-01-01"));
                $("#datee").val(day);
                onSearch();
            }
        }


        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/AccountHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }




        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>

</asp:Content>
