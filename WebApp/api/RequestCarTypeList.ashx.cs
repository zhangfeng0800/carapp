using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;

namespace WebApp.api
{
    /// <summary>
    /// RequestCarTypeList 的摘要说明
    /// </summary>
    public class RequestCarTypeList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new CarTypeBLL();
           context.Response.Write(bll.GetCarTypeJson());
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