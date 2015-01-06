<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="RentCar.aspx.cs" Inherits="CarAppAdminWebUI.Car.RentCar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省份</span> <span class="">
                    <select class="adm_21" id="provenceID" style="width: 80px;" name="provenceID">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">城市</span> <span class="">
                    <select class="adm_21" id="cityId" style="width: 80px;" name="cityId">
                    </select></span> </span><span class="input_blo"><span class="input_text">区县</span> <span
                        class="">
                        <select class="adm_21" id="areaId" style="width: 80px;" name="areaId">
                        </select>
                    </span></span><span class="input_blo"><span class="input_text">用车方式</span> <span
                        class="">
                        <select id="caruseway" name="caruseway">
                         <option value="">不限</option>
                        <%foreach (var model in Caruseway)
                          { %>
                          <option value="<%=model.Id %>"><%=model.Name %></option>
                          <%} %>
                               
                     
                        </select>
                    </span></span><span class="input_blo"><span class="input_text">车辆类型</span> <span
                        class="">
                        <select id="cartype" name="cartype">
                            <option value="">不限</option>
                            <% for (int i = 0; i < CarType.Rows.Count; i++)
                               {%>
                            <option value="<%=CarType.Rows[i]["id"] %>">
                                <%=CarType.Rows[i]["typename"] %></option>
                            <%} %>
                        </select>
                    </span></span><span class="input_blo"><span class="input_text">状态</span> <span class="">
                        <select class="adm_21" style="width: 100px;" id="sIsDelete" name="sIsDelete">
                            <option value="">不限</option>
                            <option value="0" selected="selected">正常运行</option>
                            <option value="2">暂停</option>
                            <option value="1">删除</option>
                        </select>
                    </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                        iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">添加</a>&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="javascript:onEditPause()" class="easyui-linkbutton" iconcls="icon-edit">暂停/恢复</a>&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
            </tr>
        </table>
    
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="添加新的用车类型" style="width: 800px; height: 500px;">
    </div>
    <div id="editwindow" title="编辑用车类型" style="width: 800px; height:570px;">
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            initProvinceSelectValue("provenceID", "不限", "13");
            initCitySelect("cityId", "不限", "13", "1301");
            initCitySelect("areaId", "不限", "1301", "");

            citySelectChange("provenceID", "cityId", "areaId", "不限");
            citySelectChange("cityId", "areaId", "", "不限");
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
                url: "/Car/RentCarHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                toolbar: "#toolbar",
                title: "城市用车信息管理",
                frozenColumns: [[
                 { field: 'ck', checkbox: true },
              { field: 'cityName', title: '所属城市', width: 100 }
                ]],
                columns: [
                [
                { field: 'CarUseWayName', title: '用车方式名称', width: 100 },
                { field: 'carTypeName', title: '车辆类型名称', width: 100 },
                { field: 'startPrice', title: '起步价（元/次）', width: 100 },
                { field: 'DiscountPrice', title: '折扣价（元/次）', width: 100 },
                { field: 'feeIncludes', title: '起步价描述', width: 100 },
                { field: 'kiloPrice', title: '超公里（元/公里）', width: 100 },
                { field: 'hourPrice', title: '超分钟（元/分钟）', width: 100 },
                { field: 'hotLineName', title: '热门线路名称', width: 100 },
                { field: 'brandName', title: '包含品牌', width: 300 },
                { field: 'isDelete', title: '状态', width: 100, formatter: fstatus }
                    ]
                ]
            });
        }

        /* formatter */
        function fstatus(value, row, index) {
            var status = new Array("正常", "<span style='color:red;'>已删除</span>","<span style='color:red;'>暂停</span>");
            return status[value];
        }
        /* 0往返 1单程 */
        function fhotLineName(value, row, index) {
            if (value == "" || value == null || value == "null") {
                return "";
            }
            alert(row.isoneway);
            if (row.isoneway == "0") {
                return "[往返]" + value;
            } else {
                return "[单程]" + value;
            }
        }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/RentCarHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Car/RentCarAdd.aspx');
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "id", "/Car/RentCarEdit.aspx?id=");
        }
        function onEditPause() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.post("/Car/RentCarHandler.ashx", { "action": "editpause", "id": row.id }, function (data) {
                if (data == "success")
                    $.messager.alert('消息', '操作成功！', 'info', function () {
                        onSearch();
                    });
            });
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            $.messager.confirm("提示", "此项操作会删除此信息,并且此操作不可恢复，你确定要执行此操作么？", function (r) {
                if (r) {
                    $.post("/Car/RentCarHandler.ashx", { "action": "delete", "id": row.id }, function (data) {
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
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
