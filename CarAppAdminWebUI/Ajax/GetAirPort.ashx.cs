using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetAirPort 的摘要说明
    /// </summary>
    public class GetAirPort : IHttpHandler
    {
        private readonly AirportBLL _airportBll = new AirportBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            string value = context.Request["value"];
            var list = new List<Model.AirPort>();
            if (action == "pid")
            {
                list = _airportBll.GetAirportByProvince(value);
            }

            context.Response.Write(JsonConvert.SerializeObject(list));
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