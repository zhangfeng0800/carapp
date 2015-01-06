<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="CarBrand.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarBrand" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    
    <form id="schForm">
    <input name="action" id="action" value="list" type="hidden" />
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                信息查询</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">品牌名称</span> <span class="">
                    <input class="adm_21" id="Keyword" name="Keyword" type="text" value="" />
                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                    iconcls="icon-search">查询</a> </span>
            </div>
        </div>
    </div>
    <div id="toolbar" class="datagrid-toolbar">
        <table>
            <tr>
                <td>
                    <a href="javascript:onAdd()" class="easyui-linkbutton" iconcls="icon-add">添加</a>
                </td>
                <td>
                    <a href="javascript:onEdit()" class="easyui-linkbutton" iconcls="icon-edit">编辑</a>
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
    <div id="addwindow" title="添加新的品牌">
    </div>
    <div id="editwindow" title="编辑品牌信息">
    </div>
    <div id="w" class="easyui-window" title="查看图片" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 350px; height: 350px;">
        <span>
            <img src="" id="imgcontainer" style="margin: 0 auto;" /></span>
    </div>

    <div id="num" class="easyui-window" title="查看所属" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 350px; height: 350px;">
        <table id="mydata">
            
        </table>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            resizeTable();
            resizeCarWindow("addwindow");
            resizeCarWindow("editwindow");
            bindGrid();
            bindWin();
        });


        function showBimg(value, data, index) {
            return "<a  style=\"text-decoration:underline\" href=\"javascript:showImg(true,'" + value + "')\">点击查看</a>";
        }
        function showSimg(value, data, index) {
            return "<a style=\"text-decoration:underline\" href=\"javascript:showImg(false,'" + value + "')\">点击查看</a>";
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
        function showImg(isbig, value) {
            if (isbig) {
                $("#imgcontainer").css("width", 250);
                $("#imgcontainer").css("height", 190);
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
        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height()-10);
            var width = $(window).width();
            $("#gdgrid").css("height", height);
            $("#gdgrid").css("width", width);
            $("#querycontainer").css("width", width);
        }
        function resizeCarWindow(name) {
            var height = $(window).height() - 50;

            var width = $(window).width() - 20;
            $("#" + name).css("width", width);
            $("#" + name).css("height", height);
        }
        //绑定数据表格
        function bindGrid() {
            $('#gdgrid').datagrid({
                url: "/Car/CarBrandList.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: true,
                singleSelect: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "公司服务车型管理",
                toolbar: "#toolbar",
                columns: [
                [
{ field: 'ck', checkbox: true, width: 50 },
              {
                  field: 'brandName',
                  title: '品牌名称',
                  width: 140,
                  formatter: function (value, row, index) {
                      var str = row.brandName;
//                      if (row.imgUrl != null && row.imgUrl != "") {
//                          str = '<img style="width:20px;height:20px;" src="' + row.ImgUrl + '" alt="' + row.brandName + '" />' + str;
//                      }
                      return str;
                  }
              },
                { field: 'description', title: '品牌描述', width: 300 },
                { field: 'imgUrl', title: '品牌图片（大）', width: 150, formatter: showBimg },
                { field: 'sImgUrl', title: '品牌图片（小）', width: 150, formatter: showSimg },
                  { field: 'sort', title: '排序字段', width: 100 },
                  { field: 'brandNum', title: '登记车辆（辆）', width: 100, formatter: GetBrandNum },
                  { field: 'brandDriverNum', title: '司机登录（辆）', width: 100 },
                    ]
                ]
            });
      }
      function GetBrandNum(value, row, index) {
          return "<a style=\"text-decoration:underline\" href=\"javascript:showData(" + row.id + ")\">" + value + "</a>";
      }
      function showData(value) {
          $('#mydata').datagrid({
              url: "/Car/CarBrandList.ashx?BrandId=" + value,
              method: 'post',
              pagination: false,
              fitColumns: true,
              singleSelect: true,
              title: "",
              columns: [
                    [
                    { field: 'cityName', title: '城市名称', width: 150 },
                    { field: 'num', title: '数量（辆）', width: 150 }
                    ]
                ]
          });

          $("#num").window("open");
      }

        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/CarBrandList.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        function onAdd() {
            $('#addwindow').window('open');
            $('#addwindow').window('refresh', '/Car/CarBrandAdd.aspx');
        }
        function onEdit() {
            edit("gdgrid", "editwindow", "id", "/Car/CarBrandEdit.aspx?id=");
        }

        function onDelete() {
            ajaxdelete("carBrand", "id", "id", "gdgrid", onSearch);
        }
        //关闭弹窗
        function onClose() {
            $('[id$=window]').window('close');
            onSearch();
        }
    </script>
</asp:Content>
