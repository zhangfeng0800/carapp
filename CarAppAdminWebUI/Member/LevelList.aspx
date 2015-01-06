<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="LevelList.aspx.cs" Inherits="CarAppAdminWebUI.Member.LevelList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">级别名称</span> <span class="">
                    <input class="adm_21" id="Keyword" name="Keyword" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">添加</a>
                </td>
                <td>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>
                </td>
                <td>
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的会员级别" style="width: 600px; height: 300px;">
    </div>
    <div id="editwindow" title="编辑会员级别" style="width: 600px; height: 300px;">
    </div>

      <div id="leveruserswindow" class="easyui-window" title="用户列表" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 1200px; height: 630px;">
        <table id="theusers" style=" height:600px;">
            
        </table>
    </div>

    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();
        });

        function resizeTable() {
            var height = ($(window).height());
            var width = $(window).width();
            $("#gdgrid").css("height", height - $("#querycontainer").height() - 10);
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
                url: "/Member/LevelHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "用户流水管理",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },

                { field: 'Name', title: '等级名称', width: 100,formatter: fname },
                { field: 'UserType', title: '会员类型', width: 100, formatter: fUserType },
                { field: 'ScoreLL', title: '积分限制', width: 100 },
                { field: 'ScoreUL', title: '积分上限', width: 100 },
                { field: 'Discount', title: '折扣率', width: 100 },
                { field: 'Order', title: '排序号', width: 100 }
                    ]
                ]
            });
        }
        function fname(value,data,index) {
            if (data.UserType == 3) {
                return "<a href='javascript:showUser("+data.Id+")'>" + value + "</a>";
            }
            else
                return value;
        }
        function showUser(levelid) {
            $("#leveruserswindow").window("open");
            $('#theusers').datagrid({
                url: "/Member/UserAccountHandler.ashx?action=levelUser&levelId="+levelid,
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                remoteSort: true,
                pageList: [15, 30, 45, 60],
                title: "用户信息管理",
                pageSize: 15,
                frozenColumns: [[
                 { field: 'ck', checkbox: true },
               { field: 'compname', title: '集团 / 个人名称', formatter: fusername }
                ]],
                columns: [
                [
                { field: 'username', title: '昵称', width: 100, width: 100 },
                { field: 'telphone', title: '手机号码', width: 100 },
                { field: 'balance', title: '账户余额（元）', width: 100, sortable: true },
                { field: 'email', title: '邮箱地址', width: 100 },
                { field: "registtime", title: "注册时间", width: 100, formatter: easyui_formatterdate, sortable: true },
                { field: 'type', title: '用户类型', width: 100, formatter: fUserType },
                { field: 'creater', title: '创建人', width: 100 },
                { field: 'pid', title: '查看', width: 100, formatter: fpid },
                 { field: 'ishidefunding', title: '特殊用户（不能参加资金活动）', width: 200, formatter: isHide }
               ]
                ]
            });
        }
        function changeHideFunding(id) {
            $.post("/Member/UserAccountHandler.ashx", { action: "changeHideFunding", id: id }, function (data) {
                if (data.IsSuccess) {
                    $.messager.alert('提示', '更改成功');
                    onSearch();
                }
                else {
                    $.messager.alert('提示', '更改失败');
                }
            }, "json");
        }
        function isHide(value, row, index) {
            if (value == 1)
                return "<span style='color:red;'>是</span><a href=\'javascript:changeHideFunding(" + row.id + ")\'>（更改状态）</a>";
            else
                return "否<a href=\'javascript:changeHideFunding(" + row.id + ")\'>（更改状态）</a>"
        }
        function fusername(value, row, index) {
            var html = "<a style='text-decoration:underline;' href='javascript:onShow(" + row.id + ")'>" + value + "</a> ";
            return html;
        }
        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }
        function fUserType(value, data, index) {
            if (value == 3) {
                return "个人用户";
            } else if (value == 1) {
                return "部门经理";
            } else if (value == 0) {
                return "集团用户";
            } else if (value == 2) {
                return "部门员工";
            }
        }
        function fpid(value, row, index) {
            var html = "<a href='javascript:onShow(" + row.id + ")'>查看详细</a> ";
            if (value != 0) {
                html += "<a href='javascript:onShow(" + value + ")'>查看上级</a> ";
            }
            return html;
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/LevelHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Member/LevelAdd.aspx');
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "Id", "/Member/LevelEdit.aspx?id=");
        }

        function onDelete() {
            ajaxdelete("Level", "id", "Id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
