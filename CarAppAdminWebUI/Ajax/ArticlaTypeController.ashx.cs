using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// ArticlaTypeController 的摘要说明
    /// </summary>
    public class ArticlaTypeController : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            Routing(action, context);
        }

        public void Routing(string action, HttpContext context)
        {
            switch (action)
            {
                case "AddType": AddType(context); break;
                case "upDateTypeByName": UpdateTypebyName(context); break;
                case "upDateTypeByCheck": UpdateTypebyCheck(context); break;
                case "DeleteType": DeleteType(context); break;
                default:
                    break;
            }
        }
        public void AddType(HttpContext context)
        {
            Model.Artical artical = new Model.Artical();
            artical.Name = context.Request["articalName"];
            artical.hasImage = Convert.ToInt32(context.Request["hasImage"]);
            BLL.ArticalBLL.Add(artical);
            context.Response.Write("sucess");
        }
        public void UpdateTypebyName(HttpContext context)
        {
           
            int id = Convert.ToInt32(context.Request["ID"]);
            string title = context.Request["articalName"];
            BLL.ArticalBLL.Update(title,id);
            context.Response.Write("sucess");
            
        }
        public void UpdateTypebyCheck(HttpContext context)
        {
            int id= Convert.ToInt32(context.Request["ID"]);
            int hasImage =Convert.ToInt32(context.Request["hasImage"]);
            BLL.ArticalBLL.Update(hasImage,id);
            context.Response.Write("sucess");

        }
        public void DeleteType(HttpContext context)
        {
            string requestString = context.Request["ids"];
            requestString = requestString.Substring(0, requestString.Length - 1);
            string[] ids = requestString.Split(',');
            int[] IDS = new int[ids.Length];
            for (int i = 0; i < ids.Length; i++)
            {
                IDS[i] = Convert.ToInt32(ids[i]);
            }
            BLL.ArticalBLL.Delete(IDS);
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