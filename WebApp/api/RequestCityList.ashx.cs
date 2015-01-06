using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;

namespace WebApp.api
{
    /// <summary>
    /// RequestCityList 的摘要说明
    /// </summary>
    public class RequestCityList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new CityBLL();
            //context.Response.Write(bll.GetCityList());
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