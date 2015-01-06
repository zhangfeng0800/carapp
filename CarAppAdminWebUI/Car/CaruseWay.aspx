<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CarUseWay.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarUseWay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <%-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="30%" class="adm_36 adm_25">
                当前位置：服务信息管理 > 服务方式维护
            </td>
        </tr>
    </table>--%>
    <form id="schForm">
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">名称</span> <span class="">
                    <input class="adm_21" style="width: 80px;" id="Keyword" name="Keyword" type="text"
                        value="" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>
                    
                    <span class="input_blo">    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a></span>
            </div>
        </div>
    </div>
    
    </form>
    <table id="gdgrid">
    </table>
    <div id="editwindow" title="编辑" style="width: 500px; height: 330px;">
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
            var height = ($(window).height() - $("#querycontainer").height()-10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Car/CarUseWayList.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                collapsible: true,
                pageSize: 15,
                title:"服务方式维护",
                columns: [
                    [
                        { field: 'ck', checkbox: true },

                        { field: "Name", title: "名称", width: 100 },
                        { field: 'ImgUrl', title: '用车方式图标', width: 100,
                            formatter: function (value, row, index) {
                                var str = "";
                                if (value != null && value != "") {
                                    str = '<img style="width:20px;height:20px;" src="' + value + '" title="' + row.Name + '" />';
                                }
                                return str;
                            }
                        },
                        { field: 'Description', title: '用车方式描述', width: 300 }
                    ]
                ]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/CarUseWayList.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/Car/CarUseWayEdit.aspx?id=' + row.Id);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
