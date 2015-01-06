using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// GetTravelCitylist 的摘要说明
    /// </summary>
    public class GetTravelCitylist : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var data = (new HotLineBLL()).GetTravelCityList();
            context.Response.Write(JsonConvert.SerializeObject(new
            {
                CodeId = 1,
                Data = data
            }));
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