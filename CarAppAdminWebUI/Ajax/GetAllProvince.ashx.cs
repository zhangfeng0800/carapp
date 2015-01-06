using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetAllProvince 的摘要说明
    /// </summary>
    public class GetAllProvince : IHttpHandler
    {
        private readonly CityBLL _cityBll = new CityBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var table = _cityBll.GetProvince();
            context.Response.Write(JsonConvert.SerializeObject(table));
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