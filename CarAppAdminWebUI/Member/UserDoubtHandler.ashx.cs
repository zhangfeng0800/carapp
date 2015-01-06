using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// UserDoubtHandler 的摘要说明
    /// </summary>
    public class UserDoubtHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
            }
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string where = " 1=1 ";
            var list = new BLL.UserDoubtBll().GetPageList(where, pageIndex, pageSize, out count);
            context.Response.Write(JsonConvert.SerializeObject(new {index = pageIndex, total = count, rows = list}));

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