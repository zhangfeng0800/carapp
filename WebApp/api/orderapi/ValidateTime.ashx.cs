using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.orderapi
{
    /// <summary>
    /// ValidateTime 的摘要说明
    /// </summary>
    public class ValidateTime : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["date"] != null)
            {
                DateTime dt;
                if (DateTime.TryParse(context.Request.QueryString["date"], out dt))
                {
                    if (dt.ToString("yyyy-MM-dd") == DateTime.Now.ToString("yyyy-MM-dd"))
                    {
                        var hourlist = new List<string>();
                        var minutelist = new List<string>();
                        if (DateTime.Now.Hour < 8 || DateTime.Now.Hour > 22)
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                            {
                                Data = 0,
                                StatusCode = StatusCode.请求失败
                            }));
                        }
                        else
                        {
                            for (var i = DateTime.Now.Hour + 1; i < 23; i++)
                            {
                                hourlist.Add(i.ToString());
                            }

                            for (var i = 0; i < DateTime.Now.Minute+16; i+=5)
                            {
                                minutelist.Add(i.ToString());
                            }
                            context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                            {
                                Data = new { hourlist = hourlist, minutelist = minutelist },
                                StatusCode = StatusCode.请求成功
                            }));
                        }

                    }
                    else
                    {
                        var hourlist = new List<string>();
                        for (var i = 0; i < 24; i++)
                        {
                            hourlist.Add(i.ToString());
                        }
                        var minuteslist = new List<string>();
                        for (var i = 0; i < 60; i += 5)
                        {
                            minuteslist.Add(i.ToString());
                        }
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = new { hourlist = hourlist, minutelist = minuteslist },
                            StatusCode = StatusCode.请求成功
                        }));
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        StatusCode = StatusCode.请求失败,
                        Message = Message.BADPARAMETERS
                    }));
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                    StatusCode = StatusCode.请求失败
                }));
                return;
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