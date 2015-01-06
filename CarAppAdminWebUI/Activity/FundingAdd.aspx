<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FundingAdd.aspx.cs" Inherits="CarAppAdminWebUI.Activity.FundingAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <script type="text/javascript" src="/Static/easyui/datagrid-groupview.js"></script>
  
</head>
<body>
    
    <div id="firstStep">
    <form id="addForm">
        <input type="hidden" id="action" name="action" value="addFunding" />
        <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <input class="adm_21" id="addamount" name="amount" type="text" maxlength="10" style=" font-size:20px;color:Red; height:30px; width:150px;" onkeyup="this.value=this.value.replace(/\D/g,'')"   />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>存入日期：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    
                     <input class="adm_21" id="addIndate" name="Indate" type="text" onclick="WdatePicker()" />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>存入月数：<!---->
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <input class="adm_21" id="Year" name="Year" type="text" onkeyup="this.value=this.value.replace(/\D/g,'')" value="1"   />
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>选择用户账号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                   <select class="easyui-combogrid adm_21" style="width: 150px" id="useraccount" name="useraccount"></select>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>选择规则：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <select class="easyui-combogrid adm_21" style="width: 150px" id="fundrules" name="fundrules"></select>
                </td>
            </tr>
        </table>
        </form>
        <p style="text-align: center;">
            <a class="easyui-linkbutton" href="javascript:nextStep()">下一步</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>
    </div>
    <div id="sencodStep" style="display:none;">
    <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>金额：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="amountspan" style="font-size:20px; color:Red;"></span> 元
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>存入时间：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="Indatespan"></span>
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>存入月数：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="yearspan"></span>月
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>用户账号：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <span id="useraccountspan"></span>
                </td>
            </tr>
            <tr>
                <td class="adm_45" align="right" height="30" width="25%">
                    <span class="field-validation-valid">*</span>规则：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <span id="fundrulesspan"></span>
                </td>
            </tr>
        </table>
         <p style="text-align: center;">
         <span style="color:red;">请认真核对活动金信息，提交后会根据所选规则立即生成代金券，所以一经提交，不可更改！</span><br />
                <a class="easyui-linkbutton" href="javascript:onAddSubmit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:preStep()">后退</a>
        </p>
    </div>



     <div id="useraccounttoolbar" style="padding: 5px; height: auto">
        <div>
            用户姓名:
            <input type="text" id="addcompname" name="compname" />
            手机号码:
            <input type="text" id="addtelphone" name="telphone" />       
            <input type="button" onclick="onUseraccountSearch()" value="搜索" />
        </div>
    </div>

     <div id="fundrulestoolbar" style="padding: 5px; height: auto">
        <div>
            规则名称:
            <input type="text" id="rulesname" name="rulesname" />
            建议金额:
            <input type="text" id="refrencePrice" name="refrencePrice" />       
            <input type="button" onclick="onFundrulesSearch()" value="搜索" />
        </div>
    </div>


    <script type="text/javascript">

        $(function () {
            bindcombogrid();
            bindcombogridruls();
        });
        function onAddSubmit() {
            if (confirm("确认要提交吗？")) {
                var d = $("#addForm").serialize();
                $.post("/Activity/FundingHandler.ashx", d, function (data) {
                    if (data.IsSuccess) {
                        $.messager.alert('消息', '添加成功！', 'info', function () {
                            window.location.reload();
                            //onClose();
                        });
                    } else {
                        $.messager.alert('消息', data.Message, 'error');
                    }
                }, "json");
            }
        }


        //绑定下拉列表框
        function bindcombogrid() {
            var width = $(window).width();
            $("#useraccount").combogrid({
                width: 1000,
                panelWidth: 1000,
                idField: 'id',
                panelHeight: 400,
                textField: 'compname',
                url: '/Member/UserAccountHandler.ashx?action=list&accountclass=-1&username=&realname=' + $("#addcompname").val() + '&telphone=' + $("#addtelphone").val() + "&isvip=",
                method: 'post',
                pagination: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [[
                { field: 'compname', title: '集团 / 个人名称', formatter: fusername},
                { field: 'username', title: '昵称', width: 100, width: 100 },
                { field: 'telphone', title: '手机号码', width: 100 },
                { field: 'balance', title: '账户余额（元）', width: 100, sortable: true },
                { field: 'email', title: '邮箱地址', width: 100 },
                { field: "registtime", title: "注册时间", width: 100, formatter: easyui_formatterdate, sortable: true },
                { field: 'type', title: '用户类型', width: 100, formatter: ftype },
                { field: 'creater', title: '创建人', width: 100 }
                ]],
                fitColumns: true,
                toolbar: '#useraccounttoolbar',
                onLoadSuccess: function (data) {
                }
            });
        }
        function onUseraccountSearch() {
            bindcombogrid();
        }
        function fusername(value, row, index) {
            var html = "<a style='text-decoration:underline;' href='javascript:onShow(" + row.id + ")'>" + value + "</a> ";
            return html;
        }
        /* formatter */
        function ftype(value, row, index) {
            var array = new Array("集团管理员", "部门管理员", "集团员工", "个人会员");
            return array[value];
        }

        //绑定下拉列表框
        function bindcombogridruls() {
            var width = $(window).width();
            $("#fundrules").combogrid({
                width: 1000,
                panelWidth: 1000,
                idField: 'Id',
                panelHeight: 400,
                textField: 'Name',
                url: '/Activity/FundingHandler.ashx?action=ruleslist&Status=正常&Name=' + $("#rulesname").val() + '&ReferencePrice=' + $("#refrencePrice").val(),
                method: 'post',
                pagination: true,
                pageList: [15, 30, 45, 60],
                pageSize: 15,
                columns: [[
                { field: 'Id', title: '编号', width: 100 },
                { field: 'Name', title: '名称', width: 100 },

                { field: 'Cost', title: '单券面值(元)', width: 100 },
                { field: 'Num', title: '每月返券数', width: 100 },
                { field: 'ReferencePrice', title: '建议金额（元）', width: 100 },
                { field: 'CreateTime', title: '创建时间', width: 100, formatter: easyui_formatterdate },
                { field: 'Status', title: '状态', width: 100 }
                ]],
                fitColumns: true,
                toolbar: '#fundrulestoolbar',
                onLoadSuccess: function (data) {
                }
            });
        }
        function onFundrulesSearch() {
            bindcombogridruls();
        }

        function nextStep() {
            if (checkform()) {
                var griduser = $("#useraccount").combogrid("grid");
                var rowuser = griduser.datagrid('getSelected');
                var gridrules = $("#fundrules").combogrid("grid");
                var rowrules = gridrules.datagrid('getSelected');
                $("#amountspan").html($("#addamount").val());
                $("#Indatespan").html($("#addIndate").val());
                $("#yearspan").html($("#Year").val());
                $("#useraccountspan").html("用户账号：" + rowuser.telphone + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;真实姓名：" + rowuser.compname);
                $("#fundrulesspan").html("规则名称：" + rowrules.Name + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;每月返券数：" + rowrules.Num + "张&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单券面值:" + rowrules.Cost + "元");

                $("#firstStep").hide();
                $("#sencodStep").show();
            }   
        }
        function preStep() {
            $("#sencodStep").hide();
            $("#firstStep").show();
        }

        function checkform() {
            if ($("#addamount").val() == "") {
                showValidateMessage("请填写基金金额");
                return false;
            }
            else if ($("#addIndate").val() == "") {
                showValidateMessage("请填写存入日期");
                return false;
            }
            else if ($("#Year").val() == "") {
                showValidateMessage("请填写年数");
                return false;
            }
            else if ($('#useraccount').combogrid('getValue') == "") {
                showValidateMessage("请选择用户");
                return false;
            }
            else if ($('#fundrules').combogrid('getValue') == "") {
                showValidateMessage("请选择基金规则");
                return false;
            }
            return true;
        }

    </script>
</body>
</html>
