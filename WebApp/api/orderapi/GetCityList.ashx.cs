using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.api.orderapi
{
    /// <summary>
    /// GetCityList 的摘要说明
    /// </summary>
    public class GetCityList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new CityBLL();
            if (context.Request.QueryString["provinceId"] != null)
            {
                if (context.Request.QueryString["type"] == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = null,
                            Message = Message.EMPTY,
                            StatusCode = StatusCode.请求失败
                        }));
                    return;
                }
                var list = bll.GetCityByProvince(int.Parse(context.Request.QueryString["provinceId"]), Convert.ToInt32(context.Request.QueryString["type"]));
                context.Response.Write(list.Rows.Count == 0
                    ? JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = null,
                        Message = Message.EMPTY,
                        StatusCode = StatusCode.请求失败
                    })
                    : JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = list,
                        Message = Message.SUCCESS,
                        StatusCode = StatusCode.请求成功
                    }));
            }
            else
            {

                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = null,
                        Message = Message.EMPTY,
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