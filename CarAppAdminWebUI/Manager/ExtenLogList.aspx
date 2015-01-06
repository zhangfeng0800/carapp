<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ExtenLogList.aspx.cs" Inherits="CarAppAdminWebUI.Manager.ExtenLogList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="loglist" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">开始时间</span> <span
                    class="">
                    <input class="adm_21" id="startdate" name="startdate" type="text" value=""
                        width="80"  readonly onclick="WdatePicker()" onfocus="WdatePicker()"/>
                </span></span><span class="input_blo"><span class="input_text">结束时间</span> <span
                    class="">
                        <input class="adm_21" id="enddate" name="enddate" type="text" readonly onclick="WdatePicker()" onfocus="WdatePicker()" value=""
                        width="80" />
                </span></span>

                <span class="input_blo"><span class="input_text">坐席号</span> <span class="">
                    <input class="adm_21" id="exten" name="exten" width="80" />
                </span></span><span class="input_blo"><span class="input_text">客服名称</span> <span
                    class="">
                    <input class="adm_21" id="name" name="name" type="text" value="" width="80" />
                </span></span><span class="input_blo"><span class="input_text">操作类型</span> <span
                    class="">
                    <select class="adm_21" id="type" name="type">
                        <option value="">不限</option>
                        <option value="签入">签入</option>
                        <option value="签出">签出</option>
                    </select>
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
                url: "/member/PhoneCenterHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                singleSelect: true,
                fitColumns: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "客服日志",

                columns: [
                [
                 { field: 'Exten', title: '坐席号', width: 150 },
                { field: 'Name', title: '客服名称', width: 150 },
                 { field: 'OperationType', title: '操作类型', width: 150 },
                { field: 'OperationTime', title: '操作时间', width: 150, formatter: easyui_formatterdate }
                    ]
                ]
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
            $("#gdgrid").datagrid("options").url = "/member/PhoneCenterHandler.ashx?" + $("#schForm").serialize();
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
