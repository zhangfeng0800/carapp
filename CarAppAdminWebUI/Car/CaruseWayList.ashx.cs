using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// CarUseWayList 的摘要说明
    /// </summary>
    public class CarUseWayList : IHttpHandler
    {
        private readonly CarUseWayBLL _carUserWayBll = new CarUseWayBLL();
        public void ProcessRequest(HttpContext context)
        {
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            context.Response.ContentType = "text/plain";
            int count;
            var list = _carUserWayBll.GetPageList(pageIndex, pageSize, keyword, out count);
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