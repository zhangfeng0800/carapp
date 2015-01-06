using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetAllCity 的摘要说明
    /// </summary>
    public class GetAllCity : IHttpHandler
    {
        private readonly CityBLL _cityBll = new CityBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string pidStr=context.Request["pid"];
            if (!string.IsNullOrEmpty(pidStr))
            {
                context.Response.Write(JsonConvert.SerializeObject(_cityBll.GetCityByProvince(Convert.ToInt32(pidStr))));

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