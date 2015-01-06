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
    /// getProvinceList 的摘要说明
    /// </summary>
    public class GetProvinceList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new CityBLL();

            if (context.Request.Form["type"] == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse()
                {
                    Data = null,
                    Message = Message.EMPTY,
                    StatusCode = StatusCode.请求失败
                }));
                return;
            }
            var data = bll.GetHotlineProvince(int.Parse(context.Request.Form["type"]));
            context.Response.Write(data.Rows.Count == 0
                ? JsonConvert.SerializeObject(new AjaxResponse()
                {
                    Data = null,
                    Message = Message.EMPTY,
                    StatusCode = StatusCode.请求失败
                })
                : JsonConvert.SerializeObject(new AjaxResponse()
                {
                    Data = data,
                    Message = Message.SUCCESS,
                    StatusCode = StatusCode.请求成功
                }));
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