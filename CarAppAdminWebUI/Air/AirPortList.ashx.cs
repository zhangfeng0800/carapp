using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Air
{
    /// <summary>
    /// AirPortList 的摘要说明
    /// </summary>
    public class AirPortList : IHttpHandler
    {
        private readonly AirportBLL _airportBll = new AirportBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            int count;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            string provinceID = context.Request["provenceID"];

            string where = "airportName like '%" + Common.Tool.SqlFilter(keyword) + "%'";

            if (!string.IsNullOrEmpty(provinceID))
            {
                where += " and provenceID='" + provinceID + "'";
            }

            var list = _airportBll.GetPageList(pageIndex, pageSize, where, out count);
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