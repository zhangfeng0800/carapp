using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.api
{
    /// <summary>
    /// MyPassenger 的摘要说明
    /// </summary>
    public class MyPassenger : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            Routing(context, action);
        }
        public void Routing(HttpContext context, string action)
        {
            switch (action)
            {
                case "add": Add(context); break;
                case "update": Update(context); break;
                case "Delete": Delete(context); break;
                default:
                    break;
            }
        }
        public void Add(HttpContext context)
        {

        }
        public void Update(HttpContext context)
        {

        }
        public void Delete(HttpContext context)
        {
            string requestString = context.Request["ids"];
            requestString = requestString.Substring(0, requestString.Length - 1);
            string[] ids = requestString.Split(',');
            int[] IDS = new int[ids.Length];
            for (int i = 0; i < ids.Length; i++)
            {
                IDS[i] = Convert.ToInt32(ids[i]);
            }
            new BLL.ContactPerson().Delete(IDS);
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