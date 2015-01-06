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
    /// GetHotLineByCity 的摘要说明
    /// </summary>
    public class GetHotLineByCity : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityId"] != null)
            {
                var list = new ServiceCityBLL().GetOpenCity(context.Request.QueryString["cityId"]);
                if (list.Count <= 0)
                {
                    context.Response.Write(
                        JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = null,
                            Message = Message.EMPTY,
                            StatusCode = StatusCode.请求失败
                        }));
                }
                else
                {
                    context.Response.Write(
                        JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = list,
                            Message = Message.SUCCESS,
                            StatusCode = StatusCode.请求成功
                        }));
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(
                    new AjaxResponse
                    {
                        Data = null,
                        Message = Message.BADPARAMETERS,
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