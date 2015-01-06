<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegistUser.aspx.cs" MasterPageFile="~/Admin.Master"
    Inherits="CarAppAdminWebUI.Statistics.RegistUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                注册用户统计</h3>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
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
                url: "/Statistics/RegistUser.ashx?" + $("#schForm").serialize(),
                method: 'post',
                rownumbers: true,
                fitColumns: false,
                pageList: [15],
                pageSize: 15,
                title: "注册用户统计",
                columns: [[
                //                { field: 'id', title: 'ID', width: 50 },
                {field: 'RegistDate', title: '注册时间', width: 150 },
                { field: 'RegisterCount', title: '注册人数', width: 150 },
                { field: 'maleCount', title: '男用户数', width: 150 },
                { field: 'femaleCount', title: '女用户数', width: 150 },
                ]],
                rowStyler: function (index, row) {
                    if (row.RegistDate == '总计') {
                        return 'background-color:#6293BB;color:#fff;font-weight:bold;';
                    }
                }
            });
        }
    </script>
</asp:Content>
