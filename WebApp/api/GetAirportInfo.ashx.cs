using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

using System.Web;
using BLL;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// GetAirportInfo 的摘要说明
    /// </summary>
    public class GetAirportInfo : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityid"] != null)
            {
                var bll = new AirportBLL();
                context.Response.Write(
                    bll.GetAirportJson(
                        int.Parse(context.Request.QueryString["cityid"].ToString(CultureInfo.InvariantCulture))));
                return;
            }
            if (!string.IsNullOrEmpty(context.Request["cityid"]))
            {
                var bll = new AirportBLL();
                context.Response.Write(
                    JsonConvert.SerializeObject(bll.GetList(int.Parse(context.Request["cityid"]))));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new { HttpStatusCode = "400", message = "请求参数错误" }));
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