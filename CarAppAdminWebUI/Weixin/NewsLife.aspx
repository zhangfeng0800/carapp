<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="NewsLife.aspx.cs" Inherits="CarAppAdminWebUI.Weixin.NewsLife" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">

 
    <div   id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a id="add" href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">
                        添加</a>
                </td>
                <td>
                    <a id="upd" href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-remove">
                        编辑</a>
                </td>
                <td>
                    <a id="del" href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">
                        删除</a>
                </td>

                   <td>
                    <a id="A1" href="javascript:onReply()" class="easyui-linkbutton" iconcls="icon-remove">
                        设为发送</a>
                </td>

               

            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>

    <table id="gdgrid">
    </table>
     <div id="editwindow" title="编辑微信图文" style="width: 1200px; height: 800px;">
    </div>

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
                url: "/Weixin/NewsList.ashx?action=list&type=租车生活",
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
                 { field: 'ID', title: '自动编号', width: 60 },
                { field: 'Type', title: '图文类型', width: 100 },

                { field: 'CreateTime', title: '创建时间', width: 120, formatter: easyui_formatterdate, sortable: true },
                { field: 'State', title: '发送状态', width: 100, formatter: getState, sortable: true },
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
            $("#gdgrid").datagrid("options").url = "/Weixin/NewsList.ashx?action=list&type=租车生活";
            $("#gdgrid").datagrid("load");
        }

        function getState(value,row,index) {
            if (value == "发送中") {
                return "<span style='color:red'>发送中</span>";
            }
            else
                return value;
        }

        function onReply() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"];
            $.ajax({
                url: "NewsList.ashx",
                data: { action: "setSend", ID: id },
                type: 'post',
                success: function (data) {
                    $.messager.alert('消息', '成功');
                    onSearch();
                }
            });
        }

        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["ID"];
            //window.location.href = 'NewsOpera.aspx?wxNewsID=' + id;

           
            top.addTab("租车生活(ID:" + id + ")", "WeiXin/NewsOpera.aspx?wxNewsID=" + id + "&type=租车生活", "icon-nav"); 
           
          
            //            $("#editwindow").window('open');
            //            $('#editwindow').window('refresh', 'NewsOpera.aspx?wxNewsID=' + id);

        }

        function onAdd() {
            $.ajax({
                url: "NewsList.ashx",
                data: { action: "add", type: '租车生活' },
                type: 'post',
                async: false,
                success: function (data) {
                    if (data != "0") {
                        onSearch();
                        setTimeout(function () {
                            top.addTab("租车生活(ID:" + data + ")", "WeiXin/NewsOpera.aspx?wxNewsID=" + data + "&type=租车生活", "icon-nav");
                        }, 100);
                        
                    }
                }
            });
           
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }

            var id = row["ID"];
            if (confirm("确认要删除吗?")) {
                $.ajax({
                    url: "NewsList.ashx",
                    type: 'post',
                    data: { action: "del", ID: id },
                    success: function (data) {
                        if (data != "0") {
                            $.messager.alert('消息', '删除成功！', 'info', function () {
                                $("#gdgrid").datagrid("load");
                            })
                        }
                    }
                })
            }
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');

        }

    </script>

</asp:Content>
