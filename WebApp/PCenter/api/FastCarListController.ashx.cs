using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Newtonsoft.Json;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// FastCarListController 的摘要说明
    /// </summary>
    public class FastCarListController : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string action = context.Request["action"];
            switch (action)
            {
                case "getCoupon": getCoupon(context); break;
                case "getDetail": GetDetail(context); break;
                case "getCityType": getCityType(context); break;
                case "subOrder": SubOrder(context); break;
                default:
                    break;
            }
        }
        public void getCoupon(HttpContext context)
        {
            var userAccount = context.Session["userInfo"] as Model.UserAccount;
            var orderMoney = decimal.Parse(context.Request["ordermoney"]);
            var coupons = BLL.Coupon.GetList(userAccount.Id).Where(s => s.Status == 0 && s.Startdate < DateTime.Now && s.Deadline > DateTime.Now && s.Restrictions <= orderMoney).ToList();
            context.Response.Write(JsonConvert.SerializeObject(coupons));
        }
        public void GetDetail(HttpContext context)
        {
            var modelRentCar = new BLL.RentCarBLL().GetModel(int.Parse(context.Request["rentCarID"]));
            var resultCarDetail = new BLL.BLLExpand.CarFullType(modelRentCar);
            context.Response.Write(JsonConvert.SerializeObject(resultCarDetail));
        }
        public void getCityType(HttpContext context)
        {
            string codeID = context.Request["codeid"];
            string result = new BLL.CityBLL().GetCityType(codeID);
            if (result == "2")
            {
                var time = DateTime.Now.AddMinutes(70);
                context.Response.Write(JsonConvert.SerializeObject(new {hour = time.Hour, minutes = time.Minute }));
            }
            else
            {
                var time = DateTime.Now.AddMinutes(130);
                context.Response.Write(JsonConvert.SerializeObject(new { hour = time.Hour, minutes = time.Minute }));
            }
        }
        public void SubOrder(HttpContext context)
        {
            try
            {
                var quickOrderCarModel = new BLL.QuickOrderCarBLL().GetModel(int.Parse(context.Request["quickOrderID"]));
                var time_date = context.Request["time_date"];
                var time_hour = context.Request["time_hour"];
                var time_minutes = context.Request["time_minutes"];
                var passangerNumber = context.Request["passangerNumber"];
                var couponID = context.Request["couponid"];
                var voucherId = context.Request["voucherId"];
                var remaks = context.Request["remarks"];
                var useHour = string.IsNullOrEmpty(context.Request["useHour"]) == true ? "0" : context.Request["useHour"];
                var startTime = new DateTime(int.Parse(time_date.Split('-')[0]), int.Parse(time_date.Split('-')[1]), int.Parse(time_date.Split('-')[2]), int.Parse(time_hour), int.Parse(time_minutes), 0);
                var newOrder = new Model.Orders();
                newOrder.arriveAddress = quickOrderCarModel.downAddress;
                newOrder.departureCityID = quickOrderCarModel.startCountryID;
                newOrder.departureTime = startTime;
                newOrder.EndPosition = quickOrderCarModel.downPosition;
                newOrder.mapPoint = quickOrderCarModel.upPosition;
                newOrder.orderDate = DateTime.Now;
                newOrder.useHour = int.Parse(useHour == "null" ? "0" : useHour);
                string neworderid = Common.GenerateNo.GenerateUniqueOrderNo(5);//生成订单号
                while ((new BLL.OrderBLL().GetModel(neworderid)) != null)
                {
                    neworderid = Common.GenerateNo.GenerateUniqueOrderNo(5);
                }
                newOrder.orderId = neworderid.Split('|')[0];
                newOrder.orderMoney = new BLL.RentCarBLL().GetModel(quickOrderCarModel.rentCarID).DiscountPrice;
                newOrder.orderMessage = "";//不知道特殊要求是哪个字段
                newOrder.remarks = remaks;//不知道特殊要求是哪个字段
                newOrder.orderStatusID = (int)Common.OrderStatus.等待确认;
                newOrder.passengerName = quickOrderCarModel.passangerName;
                newOrder.passengerNum = int.Parse(passangerNumber);
                newOrder.passengerPhone = quickOrderCarModel.passangerPhone;
                newOrder.paystatus = Common.PayStatus.unPaid;
                newOrder.rentCarID = quickOrderCarModel.rentCarID;
                newOrder.startAddress = quickOrderCarModel.upAddress;
                newOrder.startAddressDetail = quickOrderCarModel.upAddressDetail;
                newOrder.targetCityID = quickOrderCarModel.arriveCountryID;
                newOrder.userID = quickOrderCarModel.userID;
                if (couponID != "0")
                {
                    var couponModel = BLL.Coupon.GetModel(int.Parse(couponID));
                    if (couponModel.Status == 0)
                    {
                        couponModel.Status = 1;
                        couponModel.OrderId = newOrder.orderId;
                        new BLL.Coupon().UpdateStatus(newOrder.orderId, couponModel.Id.ToString());
                        newOrder.orderMoney = newOrder.orderMoney - couponModel.Cost < 0 ? 0 : newOrder.orderMoney - couponModel.Cost;
                    }
                }
                else if (voucherId != "0")
                {
                    var voucher = new BLL.VouchersBll().GetModel(Int32.Parse(voucherId));
                    if (voucher.Status == "未使用")
                    {
                        int result = new BLL.VouchersBll().UpdateState(Int32.Parse(voucherId), newOrder.orderId);
                        if (result != 0)
                        {
                            if (voucher.Cost >= (decimal)newOrder.orderMoney)
                            {
                                newOrder.orderMoney = 0;
                            }
                            else
                            {
                                newOrder.orderMoney = newOrder.orderMoney - voucher.Cost;
                            }
                        }
                    }
                }
                new BLL.OrderBLL().InsertData(newOrder);
                context.Response.Write(JsonConvert.SerializeObject(new { orderID = newOrder.orderId }));
            }
            catch
            {
                context.Response.Write(JsonConvert.SerializeObject(new { orderID = "0" }));
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