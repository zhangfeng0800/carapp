<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="ServiceCityList.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.ServiceCityList1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
   
    <form id="schForm">
    <input id="action" name="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省份</span> <span class="">
                    <select class="adm_21" style="width: 100px;" id="provenceID" name="provenceID">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">城市</span> <span class="">
                    <select class="adm_21" style="width: 100px;" id="cityId" name="cityId">
                    </select>
                </span></span><span class="input_blo"><span class="input_text">区县</span> <span class="">
                    <select class="adm_21" style="width: 100px;" id="areaId" name="areaId">
                        <option value="">不限</option>
                    </select>
                </span></span><span class="input_blo"><span class="input_text">服务方式</span> <span
                    class="">
                    <select class="adm_21" id="caruseway" name="caruseway">
                    <option value="6" selected="selected">热门线路</option>
                    </select>
                </span></span>
                <span class="input_blo"><span class="input_text">状态</span> <span
                    class="">
                    <select class="adm_21" id="state" name="state">
                        <option value="-1">不限</option>
                         <option value="0">正常</option>
                           <option value="1">已删除</option>
                    </select>
                </span></span>
                <span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
      <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td colspan="5">
                  <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-remove">添加</a>
                    <a href="javascript:onAddHotLine()" class="easyui-linkbutton" iconcls="icon-remove">
                        添加热门线路</a> <a href="javascript:onEditHotLine()" class="easyui-linkbutton" iconcls="icon-remove">
                            编辑热门线路图片</a> <a href="javascript:onDelete()" class="easyui-linkbutton" iconcls="icon-remove">
                                删除</a>
                               <%--  <a href="javascript:onRecovery()" class="easyui-linkbutton" iconcls="icon-remove">
                                恢复</a>--%>
                </td>
            </tr>
        </table>
        <div style="clear: both;">
        </div>
    </div>
     
    </form>
    <table id="gdgrid">
    </table>
    <div id="addwindow" title="开通新的服务" style="width: 600px; height: 220px;">
    </div>
    <div id="addhotlinewindow" title="开通新的热门线路" style="width: 600px; height: 300px;">
    </div>
    <div id="edithotlinewindow" title="编辑热门线路图片" style="width: 600px; height: 195px;">
    </div>
    <div id="w" class="easyui-window" title="查看图片" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 350px; height: 350px;">
        <span>
            <img src="" id="imgcontainer" style="margin: 0 auto;" /></span>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            initProvinceSelectValue("provenceID", "不限", "13");
            initCitySelect("cityId", "不限", "13", "");

            citySelectChange("provenceID", "cityId", "areaId", "不限");
            citySelectChange("cityId", "areaId", "", "不限");

            //initCarUseWay();
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
            $("#querycontainer").width(width);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/ProvinceCity/ServiceCityHandler.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "开通服务城市管理",
                toolbar:"#toolbar",
                columns: [
                    [
                        { field: 'ck', checkbox: true },
                        { field: 'cityName', title: '城市名称', width: 100 },
                        { field: 'carusewayName', title: '服务方式', width: 100 },
                        { field: 'HotlineName', title: '热门线路', width: 100 },
                        { field: 'imgurl', title: '图片', width: 100, formatter: showBimg },
                        { field: 'isDelete', title: '状态', width: 100, formatter: fstatus }
                    ]
                ]
            });
        }
        function showBimg(value, data, index) {
            return "<a  style=\"text-decoration:underline\" href=\"javascript:showImg(true,'" + value + "')\">点击查看</a>";
        }
        function showImg(isbig, value) {
            if (isbig) {
                $("#imgcontainer").css("width", 200);
                $("#imgcontainer").css("height", 250);
                $("#imgcontainer").css("margin-left", 50);
                $("#imgcontainer").css("margin-top", 25);
            } else {
                $("#imgcontainer").css("width", 150);
                $("#imgcontainer").css("height", 150);
                $("#imgcontainer").css("margin-left", 75);
                $("#imgcontainer").css("margin-top", 75);
            }
            if (value == "" || value == null) {
                $.messager.alert("提示信息", "暂无图片");
                return;
            }
            $("#imgcontainer").attr("src", value);
            $("#w").window("open");
        }
        /* formatter */
        function fstatus(value, row, index) {
            var status = new Array("正常", "<span style='color:red;'>已删除</span>");
            return status[value];
        }

        function fImgUrl(value, row, index) {
            if (value == "") {
                return "";
            } else {
                return '<img src="' + row.ImgUrl + '" style="width:30px;height:30px;" /> ' + row.ImgUrl;
            }
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

        function onRecovery() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            if (row.isDelete!=1) {
                $.messager.alert('消息', '该数据未删除，不用恢复', 'error');
                return;
            }
            $.post("/ProvinceCity/ServiceCityHandler.ashx", { "action": "Recovery", "Id": row.id }, function (data) { 
                
            })
        }

        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/ProvinceCity/ServiceCityHandler.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/ProvinceCity/ServiceCityItemAdd.aspx');
        }
        function onAddHotLine() {
            $('#addhotlinewindow').window('open');
            $('#addhotlinewindow').window('refresh', '/ProvinceCity/ServiceCityHotLineAdd.aspx');
        }

        function onEditHotLine() {
            var row = $("#gdgrid").datagrid("getSelected");
            if (!row) {
                $.messager.alert('消息', '你没有选择数据', 'error');
                return;
            }
            if (row.carusewayID != 6) {
                $.messager.alert('消息', '只有热门线路允许修改图片', 'error');
                return;
            }
            $('#edithotlinewindow').window('open');
            $('#edithotlinewindow').window('refresh', "/ProvinceCity/ServiceCityHotLineEdit.aspx?id=" + row.id);
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
            $.messager.confirm("提示", "此项操作会删除该城市开通的用车服务,并且此操作不可恢复，你确定要执行此操作么？", function (r) {
                if (r) {
                    $.post("/ProvinceCity/ServiceCityHandler.ashx", { "action": "delete", "id": row.id }, function (data) {
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
