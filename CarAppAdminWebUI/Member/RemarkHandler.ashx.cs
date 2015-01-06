using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// RemarkHandler 的摘要说明
    /// </summary>
    public class RemarkHandler : IHttpHandler
    {
        private readonly Remark _remark = new Remark();
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
            string keyword = Common.Tool.GetString(context.Request["keyword"]);
            string score = Common.Tool.GetString(context.Request["score"]);
            int userId = string.IsNullOrEmpty(context.Request["userId"]) ? 0 : Convert.ToInt32(context.Request["userId"]);
            string where = "content like '%" + Common.Tool.SqlFilter(keyword) + "%'";
            if (score != "")
                where += " and score='" + score + "'";
            if (userId != 0)
                where += " and userid=" + userId;


            var list = _remark.GetPageList(pageIndex, pageSize, where, out count);
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