<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AirPlaneAdd.aspx.cs" Inherits="CarAppAdminWebUI.Air.AirPlaneAdd" %>

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
                <td class="adm_45" align="right" height="30" width="30%">
                    <span class="field-validation-valid">*</span>所在机场：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addprovenceID" name="provenceID">
                    </select>

                    <select class="adm_21" id="addairportName" name="airportName">
                        <option value="">请选择机场</option>
                    </select>
                    <span class="field-validation-valid" data-valmsg-for="addairportName" data-valmsg-replace="true">
                    </span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>航班号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addplaneNo" name="planeNo" type="text" />
                    <span class="field-validation-valid" data-valmsg-for="addplaneNo"
                        data-valmsg-replace="true"></span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>起航时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21 Wdate" id="addtime" onClick="WdatePicker({dateFmt:'HH:mm'})" name="time" type="text" />
                    <span class="field-validation-valid" data-valmsg-for="addtime"
                        data-valmsg-replace="true"></span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>抵达时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21 Wdate" id="addarrivalTime" onClick="WdatePicker({dateFmt:'HH:mm',minDate:'#F{$dp.$D(\'addtime\')}'})" name="arrivalTime" type="text" />
                    <span class="field-validation-valid" data-valmsg-for="addarrivalTime"
                        data-valmsg-replace="true"></span>
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
            selectChange("addprovenceID", "addairportName");
        });

        function selectChange(actionSelect, targetSelect) {
            $("#" + actionSelect).change(function () {
                var pid = $(this).val();
                if (pid != "") {
                    $.get("/Ajax/GetAirPort.ashx", { "action":"pid","value": pid }, function (data) {
                        $("#" + targetSelect).empty();
                        $("#" + targetSelect).append('<option value="">请选择机场</option>');
                        var pro = "";
                        for (var i = 0; i < data.length; i++) {
                            pro += '<option value=' + data[i].AirPortName + '>';
                            pro += data[i].AirPortName;
                            pro += '</option>';
                        }
                        $("#" + targetSelect).append(pro);
                    }, "json");
                }
            });
        }

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.post("/Air/SaveAirPlane.ashx", d, function (data) {
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
            var airportName = $.trim($("#addairportName").val());
            if (!airportName||airportName == "") {
                $("[data-valmsg-for=addairportName]").html("请选择机场");
                return false;
            } else {
                $("[data-valmsg-for=addairportName]").html("");
            }

            var planeNo = $.trim($("#addplaneNo").val());
            if (planeNo == "") {
                $("[data-valmsg-for=addplaneNo]").html("请填写");
                return false;
            } else {
                $("[data-valmsg-for=addplaneNo]").html("");
            }
            if (planeNo.length>50) {
                $("[data-valmsg-for=addplaneNo]").html("航班号不能超过50个字");
                return false;
            } else {
                $("[data-valmsg-for=addplaneNo]").html("");
            }

            var time = $.trim($("#addtime").val());
            if (time == "") {
                $("[data-valmsg-for=addtime]").html("请填写");
                return false;
            } else {
                $("[data-valmsg-for=addtime]").html("");
            }

            var arrivalTime = $.trim($("#addarrivalTime").val());
            if (arrivalTime == "") {
                $("[data-valmsg-for=addarrivalTime]").html("请填写");
                return false;
            } else {
                $("[data-valmsg-for=addarrivalTime]").html("");
            }

            return true;
        }

    </script>
</body>
</html>
