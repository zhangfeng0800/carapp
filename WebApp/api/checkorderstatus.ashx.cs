using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// checkorderstatus 的摘要说明
    /// </summary>
    public class checkorderstatus : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.Form["orderid"] != null)
            {
                var orderid = context.Request.Form["orderid"];
                var data = (new BLL.OrderBLL()).GetOrderById(orderid);
                if (data.Rows.Count > 0)
                {
                    if (new BLL.RentCarBLL().GetModelbyID(new BLL.OrderBLL().GetModel(orderid).rentCarID).carusewayID != 7)
                    {
                        if (BLL.OrderBLL.CheckOrderIsPastTime(Convert.ToDateTime(data.Rows[0]["departureTime"])))
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new
                                                                                   {
                                                                                       Message = "订单已过期",
                                                                                       CodeId = 0,
                                                                                       location =
                                                                                   "/pcenter/myorders.aspx"
                                                                                   }));
                            return;
                        }
                    }
                    if (int.Parse(data.Rows[0]["orderstatusid"].ToString()) > 1)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new
                        {
                            Message = "订单已支付",
                            CodeId = 0,
                            location="/pcenter/myorders.aspx"
                        }));
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new
                        {
                            Message = "",
                            CodeId = 1
                        }));
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        Message = "订单号不存在",
                        CodeId =2
                    }));
                }
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