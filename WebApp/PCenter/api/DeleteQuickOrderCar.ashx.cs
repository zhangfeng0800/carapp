using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// DeleteQuickOrderCar 的摘要说明
    /// </summary>
    public class DeleteQuickOrderCar : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            int id =int.Parse(context.Request["id"]);
            new BLL.QuickOrderCarBLL().Delete(id);
            context.Response.Write("1");
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