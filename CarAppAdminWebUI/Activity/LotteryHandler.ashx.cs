using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Web;
using IEZU.Log;
using Newtonsoft.Json;
using System.Data;

namespace CarAppAdminWebUI.Activity
{
    /// <summary>
    /// LotteryHandler 的摘要说明
    /// </summary>
    public class LotteryHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    GetList(context);
                    break;
                case "LotteryStatistics":
                    LotteryStatistics(context);
                    break;
                case "LotteryCollect":
                    LotteryCollect(context);
                    break;
                case "LotteryOrders":
                    LotteryOrders(context);
                    break;
                case "GiftCarCharts":
                    context.Response.ContentType = "application/json";
                    GiftCarCharts(context);
                    break;
                case "updatelotterysetting":
                    context.Response.ContentType = "application/json";
                    UpdateOrderLotterySetting(context);
                    break;

            }

        }


        public void UpdateOrderLotterySetting(HttpContext context)
        {
            try
            {
                var starttime = context.Request["starttime"];
                var endtime = context.Request["endtime"];
                var buttontext = context.Request["buttontext"].ToString();
                var money = context.Request["money"].ToString();
                var result = (new BLL.ActivitiesBLL()).UpdateLotterySetting(Convert.ToDateTime(starttime),
                    Convert.ToDateTime(endtime), int.Parse(money), buttontext,int.Parse(context.Request["id"].ToString()));
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = result > 0 ? 1 : 0, msg = "操作失败" }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = exception.Message }));
            }
        }
        private void GiftCarCharts(HttpContext context)
        {
            string dates = context.Request["dates"];
            string datee = context.Request["datee"];
            string type = context.Request["type"];

            var data = BLL.LotteryRecordBll.GetGiftCarData(dates, datee, type);

            switch (type)
            {
                case "dailydata":
                    var num = from d in data.AsEnumerable()
                              select d["num"];
                    var totalMoney = from d in data.AsEnumerable()
                                     select d["totalMoney"];
                    var myDate = from d in data.AsEnumerable()
                                 select d["myDate"].ToString();
                    context.Response.Write(JsonConvert.SerializeObject(new { num = num.ToArray(), totalMoney = totalMoney.ToArray(), myDate = myDate.ToArray() }));
                    break;
                case "weeklydata":
                    num = from d in data.AsEnumerable()
                          select d["num"];
                    totalMoney = from d in data.AsEnumerable()
                                 select d["totalMoney"];
                    myDate = from d in data.AsEnumerable()
                             select d["startdate"].ToString() + "到" + d["enddate"].ToString();
                    context.Response.Write(JsonConvert.SerializeObject(new { num = num.ToArray(), totalMoney = totalMoney.ToArray(), myDate = myDate.ToArray() }));
                    break;
                case "monthlydata":
                    num = from d in data.AsEnumerable()
                          select d["num"];
                    totalMoney = from d in data.AsEnumerable()
                                 select d["totalMoney"];
                    myDate = from d in data.AsEnumerable()
                             select d["yearname"].ToString() + "-" + d["monthname"].ToString();
                    context.Response.Write(JsonConvert.SerializeObject(new { num = num.ToArray(), totalMoney = totalMoney.ToArray(), myDate = myDate.ToArray() }));
                    break;
                case "yearlydata":
                    num = from d in data.AsEnumerable()
                          select d["num"];
                    totalMoney = from d in data.AsEnumerable()
                                 select d["totalMoney"];
                    myDate = from d in data.AsEnumerable()
                             select d["yearname"].ToString();
                    context.Response.Write(JsonConvert.SerializeObject(new { num = num.ToArray(), totalMoney = totalMoney.ToArray(), myDate = myDate.ToArray() }));
                    break;
            }

        }

        private void LotteryOrders(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string telphone = context.Request["telphone"];
            string dates = context.Request["dates"];
            string datee = context.Request["datee"];
            if (datee != "")
                datee += " 23:59:59";

            var list = BLL.LotteryRecordBll.GetLotteryPageList(pageSize, pageIndex, "", telphone, "orders", dates, datee, out count);

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }

        private void LotteryCollect(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string telphone = context.Request["telphone"];
            string dates = context.Request["dates"];
            string datee = context.Request["datee"];
            if (datee != "")
                datee += " 23:59:59";

            var list = BLL.LotteryRecordBll.GetLotteryPageList(pageSize, pageIndex, "", telphone, "wxNewsChildren", dates, datee, out count);

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }

        private void LotteryStatistics(HttpContext context)
        {
            string dates = context.Request["datestart"];
            string datee = context.Request["dateend"];
            var data = BLL.LotteryRecordBll.GetLotteryStatistics(dates, datee);
            context.Response.Write(JsonConvert.SerializeObject(new { rows = data }));
        }

        private void GetList(HttpContext context)
        {
            string compname = context.Request["compname"];
            string telphone = context.Request["telphone"];
            string dates = Common.Tool.GetString(context.Request["dates"]);
            string datee = Common.Tool.GetString(context.Request["datee"]);

            if (datee != "")
                datee += " 23:59:59";


            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string sort = Common.Tool.GetString(context.Request["sort"]);
            string order = Common.Tool.GetString(context.Request["order"]);
            string tableName = Common.Tool.GetString(context.Request["tableName"]);

            if (sort == "")
                sort = "Money";

            var list = BLL.LotteryRecordBll.GetLotteryCollectList(pageSize, pageIndex, compname, telphone, tableName, dates, datee, sort, order, out count);

            if (tableName == "wxNewsChildren")
            {
                var foot = new List<object>() { new {  Money ="金额合计：" + (list.Rows.Count > 0 ? list.Rows[0]["summoney"] + "元" : "0") +" &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;次数总计："+(list.Rows.Count > 0 ? list.Rows[0]["sumNum"]  : "0")+"次", compname = "",
                        telphone = "" } };
                context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list, footer = foot }));
            }
            else
            {
                var foot = new List<object>() { new {  Money ="优惠券合计(每张10元)：" + (list.Rows.Count > 0 ? Convert.ToInt32(list.Rows[0]["sumNum"])*10 + "元" : "0") +" &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;次数总计："+(list.Rows.Count > 0 ? list.Rows[0]["sumNum"]  : "0")+"次", compname = "",
                        telphone = "" } };

                context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list, footer = foot }));
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