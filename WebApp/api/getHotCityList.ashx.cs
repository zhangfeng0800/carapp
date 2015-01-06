using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// getHotCityList 的摘要说明
    /// </summary>
    public class getHotCityList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var city = new ServiceCityBLL();
            var data = city.GetHotCity();
            if (data.Rows.Count > 0)
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                    Data = data,
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