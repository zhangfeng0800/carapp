<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ManagerList.aspx.cs" Inherits="CarAppAdminWebUI.Manager.ManagerList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
     
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">用户名</span> <span class="">
                    <input class="adm_21" id="keyword" name="keyword" type="text" style=" width:80px;" />
                </span></span>
                <span class="input_blo"><span class="input_text">工号</span> <span class="">
                    <input class="adm_21" id="jobnumber" name="jobnumber" type="text" style=" width:80px;" />
                </span></span>
                <span class="input_blo"><span class="input_text">管理员组</span> 
                <span class="">
                    <select id="groupname" name="groupname">
                        <option value="0">请选择</option>
                        <option value="1">超级管理员</option>
                        <option value="2">客服</option>
                        <option value="3">微信管理员</option>
                    </select>
                </span></span>
                 <span class="input_blo"><span class="input_text">状态</span> 
                <span class="">
                    <select id="isdelete" name="isdelete">
                        <option value="">不限</option>
                        <option value="0">正常</option>
                        <option value="1">已删除</option>
                    </select>
                </span></span>

                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span> 
                    <span class="input_blo"><a href="javascript:onAdd()"
                        class="easyui-linkbutton" iconcls="icon-add">添加</a> </span>
                        <span class="input_blo">
                            <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">编辑</a>
                        </span>
                        <span class="input_blo">
                            <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                        </span>
            </div>
        </div>
    </div>
    
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的管理员" style="width: 500px; height: 300px;">
    </div>
    <div id="editwindow" title="编辑管理员信息" style="width: 500px; height: 300px;">
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
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Manager/ManagerHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                title: "管理员管理",
                pageSize: 15,
                columns: [
                    [
                        { field: 'ck', checkbox: true },
                        { field: 'AdminName', title: '用户名', width: 100 },
                        { field: 'JobNumber', title: '工号', width: 100 },
                        { field: 'AdminGroupsId', title: '所属用户组', width: 100, formatter: showgroupName },
                        { field: 'Phone', title: '电话', width: 100 },
                         { field: 'IsDelete', title: '是否删除', width: 100 ,formatter:fdelete} 
                    ]
                ]
            });
        }
        function fdelete(value, data, index) {
            if (value == "1")
                return "<span style='color:red;'>已删除</span>"
            else
                return "正常";
        }
        function showgroupName(value, data, index) {
            if (value == 1) {
                return "超级管理员";
            } else if (value == 2) {
                return "客服";
            } else if (value == 3) {
                return "微信管理员"
            }

        }
        function fStatus(value, data, index) {
            if (value == 0) {
                return "下班";
            } else {
                return "上班";
            }
        }
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Manager/ManagerHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Manager/ManagerAdd.aspx');
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Manager/ManagerEdit.aspx?id=' + row.AdminId);
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "你确定要执行此操作么？", function (r) {
                if (r) {
                    $.post("/Manager/ManagerHandler.ashx", { "action": "delete", "id": row.AdminId }, function (data) {
                        if (data.IsSuccess) {
                            $.messager.alert('消息', '成功');
                            onSearch();
                        }
                        else {
                            $.messager.alert('消息', data.Message, 'error');
                        }
                    }, "json");
                }
            });

            
        }

        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
      
    </script>
</asp:Content>
