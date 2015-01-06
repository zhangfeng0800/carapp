<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CouponList.aspx.cs" Inherits="CarAppAdminWebUI.Member.CouponList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    
    <form id="schForm">
    <input type="hidden" id="action" name="action" value="list" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">状态</span> <span class="">
                    <select id="status" name="status">
                        <option value="">不限</option>
                        <option value="0">未使用</option>
                        <option value="1">已使用</option>
                    </select>
                </span></span>
                <span class="input_blo"><span class="input_text">用户真实姓名：</span> <span class=""><input name="compname" style="width:80px;" /></span></span>
                    <span class="input_blo"><span class="input_text">用户手机：</span> <span class=""><input name="telphone" style="width:80px;" /></span></span>
                      <span class="input_blo"><span class="input_text">优惠券名称：</span> <span class=""><input name="couponName" style="width:80px;" /></span></span>
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span>

                <span class="input_blo" style=" float:right;">编号：<input name="cardnoStart" id="cardnoStart" value="0" style="width:50px" />-<input name="cardnoEnd" id="cardnoEnd" value="0" style="width:50px"  /><a href="javascript:onExport()">根据编号导出</a></span>
            </div>
        </div>
    </div>
    <div  id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
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
    <div id="addwindow" title="添加新的优惠券" style="width: 500px; height: 330px;">
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
                url: "/Member/CouponHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "优惠劵信息管理 ",
                toolbar:"#toolbar",
                columns: [
                [
                { field: 'ck', checkbox: true },
                { field: 'id', title: '编号', width: 100 },
                { field: 'name', title: '优惠券名称', width: 100 },
                { field: 'cost', title: '面值（元）', width: 100},
                                { field: 'sn', title: '序列号', width: 100 },
                {field: 'username', title: '会员名称', width: 120, formatter: getUserName },
                { field: 'startdate', title: '有效期开始时间', width: 100, formatter: easyui_formatterdate },
                { field: 'deadline', title: '有效期结束时间', width: 100, formatter: easyui_formatterdate },
                { field: 'restrictions', title: '使用限制（元）', width: 100, formatter: frestrictions },
                { field: 'status', title: '状态', width: 100, formatter: fstatus }
                    ]
                ]
            });
        }

        function onExport() {
            window.open("/Member/GiftCardsExport.aspx?action=coupon&idStart=" + $("#cardnoStart").val() + "&idEnd=" + $("#cardnoEnd").val());
        }


//        function getUserName(value, row, index) {
//            var result = "";
//            $.ajax({
//                url: "/Member/CouponHandler.ashx",
//                data: { action: "username", userid: value },
//                type: "post",
//                async: false,
//                success: function (data) {
//                    result = data;
//                }, error: function () {
//                    return "";
//                }
//            });
//            return result;

//        }
        /* formatter */
        function fuid(value, row, index) {
            if (value == 0) {
                return "";
            }
            return value;
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

        function frestrictions(value, row, index) {
            if (value == 0) {
                return "不限制";
            }
            return value;
        }
        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }
        function getUserName(value, row, index) {
            if (value != "")
                return "<a href='javascript:onShow(" + row.userid + ")'>" + value + "</a>";
            else
                return "";

        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Member/CouponHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Member/CouponAdd.aspx');
        }

        function onDelete() {
            ajaxdelete("Coupon", "id", "id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
