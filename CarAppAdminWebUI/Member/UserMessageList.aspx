<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="UserMessageList.aspx.cs" Inherits="CarAppAdminWebUI.Member.UserMessageList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<style type="text/css">
        .mychat{ margin-right:40px;} 
        .mychat li{ line-height:30px;}
        .mychat .date{ float:right;  color:#a3a3a3; width:150px;}
        .mychat .leave{ background-color:#eaf2ff; height:auto;}
       </style> 
     
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">留言内容关键字</span> <span class="">
                      <input class="adm_21" id="keyword" name="keyword" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
                    <span class="input_blo">
                          <a href="javascript:onDetail()" class="easyui-linkbutton" iconcls="icon-remove">回复</a>
                    </span>
                    <span class="input_blo">
                        
                              <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                    </span>
            </div>
        </div>
    </div>
    <%--<div style="padding: 5px; height: 55px;" id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    留言内容：
                </td>
                <td>
                    <input class="adm_21" id="keyword" name="keyword" />
                </td>
                <td>
                    <a href="javascript:onSearch()" class="easyui-linkbutton" iconcls="icon-search">查询</a>
                </td>
                 <td>
                    <a href="javascript:onDetail()" class="easyui-linkbutton" iconcls="icon-remove">回复</a>
                </td>
                <td>
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>--%>
    </form>
    <table id="gdgrid">
    </table>
      <div id="editwindow" title="回复" style="width: 1000px; height: 660px;">
    </div>

    <script type="text/javascript">
     
        //初始化
        $(function () {
            resizeTable();
            bindWin();
            bindGrid(); 
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
        function substr(value, row, index) {
            var result = "";
            if (value.length > 15) {
                result = value.substr(0, 15) + '...';
            } else {
                result = value;
            }
            return "<a href=\"javascript:showDetail('" + row.id + "');\" style=\"text-decoration:underline;\" title='点击查看评论详情'>" + result + "</a>";
        }
        function resizeTable() {
            var height = ($(window).height() - 80);
            var width = $(window).width();
       
            $("#gdgrid").css("width", width);
            $("#editwindow").css("width",700);
            $("#editwindow").css("height", height + 80);
            $("#gdgrid").css("height", $(window).height() - $("#querycontainer").height() - 10);
            $("#querycontainer").css("width",width);
        }

        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Member/UserMessageHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "留言信息管理",
                toolbar:"#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'content', title: '内容', width: 200,formatter:substr },
                { field: 'leavetime', title: '时间', width: 100, formatter: easyui_formatterdate },
                { field: 'userid', title: '查看', width: 80, formatter: fuserid },
                { field: 'nextID', title: '回复状态', width: 100, formatter: Replystate }
                    ]
                ]
            });
        }


        /* formatter */
        function fuserid(value, row, index) {
            if (value == 0) {
                return "";
            }
            var html = "<a href='javascript:onShowUser(\"" + value + "\")'>查看相关会员信息</a>";
            return html;
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
                            html= "<span style='color:red'>有新留言，待回复</span>";
                        else
                            html= "<span>已回复</span>";
                    }
                })
            }
            else
                html = "<span style='color:red'>有新留言，待回复</span>";
            return html;
        }

        function onShowUser(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }

        

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/UserMessageHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }

        function onDetail() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Member/UserMessageDetail.aspx?id='+row.id);
        }

        function showDetail(id) {
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Member/UserMessageDetail.aspx?id=' + id);
        }
        function onDelete() {
            ajaxdelete("userMessage", "id", "id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>