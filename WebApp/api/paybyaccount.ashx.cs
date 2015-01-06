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
    /// paybyaccount 的摘要说明
    /// </summary>
    public class paybyaccount : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string orderId = context.Request.Form["orderid"];
            int result = new BLL.AccountBLL().DealPayNotify(0, "支付订单", orderId, 0);
           　
            context.Response.Write(result == 1
                                       ? JsonConvert.SerializeObject(new {StatusCode = StatusCode.请求成功, Data = orderId})
                                       : JsonConvert.SerializeObject(new AjaxResponse {StatusCode = StatusCode.请求失败}));
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



