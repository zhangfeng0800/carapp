using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using IEZU.Log;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// ArticalContentController 的摘要说明
    /// </summary>
    public class ArticalContentController : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            HttpFileCollection file = context.Request.Files;
            Routing(action, context);
        }

        public void Routing(string action, HttpContext context)
        {
            switch (action)
            {
                case "AddContent": AddArticalContent(context); break;
                case "upDateContent": upDateContent(context); break;
                case "DeleteContent": DeleteContent(context); break;
                default:
                    break;
            }
        }
        public void AddArticalContent(HttpContext context)
        {
            var title = context.Request["atitle"];
            if (string.IsNullOrEmpty(title.Trim()))
            {
                context.Response.Write("请输入文章标题");
                return;
            }
            if (title.Length > 40)
            {
                context.Response.Write("文章标题长度应小于40");
                return;
            }
            if (string.IsNullOrEmpty(context.Request["content"]))
            {
                context.Response.Write("请输入文章内容");
                return;
            }
            try
            {
                var orderNumber = 0;
                if (!string.IsNullOrEmpty(context.Request["orderNumber"]))
                {
                    try
                    {
                        orderNumber = int.Parse(context.Request["orderNumber"]);
                    }
                    catch (Exception exception)
                    {
                        LogHelper.WriteException(exception);
                        context.Response.Write("请检查排序");
                        return;
                    }
                }
                string myurl = ConfigurationManager.AppSettings["backUrl"];
                var content  = new Model.ArticalContent();
                content.articalID = Convert.ToInt32(context.Request["articalType"]);
                content.contents = Common.regexPath.DoChange(context.Request["content"].ToString(), myurl);
                content.dateTime = DateTime.Now;
                content.isPublish = Convert.ToInt32(context.Request["ispublish"]);
                content.title = context.Request["atitle"];
                content.imagePath = context.Request["imagePath"];
                if (content.imagePath != "" && !content.imagePath.Contains(myurl))
                    content.imagePath = myurl + content.imagePath;
                content.mainInfo = context.Request["mainInfo"];
                content.orderNumber =orderNumber;
               
                BLL.ArticalContent.Add(content);
                context.Response.Write("1");
            }
            catch (Exception ex)
            {
                context.Response.Write("操作失败");
                LogHelper.WriteException(ex);
            }

        }
        public void upDateContent(HttpContext context)
        {
            if (string.IsNullOrEmpty(context.Request["atitle"]))
            {
                context.Response.Write("请输入文章标题");
                return;
            }
            if (string.IsNullOrEmpty(context.Request["content"]))
            {
                context.Response.Write("请输入文章内容");
                return;
            }
           
            try
            {
                var orderNumber = 0;
                if (!string.IsNullOrEmpty(context.Request["orderNumber"]))
                {
                    try
                    {
                        orderNumber = int.Parse(context.Request["orderNumber"]);
                    }
                    catch (Exception exception)
                    {
                        LogHelper.WriteException(exception);
                        context.Response.Write("请检查排序");
                        return;
                    }
                }
                var title = context.Request["atitle"];
                if (title.Trim().Length > 40)
                {
                    context.Response.Write("文章标题长度应小于40");
                    return;
                }
                string myurl = ConfigurationManager.AppSettings["backUrl"];
                Model.ArticalContent content = new Model.ArticalContent();
                content.ID = Convert.ToInt32(context.Request["ID"]);
                content.articalID = Convert.ToInt32(context.Request["articalType"]);
                content.contents = Common.regexPath.DoChange(context.Request["content"].ToString(), myurl);
                content.dateTime = DateTime.Now;
                content.title = context.Request["atitle"];
                content.isPublish = Convert.ToInt32(context.Request["ispublish"]);
                content.imagePath = context.Request["imagePath"];
                if (content.imagePath != "" && !content.imagePath.Contains(myurl))
                    content.imagePath = myurl + content.imagePath;
                content.mainInfo = context.Request["mainInfo"];
                content.orderNumber = orderNumber;
                BLL.ArticalContent.Update(content);
                context.Response.Write("1");
            }
            catch (Exception ex)
            {
                LogHelper.WriteException(ex);
                context.Response.Write("操作失败");
            }

        }
        public void DeleteContent(HttpContext context)
        {
            string requestString = context.Request["ids"];
            requestString = requestString.Substring(0, requestString.Length - 1);
            string[] ids = requestString.Split(',');
            int[] IDS = new int[ids.Length];
            for (int i = 0; i < ids.Length; i++)
            {
                IDS[i] = Convert.ToInt32(ids[i]);
            }
            BLL.ArticalContent.Delete(IDS);
            context.Response.Write(1);
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