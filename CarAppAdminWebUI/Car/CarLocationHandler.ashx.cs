using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using BLL;
using CarAppAdminWebUI.Order;
using Common;
using IEZU.Log;
using Model;
using Model.Ext;
using Model.GPS;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// CarLocationHandler 的摘要说明
    /// </summary>
    public class CarLocationHandler : IHttpHandler
    {
        private readonly CarInfoBLL _carInfoBll = new CarInfoBLL();
        private readonly OrderBLL _orderBll = new OrderBLL();
        private readonly RentCarBLL _rentCarBll = new RentCarBLL();
        private readonly CityBLL _cityBll = new CityBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "orderlist":
                    OrderList(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "model":
                    GetModel(context);
                    break;
                case "newcarinfo":
                    NewCarInfoList(context);
                    break;
                case "ordercount":
                    OrderCount(context);
                    break;
                case "carroute":
                    GetCarRoute(context);
                    break;
                case "newmodel":
                    GetCarInfoModel(context);
                    break;
                case "currentlocation":
                    GetCurrentLocation(context);
                    break;
                case "gpssource":
                    UpdateGpsSource(context);
                    break;
                case "routeinfo":
                    context.Response.ContentType = "application/json";
                    GetCarRouteInfo(context);
                    break;
                case "distanceinfo":
                    context.Response.ContentType = "application/json";
                    GetCarDistance(context);
                    break;
            }
        }

        public void GetCarDistance(HttpContext context)
        {
            var starttime = context.Request["starttime"];
            var endtime = context.Request["endtime"];

            var sortype = context.Request["sort"]??"0";
            var order = context.Request["order"] ?? "desc";
            if (sortype == "servicedistance")
            {
                sortype = "1";
            }
            else if (sortype == "emptydistance")
            {
                sortype = "2";
            }
            else if (sortype == "totaldistance")
            {
                sortype = "3";
            }
            else if (sortype == "otherdistance")
            {
                sortype = "4";
            }
            else
            {
                sortype = "0";
            }
          
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            var rowcount = 0;
            var data=_carInfoBll.GetCarDistanceData(DateTime.Parse(starttime.ToString()),DateTime.Parse(endtime.ToString()),order,int.Parse(sortype),pageSize,pageIndex,out  rowcount);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = rowcount, rows = data }));
        }
        public void GetCarRouteInfo(HttpContext context)
        {
            var data = _carInfoBll.GetCarBasicInfo(context.Request["carno"] ?? "");
            if (data.Rows.Count == 0)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "车辆不存在" }));
                return;
            }
            var vid = data.Rows[0]["vid"].ToString().Trim();
            var starttime = Convert.ToDateTime(context.Request["starttime"]);
            var endtime = Convert.ToDateTime(context.Request["endtime"]);
            if ((endtime - starttime).Days > 1)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "只能查询两天内的轨迹" }));
                return;
            }
            var routeresult = GPSOperation.GetCarRoute(vid, starttime, endtime);
            if (routeresult.error != 0)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "路径获取失败" }));
                return;
            }
            var routelist = JsonConvert.DeserializeObject<List<Model.GPS.HList>>(routeresult.hlist.ToString());
            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, data = routelist }));

        }
        public void GetCurrentLocation(HttpContext context)
        {
            var vid = context.Request["vid"].ToString();
            var result = GPSOperation.GetCarPosition(vid);
            if (result.error == 0)
            {
                var positionInfo = JsonConvert.DeserializeObject<List<CarPositionInfo>>(result.calist.ToString());
                if (positionInfo.FirstOrDefault() != null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { data = positionInfo.FirstOrDefault(), resultcode = 0 }));
                    return;
                }
                context.Response.Write(JsonConvert.SerializeObject(new { msg = "gps获取失败", resultcode = -2 }));
                return;
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new { msg = "gps获取失败", resultcode = -2 }));
                return;
            }
        }
        private void GetCarRoute(HttpContext context)
        {
            var orderid = context.Request["orderid"];

            if (string.IsNullOrEmpty(orderid))
            {
                context.Response.Write(JsonConvert.SerializeObject(new { msg = ResultCode.参数错误.ToString(), resultcode = ResultCode.参数错误 }));
                return;
            }
            var gpsInstance = GPSOperation.GetGpsVid(orderid);
            if (gpsInstance == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { msg = "gps获取失败", resultcode = ResultCode.业务操作失败 }));
                return;
            }
            DateTime startDate;
            DateTime endDate;
            if (!DateTime.TryParse(gpsInstance.StartDate, out startDate) || !DateTime.TryParse(gpsInstance.EndDate, out endDate))
            {
                endDate = DateTime.Now;
            }
            if (gpsInstance.StartDate.Length == 0)
            {
                startDate = DateTime.Now;
            }
            try
            {
                var statusid = "";
                float lng;
                float lat;
                var data = (new OrderBLL()).GetPostition(orderid, out lng, out lat, out statusid);
                var sendcartime = data.Rows[0]["sendcartime"].ToString();
                var serviceStarttime = data.Rows[0]["startservicetime"].ToString();
                var carRoute = GPSOperation.GetCarRoute(gpsInstance.Info.vid, startDate, endDate);

                if (carRoute == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { msg = ResultCode.业务操作失败.ToString(), resultcode = ResultCode.业务操作失败 }));
                    return;
                }
                var serviceBeforeRoute = new Model.GPS.CarRoute();
                var showBeforeRoute = "";
                if (statusid == "3" || statusid == "4" || statusid == "6")
                {
                    serviceBeforeRoute = GPSOperation.GetCarRoute(gpsInstance.Info.vid, DateTime.Parse(sendcartime), DateTime.Parse(serviceStarttime));
                }

                if (serviceBeforeRoute.error != 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { msg = ResultCode.业务操作失败.ToString(), resultcode = ResultCode.业务操作失败 }));
                    return;
                }
                var hlists = serviceBeforeRoute.hlist;
                var listrouteinfo = new List<Model.GPS.HList>();
                if (hlists == null)
                {
                    showBeforeRoute = "0";
                }
                else
                {
                    listrouteinfo = JsonConvert.DeserializeObject<List<HList>>(hlists.ToString());
                    showBeforeRoute = "1";
                }
                if (carRoute.error == 0)
                {
                    var hlist = JsonConvert.DeserializeObject<List<HList>>(carRoute.hlist.ToString());
                    var startLocation = hlist.FirstOrDefault();
                    var startlng = "";
                    var startlat = "";
                    if (startLocation != null)
                    {
                        startlng = startLocation.lng;
                        startlat = startLocation.lat;
                    }
                    CarPosition position = GPSOperation.GetCarPosition(gpsInstance.Info.vid);

                    if (position != null)
                    {
                        var carlist = JsonConvert.DeserializeObject<List<CarPositionInfo>>(position.calist.ToString());
                        context.Response.Write(carlist.Count > 0 && (statusid == "10" || statusid == "11" || statusid == "12" || statusid == "2")
                            ? JsonConvert.SerializeObject(
                                new
                                {
                                    data = hlist,
                                    startlng = startlng,
                                    startlat = startlat,
                                    carlng = carlist.First().lng,
                                    carlat = carlist.First().lat,
                                    carposition = carlist.First().position,
                                    orderstartlng = lng,
                                    orderstartlat = lat,
                                    resultcode = ResultCode.成功
                                })
                            : JsonConvert.SerializeObject(
                                new { data = hlist, startlng = startlng, startlat = startlat, resultcode = ResultCode.成功, showBeforeRoute, gpsdata = listrouteinfo }));
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { data = hlist, startlng = startlng, startlat = startlat, resultcode = ResultCode.成功 }));
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { msg = ResultCode.业务操作失败.ToString(), resultcode = ResultCode.业务操作失败 }));
                }
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { msg = ResultCode.业务操作失败.ToString(), resultcode = ResultCode.业务操作失败 }));
            }
        }
        private void OrderCount(HttpContext context)
        {
            int count = _orderBll.GetCount("orderstatusid=8");
            context.Response.Write(count);
        }

        private void GetModel(HttpContext context)
        {
            string idStr = context.Request["id"];
            int id;
            if (int.TryParse(idStr, out id))
            {
                var model = _carInfoBll.GetList().Where(c => c.Id == id);
                context.Response.Write(JsonConvert.SerializeObject(model));
            }
        }

        public void GetCarInfoModel(HttpContext context)
        {
            CarInfoBLL bll = new CarInfoBLL();
            string idStr = context.Request["id"];
            int id;
            if (int.TryParse(idStr, out id))
            {
                var model = _carInfoBll.GetCarInfoModel(id);

                context.Response.Write(JsonConvert.SerializeObject(model));
            }
        }
        private void OrderList(HttpContext context)
        {
            int count = 0;
            var mappoint = "";
            var carno = context.Request["carno"] ?? "";
            if (!string.IsNullOrEmpty(context.Request.QueryString["orderid"]))
            {
                var ordermodel = _orderBll.GetModel(context.Request["orderid"].ToString().Trim());

                if (ordermodel != null && ordermodel.orderStatusID == 8)
                {
                    var data = _orderBll.GetSendCarOrder(context.Request["orderid"].ToString().Trim());
                    if (data.Count > 0)
                    {
                        var carlist = _carInfoBll.GetSendCarList(data[0].orderId, carno, 0, "", "", 400, 1, out count,
                            "", true);
                        context.Response.Write(JsonConvert.SerializeObject(new { orders = data, cars = carlist }));
                        return;
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
            }
            var list = _orderBll.GetSendCarOrder();
            if (list.Count > 0)
            {
                var model = list[0];
                var carlist = _carInfoBll.GetSendCarList(model.orderId, carno, 0, "", "", 400, 1, out count, "", true);
                context.Response.Write(JsonConvert.SerializeObject(new { orders = list, cars = carlist }));
            }
        }

        private void UpdateGpsSource(HttpContext context)
        {
            try
            {
                context.Response.Write(new SystemBLL().UpdateGpsSource());
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write("0");
            }
        }
        private void List(HttpContext context)
        {
            string carNo = context.Request["carNo"] ?? "";
            string telPhone = context.Request["telPhone"] ?? "";
            string driverName = context.Request["driverName"] ?? "";
            string carbrand = string.IsNullOrEmpty(context.Request["carbrand"]) ? "0" : context.Request["carbrand"].ToString();
            string cityName = context.Request["city"];
            var gpsdevice = (new SystemBLL()).GpsSource();
            string Online = context.Request["Online"];

            DataTable data = _carInfoBll.GetCarInfoList(carNo, telPhone, driverName, int.Parse(carbrand), string.IsNullOrEmpty(Online) ? 0 : 1);

            var list = Common.DataTableToList.List<CarInfoExt>(data);
            try
            {
                var cargpslist = GPSOperation.GetCarList();
                var sb = new StringBuilder();
                if (cargpslist != null)
                {
                    foreach (IMEIInfo t in cargpslist)
                    {
                        sb.Append(t.vid.ToString() + ",");
                    }
                }

                List<CarPositionInfo> carpostion;
                if (gpsdevice == "GPS")
                {
                    carpostion =
                        JsonConvert.DeserializeObject<List<CarPositionInfo>>(
                            GPSOperation.PostCarposition(sb.ToString().Trim(',')).calist.ToString());
                }
                else
                {
                    carpostion = GPSOperation.GetCarLocationList();
                }

                foreach (var c in list)
                {
                    switch ((int)c.carWorkStatus)
                    {
                        case 1:
                            c.WorkStatusName = "工作中";
                            break;
                        case 2:
                            c.WorkStatusName = "离开或请假";
                            break;
                        case 3:
                            c.WorkStatusName = "可以接单/空闲中";
                            break;
                        case 4:
                            c.WorkStatusName = "已出发";
                            break;
                        case 5:
                            c.WorkStatusName = "已就位";
                            break;
                        case 6:
                            c.WorkStatusName = "订单已接取";
                            break;
                        case 8:
                            c.WorkStatusName = "租出";
                            break;
                        case 9:
                            c.WorkStatusName = "借出";
                            break;
                        default:
                            c.WorkStatusName = "其它";
                            break;
                    }
                    var postion =
                        carpostion.FirstOrDefault(
                            p => String.Equals(p.carno, c.CarNo, StringComparison.CurrentCultureIgnoreCase));
                    if (postion != null)
                    {
                        try
                        {
                            c.latitude = decimal.Parse(postion.lat);
                            c.longitude = decimal.Parse(postion.lng);
                            c.currentPosition = postion.position;
                            c.updateTime = DateTime.Parse(postion.gpstime);
                            c.speed = decimal.Parse(postion.speed);
                            c.direction = int.Parse(postion.direction.ToString());
                            c.GpsTime = postion.gpstime.ToString();
                        }
                        catch (Exception exception)
                        {
                            LogHelper.WriteException(exception);
                        }
                    }
                }

            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }
            context.Response.Write(JsonConvert.SerializeObject(list));
        }

        private void NewCarInfoList(HttpContext context)
        {
            var model = _carInfoBll.GetList().OrderByDescending(c => c.updateTime).Take(1);
            context.Response.Write(JsonConvert.SerializeObject(model));
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