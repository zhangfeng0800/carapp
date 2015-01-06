using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// getprovincebyairport 的摘要说明
    /// </summary>
    public class getprovincebyairport : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new CityBLL();
            var dt = bll.GetProvinceByAirport();
            if (dt.Rows.Count > 0)
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                    Data = dt,
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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}