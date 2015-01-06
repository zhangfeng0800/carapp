<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="RemarkList.aspx.cs" Inherits="CarAppAdminWebUI.Member.RemarkList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
 
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">评论内容关键字</span> <span class="">
                    <input class="adm_21" id="Text1" name="keyword" />
                </span></span><span class="input_blo"><span class="input_text">评分</span> <span class="">
                    <select id="score" name="score">
                        <option value="">不限</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                    </select>
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
                    <span class="input_blo">
                        
                              <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                    </span>
            </div>
        </div>
    </div>
    
    </form>
    <table id="gdgrid">
    </table>
    <div id="w" class="easyui-window" title="评论详情" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 500px; height: 350px;">
        <span id="remarkcontainer" style="padding: 10px;"></span>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
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
        function resizeTable() {
            var height = ($(window).height() -$("#querycontainer").height()-10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        function showDetail(value) {
            $("#remarkcontainer").text(value);
            $("#w").window("open");
        }
        function substr(value, row, index) {
            var result = "";
            if (value.length > 15) {
                result = value.substr(0, 15) + '...';
            } else {
                result = value;
            }
            return "<a href=\"javascript:showDetail('" + value + "');\" style=\"text-decoration:underline;\" title='点击查看评论详情'>" + result + "</a>";
        }  

        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Member/RemarkHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title:"评论信息管理",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'Content', title: '评论内容', width: 100, formatter: substr },
                { field: 'Score', title: '评分', width: 100 },
                { field: 'OrderId', title: '相关订单', width: 100, formatter: forderid }
                    ]
                ]
            });
        }

        /* formatter */
        function forderid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a href='javascript:onShowOrder(\"" + value + "\")'>查看相关订单</a>";
            return html;
        }

        function onShowOrder(id) {
            top.addTab("订单详情(ID:" + id + ")", "/Order/OrderDetail.aspx?id=" + id, "icon-nav");
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/RemarkHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }

        function onDelete() {
            ajaxdelete("Remark", "id", "Id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
