using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;
using WebApp.api.orderapi;

namespace WebApp.api
{
    /// <summary>
    /// DailyRentHandler 的摘要说明
    /// </summary>
    public class DailyRentHandler : IHttpHandler
    {
        private RentCarBLL _rentCarBll = new RentCarBLL();
        public void ProcessRequest(HttpContext context)
        {
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
            context.Response.ContentType = "application/json";
            string cid = context.Request["cid"];
            var list = _rentCarBll.GetList(cid, int.Parse(context.Request.QueryString["wayid"]));
            context.Response.Write(JsonConvert.SerializeObject(list));
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