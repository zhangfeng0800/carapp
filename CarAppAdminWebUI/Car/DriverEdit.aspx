<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DriverEdit.aspx.cs" Inherits="CarAppAdminWebUI.Car.DriverEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="padding: 5px;">
        <form id="editForm">
        <input type="hidden" id="action" name="action" value="edit" />
        <input type="hidden" id="id" name="id" value="<%=Model.Id %>" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>工号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editjobnumber" value="<%=Model.JobNumber %>" name="jobnumber" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>性别：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editsex" style="width: 100px;" name="sex">
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
                    <input class="adm_21" id="editcardno" value="<%=Model.CardNo %>" name="cardno" type="text" />
                </td>
            </tr>
              <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>获得驾照时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21 Wdate" id="editdrivertime" name="getLicenseDay" value='<%=GetDate(Model.GetLicenseDay.ToString()) %>' type="text" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"  />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid"></span>姓名：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editname" value="<%=Model.Name %>" name="name" type="text" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid"></span>私人手机：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="driverPhone" value="<%=Model.DriverPhone %>" name="driverPhone" type="text" onkeyup="this.value=this.value.replace(/\D/g,'')" />
                </td>
            </tr>
            <%--<tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    默认密码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editpassword" name="password" value="123" readonly="readonly"
                        type="text" />
                    默认密码 123
                </td>
            </tr>--%>
            <%--<tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>驾驶车辆：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select class="adm_21" id="editcarno" style="width: 100px;" name="carno">
                    </select>
                </td>
            </tr>--%>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>出生日期：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21 Wdate" id="editage" name="birthday" value='<%=GetDate(Model.Birthday.ToString()) %>' type="text" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>身份证号码：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="editssn" name="ssn" value="<%=Model.SSN %>" type="text" />
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

                    <input class="adm_21" id="editaddress" name="address" value="<%=Model.Address %>" type="text" style="width:200px;" />
                </td>
            </tr>
          
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    其他：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <textarea class="adm_21" id="editother" name="other" style="width: 99%; height: 30px;"
                        type="text"><%=Model.Other %></textarea>
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
                                <input class="adm_21" id="editimgurl" value="<%=Model.Imgurl %>" readonly="readonly" style="width: 300px;" name="imgurl"
                                    type="text" />&nbsp;<a href="../Images/imgPosition/DriverImg.jpg" style=" color:blue;" target="_blank">图片位置</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iframe src="/FileUpLoad.aspx?id=editimgurl&folder=Driver&w=150&h=200" frameborder="0" style="border: 0px;
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
           
              initProvinceSelectValue("provinceId", "不限",<%=Model.ProvinceId %>);
            initCitySelect("cityId", "不限", <%=Model.ProvinceId %>, <%=Model.CityId %>);

            citySelectChange("provinceId", "cityId", "town", "不限");

            $("#editsex").val('<%=Model.Sex %>');
            initCarList();
        });

        function onAddSubmit() {
            if (checkForm()) {
                var d = $("#editForm").serialize();
                $.post("/Car/DriverHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '编辑成功！', 'info', function () {
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
            var jobnumber = $.trim($("#editjobnumber").val());
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
            if($("#provinceId").val()=="")
            {
                showValidateMessage("请选择省");
                return false;
            }
            if($("#cityId").val()=="")
            {
                 showValidateMessage("请选择市");
                return false;
            }
            /*性别*/
            var sex = $.trim($("#editsex").val());
            if (sex == "") {
                showValidateMessage("请选择性别");
                return false;
            }

            /*驾照号码*/
            var cardno = $.trim($("#editcardno").val());
            if (cardno == "") {
                showValidateMessage("请填写驾照号码");
                return false;
            }
            if (cardno.length >= 50) {
                showValidateMessage("驾照号码长度不能大于50");
                return false;
            }

            /*姓名*/
            var name = $.trim($("#editname").val());
            if (name == "") {
                showValidateMessage("请填写姓名");
                return false;
            }
            if (name.length >= 50) {
                showValidateMessage("姓名长度不能大于50");
                return false;
            }

            /*年龄*/
            var age = $.trim($("#editage").val());
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
            var ssn = $.trim($("#editssn").val());
            if (ssn == "") {
                showValidateMessage("请填写身份证号码");
                return false;
            }
            if (ssn.length >= 50) {
                showValidateMessage("无效的身份证号码");
                return false;
            }

            /*常住地址*/
            var address = $.trim($("#editaddress").val());
            if (address.length >= 50) {
                showValidateMessage("常住地址长度不能大于50");
                return false;
            }

            /*驾龄*/
            var drivertime = $.trim($("#editdrivertime").val());
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
            var other = $.trim($("#editother").val());
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
                $("#editcarno").append(pro);
                $("#editcarno").val('<%=Model.CarNo %>');
            }, "json");
        }
    </script>
</body>
</html>
