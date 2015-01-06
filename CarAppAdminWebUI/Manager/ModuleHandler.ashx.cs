using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.Configuration;
using BLL;
using IEZU.Log;
using Model;
using Model.Ext;
using Newtonsoft.Json;
using NPOI.SS.Formula.Eval;

namespace CarAppAdminWebUI.Manager
{
    /// <summary>
    /// ModuleHandler 的摘要说明
    /// </summary>
    public class ModuleHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["action"] == "list")
            {
                GetList(context);
            }
            else if (context.Request["action"] == "combox")
            {
                GetComboxTree(context);
            }
            else if (context.Request["action"] == "add")
            {
                AddModule(context);
            }
            else if (context.Request["action"] == "edit")
            {
                EditModule(context);
            }
            else if (context.Request["action"] == "delete")
            {
                DeleteModule(context);
            }
            else if (context.Request["action"] == "tree")
            {
                GetFileTree(context);
            }
        }
        public void EditModule(HttpContext context)
        {
            var msg = new AjaxResultMessage();
            try
            {
                var id = int.Parse(context.Request["id"]);
                var pid = (context.Request["pid"]);
                var modulename = context.Request["modulename"];
                var linkurl = context.Request["linkurl"];
                var sortorder = int.Parse(context.Request["sort"]);
                var isvisible = 0;
                if (context.Request["isvisible"] != null)
                {
                    isvisible = 1;
                }
                if (modulename == "")
                {
                    msg.IsSuccess = false;
                    msg.Message = "请填写模块名称";
                    context.Response.Write(JsonConvert.SerializeObject(msg));
                    return;
                }
                if (pid == "")
                {
                    pid = "0";
                }
             
                if (pid != "0" && string.IsNullOrEmpty(linkurl))
                {
                    msg.IsSuccess = false;
                    msg.Message = "请填写链接地址";
                    context.Response.Write(JsonConvert.SerializeObject(msg));
                    return;
                }
                
                var model = new Module
                {
                    ModuleName = modulename,
                    LinkUrl = linkurl,
                    ModuleSort = sortorder,
                    ModuleVisible = isvisible,
                    ParentId = int.Parse(pid),
                    ModuleID = id
                };
                var result = (new BLL.ModuleBLL()).EditModule(model);
                if (result > 0)
                {
                    msg.IsSuccess = true;
                    msg.Message = "更新成功";
                }
                else
                {
                    msg.IsSuccess = false;
                    msg.Message = "更新失败";
                }
                context.Response.Write(JsonConvert.SerializeObject(msg));

            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                msg.IsSuccess = false;
                msg.Message = "服务器错误，稍后重试";
                context.Response.Write(JsonConvert.SerializeObject(msg));
            }
        }
        public void GetList(HttpContext context)
        {
            var bll = new ModuleBLL();
            var data = bll.GetTree();
            var result = new List<Module>();
            if (context.Request["id"] != null)
            {
                result = data.Where(p => p.ParentId == int.Parse(context.Request["id"])).ToList();
            }
            else
            {
                result = data.Where(p => p.ParentId == 0).ToList();
            }

            context.Response.Write(JsonConvert.SerializeObject(result));
        }

        public void GetComboxTree(HttpContext context)
        {
            context.Response.Write(JsonConvert.SerializeObject((new BLL.ModuleBLL()).GetComboxTree()));
        }

        public void AddModule(HttpContext context)
        {
            var msg = new AjaxResultMessage();
            try
            {
                var pid = (context.Request["parentid"]);
                var modulename = context.Request["modulename"];
                var linkurl = context.Request["linkurl"];
                var sortorder = int.Parse(context.Request["sort"]);
                var isvisible = 0;
                if (context.Request["isvisible"] != null)
                {
                    isvisible = 1;
                }
                if (modulename == "")
                {
                    msg.IsSuccess = false;
                    msg.Message = "请填写模块名称";
                    context.Response.Write(JsonConvert.SerializeObject(msg));
                    return;
                }
                if (pid == "")
                {
                    pid = "0";
                }

                if (pid != "0" && string.IsNullOrEmpty(linkurl))
                {
                    msg.IsSuccess = false;
                    msg.Message = "请填写链接地址";
                    context.Response.Write(JsonConvert.SerializeObject(msg));
                    return;
                }
                if (pid != "0" && !linkurl.Contains(".aspx"))
                {
                    msg.IsSuccess = false;
                    msg.Message = "请选择正确的地址";
                    context.Response.Write(JsonConvert.SerializeObject(msg));
                    return;
                }
                if (string.IsNullOrEmpty(linkurl))
                {
                    linkurl = "";
                }
             
                var model = new Module
                {
                    ModuleName = modulename,
                    LinkUrl = linkurl,
                    ModuleSort = sortorder,
                    ModuleVisible = isvisible,
                    ParentId = int.Parse(pid)
                };
                var result = (new BLL.ModuleBLL()).InsertModule(model);
                if (result > 0)
                {
                    msg.IsSuccess = true;
                    msg.Message = "添加成功";
                }
                else
                {
                    msg.IsSuccess = false;
                    msg.Message = "添加失败";
                }
                context.Response.Write(JsonConvert.SerializeObject(msg));

            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                msg.IsSuccess = false;
                msg.Message = "服务器错误，稍后重试";
                context.Response.Write(JsonConvert.SerializeObject(msg));
            }

        }

        public void GetFileTree(HttpContext context)
        {
            var pageList = new List<object>();
            var path = context.Server.MapPath("/");
            DirectoryInfo directoryInfo = new DirectoryInfo(path);
            var directories = directoryInfo.GetDirectories();
            for (int i = 0; i < directories.Length; i++)
            {
                if (directories[i].GetFiles("*.aspx").Length > 0)
                {
                    var instance = new { text = directories[i].Name, id = i + 1, state = "closed", children = new List<object>() };
                    for (int j = 0; j < directories[i].GetFiles("*.aspx").Length; j++)
                    {
                        instance.children.Add(new { text = "/" + directories[i].Name + "/" + directories[i].GetFiles("*.aspx")[j].Name, id = "/" + directories[i].Name + "/" + directories[i].GetFiles("*.aspx")[j].Name });
                    }
                    pageList.Add(instance);
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(pageList));
        }
        public void DeleteModule(HttpContext context)
        {
            try
            {
                var bll = new ModuleBLL();
                var pid = context.Request["parentId"];
                var moduleid = context.Request["moduleId"];
                if (pid == "0")
                {
                    using (var transaction = new TransactionScope())
                    {
                        bll.DeleteByParentId(int.Parse(moduleid));
                        bll.Delete(int.Parse(moduleid));
                        transaction.Complete();
                    }

                }
                else
                {
                    bll.Delete(int.Parse(moduleid));
                }
                context.Response.Write(JsonConvert.SerializeObject(new { IsSuccess = true, Message = "删除成功" }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { IsSuccess = false, Message = "服务器错误，请稍后重试" }));
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