using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// getCityByUseway 的摘要说明
    /// </summary>
    public class getCityByUseway : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["wayid"] != null)
            {
                var wayid = 0;
                if (!int.TryParse(context.Request.QueryString["wayid"], out wayid))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Message = Message.BADPARAMETERS,
                        StatusCode = StatusCode.请求失败
                    }));
                }
                else
                {
                    var bll = new ServiceCityBLL();
                    var data = bll.GetCityListByUse(int.Parse(context.Request.QueryString["wayid"]));
                    context.Response.Write(data.Rows.Count > 0
                        ? JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = data,
                            Message = Message.SUCCESS,
                            StatusCode = StatusCode.请求成功
                        })
                        : JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Message = Message.EMPTY,
                            StatusCode = StatusCode.请求失败
                        }));
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Message = Message.BADPARAMETERS, StatusCode = StatusCode.请求失败 }));
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