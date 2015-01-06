using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// RequestCarsInfo 的摘要说明
    /// </summary>
    public class RequestCarsInfo : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["longitude"] != null && context.Request.QueryString["latitude"] != null &&
                context.Request.QueryString["cartype"] != null)
            {
                var bll = new CarInfoBLL();
                context.Response.Write(bll.GetNearestCarList(context.Request.QueryString["longitude"],
                    context.Request.QueryString["latitude"], context.Request.QueryString["cartype"]));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new{statuscode="400",message="请求参数错误"}));
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