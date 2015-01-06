<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarCityNum.aspx.cs" MasterPageFile="~/Admin.Master"
    Inherits="CarAppAdminWebUI.Car.CarCityNum" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <form id="schForm">
    <div class="container" id="querycontainer">
        <div class="con_border">
            <h3 class="con_til">
                城市车辆统计</h3>
            <div class="con_bg clearfix">
                <span class="input_blo"><span class="input_text">省&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;份</span>
                    <span class="">
                        <select class="adm_21" style="width: 80px;" id="province" name="province">
                        </select>
                    </span></span><span class="input_blo"><span class="input_text">城&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;市</span>
                        <span class="">
                            <select class="adm_21" id="city" name="city" style="width: 80px;">
                            </select></span> </span><span class="input_blo"><span class="input_text">区&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;县</span>
                                <span class="">
                                    <select class="adm_21" style="width: 80px;" id="town" name="town">
                                    </select>
                                </span></span><span class="input_blo"><a href="javascript:onSearch()" class="easyui-linkbutton"
                                    icon="icon-search">查询</a></span>
            </div>
        </div>
    </div>
    </form>
    <table id="gdgrid">
    </table>
    <div id="w" class="easyui-window" title="城市车辆" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,resizable:false"
        style="width: 700px; height: 500px;">
        <span>
            <table id="cityCar">
            </table>
        </span>
    </div>
    <script type="text/javascript">
        //初始化
        $(function () {
            initProvinceSelectValue("province", "不限", "13");
            initCitySelect("city", "不限", "13", "");
            initCitySelect("town", "不限", "1301", "");

            citySelectChange("province", "city", "town", "不限");
            citySelectChange("city", "town", "", "不限");


            resizeTable();
            bindGrid();
            bindWin();
        });

        function resizeTable() {
            var height = ($(window).height() - $("#querycontainer").height() - 10);
            var width = $(window).width;
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
                url: "/Car/CarCityNum.ashx?" + $("#schForm").serialize(),
                method: 'post',
                pagination: true,
                rownumbers: true,
                showFooter: true,
                fitColumns: false,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "城市车辆统计",
                columns: [[
                { field: 'proName', title: '省份', width: 100 },
                { field: 'cityName', title: '城市', width: 150 },
                { field: 'countyName', title: '区县', width: 150 },
                { field: 'carNum', title: '车数量', sortable: true, width: 150,
                    styler: function (value, row, index) {
                        if (value > 30) {
                            return 'background-color:#ffee00;color:red;';
                        }
                    }
                },
                { field: 'cx', title: '查看详情', width: 100, formatter: getCarInfo }
                ]]
            });
        }
        //搜索
        function onSearch() {
            $("#gdgrid").datagrid("options").url = "/Car/CarCityNum.ashx?" + $("#schForm").serialize();
            $("#gdgrid").datagrid("load");
        }
        //获得车辆信息
        function getCarInfo(value, row, index) {
            if (value != "") {
                var html = "<a title='点击查看城市车辆' style=\"text-decoration:underline\" href='javascript:onDetail(\"" + row.ProvinceId + "\",\"" + row.CityId + "\",\"" + row.CountyId + "\")'>" + value + "</a>";
                return html;
            }
            return value;
        }
        function onDetail(province, city, county) {
            //绑定数据表格
            $('#cityCar').datagrid({
                url: "/Car/CarInfoHandler.ashx?action=list&province=" + province + "&city=" + city + "&town=" + county + "",
                method: 'post',
                pagination: true,
                rownumbers: true,
                fitColumns: false,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                title: "",
                columns: [[
                        { field: 'carNo', title: '车牌号', width: 100 },
                        { field: 'CityName', title: '所属城市', width: 100 },
                        { field: 'telPhone', title: '电话号码', width: 100 },
                        { field: 'brandName', title: '名称', width: 150 },
                        { field: 'CarType', title: '车辆类型', width: 150 },
                    ]]
            });
            $("#w").window("open");
        }    
    </script>
</asp:Content>
