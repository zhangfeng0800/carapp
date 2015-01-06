using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.api.orderapi
{
    /// <summary>
    /// getcoupon 的摘要说明
    /// </summary>
    public class getcoupon : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.Write("Hello World");
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