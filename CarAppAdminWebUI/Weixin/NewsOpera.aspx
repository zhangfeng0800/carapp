<%@ Page Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="NewsOpera.aspx.cs"
    Inherits="CarAppAdminWebUI.Weixin.NewsOpera" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <link href="../Static/styles/WXNews.css" rel="stylesheet" type="text/css" />
 
    <script type="text/javascript">
        function onAddone() {
            $("#ChildID").val("");
            $("#title").val("");
            $("#author").val("");
            $("#addimgUrl").val("");
            $("#media_id").val("");
            UE.getEditor('addcontainer').setContent("");

            $("#description").val("");
            $("#contentUrl").val("");
            $("#isVis").prop("checked", "checked");
            $("#bottom").fadeIn();
            $("#sort").val("");
        }

        function editshow(id) {
            $.ajax({
                url: "NewsOpera.aspx",
                data: { action: "edtiShow", clId: id },
                type: "post",
                success: function (data) {
                    var jsond = eval('(' + data + ')');
                    $("#NewsID").val(jsond.NewsId);
                    $("#ChildID").val(jsond.ID);
                    $("#title").val(jsond.Title);
                    $("#author").val(jsond.Author);
                    $("#addimgUrl").val(jsond.ImgUrl);
                    $("#media_id").val(jsond.Media_id);
                    // $("[name='contentw']").val(jsond.Contentw);

                    UE.getEditor('addcontainer').setContent(jsond.Contentw);

                    $("#description").val(jsond.Description);
                    $("#contentUrl").val(jsond.ContentUrl);
                    if (jsond.IsVisbottom == 0) {
                        $("#isVis").prop("checked", false);
                        $("#bottom").fadeOut();
                    }
                    else {
                        $("#isVis").prop("checked", "checked");
                        $("#bottom").fadeIn();
                    }
                    $("#sort").val(jsond.Sort);
                }
            })
        }
        function del(id) {
            if (confirm("确定要删除吗?")) {
                $.ajax({
                    url: "NewsOpera.aspx",
                    data: { action: "del", clId: id },
                    type: "post",
                    success: function (data) {
                        if (data == "1") {
                            $("#other" + id).prev().remove();
                            $("#other" + id).remove();

                            alert("删除成功");
                        }
                    }
                })
            }
        }

        function submy() {
            if (!check())
                return;
            $("#form1").submit();
        }
        function check() {
            if ($("#title").val() == "") {
                alert('名称不能为空！');
                return false;
            }
            if ($("#media_id").val() == "") {
                alert('上传图片不能为空！');
                return false;
            }
            if ($("#contentw").val() == "") {
                alert('内容不能为空！');
                return false;
            }
            return true;
        }
        function SendWx() {
            if (confirm("确认要发送吗？")) {
                var newID = $("#NewsID").val();
                $.ajax({
                    url: "weixinHandler.ashx",
                    data: { action: "SendNews", newID: newID },
                    type: "post",
                    success: function (data) {
                        if (data == 1)
                            alert("发送成功");
                        else
                            alert("发送失败");
                    }
                })
            }
        }
        function showOpera(obj) {

            $(obj).children(".opera").css("display", "block");
        }
        function hiddOpera(obj) {
            $(obj).children(".opera").css("display", "none");
            // $("#opera").css("display", "none");
        }

        function gotoPreview() {
            var ChildID = $("#ChildID").val();
            if (ChildID == "") {
                alert("没有可预览对象");
            }
            else {
                window.open("http://m.iezu.cn/carlifeweixin.aspx?id=" + ChildID);
            }

        }

        function checkBott(obj) {
            if ($(obj).prop("checked"))
                $("#bottom").fadeIn("normal");
            else
                $("#bottom").fadeOut("normal");
        }
        function onSetReply() {
            var id = <%=NewsID %>;
            $.ajax({
                url: "NewsList.ashx",
                data: { action: "setSend", ID: id },
                type: 'post',
                success: function (data) {
                    alert("成功")
                }
            });
        }
    </script>
    <div style="width: 1400px; margin-top:10px; margin-left:10px;">
        <div class="msg_left">
            <% for (int i = 0; i < list.Count; i++)
               {
                   if (i == 0)
                   {
            %>
            <div class="first" onmouseover='javascript:$("#eidtFirst").css("display", "block")'
                onmouseout='javascript:$("#eidtFirst").css("display", "none")'>
                <div  id="eidtFirst" style="position: absolute; display: none;">
                <a style=" margin-top:70px;" class="edite" onclick="editshow(<%=list[i].ID %>)"
                    href="javascript:void(0);"><img  alt="编辑" title="编辑"  width="39px" height="39px" src="../Images/ux_1399623479_1944344.png" /></a>
                     <a class="edite" href="<%=list[i].ContentUrl %>"  target="_blank"><img alt="预览" title="预览" width="39px" height="39px" src="../Images/preview.png" /></a>&nbsp;&nbsp;&nbsp;&nbsp;
                    </div>
                    <span id="FrontImg" class="edit">
                        <img height="155px" width="100%" alt="封面" src="<%=list[i].ImgUrl %>" /></span>
                <div class="title">
                    <%=list[i].Title %></div>
            </div>
            <%
}
                   else
                   { 
            %>
            <div class="line">
            </div>
            <div class="other" id="other<%=list[i].ID %>" onmouseover="showOpera(this)" onmouseout="hiddOpera(this)">
                <div class="o_title">
                    <span>
                        <%=list[i].Title %></span>
                </div>
                <div class="o_img">
                    <img height="80px" width="80px" alt="封面" src="<%=list[i].ImgUrl %>" />
                </div>

                <div class="opera" style="display: none;">
                    <a class="edite" onclick="editshow(<%=list[i].ID %>)" href="javascript:void(0);"><img alt="编辑" title="编辑" width="39px" height="39px" src="../Images/ux_1399623479_1944344.png" /></a>&nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="edite" href="<%=list[i].ContentUrl %>"  target="_blank"><img alt="预览" title="预览" width="39px" height="39px" src="../Images/preview.png" /></a>&nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="deld" onclick="del(<%=list[i].ID %>)"
                        href="javascript:void(0);"><img  alt="删除" title="删除" width="40px"  height="40px" src="../Images/ux_1399623492_8104007.png" /></a>
                </div>
            </div>
            <%
} 
            %>
            <%
                } 
            %>
            <div class="line">
            </div>
            <a class="addnews" href="javascript:void(0);" onclick="onAddone()"><i class="icon24_common add_gray">
                增加一条</i> </a>
                （最多添加10条）
               
            <br />
            
            <%if (string.IsNullOrEmpty(type))
              {%>
             <p style="text-align: center;  ">
                    <a class="easyui-linkbutton" href="javascript:SendWx()">发送到微信</a>&nbsp;&nbsp;
                </p>
                <%}
              else { %>
               <p style="text-align: center;  ">
                    <a class="easyui-linkbutton" href="javascript:onSetReply()">设为发送</a>&nbsp;&nbsp; 
                </p>
              <%} %>
              <a target="_blank" style="color:blue;" href="../Images/imgPosition/onenews.jpg">单图文样式</a>&nbsp;&nbsp;&nbsp;&nbsp;
               <a target="_blank" style="color:blue;" href="../Images/imgPosition/wxmorenews.jpg">多图文样式</a>
        </div>

        <div class="msg_right">
                <form action="NewsOpera.aspx" method="post" id="form1">
                <table class="adm_8" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td colspan="2" class="adm_45" style=" text-align:center; font-size:16px;">
                            <input style="display: none;" type="text" id="NewsID" name="NewsID" value="<%=NewsID %>" />
                            <input style="display: none;" type="text" id="Type" name="Type" value="<%=type %>" />
                            <input style="display: none;" type="text" id="ChildID" name="ChildID" />
                            <span >详细信息</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="adm_45" style=" width:50px;">
                            标题
                        </td>
                        <td class="adm_42">
                            <input class="adm_21" style=" width:400px;" type="text" id="title" name="title" />
                        </td>
                    </tr>
                   
                    <tr   <%if (!string.IsNullOrEmpty(type))
              {%> style=" display:none;" <%} %>>
                        <td class="adm_45">
                            作者
                        </td>
                        <td class="adm_42">
                          <input type="text" id="author" name="author" />
                            <span class="explay">(选填)</span><br /> 
                        </td>
                    </tr>
                
                   
                    <tr>
                        <td class="adm_45" >
                            封面
                        </td>
                        <td class="adm_42 w420">
                            <input id="addimgUrl"  class="adm_21 w420" readonly="readonly"  name="imgUrl" type="text" />
                            <input id="media_id" style="display: none;" name="media_id" type="text" />
                            <br />
                            <iframe src="ImgUpLoad.aspx?id=addimgUrl&med=media_id&folder=weixinNews" frameborder="0"
                                style="border: 0px; height: 43px; width:200px;"></iframe>
                                <div style=" float:right; width:400px;">
                              <span class="explay">大图片建议尺寸：360像素 * 200像素 小图片建议尺寸：200像素 * 200像素   支持128K以内图片且格式为.jpg .jpeg</span>
                              </div>
                        </td>
                    </tr>

                     <tr>
                        <td class="adm_45" >
                            原文链接
                        </td>
                        <td class="adm_42">
                            <input type="text"  class="adm_21 w420" id="contentUrl" name="contentUrl" /> 
                             <div style=" float:right; width:400px;">
                            <span class="explay"> 如果链接到正文此处可留空，链接到其他页面则需输入完整网址</span>
                            </div>
                        </td>
                    </tr>
                        <tr>
                        <td class="adm_45" >
                            描述
                        </td>
                        <td class="adm_42">
                            <textarea rows="3" cols="50" id="description" name="description"></textarea>
                             <div style=" float:right; width:400px;">
                            <span class="explay">如果只有一条图文，则会显示描述，如果为多条，则此描述不在首页显示</span>
                            </div>
                        </td>
                    </tr>
                    
                    <tr>
                    <td  class="adm_45">排序</td>
                    <td  class="adm_42"><input type="text" id="sort" name="sort"  onkeyup="this.value=this.value.replace(/\D/g,'')"  />  <span class="explay">默认排序可留空,按大小降序排列</span></td></tr>
                    
                    <tr>
                        <td class="adm_45" >
                            正文
                        </td>
                        <td class="adm_42" >

                   
                    <script id="addcontainer" name="contentw" type="text/plain" style="height:300px; width:600px;"></script>
                    <script type="text/javascript">
                        var editor = UE.getEditor('addcontainer')
                    </script>
                   

                           <%-- <textarea rows="3" cols="50" id="contentw" name="contentw"></textarea>--%>
                        
                            <span class="explay">如果需要更大编辑空间，可以点击编辑器菜单栏右上角的 全屏 按钮 ,文章内上传图片时，要求文件大小控制在128k以内,文件宽度不得超过360像素,高度不限</span>
                          
                        </td>
                    </tr>
                    <tr><td  class="adm_45" >显示底部：</td>
                    <td class="adm_42">
                    <input id="isVis" name="isVis" type="checkbox" checked="checked" onclick="checkBott(this)" value="1" style=" float:left;" /> <span class="explay">如果选中，则会在文章底部显示此信息</span>
                    <div id="bottom" style=" width:60%; float:right;"><%=bottom %></div>
                    </td>
                    </tr>
                
                   
                    <tr><td colspan="2">
                     <p style="text-align: center;">
                    <a class="easyui-linkbutton" href="javascript:submy()">保存</a>&nbsp;&nbsp;&nbsp;&nbsp;
                      <a class="easyui-linkbutton" href="javascript:gotoPreview()">预览</a>

                </p>
                    </td></tr>
                </table>
               
                </form>
        </div>
    </div>

</asp:Content>
