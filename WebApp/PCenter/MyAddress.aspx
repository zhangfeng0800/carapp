<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyAddress.aspx.cs" Inherits="WebApp.PCenter.MyAddress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        function ShowAddData() {
            $("#addData").show();
        }
        $(function () {
            var isChecked = 0;
            $("#selectAll").click(function () {
                if (isChecked == 0) {
                    $("input[name='selects']").each(function () {
                        $(this).attr("checked", "checked");
                    });
                    isChecked = 1;
                }
                else if (isChecked == 1) {
                    $("input[name='selects']").each(function () {
                        $(this).removeAttr("checked");
                    });
                    isChecked = 0;
                }
            });
            GoToPage(1);
            $("#firstpge").click(function () {
                GoToPage(1);
            });
            $("#lastpage").click(function () {
                GoToPage($("#totalpage").val());
            });
            $("#prepage").click(function () {
                var pageIndex = parseInt($("#currentpage").val());
                if (pageIndex > 1) {
                    GoToPage(pageIndex-1);
                }
            });
            $("#nextpage").click(function () {
                var pageIndex = parseInt($("#currentpage").val());
                if (pageIndex < parseInt($("#totalpage").val())) {
                    GoToPage(pageIndex + 1);
                }
            });
        })

     

        function GoToPage(pageIndex) {

            $.post("/api/MyAddress.ashx", { action: "List", pageIndex: pageIndex }, function (data) {

                if (data.resultcode == 0) {
                    alert("登陆信息有误");
                    return;
                }
                var list = data.list;
                var pageCount = data.pageCount;

                $("#totalpage").val(pageCount);
                $("#currentpage").val(pageIndex);
                $("#tbodylist").val("");

                var html = "";
                for (i = 0; i < list.length; i++) {
                    html += "<tr><td><input type=\"checkbox\" name='selects' value='" + list[i].id + "'/></td><td>" + list[i].provinceID + "</td><td>" + list[i].address + "</td><td>" + list[i].remarks + "</td><td>" + list[i].sort + "</td>" 
                    +"<td><a href='MyAddressManager.aspx?id=" + list[i].id + "'>修改</a></td></tr>";
                }
                $("#tbodylist").html(html);
            }, "json");
        }
        

        function Delete() {
            var datas = "";
            $("input[name='selects']").each(function () {
                if ($(this).prop("checked") == true) {
                    datas += ($(this).val() + ",");
                }
            });
            if (datas.length == 0) {
                alert("请选择");
                return;
            }
            $.post("/api/MyAddress.ashx", { 'action': 'Delete', 'ids': datas }, function (data) {
                window.location.href = "<%=Request.Url %>";
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <h3 class="per-order-til">
                修改常用地址</h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <div class="dingdan_tb">
                    <table class="order_tb" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:10px">
                        <tr class="order_tr" id="tr_title">
                            <td style="width:8%">
                                <input type="checkbox" id="selectAll"/>全选</td>
                            <td style="width: 20%;">城市</td>
                            <td style="width: 20%;">地址</td>
                            <td style="width: 20%;">备注</td>
                            <td style="width: 12%;">排序（从大到小）</td>
                             <td style="width: 8%;">操作</td>
                        </tr>
                        <tbody id="tbodylist">
                           <%-- <%
                                foreach (var item in address)
                                {
                                    Response.Write("<tr>");
                                    Response.Write("<td>");
                                    Response.Write("<input type=\"checkbox\" name='selects' value='" + item.id + "'/></td> ");
                                    Response.Write("<td>" + new BLL.CityBLL().GetFullAddressByCodeID(item.cityID) + "</td>");
                                    Response.Write("<td>" + item.address + "</td>");
                                    Response.Write("<td>" + item.remarks + "</td>");
                                    Response.Write("<td>" + item.sort + "</td>");
                                    Response.Write("<td><a href='MyAddressManager.aspx?id=" + item.id + "'>修改</a></td>");
                                    Response.Write("</tr>");
                                }
                            %>--%>
                        </tbody>
                    </table>
                      <div style="text-align: center; margin-top: 20px;" id="pager">
            <a href="javascript:;" style="margin: 0 10px;" id="firstpge">首页</a><a href="javascript:;"
                style="margin: 0 10px;" id="prepage">上一页</a> <a href="javascript:;" style="margin: 0 10px;"
                    id="nextpage">下一页</a> <a href="javascript:;" style="margin: 0 10px;" id="lastpage">末页</a>
            当前第<input type="text" id="currentpage" readonly="readonly" style="border: 0; width: 30px;
                text-align: center;" />页 总共
            <input type="text" id="totalpage" readonly="readonly" style="border: 0; width: 30px;
                text-align: center;" />页
            <input type="hidden" id="txtstatus" readonly="readonly" />
        </div>

                    <a href="javascript:Delete()" class="person-button"><em>删除所选</em></a>
                    <a href="MyAddressManager.aspx" class="person-button"><em>添加常用地址</em></a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
