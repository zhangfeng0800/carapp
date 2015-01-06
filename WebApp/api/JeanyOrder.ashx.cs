using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using Common;

namespace WebApp.api
{
    /// <summary>
    /// JeanyOrder 的摘要说明
    /// </summary>
    public class JeanyOrder : IHttpHandler
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
                case "GetDataByTime": GetDataByTime(context); break;
                default:
                    break;
            }
        }

        public void GetList(HttpContext context)
        {
            int userId = Convert.ToInt32(context.Request["userId"]);
            int currentPage = Convert.ToInt32(context.Request["currentPage"]);
            int pageRowCount = 5;
            int orderStatusID = Convert.ToInt32(context.Request["orderStatusID"]);
            var result = BLL.OrderBLL.GetList(userId);
            var result2 = result.Where(s => s.OrderStatus == (OrderStatus)Enum.Parse(typeof(OrderStatus), orderStatusID.ToString())).Skip((currentPage - 1) * pageRowCount).Take(pageRowCount);
            if (orderStatusID == 0)
            {
                result2 = result.Skip((currentPage - 1) * pageRowCount).Take(pageRowCount);
            }
            string responseText = "";
            var carUseWay = BLL.CarUseWayBLL.getList();
            //var orderStatus = BLL.orderStatus.GetList();
            foreach (var item in result2)
            {
                //var ResultOrderStatus = orderStatus.Where(s => s.id == item.orderStatusID).FirstOrDefault().orderstatus;
                //if (ResultOrderStatus == null)
                //{
                //    ResultOrderStatus = "";
                //}
                responseText += " <tr>                        ";
                responseText += " <td>" + item.id + "</td>     ";
                responseText += " <td>" + item.passengerName + "</td>     ";
                responseText += " <td>" + item.orderDate.ToString("yyyy-MM-dd hh:mm") + "</td> ";
                responseText += " <td>" + item.departureTime.ToString("yyyy-MM-dd hh:mm") + "</td> ";
                responseText += " <td>" + carUseWay.Where(c => c.Id == item.rentCarID).FirstOrDefault().Name + "</td> ";
                responseText += " <td>" + item.useHour + "</td> ";
                responseText += " <td>未付金额</td> ";
                responseText += " <td> " + item.OrderStatus + "</td> ";
                responseText += " <td>操作</td>        ";
                responseText += " </tr>                       ";
            }
            context.Response.Write(responseText);
        }
        public void GetDataByTime(HttpContext context)
        {
            int userId = Convert.ToInt32(context.Request["userId"]);
            int currentPage = Convert.ToInt32(context.Request["currentPage"]);
            int pageRowCount = 5;
            int orderStatusID = Convert.ToInt32(context.Request["orderStatusID"]);
            DateTime startTime = Convert.ToDateTime(context.Request["startTime"]).Date;
            DateTime overTime = Convert.ToDateTime(context.Request["overTime"]).Date;
            var result = BLL.OrderBLL.GetList(userId);
            var result2 = result.Where(s => s.OrderStatus == (OrderStatus)Enum.Parse(typeof(OrderStatus), orderStatusID.ToString()) && s.orderDate >= startTime && s.orderDate <= overTime).Skip((currentPage - 1) * pageRowCount).Take(pageRowCount);
            int count = result.Where(s => s.OrderStatus == (OrderStatus)Enum.Parse(typeof(OrderStatus), orderStatusID.ToString()) && s.orderDate >= startTime && s.orderDate <= overTime).ToList().Count;
            if (orderStatusID == 0)
            {
                result2 = result.Where(s => s.orderDate >= startTime && s.orderDate <= overTime).Skip((currentPage - 1) * pageRowCount).Take(pageRowCount);
                count = result.Where(s => s.orderDate >= startTime && s.orderDate <= overTime).ToList().Count;
            }
            string responseText = "";
            var carUseWay = BLL.CarUseWayBLL.getList();
            //var orderStatus = BLL.orderStatus.GetList();
            foreach (var item in result2)
            {
                //var ResultOrderStatus = orderStatus.Where(s => s.id == item.orderStatusID).FirstOrDefault().orderstatus;
                //if (ResultOrderStatus == null)
                //{
                //    ResultOrderStatus = "";
                //}
                responseText += " <tr>";
                responseText += " <td>" + item.id + "</td>";
                responseText += " <td>" + item.passengerName + "</td>";
                responseText += " <td>" + item.orderDate.ToString("yyyy-MM-dd hh:mm") + "</td> ";
                responseText += " <td>" + item.departureTime.ToString("yyyy-MM-dd hh:mm") + "</td> ";
                responseText += " <td>" + carUseWay.Where(c => c.Id == item.rentCarID).FirstOrDefault().Name + "</td> ";
                responseText += " <td>" + item.useHour + "</td> ";
                responseText += " <td>未付金额</td> ";
                responseText += " <td>" + item.OrderStatus + "</td> ";
                responseText += " <td>操作</td>";
                responseText += " </tr>                       ";
            }

            int pageCount = count / 5;
            context.Response.Write(responseText + "|" + count + "|" + pageCount);
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