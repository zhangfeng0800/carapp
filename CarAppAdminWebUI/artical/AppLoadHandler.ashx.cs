using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.artical
{
    /// <summary>
    /// AppLoadHandler 的摘要说明
    /// </summary>
    public class AppLoadHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
                case "Delete":
                    Delete(context);
                    break;
                case "add":
                    Add(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "editState":
                    EditState(context);
                    break;
            }
        }

        private void EditState(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["Id"]);
            Model.AppLoad appLoad = new BLL.AppLoadBll().GetModel(id);
            if (appLoad.State == "显示")
                appLoad.State = "隐藏";
            else
            {
                appLoad.State = "显示";
            }

            int result = new BLL.AppLoadBll().UpdateData(appLoad);
            context.Response.Write(result);
        }

        private void Edit(HttpContext context)
        {
            try
            {
                if (string.IsNullOrEmpty(context.Request["Image"]))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { Message = "请选择图片" }));
                    return;
                }
                int id = Convert.ToInt32(context.Request["Id"]);
                string state = context.Request["State"].ToString();
                string imageurl = context.Request["Image"].ToString();
                string preimg = System.Web.Configuration.WebConfigurationManager.AppSettings["backUrl"];
                if (!imageurl.Contains("http"))
                    imageurl = preimg + imageurl;
                int sort = 0;
                try
                {
                    sort = Convert.ToInt32(context.Request["Sort"]);
                }
                catch (Exception ex)
                {
                    LogHelper.WriteException(ex);
                    context.Response.Write(JsonConvert.SerializeObject(new { Message = "请检查排序" }));
                    return;
                }

                int version = 0;
                try
                {
                    version = Convert.ToInt32(context.Request["Version"]);
                }
                catch (Exception ex)
                {
                    LogHelper.WriteException(ex);
                    context.Response.Write(JsonConvert.SerializeObject(new { Message = "请检查版本信息" }));
                    return;
                }
                Model.AppLoad appLoad = new BLL.AppLoadBll().GetModel(id);
                appLoad.State = state;
                appLoad.ImageUrl = imageurl;
                appLoad.Sort = sort;
                appLoad.Version = version;
                int result = new BLL.AppLoadBll().UpdateData(appLoad);
                context.Response.Write(JsonConvert.SerializeObject(new { IsSuccess = result }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { Message = "操作失败，请检查参数" }));
            }

        }

        private void Add(HttpContext context)
        {
            try
            {
                string state = context.Request["State"].ToString();
                if (string.IsNullOrEmpty(context.Request["Image"]))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { Message = "请选择图片" }));
                    return;
                }

                string imageurl = System.Web.Configuration.WebConfigurationManager.AppSettings["backUrl"] +
                                  context.Request["Image"].ToString();
                int sort = 0;
                try
                {
                    sort = Convert.ToInt32(context.Request["Sort"]);
                }
                catch (Exception ex)
                {
                    LogHelper.WriteException(ex);
                    context.Response.Write(JsonConvert.SerializeObject(new { Message = "请检查排序" }));
                    return;
                }

                int version = 0;
                try
                {
                    version = Convert.ToInt32(context.Request["Version"]);
                }
                catch (Exception ex)
                {
                    LogHelper.WriteException(ex);
                    context.Response.Write(JsonConvert.SerializeObject(new { Message = "版本信息" }));
                    return;
                }
                var appload = new AppLoad()
                {
                    State = state,
                    ImageUrl = imageurl,
                    Sort = sort,
                    Version = version
                };
                int id = new BLL.AppLoadBll().AddData(appload);

                context.Response.Write(JsonConvert.SerializeObject(new { IsSuccess = id }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { Message = "操作失败，请检查参数" }));
            }

        }

        private void Delete(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            int result = new BLL.AppLoadBll().DelData(id);
            context.Response.Write(result);
        }

        private void List(HttpContext context)
        {
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string where = "";
            int rowCount = 0;
            var appList = new BLL.AppLoadBll().GetPage(pageSize, pageIndex, where, out rowCount, "Version desc");

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = rowCount, rows = appList }));
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