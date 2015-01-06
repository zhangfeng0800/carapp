using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.orderapi
{
    /// <summary>
    /// GetHotLineStyle 的摘要说明
    /// </summary>
    public class GetHotLineStyle : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityId"] != null && context.Request.QueryString["hotlineId"] != null)
            {
                var bll = new HotLineBLL();
                var dt = bll.GetHotLineStyle(context.Request.QueryString["cityId"],
                          context.Request.QueryString["hotlineId"]);
                if (dt.Rows.Count > 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = dt,
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
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
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