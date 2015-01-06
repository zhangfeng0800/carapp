<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ChargeDescriptionList.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.ChargeDescriptionList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">

   <form id="schForm">
    <input id="action" name="action" value="List" type="hidden" />
 

     <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省份</span> <span class="">
                    <select class="adm_21" id="sprovinceId" style="width: 100px;" name="provinceId">
                    </select>
                </span></span>
                <span class="input_blo"><span class="input_text">城市</span> <span class="">
                    <select class="adm_21" id="scityId" style="width: 100px;" name="cityId">
                    </select>
                </span></span>
                <span class="input_blo"><span class="input_text">区县</span> <span class="">
                    <select class="adm_21" id="scountyId" style="width: 100px;" name="countyId">
                        <option value="">不限</option>
                    </select>
                </span></span>
                 <span class="input_blo">
                 <span class="input_text">状态</span>
                 <span>
                 <select class="adm_21" id="State" style="width: 100px;" name="State">
                        <option value="显示">显示</option>
                        <option value="隐藏">隐藏</option>
                    </select>
                 </span>
                 </span>

                
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
            </div>
        </div>
          <div class="con_bg clearfix">
                    <span class="input_blo">
                          <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">新增</a>
                    </span>
                      <span class="input_blo">
                          <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">修改</a>
                    </span>
                    <span class="input_blo">
                              <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">删除</a>
                    </span>
                      <span class="input_blo">
                            （该信息显示在app的《扣费规则》中，选择省市区针对这个城市，不限制面向所有城市的用户）
                    </span>
            </div>
    </div>

          

    <table id="gdgrid">
    </table>
     <div id="addwindow" title="新增扣费说明" style="width: 1000px; height: 660px;">
    </div>
      <div id="editwindow" title="编辑扣费说明" style="width: 1000px; height: 660px;">
    </div>
    </form>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            bindGrid();
            bindWin();

            initCitySelect("sprovinceId", "不限", 0, "");
            initCitySelect("scityId", "不限", "13", "");
            citySelectChange("sprovinceId", "scityId", "scountyId", "不限");
            citySelectChange("scityId", "scountyId", "", "不限");
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

        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/ProvinceCity/ChargeDescription.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                singleSelect: true,
                remoteSort: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "用户扣费说明",
                frozenColumns: [[
                 { field: 'ck', checkbox: true }
                ]],
                columns: [
                [
                 { field: 'Id', title: '编号', width: 100, width: 100 },
                { field: 'TownId', title: '城市', width: 100, width: 120 },

                { field: 'Description', title: '扣费说明', width: 500 },
                 { field: 'State', title: '状态', width: 100 },
                { field: 'Sort', title: '排序', width: 100 }
                    ]
                ]
            });
        }
        function setImg(value, row, index) {
            return "<img src='" + value + "' style='width:50px; height:50px;'>";
        }

        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/ProvinceCity/ChargeDescriptionAdd.aspx');
        }
        function onEdit() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["Id"];
            $('#editwindow').window('open');
            $('#editwindow').window('refresh', '/ProvinceCity/ChargeDescriptionEdit.aspx?id=' + id);
        }

        function onDelete() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            var id = row["Id"];
            if (confirm("确认要删除吗?")) {
                $.post("/ProvinceCity/ChargeDescription.ashx", { 'action': 'Delete', 'id': id }, function (data) {
                    onSearch();
                });
            }
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/ProvinceCity/ChargeDescription.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            window.location.reload();
        }

  </script>
</asp:Content>
