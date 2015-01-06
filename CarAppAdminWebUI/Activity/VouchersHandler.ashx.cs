using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Activity
{
    /// <summary>
    /// VouchersHandler 的摘要说明
    /// </summary>
    public class VouchersHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            if(action == "list")
            {
                int count = 0;
                int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
                int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
                string compname = context.Request["compname"] ?? "";
                string status = context.Request["status"] ?? "";
                int userId = string.IsNullOrEmpty(context.Request["userId"])
                                 ? 0
                                 : Convert.ToInt32(context.Request["userId"]);

                string sort = Common.Tool.GetString(context.Request["sort"]);
                string order =  Common.Tool.GetString(context.Request["order"]);
                if (sort == "")
                    sort = "UseTime";

                var list = new BLL.VouchersBll().GetPageList(compname, userId, 0, status, 0,sort,order, pageSize, pageIndex, out count);
                context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
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