using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.api
{
    /// <summary>
    /// JeanyCoupon 的摘要说明
    /// </summary>
    public class JeanyCoupon : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            Routing(context, action);
          
        }
        public void Routing(HttpContext context, string action)
        {
            switch (action)
            {
                case "GetList": GetList(context); break;
                default:
                    break;
            }
        }
        public void GetList(HttpContext context)
        {
            int pageCount = 0;
            int userId = Convert.ToInt32(context.Request["userId"]);
            int currentPage = Convert.ToInt32(context.Request["currentPage"]);
            int pageRowCount = 5;
            int couponStatus = Convert.ToInt32(context.Request["couponStatus"]);
            var result = BLL.Coupon.GetList(userId);
            var result2 = result.Where(s => s.Status == couponStatus && s.Deadline >= DateTime.Now);
            if (couponStatus == 2)
            {
                result2 = result.Where(s => s.Deadline <= DateTime.Now && s.Status == 0);
            }
            pageCount = result2.ToList().Count / 5;
            var result3=result2.Skip((currentPage - 1) * pageRowCount).Take(pageRowCount);
            string responseText = "";
            foreach (var item in result3)
            {
                responseText += " <tr> ";
                responseText += " <td>" + item.Sn + "</td>     ";
                responseText += " <td>" + item.Startdate.ToString("yyyy-MM-dd hh:mm") + "</td>     ";
                responseText += " <td>" + item.Name + "</td> ";
                responseText += " <td>" + item.Cost + "</td> ";
                responseText += " <td>" + item.Deadline.ToString("yyyy-MM-dd hh:mm") + "</td> ";
                responseText += " <td></td> ";
                responseText += " </tr> ";
            }
            context.Response.Write(responseText+"|"+pageCount);
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