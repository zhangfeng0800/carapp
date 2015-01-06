using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Statistics
{
    /// <summary>
    /// HotspotHandler 的摘要说明
    /// </summary>
    public class HotspotHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            if (action == "Hotspot")
            {
                try
                {
                    string startDate = context.Request["startDate"];
                    string endDate = context.Request["endDate"];
                    string caruseway = context.Request["caruseway"];
                    string cartype = context.Request["cartype"];
                    string pointtype = context.Request["pointtype"];
                    var data = new BLL.OrderBLL().GetHotSpot(startDate, endDate, caruseway, cartype, pointtype);
                    context.Response.Write(JsonConvert.SerializeObject(data));
                }
                catch (Exception exp)
                {
                    
                    throw;
                }
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