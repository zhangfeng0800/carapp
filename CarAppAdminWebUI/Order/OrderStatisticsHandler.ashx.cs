using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Order
{
    /// <summary>
    /// OrderStatisticsHandler 的摘要说明
    /// </summary>
    public class OrderStatisticsHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var orderbll = new OrderBLL();
            var data = new DataTable();
            if (context.Request["type"] == "status")
            {
                data = orderbll.GetOrderStatusData(context.Request["startDate"], context.Request["endDate"]);
               
            }else if (context.Request["type"]=="month")
            {
                data = orderbll.GetMonthlyData(context.Request["startDate"], context.Request["endDate"]);
            }else if (context.Request["type"] == "day")
            {
                data = orderbll.GetDailyData(context.Request["startDate"], context.Request["endDate"]);
            }
            else if (context.Request["type"] == "useway")
            {
                data = orderbll.GetCarUseWayData(context.Request["startDate"], context.Request["endDate"]);
            }
            else if (context.Request["type"] == "userorders")
            {
                data = orderbll.GetUserOrders(context.Request["startDate"], context.Request["endDate"]);
            }
            context.Response.Write(JsonConvert.SerializeObject(data));

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