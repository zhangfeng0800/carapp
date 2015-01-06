<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServiceCityHotLineAdd.aspx.cs"
    Inherits="CarAppAdminWebUI.ProvinceCity.ServiceCityHotLineAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <link rel="stylesheet" type="text/css" href="/Static/uploadify/uploadify.css" />
    <div style="padding: 5px;">
        <form id="addhotlineForm">
        <input type="hidden" id="action" name="action" value="hotlineadd" />
        <input type="hidden" id="carUseWay" name="carUseWay" value="6" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>开通城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addhotlineprovenceID" style="width: 100px;" name="provenceID">
                    </select>
                    <select class="adm_21" id="addhotlinecityId1" style="width: 100px;" name="cityId1">
                        <option value="">请选择</option>
                    </select>
                    <select class="adm_21" id="addhotlinecityId" style="width: 100px;" name="cityId">
                        <option value="">请选择</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>热门线路城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addhotlinehotlineid" name="hotlineid">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    是否热门城市：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input type="radio" name="ishotcity" value="1"/>是 <input type="radio" checked="checked" name="ishotcity" value="0"/>否
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>类型图片：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="addimgurl" readonly="readonly" style="width: 300px;" name="imgUrl" type="text" />
                                &nbsp;<a target="_blank" href="../Images/imgPosition/ServiceCityListDefault.jpg" style="color:blue;">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                           <td>
                                <iframe src="/FileUpLoad.aspx?id=addimgurl&folder=HotLine&w=150&h=100" frameborder="0" style="border: 0px;height: 43px;">
                                </iframe>
                            </td> 
                        </tr>
                    </table>
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
            initCitySelect("addhotlineprovenceID", "请选择", 0, "");
            citySelectChange("addhotlineprovenceID", "addhotlinecityId1", "addhotlinecityId", "请选择");
            citySelectChange("addhotlinecityId1", "addhotlinecityId", null, "请选择");
            initHotLine("addhotlinehotlineid");
        });

        function initHotLine(targetSelect) {
            $.get("/Ajax/GetHotLine.ashx", null, function (data) {
                var pro = "";
                pro += '<option value="">请选择热门线路城市</option>';
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].id + '>';
                    pro += data[i].name;
                    pro += '</option>';
                }
                $("#" + targetSelect).append(pro);
            }, "json");

        }

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addhotlineForm").serialize();
                $.post("/ProvinceCity/ServiceCityHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        var message = "服务开通成功！";
                        if (data.Message != "") {
                            message = data.Message;
                        }
                        $.messager.alert('消息', message, 'info', function () {
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
            var cityId = $.trim($("#addhotlinecityId").val());
            if (cityId == "") {
                showValidateMessage("请选择城市");
                return false;
            }

            var hotlineid = $.trim($("#addhotlinehotlineid").val());
            if (hotlineid == "") {
                showValidateMessage("请选择热门线路城市");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
