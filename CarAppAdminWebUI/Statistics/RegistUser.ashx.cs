using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Statistics
{
    /// <summary>
    /// RegistUser1 的摘要说明
    /// </summary>
    public class RegistUser1 : IHttpHandler
    {
        private readonly UserAccountBLL userBll = new UserAccountBLL();
        public void ProcessRequest(HttpContext context)
        {
            GetRegistUser(context);
        }

        private void GetRegistUser(HttpContext context)
        {
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            var list = userBll.GetRegistUser();
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = 9, rows = list }));
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