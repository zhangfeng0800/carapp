using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Manager
{
    /// <summary>
    /// ManagerHandler 的摘要说明
    /// </summary>
    public class ManagerHandler : IHttpHandler
    {
        private readonly AdminBll _adminBll = new AdminBll();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    Add(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "editpwd":
                    EditPwd(context);
                    break;
                case "delete":
                    Delete(context);
                    break;
            }
        }

        private void Delete(HttpContext context)
        {
            string adminid = context.Request["id"];
            var message = new AjaxResultMessage();
            try
            {
                var model = _adminBll.GetModel(Int32.Parse(adminid));

                if (model.IsDelete == 1)
                {
                    message.IsSuccess = false;
                    message.Message = "不能重复删除";
                }
                else
                {
                    model.IsDelete = 1;
                    int result = _adminBll.Update(model);
                    if (result != 0)
                        message.IsSuccess = true;
                    else
                    {
                        message.IsSuccess = false;
                        message.Message = "未知错误,请联系管理员";
                    }

                }
            }
            catch (Exception e)
            {
                message.IsSuccess = false;
                message.Message = e.Message;
                throw;
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
           
        }

        private void EditPwd(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                string oldpwd = context.Request["oldpwd"];
                string newpwd = context.Request["newpwd"];
                string adminName = context.User.Identity.Name;
                string adminPassword = Common.EncryptAndDecrypt.Encrypt(oldpwd.Trim());

                var adminModel = _adminBll.GetModel(adminName);
                if (adminModel == null)
                {
                    message.IsSuccess = false;
                    message.Message = "登录失效，请重新登录";
                }
                else if (adminModel.AdminPassword != adminPassword)
                {
                    message.IsSuccess = false;
                    message.Message = "旧密码输入不正确";
                }
                else 
                {
                    adminModel.AdminPassword = Common.EncryptAndDecrypt.Encrypt(newpwd.Trim());
                    int row = new BLL.AdminBll().Update(adminModel);
                    if (row != 0)
                    {
                        message.IsSuccess = true;
                        message.Message = "修改成功";
                    }
                    else
                    {
                        message.IsSuccess = false;
                        message.Message = "未知错误，请联系管理员";
                    }
                }
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception e)
            {
                LogHelper.WriteException(e);
                message.IsSuccess = false;
                message.Message = e.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
          
            

        }

        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                string adminName = context.Request["adminName"];
                string adminPassword = context.Request["adminPassword"];
                int adminGroupsId = Convert.ToInt32(context.Request["adminGroupsId"]);
                string phone = context.Request["Phone"];
                string jobnumber = context.Request["Jobnumber"];
                if (_adminBll.IsExist(adminName))
                {
                    message.IsSuccess = false;
                    LogHelper.WriteOperation("查询用户名[" + adminName + "]", OperationType.Query, "[" + adminName + "]已经存在", HttpContext.Current.User.Identity.Name);
                    message.Message = "已经存在此用户名";
                }
                else
                {
                    var model = new Model.Admin()
                    {
                        AdminName = adminName,
                        AdminPassword = Common.EncryptAndDecrypt.Encrypt(adminPassword),
                        AdminGroupsId = adminGroupsId,
                        Phone = phone,
                        CreateTime = DateTime.Now,
                        Status = 0,
                        JobNumber = jobnumber
                    };
                    _adminBll.Add(model);
                    LogHelper.WriteOperation("添加的用户名为[" + adminName + "]", OperationType.Add, "添加成功", HttpContext.Current.User.Identity.Name);
                    message.IsSuccess = true;
                    message.Message = "";
                }

            }
            catch (Exception ex)
            {
                LogHelper.WriteException(ex);
                message.IsSuccess = false;
                if (ex.Message.Contains("UNIQUE KEY"))
                    message.Message = "工号已经存在，请重新输入";

            }
            context.Response.Write(JsonConvert.SerializeObject(message));

        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int id = Convert.ToInt32(context.Request["id"]);
                string adminName = context.Request["adminName"];
                string adminPassword = context.Request["adminPassword"];
                int adminGroupsId = Convert.ToInt32(context.Request["adminGroupsId"]);
                string oldpassword = context.Request["oldpassword"];
                string phone = context.Request["Phone"];
                string jobnumber = context.Request["Jobnumber"];
                if (_adminBll.IsExist(id, adminName))
                {
                    message.IsSuccess = false;
                    message.Message = "已经存在此用户名";
                    LogHelper.WriteOperation("查询用户名[" + adminName + "]", OperationType.Query, "[" + adminName + "]已经存在", HttpContext.Current.User.Identity.Name);
                }
                else
                {
                    var model = _adminBll.GetModel(id);
                    model.AdminName = adminName;
                    model.AdminGroupsId = adminGroupsId;
                    model.Phone = phone;
                    model.JobNumber = jobnumber;
                    if (!string.IsNullOrEmpty(adminPassword))
                    {
                        model.AdminPassword = Common.EncryptAndDecrypt.Encrypt(adminPassword);
                    }
                    else
                    {
                        model.AdminPassword = oldpassword;
                    }
                    _adminBll.Update(model);
                    LogHelper.WriteOperation("更新用户名[" + adminName + "]的信息", OperationType.Update, "更新后的用户名是[" + model.AdminName + "]", HttpContext.Current.User.Identity.Name);
                    message.IsSuccess = true;
                    message.Message = "";
                }
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                message.IsSuccess = false;
                if(exception.Message.Contains("UNIQUE KEY"))
                    message.Message = "工号已经存在，请重新输入";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));

        }

        private void List(HttpContext context)
        {
            try
            {
                int count = 0;
                int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
                int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
                string keyword = context.Request["Keyword"];
                string jobnumber = context.Request["jobnumber"];
                string where = "adminName like '%" + Common.Tool.SqlFilter(keyword) + "%'";

                string isdelete =Common.Tool.GetString(context.Request["isdelete"]);

                if (context.Request["groupname"] != "0")
                {
                    where += " and admingroupsid=" + context.Request["groupname"];
                }
                if (isdelete != "")
                {
                    where += " and isdelete=" + Int32.Parse(isdelete);
                }
                if (jobnumber != "")
                {
                    where += " and jobnumber=" + jobnumber;
                }
                var list = _adminBll.GetList(pageIndex, pageSize, where, out count);
                LogHelper.WriteOperation("查询管理员", OperationType.Query, "查询成功",HttpContext.Current.User.Identity.Name);
                context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }


        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}