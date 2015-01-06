<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MenuAdd.aspx.cs" Inherits="CarAppAdminWebUI.Weixin.MenuAdd1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
       <link href="../Static/styles/WXNews.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../Static/scripts/jquery-1.4.1.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
     <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="98%">
            <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>所属：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                    <select name="pid" id="pid">
             <option value='0' selected='selected'>请选择</option>
            </select>
                    <span class="field-validation-valid" data-valmsg-for="addbrandName" data-valmsg-replace="true">
                    </span>
                </td>
            </tr>
              <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>按钮名称：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                  <input type="text" name="name" class="adm_21" id="name" value='<%=wxmenu.Name %>' /> 
                  
                </td>
            </tr>
             <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>类型：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <input type="radio" name="type" value="view" checked="checked" />
                     <span class="poit" onclick="check(this)">view</span>
                     <input type="radio" name="type" value="click" /><span class="poit" onclick="check(this)">click</span>
                </td>
            </tr>
              <tr>
                <td class="adm_45" align="right" height="30" width="22%">
                    <span class="field-validation-valid">*</span>连接地址：
                </td>
                <td class="adm_42" width="78%" colspan="3">
                     <input class="adm_21" type="text" name="url" id="url" style=" width:300px"  value='<%=wxmenu.Url %>' />
                </td>
            </tr>

        </table>
          <p style="text-align: center;">
            <a class="easyui-linkbutton"  href="javascript:submit()">确认提交</a> <a class="easyui-linkbutton"
                href="javascript:onClose()">取消</a>
        </p>


      <input type="hidden" value='<%=Request.QueryString["id"] %>' name="updateid" id="updateid" />
    </div>
    </form>

    <script type="text/javascript">
        $(function () {
            GetPlist(0);
            $("input[type='radio'][value='<%=wxmenu.Type %>']").attr("checked", true);
        })
        function GetPlist(pid) {
         
            $.ajax({
                url: "weixinHandler.ashx",
                data: { action: "getpid", pid: pid },
                type: "post",
                success: function (data) {
                    if (data == "0") {
                        return;
                    }
                    var html = "<option value='0'>请选择</option>";

                    $.each(data, function (index, val) {
                        if (val.ID && val.Name) {
                            html += "<option value='" + val.ID + "'>" + val.Name + "</option>";
                        }
                    });
                    $("#pid").html(html);

                    $("#pid").val('<%=wxmenu.Pid %>');
                }
            });
        }

        function check(obj) {
            $(obj).prev().attr("checked", "checked");
        }
        function submit() {
            var pid = $("#pid").val();
            var name = $("#name").val();
            var type = $("input[name='type']:checked").val();
            var url = $("#url").val();
            if (name == "") {
                alert("名称不能为空");
                return;
            }

            if ($("#updateid").val() == "") {
                $.ajax({
                    url: "weixinHandler.ashx",
                    data: { action: "add", pid: pid, name: name, type: type, url: url },
                    type: "post",
                    success: function (data) {
                        if (data == "0") {
                            alert("添加失败！");
                            return;
                        }
                        GetPlist(0);
                        alert("添加成功！");
                        reload();
                    }
                })
            }
            else {
                $.ajax({
                    url: "weixinHandler.ashx",
                    data: { action: "update", pid: pid, name: name, type: type, url: url, id: $("#updateid").val() },
                    type: "post",
                    success: function (data) {
                        if (data == "0") {
                            alert("修改失败！");
                            return;
                        }
                        GetPlist(0);
                        alert("修改成功！");
                        reload();
                    }
                })
            }
        }
    </script>
</body>
</html>
