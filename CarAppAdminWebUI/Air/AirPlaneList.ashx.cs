using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Air
{
    /// <summary>
    /// AirPlaneList 的摘要说明
    /// </summary>
    public class AirPlaneList : IHttpHandler
    {
        private readonly AirPlaneBLL _airPlaneBll = new AirPlaneBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            int count;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            string airportName = context.Request["airportName"];
            string where = "1=1";
            if (!string.IsNullOrEmpty(keyword))
            {
                where += " and planeNo like '%" + Common.Tool.SqlFilter(keyword) + "%'";
            }
            if (!string.IsNullOrEmpty(airportName))
            {
                where += " and airportName like '%" + Common.Tool.SqlFilter(airportName) + "%'";
            }
            

            var list = _airPlaneBll.GetPageList(pageIndex, pageSize, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
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