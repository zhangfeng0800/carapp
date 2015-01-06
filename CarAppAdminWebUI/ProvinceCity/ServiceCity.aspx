<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ServiceCity.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.ServiceCity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省份</span> <span class="">
                    <select class="adm_21" id="provenceID" name="provenceID">
                    </select>

                       
                </span></span>
                  <span class="input_blo"><span class="input_text">城市</span> <span class="">
                    <select class="adm_21" id="cityID" name="cityID">
                       <option value="">不限</option>
                    </select>
                </span></span>
                
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a></span> <span class="input_blo">
                    <a href="javascript:onDelete()"
                        class="easyui-linkbutton" style="display:none;" iconcls="icon-remove">删除</a> </span>
            </div>
        </div>
    </div>
    
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="开通新的服务" style="width: 600px; height: 440px;">
    </div>
    <div id="editwindow" title="编辑服务信息" style="width: 600px; height: 440px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            initProvinceSelect("provenceID", "不限");
            citySelectChange("provenceID", "cityID", "", "不限");
            initCarUseWay();
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
            var height = $(window).height() -$("#querycontainer").height()-10;
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        
        }

        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/ProvinceCity/ServiceCityList.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "开通服务城市管理",
                collapsible: true,
                frozenColumns: [[
                { field: 'ck', checkbox: true },
                { field: 'CityName', title: '城市名称' }
                ]],
                columns: [
                    [
                        { field: 'CarUseWays', title: '开通的用车方式' },
                        { field: 'HotLines', title: '开通的热门线路城市' }
                    ]
                ]
            });
        }
        function initCarUseWay() {
            $.get("/Ajax/GetAllCarUseWay.ashx", null, function (data) {
                var pro = "";
                pro += '<option value="">不限</option>';
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].Id + '>';
                    pro += data[i].Name;
                    pro += '</option>';
                }
                $("#caruseway").append(pro);
            }, "json");
        }
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/ProvinceCity/ServiceCityList.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "此项操作会删除该城市开通的所有用车服务,并且此操作不可恢复，你确定要执行此操作么？", function (r) {
                if (r) {
                    $.post("/ProvinceCity/SaveServiceCity.ashx", { "action": "delete", "cityId": row.CityId }, function (data) {
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
    </script>
</asp:Content>
