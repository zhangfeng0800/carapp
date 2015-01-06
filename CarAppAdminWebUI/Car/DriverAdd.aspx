<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DriverAdd.aspx.cs" Inherits="CarAppAdminWebUI.Car.DriverAdd" %>

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
                    <span class="field-validation-valid">*</span>工号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addjobnumber" name="jobnumber" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>性别：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addsex" style="width: 100px;" name="sex">
                        <option value="">请选择</option>
                        <option value="男">男</option>
                        <option value="女">女</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>驾照号码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addcardno" name="cardno" type="text" />
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>获得驾照时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21 Wdate" id="adddrivertime" name="getLicenseDay" type="text" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>姓名：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addname" name="name" type="text" />
                </td>
            </tr>
              <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid"></span>私人电话：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="driverPhone" name="driverPhone" type="text" onkeyup="this.value=this.value.replace(/\D/g,'')"  />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    默认密码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addpassword" name="password" value="123" readonly="readonly"
                        type="text" />
                    默认密码 123
                </td>
            </tr>
            <%--<tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>驾驶车辆：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="addcarno" style="width: 100px;" name="carno">
                    </select>
                </td>
            </tr>--%>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>出生日期：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21 Wdate" id="addage" name="birthday" type="text" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>身份证号码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addssn" name="ssn" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    常住地址：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                <select class="adm_21" id="provinceId" name="provinceId">
                    </select>
                <select class="adm_21" id="cityId" name="cityId">
                    </select>
                    <input class="adm_21" id="addaddress" name="address" type="text" style="width:200px;" />
                </td>
            </tr>
           
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    其他：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <textarea class="adm_21" id="addother" name="other" style="width: 99%; height: 30px;"
                        type="text"></textarea>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    照片：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <table>
                        <tr>
                            <td>
                                <input class="adm_21" id="addimgurl" readonly="readonly" style="width: 300px;" name="imgurl"
                                    type="text" />&nbsp;<a href="../Images/imgPosition/DriverImg.jpg" style=" color:blue;" target="_blank">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iframe src="/FileUpLoad.aspx?id=addimgurl&folder=Driver&w=150&h=200" frameborder="0" style="border: 0px;
                                    height: 43px;"></iframe>
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
            initProvinceSelectValue("provinceId", "不限", "13");
            initCitySelect("cityId", "不限", "13", "1301");
            citySelectChange("provinceId", "cityId", "town", "不限");
            initCarList();
        });

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#addForm").serialize();
                $.post("/Car/DriverHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '添加成功！', 'info', function () {
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
            /*工号*/
            var jobnumber = $.trim($("#addjobnumber").val());
            if (jobnumber == "") {
                showValidateMessage("请填写工号");
                return false;
            }
            if (jobnumber.length >= 30) {
                showValidateMessage("工号不能大于30个汉字");
                return false;
            }
            var driverphone = $("#driverPhone").val();
            if (driverphone != "" && driverphone.length != 11) {
                showValidateMessage("手机号格式不正确");
                return false;
            }

            /*性别*/
            var sex = $.trim($("#addsex").val());
            if (sex == "") {
                showValidateMessage("请选择性别");
                return false;
            }
            if ($("#provinceId").val() == "") {
                showValidateMessage("请选择省");
                return false;
            }
            if ($("#cityId").val() == "") {
                showValidateMessage("请选择市");
                return false;
            }

            /*驾照号码*/
            var cardno = $.trim($("#addcardno").val());
            if (cardno == "") {
                showValidateMessage("请填写驾照号码");
                return false;
            }
            if (cardno.length >= 50) {
                showValidateMessage("驾照号码长度不能大于50");
                return false;
            }

            /*姓名*/
            var name = $.trim($("#addname").val());
            if (name == "") {
                showValidateMessage("请填写姓名");
                return false;
            }
            if (name.length >= 50) {
                showValidateMessage("姓名长度不能大于50");
                return false;
            }

            /*年龄*/
            var age = $.trim($("#addage").val());
            if (age == "") {
                showValidateMessage("请填写出生日期");
                return false;
            }
//            if (!pnum(age)) {
//                showValidateMessage("请填写有效的年龄");
//                return false;
//            }
//            if (!betweennum(age, 1, 60)) {
//                showValidateMessage("请填写有效的年龄");
//                return false;
//            }

            /*身份证号码*/
            var ssn = $.trim($("#addssn").val());
            if (ssn == "") {
                showValidateMessage("请填写身份证号码");
                return false;
            }
            if (ssn.length >= 50) {
                showValidateMessage("无效的身份证号码");
                return false;
            }

            /*常住地址*/
            var address = $.trim($("#addaddress").val());
            if (address.length >= 50) {
                showValidateMessage("常住地址长度不能大于50");
                return false;
            }

            /*驾龄*/
            var drivertime = $.trim($("#adddrivertime").val());
            if (drivertime == "") {
                showValidateMessage("请填写获得驾照时间");
                return false;
            }
//            if (!pnum(drivertime)) {
//                showValidateMessage("请填写有效的驾龄");
//                return false;
//            }
//            if (!betweennum(drivertime, 1, 60)) {
//                showValidateMessage("请填写有效的驾龄");
//                return false;
//            }

            /*其他*/
            var other = $.trim($("#addother").val());
            if (other.length >= 500) {
                showValidateMessage("其他信息长度不能超过500");
                return false;
            }

            return true;
        }

        function initCarList() {
            $.get("/Car/DriverHandler.ashx", { "action": "carlist" }, function (data) {
                var pro = "";
                pro += '<option value="0">不限</option>';
                for (var i = 0; i < data.length; i++) {
                    pro += '<option value=' + data[i].Id + '>';
                    pro += data[i].CarNo;
                    pro += '</option>';
                }
                $("#addcarno").append(pro);
            }, "json");
        }
    </script>
</body>
</html>
