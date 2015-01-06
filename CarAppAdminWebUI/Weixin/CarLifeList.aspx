<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="CarLifeList.aspx.cs" Inherits="CarAppAdminWebUI.Weixin.CarLifeList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
 <div   id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                   <td>
                    <a id="A1" href="javascript:onSetLottery()" class="easyui-linkbutton" iconcls="icon-remove">
                        设为分享摇大奖</a>
                </td>
                 <td>
                    <a id="A2" href="javascript:onSetLotteryOrder()" class="easyui-linkbutton" iconcls="icon-remove">
                        设为订单页面分享</a>
                </td>
                   <td>
                    <a id="A4" href="javascript:onSetLotteryAll()" class="easyui-linkbutton" iconcls="icon-remove">
                        同时设为分享摇奖和订单页面分享</a>
                </td>
                 <td>
                    <a id="A3" href="javascript:onCancelLottery()" class="easyui-linkbutton" iconcls="icon-remove">
                        取消分享</a>
                </td>
               

            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>

    <table id="gdgrid">
    </table>
    

    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindWin();
            bindGrid();
        });
        function resizeTable() {
            var height = ($(window).height());
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
        }
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Weixin/NewsList.ashx?action=carlifelist",
                method: 'post',
                
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "租车生活",
                toolbar:"#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                 { field: 'ID', title: '预览', width: 60,formatter:GoPage },
                { field: 'Title', title: '标题', width: 100 },
                { field: 'ImgUrl', title: '封面图片', width: 100 ,formatter:setimg},
                { field: 'ContentUrl', title: '链接地址', width: 100 },
                { field: 'CreateTime', title: '创建时间', width: 120, formatter: easyui_formatterdate, sortable: true },
                { field: 'IsLottery', title: '状态', width: 100, formatter: getState }
                ]]
            });
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
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Weixin/NewsList.ashx?action=carlifelist";
            $("#gdgrid").datagrid("load");
        }
          //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');

        }
        function onSetLottery() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"];
            $.ajax({
                url: "NewsList.ashx",
                data: { action: "setLottery", ID: id },
                type: 'post',
                success: function (data) {
                    $.messager.alert('消息', '成功');
                    onSearch();
                }
            });
        }
        function onSetLotteryOrder() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"];
            $.ajax({
                url: "NewsList.ashx",
                data: { action: "setLotteryOrder", ID: id },
                type: 'post',
                success: function (data) {
                    $.messager.alert('消息', '成功');
                    onSearch();
                }
            });
        }
        function onSetLotteryAll() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"];
            $.ajax({
                url: "NewsList.ashx",
                data: { action: "SetLotteryAll", ID: id },
                type: 'post',
                success: function (data) {
                    $.messager.alert('消息', '成功');
                    onSearch();
                }
            });
        }
        function onCancelLottery() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"];
            $.ajax({
                url: "NewsList.ashx",
                data: { action: "cancelLottery", ID: id },
                type: 'post',
                success: function (data) {
                    $.messager.alert('消息', '成功');
                    onSearch();
                }
            });
        }
        function GoPage(value, row, index) {
            return "<a target='_blank' href='" + row.ContentUrl + "'>查看</a>"
        }
        function getState(value,row,index) {
            if (value == "1") {
                return "<span style='color:red'>分享摇大奖</span>";
            }
            else if (value == "2") {
                return "<span style='color:red'>分享订单</span>";
            }
            else if (value == "5") {
                return "<span style='color:red'>分享摇奖、分享订单</span>";
            }
            else
                return "正常";
        }
        function setimg(value, row, index) { 
            return "<img height='100px' width='180px' src='"+value+"' />"
        }
        </script>
</asp:Content>
