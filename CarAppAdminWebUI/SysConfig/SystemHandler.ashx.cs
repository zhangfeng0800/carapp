using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.SysConfig
{
    /// <summary>
    /// SystemHandler 的摘要说明
    /// </summary>
    public class SystemHandler : IHttpHandler
    {
        private readonly SystemBLL _systemBll = new SystemBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "errorlist":
                    ErrorList(context);
                    break;
                case "loglist":
                    LogList(context);
                    break;
            }
        }

        private void LogList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            var list = _systemBll.GetLogList(pageIndex, pageSize, "", out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }

        private void ErrorList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            var list = _systemBll.GetErrorList(pageIndex, pageSize, "", out count);
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