using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.orderapi
{
    /// <summary>
    /// showway 的摘要说明
    /// </summary>
    public class showway : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] != null)
            {
                if (context.Request.QueryString["transdata"] != null)
                {
                    int id = 0;
                    if (!int.TryParse(context.Request.QueryString["transdata"].ToString(), out id))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { StatusCode = StatusCode.请求失败 }));
                    }
                    else
                    {
                        var bll = new BLL.RentCarBLL();
                        var model = bll.GetModel(id);
                        context.Response.Write(model != null
                            ? JsonConvert.SerializeObject(new AjaxResponse
                            {
                                StatusCode = StatusCode.请求成功,
                                Data = model.carusewayID
                            })
                            : JsonConvert.SerializeObject(new AjaxResponse {StatusCode = StatusCode.请求失败}));
                        return;
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { StatusCode = StatusCode.请求失败 }));
                    return;
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { StatusCode = StatusCode.请求失败 }));
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