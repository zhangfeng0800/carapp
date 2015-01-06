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
    /// gettownlist 的摘要说明
    /// </summary>
    public class gettownlist : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityid"] != null)
            {
                string cityid = context.Request.QueryString["cityid"].ToString();
                var bll = new CityBLL();
                DataTable dt;
                if (context.Request.QueryString["type"] == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        StatusCode = StatusCode.请求失败,
                        Message = Message.EMPTY
                    }));
                    return;
                }
                dt = bll.GetTownByCity(int.Parse(cityid), int.Parse(context.Request.QueryString["type"]));

                if (dt.Rows.Count > 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = dt,
                        StatusCode = StatusCode.请求成功
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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}