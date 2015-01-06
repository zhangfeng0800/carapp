<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="UserAccountList.aspx.cs" Inherits="CarAppAdminWebUI.Member.UserAccountList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">集团/个人名称</span> <span class="">
                    <input class="adm_21" id="realname" name="realname" style="width: 80px;" />
                </span></span><span class="input_blo"><span class="input_text">昵称</span> <span class="">
                    <input class="adm_21" id="sUsername" name="username" style="width: 80px;" />
                </span></span><span class="input_blo"><span class="input_text">手机号码</span> <span
                    class="">
                    <input class="adm_21" id="telphone" name="telphone" style="width: 80px;" />
                </span></span><span class="input_blo"><span class="input_text">账户类型</span> <span
                    class="">
                    <select id="accountclass" name="accountclass">
                        <option value="-1">请选择</option>
                        <option value="0">集团管理员</option>
                        <option value="1">部门管理员</option>
                        <option value="2">部门员工</option>
                        <option value="3">个人会员</option>
                    </select>
                </span></span><span class="input_blo"><span class="input_text">是否VIP</span> <span
                    class="">
                    <select id="isvip" name="isvip">
                        <option value="">不限</option>
                        <option value="是">是</option>
                        <option value="否">否</option>
                    </select>
                </span></span><span class="input_blo"><span class="input_text">注册时间</span> <span
                    class="">
                    <input style="width: 100px;" id="times" name="times" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />-
                    <input id="timee" style="width: 100px;" name="timee" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span> <span class="input_blo"><a href="javascript:onRePassword()"
                        class="easyui-linkbutton" iconcls="icon-remove">修改登录密码</a> </span><span class="input_blo">
                            <a href="javascript:onRechargeMoney()" class="easyui-linkbutton" iconcls="icon-remove">
                                账户充值</a> </span><span class="input_blo"><a href="javascript:onRegsiter()" class="easyui-linkbutton"
                                    iconcls="icon-remove">替用户注册</a> </span><span class="input_blo"><a href="javascript:onTrans()"
                                        class="easyui-linkbutton" iconcls="icon-remove">用户转账</a>
                </span><span class="input_blo"><a href="javascript:onExport()" class="easyui-linkbutton"
                    iconcls="icon-remove">按条件导出</a> </span>
            </div>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="repasswordwindow" title="修改用户密码" style="width: 500px; height: 220px;">
    </div>
    <div id="rechargewindow" title="充值卡充值" style="width: 500px; height: 220px;">
    </div>
    <div id="userregisterwindow" title="替用户注册" style="width: 500px; height: 220px;">
    </div>
    <div id="transwindow" title="用户转账" style="width: 500px; height: 300px;">
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
            var width = $(window).width - 100;
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
        function onRegsiter() {
            $('#userregisterwindow').window('open');
            $('#userregisterwindow').window('refresh', '/Member/adminregister.aspx');
        }
        function fPermission(value, row, index) {
            return "<a href=\'javascript:cancelPermission(" + row.telphone + ")\'>取消限制</a>";
        }
        function cancelPermission(telphone) {
            $.post("/Member/UserAccountHandler.ashx", { action: "cancelPermission", tel: telphone }, function (data) {

                if (data.result == 1) {
                    $.messager.alert('提示', '取消成功');
                }
                else {
                    $.messager.alert('提示', '取消失败');
                }
            }, "json");
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Member/UserAccountHandler.ashx?" + $("#schForm").serialize(),
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
                { field: 'type', title: '用户类型', width: 100, formatter: ftype },
                { field: 'creater', title: '创建人', width: 100 },
                { field: 'pid', title: '查看', width: 100, formatter: fpid },
                 { field: 'ishidefunding', title: '普通用户（不能参加资金活动）', width: 200, formatter: isHide },
                 { field: 'permission', title: '限制(取消订单5次后不能下单)', width: 200, formatter: fPermission },
                    { field: 'isblack', title: '加入黑名单(“是”无法登陆)', width: 150, formatter: fisBlack },
                      { field: 'isvip', title: '是否VIP', width: 100, formatter: fisvip },

                           { field: "version", title: '当前版本号', width: 100 },
                                  { field: "registerdevice", title: '注册设备', width: 100 }
                ]
                ]
            });
        }
        function fisvip(value, row, index) {
            if (value == "是")
                return "<span style='color:red;'></span><a href=\"javascript:changeVipStatus(" + row.id + ",'是')\">是（更改状态）</a>";
            else
                return "<a href=\"javascript:changeVipStatus(" + row.id + ",'否')\">否（更改状态）</a>";
        }
        function changeVipStatus(id, val) {
            if (val == null) {
                val = "否";
            }
            $.post("/Member/UserAccountHandler.ashx", { action: "changevipstatus", id: id, status: val }, function (data) {
                if (data == "1") {
                    $.messager.alert('提示', '更改成功');
                    onSearch();
                }
                else {
                    $.messager.alert('提示', '更改失败');
                }
            });
        }
        function fisBlack(value, row, index) {

            if (value == "是")
                return "<span style='color:red;'>是</span><a href=\'javascript:changeBlack(" + row.id + ")\'>（更改状态）</a>";
            else
                return "否<a href=\'javascript:changeBlack(" + row.id + ")\'>（更改状态）</a>";
        }
        function changeBlack(id) {
            $.post("/Member/UserAccountHandler.ashx", { action: "changeBlack", id: id }, function (data) {
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
                return "是<a href=\'javascript:changeHideFunding(" + row.id + ")\'>（更改状态）</a>";
            else
                return "<span style='color:red;'>否</span><a href=\'javascript:changeHideFunding(" + row.id + ")\'>（更改状态）</a>"
        }

        /* formatter */
        function ftype(value, row, index) {
            var array = new Array("集团管理员", "部门管理员", "集团员工", "个人会员");
            return array[value];
        }

        function fusername(value, row, index) {
            var html = "<a style='text-decoration:underline;' href='javascript:onShow(" + row.id + ")'>" + value + "</a> ";
            return html;
        }
        function fpid(value, row, index) {
            var html = "<a href='javascript:onShow(" + row.id + ")'>查看详细</a> ";
            if (value != 0) {
                html += "<a href='javascript:onShow(" + value + ")'>查看上级</a> ";
            }
            return html;
        }

        function onShow(id) {
            top.addTab("会员详情(ID:" + id + ")", "/Member/UserAccountDetail.aspx?id=" + id, "icon-nav");
        }

        //搜索
        function onSearch() { 
            $("#gdgrid").datagrid("options").url = "/Member/UserAccountHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onExport() {
            var rows = $("#gdgrid").datagrid("getRows").length;
            var options = $("#gdgrid").datagrid('getPager').data("pagination").options;
            var curr = options.pageNumber; 
            window.open("/Member/UserExport.aspx?page="+curr+"&rows="+rows+"&" + $("#schForm").serialize()); 
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

        //修改密码
        function onRePassword() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#repasswordwindow').window('open');
            $('#repasswordwindow').window('refresh', '/Member/UserAccountRePassword.aspx?id=' + row.id);
        }

        //账户充值
        function onRechargeMoney() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $('#rechargewindow').window('open');
            $('#rechargewindow').window('refresh', '/Member/UserAccountRecharge.aspx?id=' + row.id);
        }

        function onTrans() {
            $('#transwindow').window('open');
            $('#transwindow').window('refresh', '/Member/TransMoney.aspx');
        }

        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
