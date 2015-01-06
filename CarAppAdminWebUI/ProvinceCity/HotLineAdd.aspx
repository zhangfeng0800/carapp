<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HotLineAdd.aspx.cs" Inherits="CarAppAdminWebUI.ProvinceCity.HotLineAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
 <div style="padding: 5px;">
        <form id="addForm">
        <input type="hidden" id="action" name="action" value="add" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>所属城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addprovenceID" style="width: 100px;" name="provenceID">
                    </select>
                    <select class="adm_21" id="addcityId1" style="width: 100px;" name="cityId1">
                        <option value="">请选择</option>
                    </select>
                    <select class="adm_21" id="addcityId" style="width: 100px;" name="cityId">
                        <option value="">请选择</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>线路名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addname" name="name" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    是否景点：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input type="checkbox" id="addistravel" name="istravel"/>是景点
                    
                </td>
            </tr>
            <tr id="addpricetr" style="display: none;">
                <td class="adm_45" align="right" height="30" width="22%">
                    门票价格：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addprice" name="price" type="text" value="0" />
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
                                <input class="adm_21" id="addimgurl" readonly="readonly" style="width: 300px;" name="imgurl"
                                    type="text" />  <a style="color:blue;" target="_blank" href="../Images/imgPosition/热门目的城市维护大1.jpg">图片位置1</a>  
                                    <a style="color:blue;" target="_blank"  href="../Images/imgPosition/热门目的城市维护大图2.jpg">图片位置2</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iframe src="/FileUpLoad.aspx?id=addimgurl&folder=HotLine&w=450&h=280" frameborder="0" style="border: 0px;
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
                                <input class="adm_21" id="addsimgurl" readonly="readonly" style="width: 300px;" name="simgurl"
                                    type="text" /> &nbsp;<a style="color:blue;" target="_blank"  href="../Images/imgPosition/热门目的城市维护小图.jpg">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iframe src="/FileUpLoad.aspx?id=addsimgurl&folder=HotLine&w=100&h=80" frameborder="0" style="border: 0px;
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
                    <textarea class="adm_21" id="addsummary" name="summary" style="width: 100%;height: 50px;"></textarea>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <% string guid = Guid.NewGuid().ToString(); %>
                    <script id="container<%=guid %>" name="content" type="text/plain"></script>
                    <script type="text/javascript">
                        var editor = UE.getEditor('container<%=guid %>');
                    </script>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    排序：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addsortorder" value="0" name="sortorder" type="text" />
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
            initCitySelect("addprovenceID", "请选择", 0, "");
            citySelectChange("addprovenceID", "addcityId1", "addcityId", "请选择");
            citySelectChange("addcityId1", "addcityId", null, "请选择");
            $("#addistravel").click(function() {
                var istravel = $("#addistravel").is(':checked');
                if (istravel) {
                    $("#addpricetr").show();
                } else {
                    $("#addpricetr").hide();
                }
            });
        });

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
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
            var cityId = $.trim($("#addcityId").val());
            if (cityId == "") {
                showValidateMessage("请选择城市");
                return false;
            }

            var name = $.trim($("#addname").val());
            if (name == "") {
                showValidateMessage("请填写名称");
                return false;
            }
            if (name.length >= 15) {
                showValidateMessage("热门线路名称不能超过15个汉字");
                return false;
            }

            var price = $.trim($("#addprice").val());
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

            var istravel = $("#addistravel").is(':checked');
            if (istravel) {   
                if (price == "") {
                    showValidateMessage("门票价格不能为空");
                    return false;
                }
            }

            var summary = $.trim($("#addsummary").val());
            if (summary.length>200) {
                showValidateMessage("概要说明不能大于200字");
                return false;
            }

            var sortorder = $.trim($("#addsortorder").val());
            if (!num(sortorder)) {
                showValidateMessage("排序只能是数字");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
