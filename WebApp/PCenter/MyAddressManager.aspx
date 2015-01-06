<%@ Page Title="" Language="C#" MasterPageFile="~/PCenter/PCenter.Master" AutoEventWireup="true" CodeBehind="MyAddressManager.aspx.cs" Inherits="WebApp.PCenter.MyAddressManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/MySite.js" type="text/javascript"></script>
    <script type="text/javascript">
        function checkNull() {
            if ($("input[name='address']").val() == "") {
                $("#error").html("地址不能为空！");
                return false;
            }
            else if ($("#provice").val() == "-1" || $("#provice").val() == "") {
                $("#error").html("省不能为空！");
            }
            else if ($("#city").val() == "-1" || $("#city").val() == "") {
                $("#error").html("市不能为空！");
            }
            else if ($("#town").val() == "-1" || $("#town").val() == "") {
                $("#error").html("县不能为空！");
            }
            else if ($("#location").val() == "") {
                $("#error").html("无效的地址！");
            }
            else {
                $("#sendData").submit();
            }
        }
        $(function () {
            <%if(userAddress.id != 0){ %>
            initCitySelect("province", "请选择", 0, "<%=provinceID %>");
            initCitySelect("city", "请选择", "<%=provinceID %>", "<%=cityID %>");
            initCitySelect("town", "请选择", "<%=cityID %>", "<%=townID %>");

             <%} else{ %>

            initCitySelect("province", "请选择", 0, "");
          
            <%} %>

            citySelectChange("province", "city", "town", "请选择");
            citySelectChange("city", "town", "", "请选择"); 

            $("#town").change(function(){
                 $("#address").val("");
    $("#remark").val("");
    $("#location").val("");
            });
        });
        function getCityName(prarent, selectid) {
            $.post("../PCenter/api/getCity.ashx", { "prarent": prarent }, function (data) {
                $("#" + selectid).html(data);
            });
        }
function initCitySelect(targetId, defaultvalue,pid, value) {
    $.get("/api/GetCitys.ashx", {"pid":pid}, function (data) {
        var pro = "";
        pro += '<option value="">' + defaultvalue + '</option>';
        for (var i = 0; i < data.length; i++) {
            pro += '<option value=' + data[i].codeid + '>';
            pro += data[i].cityname;
            pro += '</option>';
        }
        $("#" + targetId).append(pro);
        if (value != null && value != "") {
            $("#" + targetId).val($.trim(value));
        }
    }, "json");
}

function citySelectChange(actionSelect, targetSelect, targetSelect1,defaultvalue) {
    $("#" + actionSelect).change(function () {
        var pid = $(this).val();
        if (pid != "") {
            $.get("/api/GetCitys.ashx", { "pid": pid }, function(data) {
                $("#" + targetSelect).empty();
                $("#" + targetSelect).append('<option value="">' + defaultvalue + '</option>');
                if (targetSelect1 != null || targetSelect1 == "") {
                    $("#" + targetSelect1).empty();
                    $("#" + targetSelect1).append('<option value="">' + defaultvalue + '</option>');
                }
                var pro = "";
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].codeid + '>';
                    pro += data[i].cityname;
                    pro += '</option>';
                }
                $("#" + targetSelect).append(pro);
            }, "json");
        } else {
            $("#" + targetSelect).empty();
            $("#" + targetSelect).append('<option value="">' + defaultvalue + '</option>');
            if (targetSelect1 != null || targetSelect1 == "") {
                $("#" + targetSelect1).empty();
                $("#" + targetSelect1).append('<option value="">' + defaultvalue + '</option>');
            }
        }
    });
}
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_part_per">
        <div>
            <h3 class="per-line-til">
                <%=Method %></h3>
            <div class="jiansuo_bg" style="height: 388px;">
                <form action="MyAddressManager.aspx" method="post" id="sendData">
                <input type="hidden" value="<%=FormMethod %>" name="event" />
                <input type="hidden" value="<%=updateID %>" name="updateid" />
                <ul class="per-ul">
                    <li>
                        <span class="per-name-style">*地区：</span>
                        <select name="province" id="province">
                        </select>
                        <select name="city" id="city">
                        </select>
                     <select name="town" id="town" onclick="clear()">
                        </select>
                    </li>
                    <li><span class="per-name-style">*地址：</span>
                        <input type="text" id="address" name="address" value="<%=userAddress.address %>" onkeyup="getPlaces(this)" style="width:350px;" AUTOCOMPLETE="off" maxlength="200"  />
                        <div style="margin-left:90px; width:350px; display:none; border-left:1px solid #ccc; border-right:1px solid #ccc; border-bottom:1px solid #ccc; z-index:10000" id="result" class="backg"></div>
                        </li>
                     
                    <li><span class="per-name-style">*备注：</span>
                        <input style="width:350px;" type="text" id="remark" name="remark" value="<%=userAddress.remarks %>" /></li>
                                
                  
                   <li><span class="per-name-style">排序：</span> <input type="text" id="sort" name="sort" value="<%=userAddress.sort %>" onkeyup="this.value=this.value.replace(/\D/g,'')" maxlength="5" /></li>
                              <li>

                        <label id="error" style="color:Red">
                        </label>
                        <input type="hidden" id="location" name="location" value="<%=userAddress.location %>" />
                    </li>
                  
                    <li class="per-button-padding">
                        <input class="yc-btn bank-btn per-button-border" type="button" value="保存" onclick="checkNull()"></li>
                </ul>
                </form>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function select(obj) {
            $(obj).css("background", "#DEDEDE");
        }
        function unselect(obj) {
            $(obj).css("background", "");
        }
        function getPlaces(obj) {
            getplace($(obj).val(), $("#city").val()+"01", "#result", "#location", "#address", "#remark")
        }
        function getplace(q, c, container, positionContainer, namecontainer, addresscontainer) {
            $.ajax({
                url: "/api/baiduplaceapi.ashx",
                data: { q: q, c: c },
                type: "post",
                success: function (data) {
                    if (data.status == 0) {
                        var dataResult = "";
                        if (data.results.length == 0) {
                            return;
                        }
                        $.each(data.results, function (index, val) {
                            if (val.name && val.address) {
                                dataResult += "<p style='width:350px;' onmouseover='select(this)' onmouseout='unselect(this)' position=\"" + val.location.lng + "," + val.location.lat + "\" onclick=\'setValue(\"" + index + "\",\"" + container + "\",\"" + positionContainer + "\",\"" + namecontainer + "\",\"" + addresscontainer + "\")\' id=\"p" + index + "\">" + val.name + "," + val.address + "</p>";
                            }
                        });
                        $(container).show();
                        $(container).html(dataResult);
                    }
                }
            });
        }
        function setValue(id, parentContainer, postioncontainer, namecontainer, addresscontainer) {
            var html = $("#p" + id).html();
            $(namecontainer).val(html.split(',')[0]);
            $(addresscontainer).val(html.split(',')[1]);
            $(parentContainer).hide();
            $(postioncontainer).val($("#p" + id).attr("position"));
            $(parentContainer).html("");
        }
        </script>

</asp:Content>
