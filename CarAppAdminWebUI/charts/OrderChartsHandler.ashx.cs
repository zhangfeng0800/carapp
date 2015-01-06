using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.charts
{
    /// <summary>
    /// OrderChartsHandler 的摘要说明
    /// </summary>
    public class OrderChartsHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new OrderBLL();
            var province = context.Request["province"] ?? "";
            var city = context.Request["city"] ?? "";
            var town = context.Request["town"] ?? "";
            var starttime = context.Request["starttime"] ?? "";
            var endtime = context.Request["endtime"] ?? "";
            
            if (context.Request["type"] == "weekly")
            {

                var data = bll.GetWeeklyOrderStatistic(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = from d in data.AsEnumerable()
                               select int.Parse(d["ordercount"].ToString());

                var monthname = from d in data.AsEnumerable()
                                select d["startdate"].ToString() + "到" + d["enddate"].ToString();

                var avgnum = from d in data.AsEnumerable()
                             select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)
                              ;
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()), 2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "monthly")
            {
                var data = bll.GetMonthlyOrderStatistic(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = from d in data.AsEnumerable()
                               select int.Parse(d["ordernum"].ToString());

                var monthname = from d in data.AsEnumerable()
                                select d["yearname"].ToString() + "-" + d["monthname"].ToString();

                var avgnum = from d in data.AsEnumerable()
                             select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)
                              ;
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "daily")
            {
                var data = bll.GetDailyOrderStatistic(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = (from d in data.AsEnumerable()
                                select int.Parse(d["ordernum"].ToString())).ToList();

                var monthname = from d in data.AsEnumerable()
                                select d["dayname"].ToString();

                var avgnum = (from d in data.AsEnumerable()
                              select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)).ToList();
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "yearly")
            {
                var data = bll.GetYearlyOrderStatistic(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = (from d in data.AsEnumerable()
                                select int.Parse(d["ordernum"].ToString())).ToList();

                var monthname = from d in data.AsEnumerable()
                                select d["dayname"].ToString();

                var avgnum = (from d in data.AsEnumerable()
                              select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)).ToList();
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "timespan")
            {
                var data = bll.GetOrderTimespanChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = (from d in data.AsEnumerable()
                                select int.Parse(d["totalorder"].ToString())).ToList();

                var monthname = from d in data.AsEnumerable()
                                select d["timespan"].ToString();

                var avgnum = (from d in data.AsEnumerable()
                              select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)).ToList();
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "origin")
            {
                var data = bll.GetOrderOriginChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = (from d in data.AsEnumerable()
                                select int.Parse(d["ordercount"].ToString())).ToList();

                var monthname = from d in data.AsEnumerable()
                                select d["source"].ToString();

                var avgnum = (from d in data.AsEnumerable()
                              select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)).ToList();
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "useway")
            {
                var data = bll.GetOrderCarUsewayChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = (from d in data.AsEnumerable()
                                select int.Parse(d["ordercount"].ToString())).ToList();

                var monthname = from d in data.AsEnumerable()
                                select d["name"].ToString();

                var avgnum = (from d in data.AsEnumerable()
                              select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)).ToList();
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "cartype")
            {
                var data = bll.GetOrderCarTypeChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = (from d in data.AsEnumerable()
                                select int.Parse(d["ordercount"].ToString())).ToList();

                var monthname = from d in data.AsEnumerable()
                                select d["typename"].ToString();

                var avgnum = (from d in data.AsEnumerable()
                              select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)).ToList();
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "orderweeklychart")
            {
                var data = bll.GetOrderWeeklyChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = (from d in data.AsEnumerable()
                                select int.Parse(d["ordercount"].ToString())).ToList();

                var monthname = from d in data.AsEnumerable()
                                select d["weekday"].ToString();

                var avgnum = (from d in data.AsEnumerable()
                              select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)).ToList();
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
            }
            else if (context.Request["type"] == "genderdata")
            {
                var data = bll.GetOrderSexChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), province, city, town);
                var ordernum = (from d in data.AsEnumerable()
                                select int.Parse(d["totalorder"].ToString())).ToList();

                var monthname = from d in data.AsEnumerable()
                                select d["gender"].ToString();

                var avgnum = (from d in data.AsEnumerable()
                              select Math.Round(Convert.ToDouble(d["avgmoney"].ToString()), 2)).ToList();
                var totalmoney = from d in data.AsEnumerable()
                                 select Math.Round(Convert.ToDouble(d["totalmoney"].ToString()),2);
                context.Response.Write(JsonConvert.SerializeObject(new { ordernum = ordernum.ToArray(), monthname = monthname.ToArray(), avgnum = avgnum.ToArray(), totalmoney = totalmoney.ToArray() }));
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