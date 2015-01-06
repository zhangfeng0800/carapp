<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="DialInfoList.aspx.cs" Inherits="CarAppAdminWebUI.Manager.DialInfoList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">会员名称</span> <span class="">
                    <input class="adm_21" id="name" name="name" type="text" value="" width="80" />
                </span></span><span class="input_blo"><span class="input_text">会员号码</span> <span
                    class="">
                    <input class="adm_21" id="usertelphone" name="usertelphone" type="text" value=""
                        width="80" />
                </span></span><span class="input_blo"><span class="input_text">主叫号码</span> <span
                    class="">
                    <input class="adm_21" id="caller" name="caller" type="text" value="" width="80" />
                </span></span><span class="input_blo"><span class="input_text">坐席号</span> <span class="">
                    <input class="adm_21" id="exten" name="exten" width="80" />
                </span></span><span class="input_blo" style="display: none;"><span class="input_text">客服名称</span> <span
                    class="">
                    <input class="adm_21" id="adminname" name="adminname" type="text" value="" width="80" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
            </div>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            resizeCarWindow();
            resizeReSendCarWindow();
            bindGrid();
            bindWin();
        });

        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width;
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
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
                url: "/Manager/DialInfoHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                singleSelect: true,
                fitColumns: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "呼叫记录",

                columns: [
                [
                { field: "username",width: 100, title: "会员姓名" },
                { field: "usertelphone",width: 100, title: "用户号码",formatter:formatCallbackUserTelphone },
//                 { field: 'adminname', title: '客服名称', width: 150 },
                { field: 'caller', title: '主叫号码', width: 150,formatter:formatCallbackCaller },
                 { field: 'extennum', title: '坐席号', width: 150 },
                { field: 'dialtime', title: '操作时间', width: 150, formatter: easyui_formatterdate },
                   { field: 'id', title: '回拨', width: 150, formatter: fcallback }
                    ]
                ]
            });
        }

        function  formatCallbackUserTelphone(value,rowData,rowIndex) {
            return "<a  style=\"text-decoration:underline;\"  href=\"javascript:;\" title='点击回拨此号码' onclick='callbackTelphone("+rowData.usertelphone+","+rowData.extennum+")'>"+value+"【点击回拨】</a>";
        }
        function  formatCallbackCaller(value,rowData,rowIndex) {
            return "<a style=\"text-decoration:underline;\"  href=\"javascript:;\" title='点击回拨此号码' onclick='callbackTelphone("+rowData.caller+","+rowData.extennum+")'>"+value+"【点击回拨】</a>";
        }
        function callbackTelphone(telphone,exten) {
            if (telphone == ""||exten=="") {
                alert("回呼失败");
                return;
            }
            $.ajax({
                url:"/ajax/callback.ashx?callee="+telphone+"&caller="+exten+"&timestamp="+Date.parse(new Date()),
                success: function(data) {
                    if (data.resultcode == 0) {
                        alert("回呼失败");
                    } else {
                        alert("操作成功");
                    }
                }
            });
        }
        function fcallback(value, rowdata, rowindex) {
            return "<a style=\"text-decoration:underline\" href=\"javascript:;\" onclick='callback("+value+")'>点击下单</a>";
        }
        function callback(id) {
            $.ajax({
                url:"/manager/DialInfoHandler.ashx?action=callback&adminname=<%=AdminName %>&id="+id+"&timestamp=<%=DateTime.Now.ToString("yyyyMMddHHmmssffffff") %>",
                success:function(data) {
                    if (data.resultcode != 0) {
                        alert("操作失败");
                    } else { 
                        bindGrid();
                    }
                }
            });
        }
        function toFloat(value, row, index) {
            if (value == "") {
                return "";
            } else {
                if (parseFloat(value)) {
                    return parseFloat(value).toFixed(2);
                } else {
                    return 0;
                }
            }
        }


        function formatterdate(val) {
            return easyui_formatterdate(val, null, null);
        }

        function getstring(value) {
            if (value == null || value == "") {
                return "暂无";
            }
            return value;
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Manager/DialInfoHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function resizeCarWindow() {
            var height = $(window).height();

            var width = $(window).width();
            $("#carwindow").css("width", width);
            $("#carwindow").css("height", height);
        }
        function resizeReSendCarWindow() {
            var height = $(window).height() - 20;

            var width = $(window).width() - 50;
            $("#recarwindow").css("width", width);
            $("#recarwindow").css("height", height);
        }

        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onShowUser(id) {
            top.addTab("会员详细(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }
    </script>
</asp:Content>
