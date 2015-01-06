<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ExtentList.aspx.cs" Inherits="CarAppAdminWebUI.Manager.ExtentList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="extenlist" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">坐席号</span> <span class="">
                    <input class="adm_21" id="extennt" name="extennt" width="80" />
                </span></span>
                  <span class="input_blo"><span class="input_text">状态</span> <span class="">
                 <select id="status" name="status">
                     <option value="-1">不限</option>
                         <option value="0">关闭</option>
                             <option value="1">启用</option>
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
                fitColumns: false,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "坐席设置",
                columns: [
                [
                { field: "Id", width: 100, title: "编号" },
                { field: "Exten", width: 100, title: "坐席号" },
                { field: 'IsUse', title: '当前状态', width: 150, formatter: fshutdownstatus }
                    ]
                ]
            });
        }
        function fstatus(value, rowData, rowIndex) {
            var status = "";
            if (value == 0) {
                status = "关闭";
            } else {
                status = "开启";
            }
            return status;
        }
        function fshutdownstatus(value, rowData, rowIndex) {

            var status = "";
            if (value == 0) {
                status = "关闭";
            } else {
                status = "开启";
            }
            return "<a  style=\"text-decoration:underline;\" title='点此设置状态'  href=\"javascript:;\" onclick='callbackTelphone(" + rowData.IsUse + "," + rowData.Exten + ")'>" + status + "</a>";

        }
        function callbackTelphone(status, exten) {
         
            $.ajax({
                url: "/Manager/DialInfoHandler.ashx?action=statusetting&status=" + status + "&extent=" + exten + "&timestamp=" + Date.parse(new Date()),
                success: function (data) {
                    if (data.resultcode == 0) {
                        $.messager.alert("提示信息","操作失败");
                    } else {
                        $.messager.alert("提示信息", "操作成功","info", function () {
                             $("#gdgrid").datagrid("options").url = "/Manager/DialInfoHandler.ashx?" + $("#schForm").serialize();
                        $("#gdgrid").datagrid("load");
                        });
                       
                    }
                }
            });
        }
        function fcallback(value, rowdata, rowindex) {
            return "<a style=\"text-decoration:underline\" href=\"javascript:;\" onclick='callback(" + value + ")'>点击下单</a>";
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
