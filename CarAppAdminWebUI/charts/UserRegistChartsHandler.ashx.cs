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
    /// UserRegistChartsHandler 的摘要说明
    /// </summary>
    public class UserRegistChartsHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new OrderBLL();
            var starttime = context.Request["starttime"] ?? "";
            var endtime = context.Request["endtime"] ?? "";
            if (context.Request["type"] == "monthregist")
            {
                var data = bll.GetUserRegistChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));
                var man = from d in data.AsEnumerable()
                          select int.Parse(d["man"].ToString());
                var woman = from d in data.AsEnumerable()
                            select int.Parse(d["woman"].ToString());
                var monthname = from d in data.AsEnumerable()
                                select d["yearname"].ToString() + "-" + d["monthname"].ToString();
                var totalnum = from d in data.AsEnumerable()
                               select (int.Parse(d["man"].ToString()) + int.Parse(d["woman"].ToString()));
                var manpercent = data.AsEnumerable().Sum(p => int.Parse(p["man"].ToString()));
                var womenpercent = data.AsEnumerable().Sum(p => int.Parse(p["woman"].ToString()));
                var sexlist = new List<object>();
                sexlist.Add(new { name = "男", value = manpercent });
                sexlist.Add(new { name = "女", value = womenpercent });
                context.Response.Write(JsonConvert.SerializeObject(new { women = woman.ToArray(), man = man.ToArray(), monthname = monthname.ToArray(), totalnum = totalnum, sexpercent = sexlist }));
            }
            else if (context.Request["type"] == "dailyregist")
            {
                var data = bll.GetUserDailyRegistChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));
                var man = from d in data.AsEnumerable()
                          select int.Parse(d["man"].ToString());
                var woman = from d in data.AsEnumerable()
                            select int.Parse(d["woman"].ToString());
                var monthname = from d in data.AsEnumerable()
                                select d["dayname"].ToString();
                var totalnum = from d in data.AsEnumerable()
                               select (int.Parse(d["man"].ToString()) + int.Parse(d["woman"].ToString()));
                var manpercent = data.AsEnumerable().Sum(p => int.Parse(p["man"].ToString()));
                var womenpercent = data.AsEnumerable().Sum(p => int.Parse(p["woman"].ToString()));
                var sexlist = new List<object>();
                sexlist.Add(new { name = "男", value = manpercent });
                sexlist.Add(new { name = "女", value = womenpercent });
                context.Response.Write(JsonConvert.SerializeObject(new { women = woman.ToArray(), man = man.ToArray(), monthname = monthname.ToArray(), totalnum = totalnum, sexpercent = sexlist }));
            }
            else if (context.Request["type"] == "weeklyregist")
            {
                var data = bll.GetUserWeeklyRegistChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));
                if (data.Rows.Count > 0)
                {
                    var dt = new DateTime();
                    if (DateTime.TryParse(data.Rows[data.Rows.Count - 1]["enddate"].ToString(), out dt))
                    {
                        if (dt > DateTime.Now)
                        {
                            data.Rows[data.Rows.Count - 1]["enddate"] = DateTime.Now.ToString("yyyy-MM-dd");
                        }
                    }
                }
                var man = from d in data.AsEnumerable()
                          select int.Parse(d["man"].ToString());
                var woman = from d in data.AsEnumerable()
                            select int.Parse(d["woman"].ToString());
                var monthname = from d in data.AsEnumerable()
                                select d["startdate"].ToString() + "到" + d["enddate"].ToString();

                var totalnum = from d in data.AsEnumerable()
                               select (int.Parse(d["man"].ToString()) + int.Parse(d["woman"].ToString()));
                var manpercent = data.AsEnumerable().Sum(p => int.Parse(p["man"].ToString()));
                var womenpercent = data.AsEnumerable().Sum(p => int.Parse(p["woman"].ToString()));
                var sexlist = new List<object>();
                sexlist.Add(new { name = "男", value = manpercent });
                sexlist.Add(new { name = "女", value = womenpercent });
                context.Response.Write(JsonConvert.SerializeObject(new { women = woman.ToArray(), man = man.ToArray(), monthname = monthname.ToArray(), totalnum = totalnum, sexpercent = sexlist }));
            }
            else if (context.Request["type"] == "yearlyregist")
            {
                var data = bll.GetUserYearlyRegistChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));
                var man = from d in data.AsEnumerable()
                          select int.Parse(d["man"].ToString());
                var woman = from d in data.AsEnumerable()
                            select int.Parse(d["woman"].ToString());
                var monthname = from d in data.AsEnumerable()
                                select d["dayname"].ToString();
                var totalnum = from d in data.AsEnumerable()
                               select (int.Parse(d["man"].ToString()) + int.Parse(d["woman"].ToString()));
                var manpercent = data.AsEnumerable().Sum(p => int.Parse(p["man"].ToString()));
                var womenpercent = data.AsEnumerable().Sum(p => int.Parse(p["woman"].ToString()));
                var sexlist = new List<object>();
                sexlist.Add(new { name = "男", value = manpercent });
                sexlist.Add(new { name = "女", value = womenpercent });
                context.Response.Write(JsonConvert.SerializeObject(new { women = woman.ToArray(), man = man.ToArray(), monthname = monthname.ToArray(), totalnum = totalnum, sexpercent = sexlist }));
            }
            else if (context.Request["type"] == "weixindaily")
            {
                var data = bll.GetWeixinDailyChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));

                var monthname = from d in data.AsEnumerable()
                                select d["dayname"].ToString();
                var tenyuan = from d in data.AsEnumerable()
                              select int.Parse(d["tenyuan"].ToString());

                var fiveyuan = from d in data.AsEnumerable()
                               select int.Parse(d["fiveyuan"].ToString());

                var twoyuan = from d in data.AsEnumerable()
                              select int.Parse(d["twoyuan"].ToString());
                var fifthyuan = from d in data.AsEnumerable()
                                select int.Parse(d["fifthyuan"].ToString());
                var oneyuan = from d in data.AsEnumerable()
                              select int.Parse(d["oneyuan"].ToString());

                var zerofiveyuan = from d in data.AsEnumerable()
                                   select int.Parse(d["zerofiveyuan"].ToString());
                var totalmoney = (from d in data.AsEnumerable()
                                  select
                                      (int.Parse(d["tenyuan"].ToString()) * 10) +
                                      (int.Parse(d["fiveyuan"].ToString()) * 5) +
                                      (int.Parse(d["twoyuan"].ToString()) * 2) +
                                      (int.Parse(d["fifthyuan"].ToString()) * 1.5) +
                                      (int.Parse(d["oneyuan"].ToString()) * 1) +
                                      int.Parse(d["zerofiveyuan"].ToString()) * 0.5).ToList();
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    tenyuan,
                    fiveyuan,
                    monthname,
                    twoyuan,
                    fifthyuan,
                    oneyuan,
                    zerofiveyuan,
                    totalmoney
                }));
            }
            else if (context.Request["type"] == "weixinmonthly")
            {
                var data = bll.GetWeixinMonthlyChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));

                var monthname = from d in data.AsEnumerable()
                                select d["yearname"].ToString() + "-" + d["monthname"].ToString();
                var tenyuan = from d in data.AsEnumerable()
                              select int.Parse(d["tenyuan"].ToString());

                var fiveyuan = from d in data.AsEnumerable()
                               select int.Parse(d["fiveyuan"].ToString());

                var twoyuan = from d in data.AsEnumerable()
                              select int.Parse(d["twoyuan"].ToString());
                var fifthyuan = from d in data.AsEnumerable()
                                select int.Parse(d["fifthyuan"].ToString());
                var oneyuan = from d in data.AsEnumerable()
                              select int.Parse(d["oneyuan"].ToString());

                var zerofiveyuan = from d in data.AsEnumerable()
                                   select int.Parse(d["zerofiveyuan"].ToString());
                var totalmoney = (from d in data.AsEnumerable()
                                  select
                                      (int.Parse(d["tenyuan"].ToString()) * 10) +
                                      (int.Parse(d["fiveyuan"].ToString()) * 5) +
                                      (int.Parse(d["twoyuan"].ToString()) * 2) +
                                      (int.Parse(d["fifthyuan"].ToString()) * 1.5) +
                                      (int.Parse(d["oneyuan"].ToString()) * 1) +
                                      int.Parse(d["zerofiveyuan"].ToString()) * 0.5).ToList();
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    tenyuan,
                    fiveyuan,
                    monthname,
                    twoyuan,
                    fifthyuan,
                    oneyuan,
                    zerofiveyuan,
                    totalmoney
                }));
            }
            else if (context.Request["type"] == "weixinweekly")
            {
                var data = bll.GetWeixinWeeklyChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));

                if (data.Rows.Count > 0)
                {
                    var dt = new DateTime();
                    if (DateTime.TryParse(data.Rows[data.Rows.Count - 1]["enddate"].ToString(), out dt))
                    {
                        if (dt > DateTime.Now)
                        {
                            data.Rows[data.Rows.Count - 1]["enddate"] = DateTime.Now.ToString("yyyy-MM-dd");
                        }
                    }
                }
                var monthname = from d in data.AsEnumerable()
                                select d["startdate"].ToString() + "到" + d["enddate"].ToString();
                var tenyuan = from d in data.AsEnumerable()
                              select int.Parse(d["tenyuan"].ToString());

                var fiveyuan = from d in data.AsEnumerable()
                               select int.Parse(d["fiveyuan"].ToString());

                var twoyuan = from d in data.AsEnumerable()
                              select int.Parse(d["twoyuan"].ToString());
                var fifthyuan = from d in data.AsEnumerable()
                                select int.Parse(d["fifthyuan"].ToString());
                var oneyuan = from d in data.AsEnumerable()
                              select int.Parse(d["oneyuan"].ToString());

                var zerofiveyuan = from d in data.AsEnumerable()
                                   select int.Parse(d["zerofiveyuan"].ToString());
                var totalmoney = (from d in data.AsEnumerable()
                                  select
                                      (int.Parse(d["tenyuan"].ToString()) * 10) +
                                      (int.Parse(d["fiveyuan"].ToString()) * 5) +
                                      (int.Parse(d["twoyuan"].ToString()) * 2) +
                                      (int.Parse(d["fifthyuan"].ToString()) * 1.5) +
                                      (int.Parse(d["oneyuan"].ToString()) * 1) +
                                      int.Parse(d["zerofiveyuan"].ToString()) * 0.5).ToList();
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    tenyuan,
                    fiveyuan,
                    monthname,
                    twoyuan,
                    fifthyuan,
                    oneyuan,
                    zerofiveyuan,
                    totalmoney
                }));
            }
            else if (context.Request["type"] == "weixinyearly")
            {
                var data = bll.GetWeixinYearlyChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));


                var monthname = from d in data.AsEnumerable()
                                select d["yearname"].ToString();
                var tenyuan = from d in data.AsEnumerable()
                              select int.Parse(d["tenyuan"].ToString());

                var fiveyuan = from d in data.AsEnumerable()
                               select int.Parse(d["fiveyuan"].ToString());

                var twoyuan = from d in data.AsEnumerable()
                              select int.Parse(d["twoyuan"].ToString());
                var fifthyuan = from d in data.AsEnumerable()
                                select int.Parse(d["fifthyuan"].ToString());
                var oneyuan = from d in data.AsEnumerable()
                              select int.Parse(d["oneyuan"].ToString());

                var zerofiveyuan = from d in data.AsEnumerable()
                                   select int.Parse(d["zerofiveyuan"].ToString());
                var totalmoney = (from d in data.AsEnumerable()
                                  select
                                      (int.Parse(d["tenyuan"].ToString()) * 10) +
                                      (int.Parse(d["fiveyuan"].ToString()) * 5) +
                                      (int.Parse(d["twoyuan"].ToString()) * 2) +
                                      (int.Parse(d["fifthyuan"].ToString()) * 1.5) +
                                      (int.Parse(d["oneyuan"].ToString()) * 1) +
                                      int.Parse(d["zerofiveyuan"].ToString()) * 0.5).ToList();
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    tenyuan,
                    fiveyuan,
                    monthname,
                    twoyuan,
                    fifthyuan,
                    oneyuan,
                    zerofiveyuan,
                    totalmoney
                }));
            }
            else if (context.Request["type"] == "chargeconsumption")
            {
                var type = context.Request["timespan"].ToString().Trim();
                var data = new DataTable();
                if (type == "chargeweekly")
                {
                    data = bll.GetOrderStatisticWeeklyChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime));
                }
                else
                {
                    data = bll.GetOrderStatisticChart(Convert.ToDateTime(starttime), Convert.ToDateTime(endtime), type);
                }


                var monthname = from d in data.AsEnumerable()
                                select d["otime"].ToString();
                var yeepaymobile = from d in data.AsEnumerable()
                                   select decimal.Parse(d["易宝手机支付"].ToString());
                var weixinlottery = from d in data.AsEnumerable()
                                    select decimal.Parse(d["微信分享摇奖活动"].ToString());
                var yeepaypc = from d in data.AsEnumerable()
                               select decimal.Parse(d["易宝PC支付"].ToString());
                var unionpaypc = from d in data.AsEnumerable()
                                 select decimal.Parse(d["银联无卡支付"].ToString());
                var netbank = from d in data.AsEnumerable()
                              select decimal.Parse(d["网银充值"].ToString());
                var weixinrecharge = from d in data.AsEnumerable()
                                     select decimal.Parse(d["微信支付"].ToString());
                var alipayrecharge = from d in data.AsEnumerable()
                                     select decimal.Parse(d["支付宝充值"].ToString());
                var unionpaymobile = from d in data.AsEnumerable()
                                     select decimal.Parse(d["银联手机支付"].ToString());
                var rechargegivemoney = from d in data.AsEnumerable()
                                        select decimal.Parse(d["充值送车费"].ToString());
                var userechargecard = from d in data.AsEnumerable()
                                      select decimal.Parse(d["使用充值卡"].ToString());
                var payorder = from d in data.AsEnumerable()
                               select (decimal.Parse(d["支付订单"].ToString()) + decimal.Parse(d["二次付款"].ToString()));
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    monthname,
                    yeepaymobile,
                    weixinlottery,
                    yeepaypc,
                    unionpaypc,
                    unionpaymobile,
                    netbank,
                    weixinrecharge,
                    alipayrecharge,
                    rechargegivemoney,
                    userechargecard,
                    payorder
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