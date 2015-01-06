using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Transactions;
using System.Web;
using BLL;
using Common;
using Common.BaiduPush.Enums;
using IEZU.Log;
using Model;
using Model.Ext;
using Model.GPS;
using Newtonsoft.Json;
using Newtonsoft.Json.Schema;
using NPOI.HSSF.Record;
using NPOI.HSSF.Record.Chart;
using NPOI.SS.Formula.Functions;
using OrdersExtInfo = Model.OrdersExtInfo;

namespace CarAppAdminWebUI.Order
{
    /// <summary>
    /// OrderHandler 的摘要说明
    /// </summary>
    public class OrderHandler : IHttpHandler
    {
        private readonly OrderBLL _orderBll = new OrderBLL();
        private readonly CarInfoBLL _carInfoBll = new CarInfoBLL();
        private readonly CityBLL _cityBll = new CityBLL();
        private readonly RentCarBLL _rentCarBll = new RentCarBLL();
        private readonly carTableBLL _carTableBll = new carTableBLL();
        private readonly CarUseWayBLL _carUseWayBll = new CarUseWayBLL();
        private readonly AirportBLL _airportBll = new AirportBLL();
        private readonly UserAccountBLL _userAccountBll = new UserAccountBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
                case "carlist":
                    CarList(context);
                    break;
                case "cartablelist":
                    CarTableList(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "cancelorder":
                    CancelOrder(context); //全额退款
                    break;
                case "cancelorderU":
                    CancelOrderU(context);
                    break;
                case "completeorder":
                    CompleteOrder(context);
                    break;
                case "sentcar":
                    SentCar(context);
                    break;
                case "resentcar":
                    ReSentCar(context);
                    break;
                case "ExpiredList":
                    ExpiredList(context);
                    break;
                case "CashPayOrderList":
                    CashPayOrderList(context);
                    break;
                case "makeorder":
                    MakeOrder(context);
                    break;
                case "kefuorder":
                    GetKefuOrderList(context);
                    break;
                case "driverContact":
                    GetDriverContact(context);
                    break;
                case "getUnAcessOrder":
                    GetUnAcessOrder(context);
                    break;
                case "SendCarList":
                    GetSendCarList(context);
                    break;
                case "currentposition":
                    GetCurrentPosition(context);
                    break;
                case "op":
                    context.Response.ContentType = "application/json";
                    try
                    {
                        var status = context.Request["status"];
                        if (status == "2")
                        {
                            PickOrders(context);
                        }
                        else if (status == "12")
                        {
                            DriverStart(context);
                        }
                        else if (status == "10")
                        {
                            DriverInPlace(context);
                        }
                        else if (status == "11")
                        {
                            StartService(context);
                        }
                        else if (status == "3")
                        {
                            EndService(context);
                        }
                        else if (status == "4")
                        {
                            CalculatorFee(context);
                        }
                        else if (status == "9")
                        {
                            TwicePay(context);
                        }
                    }
                    catch (Exception exception)
                    {
                        LogHelper.WriteException(exception);
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = exception.Message }));
                    }

                    #region
                    //case 2:
                    //    return "【接取订单】";
                    //case 12:
                    //    return "【司机出发】";
                    //case 10:
                    //    return "【司机就位】";
                    //case 11:
                    //    return "【开始服务】";
                    //case 3:
                    //    return "【结束服务】";
                    //case 4:
                    //    return "【计算账单】";
                    //default:
                    //    return "";
                    #endregion
                    break;
                case "subbill":
                    context.Response.ContentType = "application/json";
                    SubmitBill(context);
                    break;
                case "enddata":
                    context.Response.ContentType = "application/json";
                    GetEndServiceData(context);
                    break;
                case "datacount":

                    DataCount(context);
                    break;
                case "cartypecount":
                    OrderTypeCount(context);
                    break;
                case "timespancount":
                    TimeSpanOrderCount(context);
                    break;
                case "weekday":
                    WeekDayOrders(context);
                    break;
                case "orderorigin":
                    OrdersOrigin(context);
                    break;
                case "refound":
                    context.Response.ContentType = "application/json";
                    OrderRefound(context);
                    break;
                case "mapresendcar":
                    context.Response.ContentType = "application/json";
                    MapSesendCar(context);
                    break;
                case "orderalarm":
                    context.Response.ContentType = "application/json";
                    GetOrderAlarm(context);
                    break;
            }
        }

        public void GetOrderAlarm(HttpContext context)
        {
            var notinplacenum = 0;
            try
            {
                var sendcarnum = 0;
                var data = _orderBll.OrderAlarm(out sendcarnum, out notinplacenum);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, sendcarnum = sendcarnum, ontinplacenum = notinplacenum, sendcardata = data.Tables[0], notplacedata = data.Tables[1] }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
            }
        }
        public void MapSesendCar(HttpContext context)
        {
            try
            {
                var data = (new OrderBLL()).GetResendCarOrderInfo(context.Request["orderid"].Trim());
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, data = data }));
            }
            catch (Exception ex)
            {
                LogHelper.WriteException(ex);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = ex.Message }));
            }

        }
        public void OrderRefound(HttpContext context)
        {
            var orderid = context.Request["orderid"];
            var type = context.Request["type"];
            var remark = context.Request["remark"] ?? "";
            var money = context.Request["money"];
            var telphone = context.Request["telphone"];
            var overkm = context.Request["overkm"];
            var result = 0;
            var msg = "";
            try
            {
                _orderBll.GetOrderRefound(orderid, decimal.Parse(money), remark, int.Parse(type), decimal.Parse(overkm), out result, out msg);
                var exten = context.Request.Cookies["exten"];
                var extennum = "";
                if (exten != null)
                {
                    extennum = exten.Value;
                }
                LogHelper.WriteOperation("为订单" + orderid + "退款" + money.ToString() + "元", OperationType.Update, "操作成功", context.User.Identity.Name + "（" + extennum + "）");
                SMS.OrderRefound(orderid, money, telphone);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = result, msg = msg }));
            }
            catch (Exception ex)
            {
                LogHelper.WriteException(ex);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = ex.Message }));
            }

        }
        public void OrdersOrigin(HttpContext context)
        {
            var ordercount = 0;
            var totalmoney = 0.00M;
            var data = _orderBll.GetOrderOriginStatics(context.Request["starttime"] ?? "", context.Request["endtime"] ?? "", out ordercount, out totalmoney);

            var type = context.Request["type"];
            if (type == "province")
            {
                var list = (from d in data.AsEnumerable()
                            group d by new { cityname = d["provincename"].ToString().Trim(), timespan = d["source"].ToString().Trim() }
                                into g
                                select new
                                {
                                    ordercount = g.Sum(p => p.Field<int>("ordercount")),
                                    totalMoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    source = g.Key.timespan,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", ordercount = ordercount, totalMoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else if (type == "city")
            {
                var list = (from d in data.AsEnumerable()
                            group d by
                                new
                                {
                                    cityname = d["provincename"].ToString().Trim() + d["cityname"].ToString().Trim(),
                                    timespan = d["source"].ToString().Trim()
                                }
                                into g
                                select new
                                {
                                    ordercount = g.Sum(p => p.Field<int>("ordercount")),
                                    totalMoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    source = g.Key.timespan,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", ordercount = ordercount, totalMoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else if (type == "town")
            {
                var list = (from d in data.AsEnumerable()
                            group d by
                                new
                                {
                                    cityname =
                                        d["provincename"].ToString().Trim() + d["cityname"].ToString().Trim() +
                                        d["townname"].ToString().Trim(),
                                    timespan = d["source"].ToString().Trim()
                                }
                                into g
                                select new
                                {
                                    ordercount = g.Sum(p => p.Field<int>("ordercount")),
                                    totalMoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    source = g.Key.timespan,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", ordercount = ordercount, totalMoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else
            {
                var list = (from d in data.AsEnumerable()
                            group d by new { timespan = d["source"].ToString().Trim() }
                                into g
                                select new
                                {
                                    ordercount = g.Sum(p => p.Field<int>("ordercount")),
                                    totalMoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    source = g.Key.timespan,
                                    cityname = "全部"
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", ordercount = ordercount, totalMoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
        }
        public void WeekDayOrders(HttpContext context)
        {
            var ordercount = 0;
            var totalmoney = 0.00M;
            var data = _orderBll.GetOrderWeekdayStatic(context.Request["starttime"] ?? "", context.Request["endtime"] ?? "", out ordercount, out totalmoney);

            var type = context.Request["type"];
            if (type == "province")
            {
                var list = (from d in data.AsEnumerable()
                            group d by new { cityname = d["provincename"].ToString().Trim(), timespan = d["weekday"].ToString().Trim() }
                                into g
                                select new
                                {
                                    ordercount = g.Sum(p => p.Field<int>("ordercount")),
                                    totalMoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    timespan = g.Key.timespan,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", ordercount = ordercount, totalMoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else if (type == "city")
            {
                var list = (from d in data.AsEnumerable()
                            group d by
                                new
                                {
                                    cityname = d["provincename"].ToString().Trim() + d["cityname"].ToString().Trim(),
                                    timespan = d["weekday"].ToString().Trim()
                                }
                                into g
                                select new
                                {
                                    ordercount = g.Sum(p => p.Field<int>("ordercount")),
                                    totalMoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    timespan = g.Key.timespan,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", ordercount = ordercount, totalMoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else if (type == "town")
            {
                var list = (from d in data.AsEnumerable()
                            group d by
                                new
                                {
                                    cityname =
                                        d["provincename"].ToString().Trim() + d["cityname"].ToString().Trim() +
                                        d["townname"].ToString().Trim(),
                                    timespan = d["weekday"].ToString().Trim()
                                }
                                into g
                                select new
                                {
                                    ordercount = g.Sum(p => p.Field<int>("ordercount")),
                                    totalMoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    timespan = g.Key.timespan,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", ordercount = ordercount, totalMoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else
            {
                var list = (from d in data.AsEnumerable()
                            group d by new { timespan = d["weekday"].ToString().Trim() }
                                into g
                                select new
                                {
                                    ordercount = g.Sum(p => p.Field<int>("ordercount")),
                                    totalMoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    timespan = g.Key.timespan,
                                    cityname = "全部"
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", ordercount = ordercount, totalMoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
        }
        public void TimeSpanOrderCount(HttpContext context)
        {
            var ordercount = 0;
            var totalmoney = 0.00M;
            var type = context.Request["type"];
            var data = _orderBll.GetOrderStaticTimespan(context.Request["starttime"] ?? "", context.Request["endtime"] ?? "", out ordercount, out totalmoney);
            if (type == "province")
            {
                var list = (from d in data.AsEnumerable()
                            group d by new { cityname = d["provincename"].ToString().Trim(), timespan = d["timespan"].ToString().Trim() }
                                into g
                                select new
                                    {
                                        totalorder = g.Sum(p => p.Field<int>("totalorder")),
                                        totalmoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                        timespan = g.Key.timespan,
                                        cityname = g.Key.cityname
                                    }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", totalorder = ordercount, totalmoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else if (type == "city")
            {
                var list = (from d in data.AsEnumerable()
                            group d by
                                new
                                {
                                    cityname = d["provincename"].ToString().Trim() + d["cityname"].ToString().Trim(),
                                    timespan = d["timespan"].ToString().Trim()
                                }
                                into g
                                select new
                                {
                                    totalorder = g.Sum(p => p.Field<int>("totalorder")),
                                    totalmoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    timespan = g.Key.timespan,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", totalorder = ordercount, totalmoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else if (type == "town")
            {
                var list = (from d in data.AsEnumerable()
                            group d by
                                new
                                {
                                    cityname =
                                        d["provincename"].ToString().Trim() + d["cityname"].ToString().Trim() +
                                        d["townname"].ToString().Trim(),
                                    timespan = d["timespan"].ToString().Trim()
                                }
                                into g
                                select new
                                {
                                    totalorder = g.Sum(p => p.Field<int>("totalorder")),
                                    totalmoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    timespan = g.Key.timespan,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", totalorder = ordercount, totalmoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else
            {
                var list = (from d in data.AsEnumerable()
                            group d by new { timespan = d["timespan"].ToString().Trim() }
                                into g
                                select new
                                {
                                    totalorder = g.Sum(p => p.Field<int>("totalorder")),
                                    totalmoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    timespan = g.Key.timespan,
                                    cityname = "全部"
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { timespan = "统计信息：", totalorder = ordercount, totalmoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }

        }
        public void OrderTypeCount(HttpContext context)
        {
            var type = context.Request["type"];
            var ordercount = 0;
            var totalmoney = 0.00M;
            var data = _orderBll.GetOrderCarTypeData(context.Request["starttime"] ?? "", context.Request["endtime"] ?? "", out ordercount, out totalmoney);
            if (type == "province")
            {
                var list = (from d in data.AsEnumerable()
                            group d by new { cityname = d["provincename"].ToString().Trim(), typename = d["typename"].ToString().Trim() }
                                into g
                                select new
                                {
                                    totalorder = g.Sum(p => p.Field<int>("ordercount")),
                                    totalmoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    typename = g.Key.typename,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { typename = "统计信息：", totalorder = ordercount, totalmoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else if (type == "city")
            {
                var list = (from d in data.AsEnumerable()
                            group d by
                                new
                                {
                                    cityname = d["provincename"].ToString().Trim() + d["cityname"].ToString().Trim(),
                                    typename = d["typename"].ToString().Trim()
                                }
                                into g
                                select new
                                {
                                    totalorder = g.Sum(p => p.Field<int>("ordercount")),
                                    totalmoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    typename = g.Key.typename,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { typename = "统计信息：", totalorder = ordercount, totalmoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else if (type == "town")
            {
                var list = (from d in data.AsEnumerable()
                            group d by
                                new
                                {
                                    cityname =
                                        d["provincename"].ToString().Trim() + d["cityname"].ToString().Trim() +
                                        d["townname"].ToString().Trim(),
                                    typename = d["typename"].ToString().Trim()
                                }
                                into g
                                select new
                                {
                                    totalorder = g.Sum(p => p.Field<int>("ordercount")),
                                    totalmoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    typename = g.Key.typename,
                                    cityname = g.Key.cityname
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { typename = "统计信息：", totalorder = ordercount, totalmoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
            else
            {
                var list = (from d in data.AsEnumerable()
                            group d by new { typename = d["typename"].ToString().Trim() }
                                into g
                                select new
                                {
                                    totalorder = g.Sum(p => p.Field<int>("ordercount")),
                                    totalmoney = g.Sum(p => p.Field<decimal>("totalmoney")),
                                    typename = g.Key.typename,
                                    cityname = "全部"
                                }).ToList();
                var dict = new List<object>();
                dict.Add(new { typename = "统计信息：", totalorder = ordercount, totalmoney = totalmoney });
                context.Response.Write(JsonConvert.SerializeObject(new { rows = list, total = ordercount, footer = dict }));
            }
        }
        public void DataCount(HttpContext context)
        {
            var type = context.Request["type"];
            CityType cityType;
            if (!Enum.TryParse(type, out cityType))
            {
                cityType = CityType.nolimit;
            }
            var count = 0;
            decimal totalmoney = 0.00M;
            var result = _orderBll.OrderStaticList(context.Request["starttime"], context.Request["endtime"], cityType, out count, out totalmoney);
            var dict = new List<object>();
            dict.Add(new { ordercount = count, ordermoney = totalmoney });
            context.Response.Write(JsonConvert.SerializeObject(new { rows = result, total = count, footer = dict }));
        }
        /// <summary>
        /// 司机接单
        /// </summary>
        /// <param name="context"></param>
        public void PickOrders(HttpContext context)
        {
            var orderid = context.Request["orderid"];
            var phone = context.Request["phone"];
            var jobnumber = context.Request["jobnumber"];
            int result = 0;
            var orderbll = new OrderBLL().PickOrder(phone, jobnumber, orderid, out result);
            context.Response.Write(result == 0
                ? JsonConvert.SerializeObject(new { resultcode = 0, msg = "订单接取失败" })
                : JsonConvert.SerializeObject(new { resultcode = 1, msg = "接单成功" }));
        }
        /// <summary>
        /// 司机出发
        /// </summary>
        /// <param name="context"></param>
        public void DriverStart(HttpContext context)
        {
            var orderid = context.Request["orderid"];
            var phone = context.Request["phone"];
            var jobnumber = context.Request["jobnumber"];

            var info = "";
            var result = new OrderBLL().DriverStart(phone, jobnumber, orderid, out info, context.User.Identity.Name, "");
            context.Response.Write(result == 0
                ? JsonConvert.SerializeObject(new { resultcode = 0, msg = info })
                : JsonConvert.SerializeObject(new { resultcode = 1, msg = "司机成功出发" }));
        }

        public void DriverInPlace(HttpContext context)
        {
            var orderid = context.Request["orderid"];
            var phone = context.Request["phone"];
            var jobnumber = context.Request["jobnumber"];

            var info = "";
            var result = new OrderBLL().DriverInPlace(phone, jobnumber, orderid, out info, context.User.Identity.Name, "");
            context.Response.Write(result == 0
                ? JsonConvert.SerializeObject(new { resultcode = 0, msg = info })
                : JsonConvert.SerializeObject(new { resultcode = 1, msg = "司机已经就位" }));
        }

        public void StartService(HttpContext context)
        {
            var orderid = context.Request["orderid"];
            var phone = context.Request["phone"];
            var jobnumber = context.Request["jobnumber"];
            var orderModel = _orderBll.GetModel(orderid);

            var info = "";
            var result = new OrderBLL().StartService(phone, jobnumber, orderid, out info, context.User.Identity.Name, "");
            try
            {
                var rentCarModel = _rentCarBll.GetModel(orderModel.rentCarID);
                var distance = 0.0M;
                GPSOperation.GetStartEmptyDistance(orderid, out distance);
                var orderext = (new BLL.OrdersExtInfo()).GetModel(orderid);
                if (orderext == null)
                {
                    (new BLL.OrdersExtInfo()).Add(new OrdersExtInfo()
                    {
                        airportMoney = 0,
                        carStopMoney = 0,
                        emptyCarMoney = 0,
                        emptydistance = Convert.ToDecimal(distance),
                        highwayMoney = 0,
                        orderID = orderid,
                        overKM = 0,
                        overKMMoney = 0,
                        overMinut = 0,
                        overMinutMoney = 0,
                        startemptydistance = Convert.ToDecimal(distance),
                        startemptyFee = Convert.ToDecimal(Math.Round(distance * rentCarModel.kiloPrice, 1)),
                        endemptydistance = 0,
                        endemptyfee = 0
                    });
                }
                else
                {
                    orderext.startemptydistance = Convert.ToDecimal(distance);
                    orderext.startemptyFee = (Math.Round(distance * rentCarModel.kiloPrice, 1));
                    (new BLL.OrdersExtInfo()).Update(orderext);
                }
            }
            catch (Exception ex)
            {
                LogHelper.WriteException(ex);
            }
            context.Response.Write(result == 0
                ? JsonConvert.SerializeObject(new { resultcode = 0, msg = info })
                : JsonConvert.SerializeObject(new { resultcode = 1, msg = "服务已经开始" }));
        }
        public void EndService(HttpContext context)
        {
            var orderid = context.Request["orderid"];
            var phone = context.Request["phone"];
            var jobnumber = context.Request["jobnumber"];

            var info = "";
            try
            {
                var orderext = (new BLL.OrdersExtInfo()).GetModel(orderid);
                var orderModel = _orderBll.GetModel(orderid);

                var endPosition = "";
                var distance = 0.0M;
                try
                {
                    endPosition = GPSOperation.GetLocation(orderid);
                    if (endPosition.Trim() == "")
                    {
                        endPosition = orderModel.EndPosition;
                    }
                    GPSOperation.GetEndEmptyDistance(orderid, out distance);
                }
                catch (Exception ex)
                {
                    LogHelper.WriteException(ex);
                }

                var rentCarModel = _rentCarBll.GetModel(orderModel.rentCarID);
                if (orderext == null)
                {
                    orderext = new OrdersExtInfo()
                    {
                        airportMoney = 0,
                        carStopMoney = 0,
                        emptyCarMoney = 0,
                        emptydistance = Convert.ToDecimal(distance),
                        highwayMoney = 0,
                        orderID = orderid,
                        overKM = 0,
                        overKMMoney = 0,
                        overMinut = 0,
                        overMinutMoney = 0,
                        startemptydistance = 0,
                        startemptyFee = 0,
                        endemptydistance = distance,
                        endemptyfee = Math.Round(distance * rentCarModel.kiloPrice, 1)
                    };
                    (new BLL.OrdersExtInfo()).Add(orderext);
                }
                else
                {
                    orderext.endemptydistance = Convert.ToDecimal(distance);
                    orderext.endemptyfee = Math.Round(distance * rentCarModel.kiloPrice, 1);
                    (new BLL.OrdersExtInfo()).Update(orderext);
                }
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }
            var result = new OrderBLL().EndService(phone, jobnumber, orderid, out info, context.User.Identity.Name, "");
            var cardistance = GPSOperation.GetCarDistance(orderid);
            var totalDistant = cardistance != null ? (cardistance.error == 0 ? cardistance.alldis : "0") : "0";
            var totalKm = 0.0;
            if (!double.TryParse(totalDistant, out totalKm))
            {
                totalKm = 0;
            }
            context.Response.Write(result == null
                ? JsonConvert.SerializeObject(new { resultcode = 0, msg = info })
                : JsonConvert.SerializeObject(new { resultcode = 1, data = result, totalDistant = Math.Round(totalKm, 2) }));
        }

        public void CalculatorFee(HttpContext context)
        {
            string orderId = context.Request["orderid"];
            string km = context.Request["km"];
            string highWayStr = context.Request["highWayStr"];
            string partStr = context.Request["partStr"];
            string portStr = context.Request["portStr"];
            string emptyFee = context.Request["emptyFee"];
            string endEmptyfee = context.Request["endemptyfee"];
            var distance = 0.00M;
            try
            {
                var carDistance = GPSOperation.GetCarDistance(orderId);
                if (carDistance == null)
                {
                    distance = 0;
                }
                else
                {
                    distance = Convert.ToDecimal(Math.Round(double.Parse(carDistance.alldis), 2));
                }
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                distance = 0;
            }
            try
            {
                var orderbll = new OrderBLL();
                var data = Common.DataTableToList.List<Model.CaculateResult>(orderbll.CalculateFee(orderId, decimal.Parse(km), decimal.Parse(highWayStr),
                    decimal.Parse(partStr),
                    decimal.Parse(portStr), decimal.Parse(emptyFee), distance, decimal.Parse(endEmptyfee)));
                context.Response.Write(JsonConvert.SerializeObject(data.FirstOrDefault()));
            }
            catch (Exception exception)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败, msg = "服务器错误" }));
                LogHelper.WriteException(exception);
            }
        }

        public void GetEndServiceData(HttpContext context)
        {
            var orderId = context.Request["orderid"];
            var list = (new DirverAccountBLL()).GetEndServiceDate(context.Request["orderid"]);
            var cardistance = GPSOperation.GetCarDistance(orderId);
            if (cardistance != null)
            {
                list.TotalDistant = cardistance.error == 0 ? cardistance.alldis : "0";
            }
            else
            {
                list.TotalDistant = "0";
            }
            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, data = list }));
        }

        public void TwicePay(HttpContext context)
        {
            var orderid = context.Request["orderid"];
            var phone = context.Request["phone"];
            var jobnumber = context.Request["jobnumber"];
            var result = 0;
            var isneed = 0;
            var isenough = 0;
            string info = "";
            var retmsg = "";
            result = _orderBll.TwicePay(phone, jobnumber, orderid, out info, out isneed, out isenough, out retmsg,
                context.User.Identity.Name, "");
            context.Response.Write(JsonConvert.SerializeObject(new
            {
                resultcode = result,
                isneed = isneed,
                isenough = isenough,
                msg = retmsg
            }));
        }
        public void SubmitBill(HttpContext context)
        {
            var orderid = context.Request["orderid"];
            var phone = context.Request["phone"];
            var jobnumber = context.Request["jobnumber"];
            var result = 0;
            var isneed = 0;
            var isenough = 0;
            string info = "";
            result = _orderBll.SubmitBill(phone, jobnumber, orderid, out info, out isneed, out isenough,
                context.User.Identity.Name, "");
            context.Response.Write(JsonConvert.SerializeObject(new
            {
                resultcode = result,
                isneed = isneed,
                isenough = isenough
            }));
        }
        public void GetCurrentPosition(HttpContext context)
        {
            if (string.IsNullOrEmpty(context.Request["vid"]))
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "数据获取失败" }));
            }
            try
            {
                var data = GPSOperation.GetCarPosition(context.Request.QueryString["vid"].Trim());
                context.Response.Write(data != null
                    ? JsonConvert.SerializeObject(new { resultcode = 1, data = data })
                    : JsonConvert.SerializeObject(new { resultcode = 0, msg = "数据获取失败" }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "数据获取失败" }));
            }


        }
        private void GetUnAcessOrder(HttpContext context)
        {
            int count = _orderBll.GetCount("orderStatusID=2");
            context.Response.Write(count);
        }

        private void GetDriverContact(HttpContext context)
        {
            string orderId = context.Request["value"];
            var orderModel = _orderBll.GetModel(orderId);
            var carModel = new Model.CarInfo();
            var driverModel = new Model.DriverAccount();
            if (!string.IsNullOrEmpty(orderModel.carId))
            {
                carModel = new BLL.CarInfoBLL().GetModel(orderModel.carId);
            }
            if (!string.IsNullOrEmpty(orderModel.JobNumber))
            {
                driverModel = new BLL.DirverAccountBLL().GetModel(orderModel.JobNumber);
            }
            else if (carModel != null && carModel.DriverID != 0)
            {
                driverModel = new BLL.DirverAccountBLL().GetModel(carModel.DriverID);
            }

            var model = new
                            {
                                driverName = driverModel.Name ?? "暂无",
                                driverPhone = driverModel.DriverPhone ?? "暂无",
                                carPhone = carModel.telPhone ?? "暂无"
                            };

            context.Response.Write(JsonConvert.SerializeObject(model));

        }

        private void CancelOrderU(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            Orders orderModel = _orderBll.GetModel(id);
            try
            {
                var carno = "";
                var cartelphone = "";
                var caruseid = "";
                var carchannelid = "";
                string usertelphone = "";
                decimal refound = 0.00M;
                int statusid = 0;
                var carusewayid = 0;
                var result = 0;
                var openid = "";
                new OrderBLL().CancelOrder(HttpContext.Current.User.Identity.Name, orderModel.userID, orderModel.orderId, "", 2, out carno, out cartelphone, out caruseid, out carchannelid, out usertelphone, out refound, out statusid, out carusewayid, out result, out openid);
                if (result == 1)
                {
                    message.IsSuccess = true;
                    if (cartelphone != "")
                    {
                        Common.SMS.driver_OrderCancel(carno, id, cartelphone);
                    }
                    if (caruseid != "7")
                    {
                        switch (statusid)
                        {
                            case 1:
                                Common.SMS.NoPayOrderCancel(usertelphone);
                                break;
                            case 12:
                            case 2:
                            case 8:
                                Common.SMS.user_OrderCancelNoPay(usertelphone);
                                break;
                            default:
                                Common.SMS.user_OrderCancelAndPay(usertelphone);
                                break;
                        }
                    }
                    else
                    {
                        switch (statusid)
                        {
                            case 1:
                                Common.SMS.NoPayOrderCancel(usertelphone);
                                break;
                            case 8:
                                Common.SMS.user_OrderCancelNoPay(usertelphone);
                                break;
                            default:
                                Common.SMS.user_OrderCancelAndPay(usertelphone);
                                break;
                        }
                    }

                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "取消失败";
                }
            }
            catch (Exception exception)
            {
                message.IsSuccess = false;
                message.Message = exception.Message;
                LogHelper.WriteException(exception);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }


        private void GetKefuOrderList(HttpContext context)
        {
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            int rowcount = 0;
            var callcenterList = new CallCenterOrderBLL();
            var username = context.User.Identity.Name;
            var model = ((new AdminBll()).GetModel(username));
            var condtion = " 1=1  ";
            if (model.AdminGroupsId != 1)
            {
                condtion += " and username='" + username + "'";
            }
            if (!string.IsNullOrEmpty(context.Request["username"]))
            {
                condtion += " and  username='" + context.Request["username"] + "'";
            }
            if (!string.IsNullOrEmpty(context.Request["exten"]))
            {
                condtion += " and  exten='" + context.Request["exten"] + "'";
            }


            var list = callcenterList.GetPager(pageSize, pageIndex, condtion, out rowcount);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = rowcount, rows = list }));
        }
        private void MakeOrder(HttpContext context)
        {
            var orderModel = new Model.Orders();
            var orderbll = new OrderBLL();

            if (context.Request["usewayid"] != null)
            {
                var starttime = context.Request["starttime"];
                DateTime dateTime;

                if (context.Request["usewayid"].ToString() != "7")
                {
                    if (!DateTime.TryParse(starttime, out dateTime))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "时间格式错误" }));
                        return;
                    }
                    if (dateTime <= DateTime.Now)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "请选择正确的时间" }));
                        return;
                    }
                }

                var reg = new Regex(@"^1\d{10}$");
                if (!reg.IsMatch(context.Request["usertelphone"]))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "乘客手机号码格式错误" }));
                    return;
                }
                var userway = context.Request["usewayid"];
                if (context.Request["usertelphone"] != null)
                {
                    var userModel = (new UserAccountBLL()).GetModel(context.Request["usertelphone"]);
                    if (userModel == null)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                        return;
                    }
                    else
                    {
                        orderModel.userID = userModel.Id;
                        var telphone = context.Request["telphone"];
                        var contactbll = new BLL.ContactPerson();
                        var contactPerson = contactbll.GetOneByPhone(telphone, userModel.Id);
                        if (contactPerson.Count == 0)
                        {
                            contactbll.Add(new Model.ContactPerson() { UserId = userModel.Id, ContactName = context.Request["passenername"], TelePhone = telphone });
                        }
                    }
                }

                orderModel.passengerName = context.Request["passenername"];
                orderModel.passengerNum = int.Parse(context.Request["passengernum"]);
                orderModel.passengerPhone = context.Request["telphone"];

                if (context.Request["usewayid"] == "7")
                {
                    orderModel.departureTime = DateTime.Now;
                    orderModel.pickupTime = DateTime.Now;
                    orderModel.realStartTime = DateTime.Now;
                }
                else
                {
                    orderModel.departureTime = Convert.ToDateTime(context.Request["starttime"]);
                }

                orderModel.remarks = context.Request["others"];
                orderModel.rentCarID = int.Parse(context.Request["rentcarid"].ToString());
                orderModel.extraFee = 0;
                orderModel.JobNumber = "";
                orderModel.SMSReceiver = 1;
                orderModel.TicketNum = 0;
                orderModel.UseKm = 0;
                orderModel.UseTime = int.Parse(string.IsNullOrEmpty(context.Request["useHour"].ToString()) ? "0" : context.Request["useHour"]);
                orderModel.YeePayID = "";
                orderModel.YeePayID2 = "";
                orderModel.carId = "";
                orderModel.deserveOrderMoney = 0;
                orderModel.finishTime = "";
                orderModel.flightDate = "";
                orderModel.flightNo = "";
                orderModel.orderMessage = "";
                orderModel.orderStatusID = 1;
                orderModel.paystatus = PayStatus.unPaid;
                orderModel.invoiceID = 0;
                orderModel.invoiceStatus = 0;
                orderModel.isreceipts = 0;
                orderModel.startAddress = "";
                orderModel.startAddressDetail = "";
                orderModel.unpaidMoney = 0;
                orderModel.OrderOrigin = "电话订车";
                orderModel.useHour = int.Parse(context.Request["useHour"].ToString());
                orderModel.departureCityID = context.Request["startcityid"].ToString();
                orderModel.SMSReceiver = bool.Parse(context.Request["ismsg"].ToString()) == true ? 1 : 0;
                DateTime orderdate;
                orderModel.orderId = orderbll.GetOrderId(out orderdate);
                orderModel.orderDate = orderdate;
                orderModel.targetCityID = context.Request["targetcityid"];
                var rentModel = (new RentCarBLL()).GetModel(int.Parse(context.Request["rentcarid"]));
                if (rentModel == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                orderModel.totalMoney = rentModel.DiscountPrice;
                orderModel.orderMoney = rentModel.DiscountPrice;

                if (context.Request["usewayid"] == "1")
                {
                    orderModel.EndPosition = context.Request["endpoint"];
                    orderModel.OrderStatus = OrderStatus.等待确认;
                    orderModel.airportID = int.Parse(context.Request["airportid"]);
                    orderModel.startAddress = context.Request["airportname"] ?? "";
                    orderModel.startAddressDetail = context.Request["airportname"] ?? "";
                    orderModel.arriveAddress = context.Request["endplace"] + "，" + context.Request["endplacedetail"];
                    Model.AirPort airport = new BLL.AirportBLL().GetModel(orderModel.airportID);
                    orderModel.mapPoint = airport != null ? airport.Lng + "," + airport.Lat : "";
                }
                else if (context.Request["usewayid"] == "2")
                {
                    orderModel.mapPoint = context.Request["startpoint"];
                    orderModel.airportID = int.Parse(context.Request["airportid"]);
                    orderModel.arriveAddress = "";
                    orderModel.startAddress = context.Request["startplace"];
                    orderModel.startAddressDetail = context.Request["startplacedetail"];
                    orderModel.arriveAddress = context.Request["airportname"] ?? "";
                    Model.AirPort airport = new BLL.AirportBLL().GetModel(orderModel.airportID);
                    orderModel.EndPosition = airport != null ? airport.Lng + "," + airport.Lat : "";
                }
                else if (context.Request["usewayid"] == "3" || context.Request["usewayid"] == "4" || context.Request["usewayid"] == "5" || context.Request["usewayid"] == "7")
                {
                    orderModel.mapPoint = context.Request["startpoint"];
                    orderModel.arriveAddress = context.Request["endplace"] + "，" + context.Request["endplacedetail"];
                    orderModel.startAddress = context.Request["startplace"];
                    orderModel.startAddressDetail = context.Request["startplacedetail"];
                    orderModel.EndPosition = context.Request["endpoint"];
                }
                else if (context.Request["usewayid"] == "6")
                {
                    orderModel.mapPoint = context.Request["startpoint"];
                    orderModel.arriveAddress = context.Request["endplace"] + "，" + context.Request["endplacedetail"];
                    orderModel.startAddress = context.Request["startplace"];
                    orderModel.startAddressDetail = context.Request["startplacedetail"];
                    orderModel.EndPosition = context.Request["endpoint"];
                    orderModel.targetCityID = rentModel.hotLineID.ToString(CultureInfo.InvariantCulture);
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "下单失败" }));
                    return;
                }
                if (context.Request["ordernum"] != "1")
                {
                    MutilOrderBLL bll = new MutilOrderBLL();
                    var orderid = "";
                    int flagresult = 0;
                    var result = bll.InsertMultiOrders(int.Parse(context.Request["ordernum"]), orderModel, out orderid, out flagresult);

                    context.Response.Write(JsonConvert.SerializeObject(flagresult == 1 ? new { resultcode = 1, ordernum = context.Request["ordernum"].ToString(), rentcarid = orderModel.rentCarID, orderid = orderid, querystring = context.Request["querystring"].ToString() } : new { resultcode = 0, ordernum = "", rentcarid = 0, orderid = "", querystring = "" }));
                }
                else
                {
                    try
                    {
                        var bll = new OrderTimesBLL();
                        bll.InsertData(new OrderTimes() { OrderId = orderModel.orderId, OrderDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), UserOrderedtime = orderModel.departureTime.ToString("yyyy-MM-dd HH:mm:ss") });
                    }
                    catch (Exception exception)
                    {
                        LogHelper.WriteException(exception);
                    }
                    context.Response.Write(JsonConvert.SerializeObject(!string.IsNullOrEmpty(orderbll.InsertData(orderModel)) ? new { resultcode = 1, rentcarid = orderModel.rentCarID, orderid = orderModel.orderId, querystring = context.Request["querystring"].ToString() } : new { resultcode = 0, rentcarid = 0, orderid = "", querystring = "" }));
                }


                return;
            }
            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "参数错误" }));
        }

        private void SentCar(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            string carid = context.Request["carid"];
            var msg = "";
            var result = 0;
            if (string.IsNullOrEmpty(id) || string.IsNullOrEmpty(carid))
            {
                message.IsSuccess = false;
                message.Message = "参数信息无效";
            }
            else
            {
                var username = context.User.Identity.Name;
                var exten = context.Request.Cookies["exten"];
                var extenid = "";
                if (exten != null)
                {
                    extenid = exten.Value.ToString();
                }
                _carInfoBll.SendCar(id, int.Parse(carid.ToString()), username, extenid, out msg, out result);
                message.IsSuccess = result != 0;
                message.Message = msg;
            }

            var lng = "";
            var lat = "";
            try
            {
                var positions = GPSOperation.GetCarPosition(GPSOperation.GetGpsVid(id).Info.vid);
                if (positions.error == 0)
                {
                    var carPosition =
                        JsonConvert.DeserializeObject<List<CarPositionInfo>>(positions.calist.ToString()).First();
                    lng = carPosition.lng;
                    lat = carPosition.lat;
                }
                _orderBll.UpdateOrderPlaceInfo(id, lng, lat, "sendcar");
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void ReSentCar(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            string carid = context.Request["carid"];
            var msg = "";
            var result = 0;
            if (string.IsNullOrEmpty(id) || string.IsNullOrEmpty(carid))
            {
                message.IsSuccess = false;
                message.Message = "参数信息无效";
            }
            else
            {
                var username = context.User.Identity.Name;
                var exten = context.Request.Cookies["exten"];
                var extenid = "";
                if (exten != null)
                {
                    extenid = exten.Value.ToString();
                }
                _carInfoBll.ReSendCarPro(id, int.Parse(carid.ToString()), username, extenid, out msg, out result);
                message.IsSuccess = result != 0;
                message.Message = msg;
            }
            var lng = "";
            var lat = "";
            try
            {
                var positions = GPSOperation.GetCarPosition(GPSOperation.GetGpsVid(id).Info.vid);
                if (positions.error == 0)
                {
                    var carPosition =
                        JsonConvert.DeserializeObject<List<CarPositionInfo>>(positions.calist.ToString()).First();
                    lng = carPosition.lng;
                    lat = carPosition.lat;
                }
                _orderBll.UpdateOrderPlaceInfo(id, lng, lat, "sendcar");
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void CancelOrder(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            var hasextinfo = 0;
            var hascancel = 0;
            var hasinvoice = 0;
            var hasremark = 0;
            var hascoupon = 0;
            var data = (new OrderBLL()).GetDriverOrdetail(id, out hascancel, out hasextinfo, out hasinvoice, out hascoupon, out hasremark);
            try
            {
                int result = 0;
                _orderBll.CancelOrder(HttpContext.Current.User.Identity.Name, id, out result);

                if (result == 1)
                {
                    message.IsSuccess = true;
                    message.Message = "";
                    Common.SMS.user_OrderCancelNoPay(data.Rows[0]["telphone"].ToString());
                    if (data.Rows[0]["cartelphone"].ToString() != "")
                    {
                        Common.SMS.driver_OrderCancel(data.Rows[0]["carInfono"].ToString(), id,
                            data.Rows[0]["cartelphone"].ToString());
                    }
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "订单取消失败";
                }

            }
            catch (Exception exception)
            {
                message.IsSuccess = false;
                message.Message = exception.Message;
                LogHelper.WriteException(exception);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        public void Complete(string id)
        {
            var message = new AjaxResultMessage();
            Orders orderModel = _orderBll.GetModel(id);

            orderModel.paystatus = PayStatus.CashPaid;
            _orderBll.upDateAllByModule(orderModel);
            LogHelper.WriteOperation("更新订单编号[" + id + "]订单状态由[现金支付给司机]为[订单完成]", OperationType.Update, "更新成功", HttpContext.Current.User.Identity.Name);
        }

        private void CompleteOrder(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                string id = context.Request["id"];
                if (id == "" || id.IndexOf(',') < 0)
                {
                    message.IsSuccess = false;
                    message.Message = "数据错误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                id = id.Substring(0, id.Length - 1);
                if (id.IndexOf(',') > -1)
                {
                    var orderids = id.Split(',');
                    foreach (var orderid in orderids)
                    {
                        Complete(orderid); //todo:  循环访问数据库
                    }
                }
                else
                {
                    Complete(id);
                }
                message.IsSuccess = true;
            }
            catch (Exception exception)
            {
                message.IsSuccess = false;
                message.Message = "数据错误";
                LogHelper.WriteException(exception);
            }

            context.Response.Write(JsonConvert.SerializeObject(new AjaxResultMessage() { IsSuccess = true, Message = "" }));
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            string startAddress = context.Request["startAddress"];
            string startAddressDetail = context.Request["placedetail"];
            string mapPoint = context.Request["startpoint"];
            string arriveAddress = context.Request["arriveAddress"];
            string arriveAddressDetail = context.Request["enddetail"];
            string endPoint = context.Request["endpoint"];
            string departureTimeString = context.Request["departureTime"];
            string passengerName = context.Request["passengerName"];
            string passengerPhone = context.Request["passengerPhone"];
            string orderStatusIDStr = context.Request["orderStatusID"];

            int orderStatusID;
            DateTime dateTime;
            if (departureTimeString == "0001/1/1 0:00:00")
            {
                message.IsSuccess = false;
                message.Message = "请输入一个有效的预约时间";
                context.Response.Write(JsonConvert.SerializeObject(message));
                return;
            }
            bool isSuccess = DateTime.TryParse(departureTimeString, out dateTime);
            if (!isSuccess)
            {
                message.IsSuccess = false;
                message.Message = "请输入一个有效的预约时间";
            }
            //else if (!int.TryParse(orderStatusIDStr, out orderStatusID))
            //{
            //    message.IsSuccess = false;
            //    message.Message = "订单状态无效";
            //}
            else
            {
                var model = _orderBll.GetModel(id);
                var sb = new StringBuilder();
                sb.Append("修改订单编号[" + id + "]");
                sb.Append(string.Format("；修改前的订单信息为    上车地址：{0}，下车地址：{1}，出发时间：{2}，乘车人：{3}，乘车人电话：{4}", model.startAddress, model.arriveAddress, model.departureTime, model.passengerName, model.passengerPhone));

                model.startAddress = startAddress;
                model.startAddressDetail = startAddressDetail;
                model.mapPoint = mapPoint;
                model.arriveAddress = arriveAddress + "，" + arriveAddressDetail;
                model.EndPosition = endPoint;
                model.departureTime = dateTime;
                model.pickupTime = dateTime;
                model.passengerName = passengerName ?? "";
                model.passengerPhone = passengerPhone ?? "";
                //model.orderStatusID = orderStatusID;
                sb.Append(string.Format("；修改后的订单信息为    上车地址：{0}，下车地址：{1}，出发时间：{2}，乘车人：{3}，乘车人电话：{4}", model.startAddress, model.arriveAddress, model.departureTime, model.passengerName, model.passengerPhone));
                //if (orderStatusID == 6 && model.orderStatusID != 1)
                //{
                //    _userAccountBll.AddScore(model);
                //    model.unpaidMoney = 0;
                //    model.paystatus = PayStatus.Paid;
                //    model.totalMoney = model.orderMoney;
                //}

                var usermodel = new BLL.UserAccountBLL().GetModel(model.userID);
                SMS.sendEditOrder(id, model.startAddress, model.arriveAddress, model.departureTime.ToString("yyyy-MM-dd HH:mm:ss"), model.passengerName, model.passengerPhone, usermodel.Telphone);


                if (usermodel != null && usermodel.WeixinOpenId != null && usermodel.WeixinOpenId != "")
                {
                    var result = WXCommon.EditOrderInfo(usermodel.WeixinOpenId, model.orderId, model.startAddress, model.arriveAddress, model.departureTime.ToString("yyyy-MM-dd HH-mm-ss"), model.passengerName, model.passengerPhone, usermodel.Compname);
                    IEZU.Log.LogHelper.WriteOperation("推送微信消息：二次付款成功", OperationType.Query,
                      result, "");
                }

                try
                {

                    _orderBll.upDateAllByModule(model);
                    var ordertimes = new OrderTimesBLL();
                    var timeModel = ordertimes.GetModel(id);
                    timeModel.UserOrderedtime = dateTime.ToString("yyyy-MM-dd HH:mm:ss");
                    ordertimes.UpdateDate(timeModel);
                    LogHelper.WriteOperation(sb.ToString(), OperationType.Update, "编辑成功",
                        HttpContext.Current.User.Identity.Name);
                    message.IsSuccess = true;
                    message.Message = "";

                }
                catch (Exception exception)
                {
                    message.IsSuccess = false;
                    LogHelper.WriteException(exception);
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void CarTableList(HttpContext context)
        {
            string carid = context.Request["id"];
            if (string.IsNullOrEmpty(carid))
            {
                return;
            }
            var list = _carTableBll.GetList(carid);
            context.Response.Write(JsonConvert.SerializeObject(list));
        }

        private void CarList(HttpContext context)
        {
            string orderId = context.Request["id"];
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            int count = 0;
            var serviceType = "";
            var carno = context.Request["carno"] ?? "";
            if (!string.IsNullOrEmpty(context.Request["type"]))
            {
                serviceType = context.Request["type"];
            }
            var carstatus = 0;
            if (!string.IsNullOrEmpty(context.Request["carstatus"]))
            {
                carstatus = int.Parse(context.Request["carstatus"]);
            }
            var rcCartype = "";
            if (!string.IsNullOrEmpty(context.Request["cartype"]))
            {
                rcCartype = context.Request["cartype"];
            }
            var townid = "";
            if (!string.IsNullOrEmpty(context.Request["townid"]))
            {
                townid = context.Request["townid"];
            }
            var list = _carInfoBll.GetSendCarList(orderId, carno, carstatus, serviceType, rcCartype, pageSize, pageIndex, out count, townid, false);
            context.Response.Write(JsonConvert.SerializeObject(new
            {
                index = pageIndex,
                total = count,
                rows = list
            }));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            var totamoney = 0.00M;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            string compname = context.Request["username"] ?? "";
            string sname = context.Request["sname"] ?? "";//passengername
            string usertel = context.Request["usertel"] ?? "";
            string passengertel = context.Request["passenagertel"] ?? "";
            string startcity = context.Request["startaddress"] ?? "";
            string targetcity = context.Request["targetaddress"] ?? "";
            string caruseway = string.IsNullOrEmpty(context.Request["caruseway"]) ? "0" : context.Request["caruseway"];
            string orderStatusId = string.IsNullOrEmpty(context.Request["orderStatusID"]) ? "0" : context.Request["orderStatusID"];
            string cartype = string.IsNullOrEmpty(context.Request["cartype"]) ? "0" : context.Request["cartype"];
            string orderid = context.Request["orderid"] ?? "";
            string usertype = string.IsNullOrEmpty(context.Request["usertypename"]) ? "0" : context.Request["usertypename"];
            string starttime = context.Request["startdate"] ?? "";
            var endtime = context.Request["enddate"] ?? "";

            string carNo = context.Request["carNo"] ?? "";
            var sort = context.Request["sort"] ?? "departuretime";
            var order = "";
            if (orderStatusId == "8")
            {
                order = context.Request["order"] ?? "asc";
            }
            else
            {
                order = context.Request["order"] ?? "desc";
            }
            try
            {
                //var list = _orderBll.GetOrderPager(pageIndex, pageSize, where, startcity, targetcity);
                var list = _orderBll.GetOrderPageListPro(starttime, endtime, compname, sname, usertel, passengertel, Int32.Parse(caruseway),
                                                      Int32.Parse(orderStatusId), Int32.Parse(cartype),
                                                     orderid, startcity, targetcity,
                                                      pageSize, pageIndex, carNo, sort, order, out count, out totamoney);
                var dict = new List<object>();
                dict.Add(new { orderId = "订单总数：" + count, passengerName = "订单总额：", passengerPhone = totamoney + "元", orderMoney = "total", totalMoney = "total" });
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    index = pageIndex,
                    total = count,
                    rows = list,
                    footer = dict
                }));
            }
            catch (Exception ex)
            {
                LogHelper.WriteException(ex);
            }

        }

        private void ExpiredList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string orderStatusID = context.Request["orderStatusID"];
            string orderid = context.Request["orderid"];
            string where = "departureTime<GETDATE() and orderStatusID in (1,2,7,8)";
            if (!string.IsNullOrEmpty(orderStatusID))
            {
                where += " and orderStatusID=" + orderStatusID;
            }
            if (!string.IsNullOrEmpty(orderid))
            {
                where += " and orderId='" + Common.Tool.SqlFilter(orderid) + "'";
            }
            var list = _orderBll.GetPageList(pageIndex, pageSize, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }

        private void CashPayOrderList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string driverName = context.Request["drivername"];
            string orderStatusID = context.Request["orderStatusID"];
            string orderid = context.Request["orderid"];
            string where = "paystatus=2";
            if (!string.IsNullOrEmpty(orderStatusID))
            {
                where += " and orderStatusID=" + orderStatusID;
            }
            if (!string.IsNullOrEmpty(orderid))
            {
                where += " and orderId  like '%" + Common.Tool.SqlFilter(orderid) + "%'";
            }
            var list = _orderBll.GetPageList(pageIndex, pageSize, where, out count, driverName);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }

        private void GetSendCarList(HttpContext context)
        {
            var orderbll = new OrderBLL();
            var list = orderbll.GetSendCarList();
            context.Response.Write(list.Count == 0
                ? JsonConvert.SerializeObject(new { resultcode = 0 })
                : JsonConvert.SerializeObject(new { resultcode = 1, data = list }));
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        #region private
        private string GetTargetCity(string orderid)
        {
            var ordermodel = (new OrderBLL()).GetModel(orderid);
            if (ordermodel != null)
            {
                var rentcarid = ordermodel.rentCarID;
                var bll = new RentCarBLL();
                var model = bll.GetModel(rentcarid);
                if (model != null)
                {
                    if (model.carusewayID == 6)
                    {
                        var hotline = (new HotLineBLL()).GetModel(model.hotLineID);
                        if (hotline != null)
                        {
                            return hotline.name + "(热门路线)";
                        }
                    }
                    else
                    {
                        var countyid = ordermodel.targetCityID;
                        var data = (new CityBLL()).GetFullResult(countyid.ToString());
                        if (data.Rows.Count > 0)
                        {
                            return data.Rows[0]["provincename"].ToString() + data.Rows[0]["citysname"].ToString() +
                                   data.Rows[0]["townname"].ToString();
                        }
                    }
                }
            }
            return "";
        }
        #endregion
    }
}