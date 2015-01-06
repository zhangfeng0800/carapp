﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarTypeEdit.aspx.cs" Inherits="CarAppAdminWebUI.Car.CarTypeEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="id" name="id" value="<%=Request.QueryString["id"] %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>类型名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="edittypeName" name="typeName" value="<%=dr["typeName"] %>" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>乘车人数：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editpassengerNum" name="passengerNum" value="<%=dr["passengerNum"] %>" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    品牌描述：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <textarea class="adm_21" style="width: 96%;" id="editdescription" name="description"><%=dr["description"]%></textarea>
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
                                <input class="adm_21" id="editimgUrl" readonly="readonly" style="width: 300px;" name="imgUrl" value="<%=dr["imgUrl"] %>" type="text" />
                                      &nbsp;<a target="_blank" style="color:blue;" href="../Images/imgPosition/carType.jpg">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                           <td>
                                <iframe src="/FileUpLoad.aspx?id=editimgUrl&folder=CarType&w=250&h=140" frameborder="0" style="border: 0px;height: 43px;">
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
        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/Car/CarTypeHandler.ashx", d, function (data) {
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
            var typeName = $.trim($("#edittypeName").val());
            if (typeName == "") {
                showValidateMessage("请填写类型名称");
                return false;
            }
            if (typeName.length >= 20) {
                showValidateMessage("类型名称不能超过20个汉字");
                return false;
            }

            var passengerNum = $.trim($("#editpassengerNum").val());
            if (passengerNum == "") {
                showValidateMessage("请填写乘车人数");
                return false;
            }
            if (!num(passengerNum)) {
                showValidateMessage("乘车人数只能为数字");
                return false;
            }
            if (!pnum(passengerNum)) {
                showValidateMessage("乘车人数只能为正整数");
                return false;
            }
            if (!betweennum(passengerNum, 1, 10)) {
                showValidateMessage("乘车人数只能为1-10之间的数字");
                return false;
            }

            
            return true;
        }
    </script>
</body>
</html>
