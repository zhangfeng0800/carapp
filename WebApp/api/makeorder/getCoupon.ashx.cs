using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Model;
using Newtonsoft.Json;
using Coupon = Model.Coupon;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// getCoupon 的摘要说明
    /// </summary>
    public class getCoupon : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    CodeId = 0
                }));
                return;
            }
            if (context.Request.QueryString["orderid"] != null)
            {
                var orderid = context.Request.QueryString["orderid"];
                var orderbll = (new OrderBLL());
                var data = orderbll.GetOrderInfo(orderid);
                if (data.Rows.Count == 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        CodeId = 0
                    }));
                    return;
                }
                if (Convert.ToDateTime(data.Rows[0]["orderdate"]).ToString("yyyyMMddHHmmss") !=
                    orderid.Substring(0, orderid.Length - 5))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        CodeId = 0
                    }));
                    return;
                }
                List<Model.Coupon> list = new List<Coupon>();
                UserAccount ua = (UserAccount)context.Session["UserInfo"];

                list =
                    BLL.Coupon.GetList(ua.Id)
                        .Where(
                            c =>
                                c.Restrictions <= decimal.Parse(data.Rows[0]["discountprice"].ToString()) &&
                                c.Deadline >= DateTime.Now && c.Status == 0 && c.Startdate <= DateTime.Now &&
                           string.IsNullOrEmpty(c.OrderId)).ToList();
                if (list.Count > 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        CodeId = 1,
                        Data = list
                    }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        CodeId = 0
                    }));

                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    CodeId = 0
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