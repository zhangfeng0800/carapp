using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// gettownbyairport 的摘要说明
    /// </summary>
    public class gettownbyairport : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityid"] != null)
            {
                string cityid = context.Request.QueryString["cityid"];
                BLL.CityBLL bll = new CityBLL();
                var data = bll.GetTownByAirport(cityid);
                if (data.Rows.Count > 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = data,
                        StatusCode = StatusCode.请求成功
                    }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = null,
                        StatusCode = StatusCode.请求失败
                    }));
                }
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