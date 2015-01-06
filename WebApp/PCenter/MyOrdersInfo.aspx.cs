using System;
using System.Collections.Generic;
using System.Data;
using Common;
using BLL;
using Model;

namespace WebApp.PCenter
{
    public partial class MyOrdersInfo : PageBase.PageBase
    {
        protected Model.Orders orderThis = new Model.Orders();
        protected RentCarBLL RCB = new RentCarBLL();
        protected CarUseWayBLL CUWB = new CarUseWayBLL();
        protected int canPay = 0;//0:已支付,1:可支付,2:超过最后支付期限,3:用户被限制支付,9:二次付款,5:服务取消
        //protected Model.Invoice thisInvo = new Invoice();
        protected Model.OrderInvoice thisInvo = new OrderInvoice();
        protected string carUseWayStr = "";
        protected string carTypeStr = "";
        protected Model.Coupon couponThis = new Model.Coupon();
        protected Model.OrdersExtInfo orderExt = new Model.OrdersExtInfo();
        protected string upCity = "";
        protected string downCity = "";
        protected string ticketnum = "";
        protected bool istravel = false;
        protected OrderCancel cancel;
        protected string hotLineWayName = "";
        public OrderTimes timeModel=new OrderTimes();
        protected Model.Vouchers vouchers;
        protected Model.RentCar rentCar;
        protected Model.CarInfo carinfo;
        protected Model.DriverAccount driverInfo;
        protected DataTable driverDt;//司机服务信息，包括总接单数，总公里数等
        protected DataTable winddt; //顺风车客户信息
        protected void Page_Load(object sender, EventArgs e)
        {
            orderThis = new OrderBLL().GetModel(Request.QueryString["orderId"]);
            if(orderThis.carId != null)
                carinfo = new BLL.CarInfoBLL().GetModel(orderThis.carId.Trim());
            var driverBll = new DirverAccountBLL();
            driverInfo = !string.IsNullOrEmpty(orderThis.JobNumber) ? driverBll.GetModel(orderThis.JobNumber) : new DriverAccount();
            driverDt = driverBll.GetDriverInfo(orderThis.JobNumber);

            if (orderThis == null)//订单不存在，或者下单人
                Response.Redirect("~/MyOrders.aspx", true);
            else
            {
                rentCar = new RentCarBLL().GetModelbyID(orderThis.rentCarID);
                upCity = new BLL.BLLExpand.CityFullBLL(int.Parse(orderThis.departureCityID)).Province.CityName + new BLL.BLLExpand.CityFullBLL(int.Parse(orderThis.departureCityID)).City.CityName;
                try
                {
                    if (rentCar.carusewayID == 6)
                    {
                        var hotModel = (new HotLineBLL()).GetModel(int.Parse(orderThis.targetCityID));
                        downCity = new BLL.BLLExpand.CityFullBLL(int.Parse(hotModel.countyId)).Province.CityName + new BLL.BLLExpand.CityFullBLL(int.Parse(hotModel.countyId)).City.CityName;
                        hotLineWayName = "线路名称：" + new BLL.BLLExpand.CityFullBLL(int.Parse(orderThis.departureCityID)).City.CityName+"--->"+hotModel.name;
                    }
                    else
                    {
                        downCity = new BLL.BLLExpand.CityFullBLL(int.Parse(orderThis.targetCityID)).Province.CityName + new BLL.BLLExpand.CityFullBLL(int.Parse(orderThis.targetCityID)).City.CityName;
                    }
                    timeModel = (new OrderTimesBLL()).GetModel(Request.QueryString["orderId"].ToString());
                }
                catch 
                {
                    hotLineWayName = "";
                    downCity = "";
                }
                if (orderThis.orderStatusID == 5)
                {
                    cancel = new BLL.OrderCancelBLL().GetModel(orderThis.orderId);
                }
            }



            //查看订单详情，查看者必须是下单者本人、下单者的创建者或下单者的企业管理员之一，否则跳转到MyOrder.aspx页面
            if (orderThis.userID != userAccount.Id && new UserAccountBLL().GetModel(orderThis.userID).Pid != userAccount.Id && new UserAccountBLL().GetMaster(orderThis.userID).Id != userAccount.Id)
            {
                winddt = new BLL.OrderBLL().GetPassengerList(orderThis.orderId, "", userAccount.Id);
                if (winddt == null)
                {
                    Response.Redirect("/pcenter/MyOrders.aspx", true);
                }
            }
            orderExt = new BLL.OrdersExtInfo().GetModel(orderThis.orderId);
            if (orderExt == null)//给超出订单范围的各项信息，赋初值
            {
                orderExt = new Model.OrdersExtInfo();
                orderExt.overMinut = 0;
                orderExt.overMinutMoney = 0.00M;
                orderExt.overKM = 0;
                orderExt.overKMMoney = 0.00M;
                orderExt.highwayMoney = 0.00M;
                orderExt.carStopMoney = 0.00M;
                orderExt.airportMoney = 0.00M;
                orderExt.emptyCarMoney = 0.00M;
            }
            //Model.RentCar rentCarThis = new BLL.RentCarBLL().GetModel(orderThis.rentCarID);//租车信息
            carUseWayStr = GetCarUseWayName(orderThis.orderId);//用车方式
            carTypeStr = new BLL.CarTypeBLL().GetCarType(rentCar.carTypeID);//预定车型

            couponThis = BLL.Coupon.GetByOrderId(orderThis.orderId);//优惠券信息
            if (Convert.ToInt32(orderThis.isreceipts) != 0 || Convert.ToInt32(orderThis.invoiceID) != 0)//发票标识可能存在isreceipts字段或invoiceID字段，所以都要判断
            {   //订单已经绑定发票
                thisInvo = new BLL.OrderInvoiceBll().GetModel(orderThis.orderId);
            }
            CityModel departureCity = new CityBLL().GetModel(Convert.ToInt32(orderThis.departureCityID));//出发城市
            DateTime nowTime = DateTime.Now;
            if (orderThis.orderStatusID == 1)
            {
                canPay = 1;
                if (carUseWayStr != "随叫随到")
                {
                    if (departureCity.Type == 2) //出发地-市区
                    {
                        if (nowTime.AddMinutes(70) > orderThis.departureTime) //判断订单是否过期
                            canPay = 2;
                    }
                    if (departureCity.Type == 3) //出发地-郊县
                    {
                        if (nowTime.AddMinutes(130) > orderThis.departureTime) //判断订单是否过期
                            canPay = 2;
                    }
                }
                DateTime userCarTime = new DateTime();
                userCarTime = rentCar.carusewayID == 1 ? orderThis.pickupTime : orderThis.departureTime;
                if (!new BLL.UserAccountBLL().CanGetOrder(userAccount.Id, rentCar.carTypeID, orderThis.orderMoney, userCarTime))
                    canPay = 3;
            }
            if (orderThis.orderStatusID != 1)
            {
                canPay = 0;//查看canPay状态请在canPay上按F12
            }
            if (orderThis.orderStatusID == 9)
            {
                canPay = 4;
            }
            if (orderThis.orderStatusID == 5)
            {
                canPay = 5;
            }
            if (orderThis.orderStatusID == 6)
            {
                canPay = 6;
            }
            if (orderThis.orderStatusID == 3)
            {
                canPay = 7;
            }

            vouchers = new BLL.VouchersBll().GetModel(orderThis.orderId); //代金券

            if(winddt != null)
            {
                foreach (DataRow row in winddt.Rows)
                {
                    orderThis.passengerNum += Convert.ToInt32(row["booknum"]);
                    orderThis.orderMoney += Convert.ToInt32(row["booknum"]) * Convert.ToDecimal(row["price"]);
                }
                timeModel.PayTime = winddt.Rows[0]["payTime"].ToString();
                orderThis.passengerName = winddt.Rows[0]["passengername"].ToString();
             
                orderThis.passengerPhone = winddt.Rows[0]["passengerphone"].ToString();
               
            }
        }

