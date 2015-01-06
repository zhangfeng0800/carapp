<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="PCenter.aspx.cs" Inherits="WebApp.PCenter.CompanyInfo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/city.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            PageReady();
            $("#Select_Province").change(function () {
                SelectProvinceChange($("#Select_Province").val(), "Select_City", "","");
            });
            $("#Select_City").change(function () {
                SelectCityChange($("#Select_City").val(), "Select_District", "");
            });
            $("#Button_Submit").click(function () {
                if ($("#Select_Trade").val() == "0") {
                    alert("请选择所属行业！");
                    return false;
                }
                if (GetSelectValue("Select_District") == "") {
                    alert("经营地点请选择完整！");
                    return false;
                }
                if ($("#Text_Tel").val() == "") {
                    alert("请填写联系电话！");
                    return false;
                }
                if (!isPhone($("#Text_Tel").val()) && !isMobile($("#Text_Tel").val())) {
                    alert("联系电话格式有误！");
                    return false;
                }
                if ($("#Select_Kind").val() == "0") {
                    alert("请选择集团性质！");
                    return false;
                }
                $.post("CompanyInfo.aspx", {
                    Action: "SubmitCompanyInfo",
                    Trade: GetSelectValue("Select_Trade"),
                    ProvinceId: GetSelectValue("Select_Province"),
                    CityId: GetSelectValue("Select_City"),
                    DistrictId: GetSelectValue("Select_District"),
                    Kind: GetSelectValue("Select_Kind"),
                    Tel: $("#Text_Tel").val().Trim()
                }, function (data) {
                    if (data.Message == "Complete")
                        alert('修改成功!');
                    else
                        alert(data.Message);
                });
            });
        });
        function PageReady() {
            initCitySelect("Select_Province", "请选择", 0, "<%=Ci.ProvinceId.Trim() %>", "<%=Ci.CityId.Trim() %>", "<%=Ci.DistrictId.Trim() %>");
            //alert("123");
            //citySelectChange("addprovenceID", "addcityId1", "addcityId", "请选择");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="per-order-til">修改集团资料</h3>
    <div class="jiansuo_bg" style="height: 388px;">
        <style type="text/css">
            .Dl_CompInfo {
                width: 80%;
            }
            .Dl_CompInfo *{
                margin: 0px;
                padding: 0px;
            }
            .Dl_CompInfo dt{
                width: 15%;
                float: left;
                height: 35px;
            }
            .Dl_CompInfo dd{
                width: 84%;
                float: left;
                height: 35px;
            }
            .Select_Normal {
                position:absolute;
                top: 0px;
            }
            .Select_Prov {
                left: 0px;
                width: 70px;
            }
            .Select_City {
                left: 80px;
                width: 144px;
            }
            .Select_Dist {
                left: 235px;
                width: 144px;
            }
        </style>
        <div class="Dl_CompInfo">
            <dl>
                <!--dt>集团名称</dt>
                <dd><%=userAccount.Compname %></dd-->
                <dt>所属行业</dt>
                <dd>
                    <select id="Select_Trade">
				        <option value="0">请选择</option>
				        <option value="1">信息传输、计算机服务和软件业</option>
                        <option value="2" >农、林、牧、渔业</option>
                        <option value="3">采矿业</option>
                        <option value="4">制造业</option>
                        <option value="5">电力、热力、燃气及水的生产和供应业</option>
                        <option value="6">环境和公共设施管理业</option>
                        <option value="7">建筑业</option>
                        <option value="8">交通运输、仓储业和邮政业</option>
                        <option value="9">批发和零售业</option>
                        <option value="10">住宿、餐饮业</option>
                        <option value="11">金融、保险业</option>
                        <option value="12">房地产业</option>
                        <option value="13">租赁和商务服务业</option>
                        <option value="14">科学研究、技术服务和地质勘查业</option>
                        <option value="15">水利、环境和公共设施管理业</option>
                        <option value="16">居民服务和其他服务业</option>
                        <option value="17">教育</option>
                        <option value="18">卫生、社会保障和社会服务业</option>
                        <option value="19">文化、体育、娱乐业</option>
                        <option value="20">综合（含投资类、主业不明显）</option>
                        <option value="99">其它</option>
                	</select>
                    <script type="text/javascript">SetSelectValue('Select_Trade', '<%=Ci.Trade %>');</script>
                </dd>
                <dt>经营地点</dt>
                <dd style="position:relative">
                    <select id="Select_Province" name="Select_Province" class="Select_Normal Select_Prov">
                    </select>
                    <select id="Select_City" name="Select_City" class="Select_Normal Select_City">
                    </select>
                    <select id="Select_District" name="Select_District" class="Select_Normal Select_Dist">
                    </select>
                </dd>
                <dt>集团性质</dt>
                <dd>
                    <select id="Select_Kind">
                        <option value="0">请选择</option>
                        <option value="1">民营集团</option>
                        <option value="2">合资集团</option>
                        <option value="3">国有集团</option>
                        <option value="4">外资集团</option>
                        <option value="5">其他集团</option>
                    </select>
                    <script type="text/javascript">SetSelectValue('Select_Kind', '<%=Ci.Kind %>');</script>
                </dd>
                <dt>联系电话</dt>
                <dd><input id="Text_Tel" value="<%=userAccount.Tel %>"/></dd>
                <dt>
                    <!--a href="javascript:Delete()" class="pen_btn"><b>删除所选</b></a>
                    <a href="MyAddressManager.aspx" class="pen_btn"><b>添加常用地址</b></a-->
                    <input type="button" id="Button_Submit" value="提交" class="yc-btn per-button-border" /></dt>
                <dd style="display:none;"></dd>
            </dl>
        </div>
    </div>
</asp:Content>
