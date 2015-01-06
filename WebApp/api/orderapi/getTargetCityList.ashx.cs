using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.orderapi
{
    /// <summary>
    /// getTargetCityList 的摘要说明
    /// </summary>
    public class getTargetCityList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            BLL.CityBLL bll = new CityBLL();
            if (context.Request.QueryString["type"] != null)
            {
                var type = context.Request.QueryString["type"];
                if (type == "province")
                {
                    var province = bll.GetProvince();
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = province,
                        StatusCode = StatusCode.请求成功
                    }));
                    return;
                }
                if (type == "city")
                {
                    if (context.Request.QueryString["id"] != null&& context.Request.QueryString["id"].ToString()!="0")
                    {
                        var province = bll.GetCityByProvince(int.Parse(context.Request.QueryString["id"]));
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = province,
                            StatusCode = StatusCode.请求成功
                        }));
                        return;
                    }
                }
                if (type == "town")
                {
                    if (context.Request.QueryString["id"] != null && context.Request.QueryString["id"].ToString()!="0")
                    {
                        var province = bll.GetTownByCity(context.Request.QueryString["id"]);
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = province,
                            StatusCode = StatusCode.请求成功
                        }));
                        return;
                    }
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