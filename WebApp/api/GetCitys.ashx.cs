using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// GetCitys 的摘要说明
    /// </summary>
    public class GetCitys : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
             context.Response.ContentType = "application/json";
            string pidStr = context.Request["pid"];
            if (!string.IsNullOrEmpty(pidStr))
            {
                context.Response.Write(JsonConvert.SerializeObject(new BLL.CityBLL().GetList("parentid="+pidStr, "")).ToLower());
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