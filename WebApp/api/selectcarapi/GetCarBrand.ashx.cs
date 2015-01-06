using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.selectcarapi
{
    /// <summary>
    /// GetCarBrand 的摘要说明
    /// </summary>
    public class GetCarBrand : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["rentId"] != null)
            {
                var dt = new CarBrandBLL().GetBrandByRentID(Convert.ToInt32(context.Request.QueryString["rentId"]));
                context.Response.Write(dt.Rows.Count > 0
                    ? JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = dt.AsEnumerable().Take(3),
                        Message = Message.SUCCESS,
                        StatusCode = StatusCode.请求成功
                    })
                    : JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = null,
                        Message = Message.EMPTY,
                        StatusCode = StatusCode.请求失败
                    }));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.BADPARAMETERS, StatusCode = StatusCode.请求失败 }));
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