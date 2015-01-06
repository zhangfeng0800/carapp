using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetHotLine 的摘要说明
    /// </summary>
    public class GetHotLine : IHttpHandler
    {
        private readonly HotLineBLL _hotLineBll = new HotLineBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            string value = context.Request["v"];
            if (action == "cid")
            {
                var list = _hotLineBll.GetHotLineByCityId(value);
                context.Response.Write(JsonConvert.SerializeObject(list));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(_hotLineBll.GetAllHotLine()));
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