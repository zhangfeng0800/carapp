<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HotLineEdit.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.HotLineEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="editid" name="id" value="<%=model.id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>所属城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editprovenceID" style="width: 100px;" name="provenceID">
                    </select>
                    <select class="adm_21" id="editcityId1" style="width: 100px;" name="cityId1">
                    </select>
                    <select class="adm_21" id="editcityId" style="width: 100px;" name="cityId">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>线路名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editname" name="name" value="<%=model.name %>" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    是否景点：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <% if (model.IsTravel == 1)
                       {
                    %>
                    <input type="checkbox" id="editistravel" checked="checked" name="istravel" />是景点
                    <%
                       }
                       else
                       {
                    %>
                    <input type="checkbox" id="editistravel" name="istravel" />是景点
                    <%
                       } %>
                </td>
            </tr>
            <tr id="editpricetr" style="display: none;">
                <td class="adm_45" align="right" height="30" width="22%">
                    门票价格：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editprice" name="price" value="<%=model.Price %>" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    线路图片(大)：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="editimgurl" readonly="readonly" value="<%=model.ImgUrl %>"
                                    style="width: 300px;" name="imgurl" type="text" />&nbsp;&nbsp;<a style="color:blue;" target="_blank" href="../Images/imgPosition/热门目的城市维护大1.jpg">图片位置1</a>  
                                    <a style="color:blue;" target="_blank"  href="../Images/imgPosition/热门目的城市维护大图2.jpg">图片位置2</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iframe src="/FileUpLoad.aspx?id=editimgurl&folder=HotLine&w=450&h=280" frameborder="0" style="border: 0px;
                                    height: 43px;"></iframe>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    线路图片(小)：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="editsimgurl" readonly="readonly" value="<%=model.SImgUrl %>"
                                    style="width: 300px;" name="simgurl" type="text" />&nbsp;<a style="color:blue;" target="_blank"  href="../Images/imgPosition/热门目的城市维护小图.jpg">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iframe src="/FileUpLoad.aspx?id=editsimgurl&folder=HotLine&w=100&h=80" frameborder="0" style="border: 0px;
                                    height: 43px;"></iframe>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    概要说明：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <textarea class="adm_21" id="editsummary" name="summary" style="width: 100%; height: 50px;"><%=model.Summary %></textarea>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <% string guid = Guid.NewGuid().ToString(); %>
                    <script id="editcontainer<%=guid %>" name="content" type="text/plain"><%=model.Description??"" %></script>
                    <script type="text/javascript">
                        var editeditor = UE.getEditor('editcontainer<%=guid %>');
                    </script>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    排序：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editsortorder" value="<%=model.SortOrder %>" name="sortorder"
                        type="text" />
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <script type="text/javascript">
        $(function () {
            initCitySelect('editprovenceID', '请选择', '0', '<%=model.provenceID %>');
            initCitySelect('editcityId1', '请选择', '<%=model.provenceID %>', '<%=model.cityID %>');
            initCitySelect('editcityId', '请选择', '<%=model.cityID %>', '<%=model.countyId %>');
            citySelectChange("editprovenceID", "editcityId1", "editcityId", "请选择");
            citySelectChange("editcityId1", "editcityId", null, "请选择");
            var isTravel = '<%=model.IsTravel %>';
            if (isTravel == '1') {
                $("#editpricetr").show();
            }
            $("#editistravel").click(function () {
                var istravel = $("#editistravel").is(':checked');
                if (istravel) {
                    $("#editpricetr").show();
                } else {
                    $("#editpricetr").hide();
                }
            });
        });

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/ProvinceCity/SaveHotLine.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '操作成功！', 'info', function () {
                            onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }
        //校验表单
        function checkForm() {
            var cityId = $.trim($("#editcityId").val());
            if (cityId == "") {
                showValidateMessage("请选择城市");
                return false;
            }

            var name = $.trim($("#editname").val());
            if (name == "") {
                showValidateMessage("请填写名称");
                return false;
            }
            if (name.length >= 15) {
                showValidateMessage("热门线路名称不能超过15个汉字");
                return false;
            }

            var price = $.trim($("#editprice").val());
            if (!num(price)) {
                showValidateMessage("请输入一个有效的门票价格");
                return false;
            }
            if (parseInt(price) < 0) {
                showValidateMessage("门票价格不能小于0");
                return false;
            }
            if (parseInt(price) > 1000) {
                showValidateMessage("门票价格不能大于1000");
                return false;
            }

            var istravel = $("#editistravel").is(':checked');
            if (istravel) {
                if (price == "") {
                    showValidateMessage("门票价格不能为空");
                    return false;
                }
            }

            var summary = $.trim($("#editsummary").val());
            if (summary.length > 200) {
                showValidateMessage("概要说明不能大于200字");
                return false;
            }

            var sortorder = $.trim($("#editsortorder").val());
            if (!num(sortorder)) {
                showValidateMessage("排序只能是数字");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