        public string GetCarUseWayName(string orderid)
        {

            var orderModel = (new OrderBLL()).GetModel(orderid);
            if (orderModel == null)
            {
                return "订单不存在";
            }
            var rentModel = (new RentCarBLL()).GetModel(orderModel.rentCarID);
            if (rentModel == null)
            {
                return "";
            }
            var usewayid = rentModel.carusewayID;
            if (usewayid == 6)
            {
                var hotlineid = rentModel.hotLineID;
                var hotlinemodel = (new HotLineBLL()).GetModel(hotlineid);
                if (hotlinemodel == null)
                {
                    return "";
                }
                if (hotlinemodel.IsTravel == 1)
                {
                    ticketnum = orderModel.TicketNum.ToString();
                    istravel = true;
                    return "旅游路线";
                }
                istravel = false;
                return "热门线路";
            }
            var useway = (new CarUseWayBLL()).GetUseName(usewayid);
            return useway.ToString();
        }
        protected string GetOrderStatus(string orderid)
        {
            DataTable data = (new BLL.OrderBLL()).GetOrderById(orderid);
            if (data.Rows.Count == 0)
            {
                return "订单号不存在";
            }
            var row = data.Rows[0];
            if (row["orderstatusid"].ToString() == "1")
            {
                CityModel departureCity = new CityBLL().GetModel(Convert.ToInt32(row["departureCityID"].ToString()));
                DateTime nowTime = DateTime.Now;

                if (new BLL.RentCarBLL().GetModelbyID(Convert.ToInt32(data.Rows[0]["rentCarID"])).carusewayID != 7)
                {

                    if (departureCity.Type == 2) //出发地-市区
                    {
                        if (nowTime.AddMinutes(70) > DateTime.Parse(row["departureTime"].ToString()))
                        {
                            return "订单过期";
                        }
                        else
                        {
                            return "等待确认";
                        }
                    }
                    else //出发地-郊县
                    {
                        if (nowTime.AddMinutes(130) > DateTime.Parse(row["departureTime"].ToString()))
                        {
                            return "订单过期";
                        }
                        else
                        {
                            return "等待确认";
                        }
                    }
                }
                return "等待确认";
            }
            else
            {
                var statusid = row["orderstatusid"].ToString();
                return Enum.Parse(typeof(OrderStatus), statusid).ToString();
            }
        }

    }
}