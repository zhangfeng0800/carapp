<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="GiftCardsList.aspx.cs" Inherits="CarAppAdminWebUI.Member.GiftCardsList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input type="hidden" id="action" name="action" value="list" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">卡&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</span>
                    <span class="">
                        <input id="number" name="number" type="text" style="width: 80px;" /> -  <input id="numberend" name="numberend" type="text" style="width: 80px;" />
                    </span></span><span class="input_blo"><span class="input_text">名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称</span>
                        <span class="">
                            <input id="name" name="name" type="text" style="width: 80px;" />
                        </span></span><span class="input_blo"><span class="input_text">面&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;值</span>
                            <span class="">
                                <input id="cast" name="cost" type="text" style="width: 80px;" />
                            </span></span><span class="input_blo"><span class="input_text">序&nbsp;&nbsp;列&nbsp;&nbsp;号</span>
                                <span class="">
                                    <input id="no" name="no" type="text" style="width: 80px;" />
                                </span></span><span class="input_blo"><span class="input_text">领&nbsp;&nbsp;卡&nbsp;&nbsp;人</span>
                                    <span class="">
                                        <input id="saleman" name="saleman" type="text" style="width: 80px;" />
                                    </span></span>
                                    <span class="input_blo"><span class="input_text">充值用户</span>
                                    <span class="">
                                        <input id="compname" name="compname" type="text" style="width: 80px;" />
                                    </span></span>
                                         <span class="input_blo"><span class="input_text">充值用户手机</span>
                                    <span class="">
                                        <input id="telphone" name="telphone" type="text" style="width: 80px;" />
                                    </span></span>
                                    <span class="input_blo"><span class="input_text">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态</span>
                                        <span class="">
                                            <select id="status" name="status">
                                                <option value="-1">不限</option>
                                                <option value="0">未使用</option>
                                                <option value="1">已使用</option>
                                            </select>
                                            <select id="IsExport" name="IsExport">
                                                <option value="-1">不限</option>
                                                <option value="1">已打印</option>
                                                <option value="0">未打印</option>
                                            </select>
                                        </span></span><span class="input_blo"><span class="input_text">使用时间</span> <span
                                            class="">
                                            <input style="width: 90px;" id="times" name="times" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />-<input
                                                id="timee" style="width: 90px;" name="timee" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
                                        </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                                            iconcls="icon-search">查询</a> </span><span class="input_blo"><a href="javascript:ManageSalesMan()"
                                                class="easyui-linkbutton" iconcls="icon-search">管理领卡人</a>
                </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table style="width: 100%;">
            <tr>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                    <a href="javascript:onPrint()" class="easyui-linkbutton" iconcls="icon-remove">设为已打印</a>
                    <span style="float: right;">卡名称：<input id="cardname" name="cardname" type="text"
                        style="width: 100px;" />
                        卡号：<input id="startid" name="startid" type="text" style="width: 50px;" value="0" />
                        -<input id="endid" name="endid" type="text" style="width: 50px;" value="0" />
                        状态<select id="state" name="state">
                            <option value="0" selected="selected">未使用</option>
                            <option value="1">已使用</option>
                        </select>
                        <a href="javascript:onExport()" class="easyui-linkbutton" iconcls="icon-remove">导出</a>
                    </span>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的充值卡" style="width: 500px; height: 300px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();
        });
        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
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
                url: "/Member/GiftCardsHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                //singleSelect: true,
                pageList: [15, 30, 45, 60, 500],
                pageSize: 15,
                title: "充值卡信息",
                toolbar: "#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                 { field: 'id', title: '卡号', width: 40 },
                { field: 'name', title: '名称', width: 100 },
                { field: 'cost', title: '面值', width: 100 },
                 { field: 'sn', title: '序列号', width: 100 },
                { field: 'username', title: '充值用户', width: 80, formatter: getUserName },
                { field: 'rechargeman', title: '充卡人', width: 80 },
                { field: 'status', title: '状态', width: 100, formatter: fstatus },
                { field: 'usetime', title: '使用时间', width: 100, formatter: gettime },
                { field: 'saleman', title: '领卡人', width: 100, formatter: fsalman },
                { field: 'created', title: '操作人', width: 100 },
                { field: 'createtime', title: '创建时间', width: 100, formatter: gettime },
                { field: 'type', title: '使用限制', width: 100, formatter: gettype },
                { field: 'isexport', title: '是否打印', width: 100, formatter: getPrintstate }
                ]
                ]
            });
        }
        function fsalman(value, row, index) {
            return "<a href='javascript:searchsaleman(\"" + value + "\")'>" + value + "</a>";

        }
        function searchsaleman(saleman) {
            $("#saleman").val(saleman);
            onSearch();
        }

        function ManageSalesMan() {
            top.addTab("管理领卡人", "/Member/SalesManList.aspx", "icon-nav");
        }
        function gettype(value, data, index) {
            if (value == 0)
                return "无限制";
            else if (value == 1)
                return "每个用户限充一张";

        }
        function gettime(value, data, index) {
            if (value == "" || value == null)
                return "";
            else
                return easyui_formatterdate(value, data, index);
        }

        function showIsUse(value, data, index) {
            if (value == null || value == "") {
                return "";
            }
            return value;
        }
        function getUserName(value, row, index) {
            if (value != "")
                return "<a href='javascript:onShow(" + row.userid + ")'>" + value + "</a>";
            else
                return "";

        }

        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }

        /* formatter */
        function fuid(value, row, index) {
            if (value == 0) {
                return "";
            }
            return value;
        }

        function getPrintstate(value, row, index) {
            if (value == 0)
                return "未打印";
            else
                return "已打印";
        }

        function fstatus(value, row, index) {
            var str = "";
            if (value == 0) {
                str = "未使用";
            } else if (value == 1) {
                str = '<span style="color:red;">已使用</span>';
            }
            return str;
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/GiftCardsHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Member/GiftCardsAdd.aspx');
        }

        function onDelete() {
            var ids = getSelectIds();
            if (ids == "") {
                $.messager.alert('消息', '你没有选择任何数据', 'error');
            }
            $.messager.confirm("提示", "你确定要执行此操作么？", function (r) {
                if (r) {
                    var d = { "action": "delete", "ids": ids };
                    $.post("/Member/GiftCardsHandler.ashx", d, function (data) {
                        if (data.IsSuccess) {
                            $.messager.alert('消息', '操作成功！', 'info', function () {
                                onSearch();
                            });
                        } else {
                            $.messager.alert('消息', data.Message, 'error');
                        }
                    }, "json");
                }
            });
        }

        /* 导出到excel */
        function onExport() {
            window.open("/Member/GiftCardsExport.aspx?startid=" + $("#startid").val() + "&endid=" + $("#endid").val() + "&cardname=" + $("#cardname").val() + "&state=" + $("#state").val());
        }

        /*设为打印*/
        function onPrint() {
            var ids = getSelectIds();
            if (ids == "") {
                $.messager.alert('消息', '你没有选择任何数据', 'error');
            }
            $.messager.confirm("提示", "你确定要执行此操作么？", function (r) {
                if (r) {

                    $.post("/Member/GiftCardsHandler.ashx", { "action": "export", "ids": ids }, function (data) {
                        if (data.IsSuccess) {
                            $.messager.alert('消息', '操作成功！', 'info', function () {
                                onSearch();
                            });
                        } else {
                            $.messager.alert('消息', data.Message, 'error');
                        }
                    }, "json")
                }
            });
        }

        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }

        function getSelectIds() {
            var items = $("#gdgrid").datagrid("getSelections");
            var ids = "";
            for (var i = 0; i < items.length; i++) {
                if (i == items.length - 1) {
                    ids += items[i].id;
                } else {
                    ids += items[i].id + ",";
                }
            }
            return ids;
        }
    </script>
</asp:Content>
