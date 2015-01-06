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
    /// GetCarUseWayByCity 的摘要说明
    /// </summary>
    public class GetCarUseWayByCity : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityId"] != null)
            {
                var cityId = context.Request.QueryString["cityId"];

                var bll = new ServiceCityBLL();
                var list = bll.GetCarUse(cityId);

                var list2 = from c in list where c.carusewayID != 7&&c.carusewayID!=8 select c;//去掉了随叫随到

                context.Response.Write(list.Count == 0
                    ? JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = null,
                        Message = Message.EMPTY,
                        StatusCode = StatusCode.请求失败
                    })
                    : JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = list2,
                        Message = Message.SUCCESS,
                        StatusCode = StatusCode.请求成功
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