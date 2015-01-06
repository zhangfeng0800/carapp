using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using BLL;

namespace WebApp.twicepay
{
    /// <summary>
    /// checkOrder 的摘要说明
    /// </summary>
    public class checkOrder : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                context.Response.ContentType = "text/plain";
                if (context.Request.Params["orderId"] != null)
                {
                    string orderId = context.Request.Params["orderId"];
                    DataTable dt = new OrderBLL().GetOrderById(orderId);
                    if (dt.Rows.Count == 0)
                    {
                        context.Response.Write("reerror");
                        context.Response.End();
                    }
                    else if (dt.Rows[0]["orderStatusID"].ToString() == "6")//订单状态改为订单完成
                    {
                        context.Response.Write("ok");
                        context.Response.End();
                    }
                    else
                    {
                        context.Response.Write("no");
                        context.Response.End();
                    }
                }
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
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