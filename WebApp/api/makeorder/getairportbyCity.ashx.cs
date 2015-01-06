using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// getairportbyCity 的摘要说明
    /// </summary>
    public class getairportbyCity : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityid"] != null)
            {
                int cityid = 0;
                if (!int.TryParse(context.Request.QueryString["cityid"], out cityid))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        StatusCode = StatusCode.请求失败
                    }));
                    return;
                }
                else
                {
                    BLL.AirportBLL bll = new AirportBLL();
                    var data = bll.GetAirPort(cityid.ToString());
                    if (data.Count > 0)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            StatusCode = StatusCode.请求成功,
                            Data = data
                        }));
                        return;
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            StatusCode = StatusCode.请求失败,
                            Message = Message.EMPTY
                        }));
                        return;

                    }
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