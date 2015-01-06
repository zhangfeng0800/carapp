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
    /// getcitybyairport 的摘要说明
    /// </summary>
    public class getcitybyairport : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["provinceid"] != null)
            {
                var provinceid = context.Request.QueryString["provinceid"].ToString();
                var bll = new CityBLL();
                var data = bll.GetCityByAirport(context.Request.QueryString["provinceid"]);
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
                        Data = data,
                        StatusCode = StatusCode.请求失败
                    }));
                }
            }
        }


        public bool IsReusable
        {
            get { return false; }
        }


    }
}