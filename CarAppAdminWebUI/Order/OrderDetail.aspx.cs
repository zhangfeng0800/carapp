using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;
using Common;
using Model;
using Model.GPS;
using Newtonsoft.Json;
using NPOI.DDF;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Order
{
    public partial class OrderDetail : BasePage
    {
        protected Orders OrderModel;
        protected RentCar RentCarModel;
        protected CarInfo CarInfoModel;
        protected DriverAccount DriverAccountModel;
        protected Model.OrdersExtInfo ordersExtInfoModel;
        protected string UserName = string.Empty;
        public string UserTelphone = "";
        private readonly OrderBLL _orderBll = new OrderBLL();
        private readonly RentCarBLL _rentCarBll = new RentCarBLL();
        private readonly CarInfoBLL _carInfoBll = new CarInfoBLL();
        private readonly DirverAccountBLL _dirverAccountBll = new DirverAccountBLL();
        private readonly BLL.OrdersExtInfo _ordersExtInfo = new BLL.OrdersExtInfo();
        private readonly UserAccountBLL _userAccountBll = new UserAccountBLL();
        public string id;
        public AirPort airportModel;
        protected OrderCancel cancel;
        public string carusename = "";
        public Model.Coupon mycoupn = null;
        public Model.CallCenterOrder centerOrder = null;
        public OrderTimes OrderTimesModel;
        protected Model.Vouchers vouchers;
        public DataTable sendRecord = new DataTable();
        protected DataTable dtPassengers;
        protected DataTable cancelPassengers;
        protected int actualNum;//已经预定人数
        protected decimal deductmoney;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Request.QueryString["id"];

            if (string.IsNullOrEmpty(id))
            {
                GoErrorPage();
            }
            OrderModel = _orderBll.GetModel(id);

            centerOrder = new BLL.CallCenterOrderBLL().GetModel(OrderModel.orderId);

            if (OrderModel == null)
            {
                GoErrorPage();
            }
            var airportId = OrderModel.airportID;
            airportModel = (new AirportBLL()).GetModel(airportId);
            sendRecord = _orderBll.GetSendRecord(id);
            cancel = new BLL.OrderCancelBLL().GetModel(OrderModel.orderId);
            OrderTimesModel = (new OrderTimesBLL()).GetModel(id);
            if (OrderModel == null)
            {
                GoErrorPage();
            }
            RentCarModel = _rentCarBll.GetModel(OrderModel.rentCarID);
            if (RentCarModel == null)
            {
                GoErrorPage();
            }
            var useModel = (new CarUseWayBLL()).GetCarUseWayModel(RentCarModel.carusewayID);
            carusename = useModel == null ? "未知" : useModel.Name;
            if (RentCarModel.carusewayID == 6)
            {
                carusename += RentCarModel.IsOneWay != 1 ? "（往返）" : "（单程）";
            }
            if (!string.IsNullOrEmpty(OrderModel.carId))
            {
                CarInfoModel = _carInfoBll.GetModel(OrderModel.carId);
            }
            if (!string.IsNullOrEmpty(OrderModel.JobNumber))
            {
                DriverAccountModel = _dirverAccountBll.GetModel(OrderModel.JobNumber);
                if (OrderModel.orderStatusID != 6 && OrderModel.orderStatusID != 5)
                {
                    DriverAccountModel.Name += "  (当前登录司机,已接单)";
                }
            }
            else if (CarInfoModel != null && CarInfoModel.DriverID != 0)
            {
                DriverAccountModel = _dirverAccountBll.GetModel(CarInfoModel.DriverID);
                DriverAccountModel.Name += "  (当前登录司机,未接单)";
            }
            ordersExtInfoModel = _ordersExtInfo.GetModel(OrderModel.orderId);
            var userModel = _userAccountBll.GetModel(OrderModel.userID);
            if (userModel != null)
            {
                UserName = userModel.Compname;
                UserTelphone = userModel.Telphone;
            }

            mycoupn = BLL.Coupon.GetByOrderId(OrderModel.orderId);
            vouchers = new BLL.VouchersBll().GetModel(OrderModel.orderId);

            if (RentCarModel.carusewayID == 8)
            {
                dtPassengers = new OrderBLL().GetPassengerList(id, "已付款",0);
                cancelPassengers = new OrderBLL().GetPassengerList(id, "已取消", 0);
                foreach(DataRow row in dtPassengers.Rows)
                {
                    actualNum += Convert.ToInt32(row["booknum"]);
                }
                foreach (DataRow row in cancelPassengers.Rows)
                {
                    deductmoney += Convert.ToDecimal(row["deductmoney"]);
                }
            }
        }
         
        public string GetStatus(int status)
        {
            switch (status)
            {
                case 2:
                    return "【接取订单】";
                case 12:
                    return "【司机出发】";
                case 10:
                    return "【司机就位】";
                case 11:
                    return "【开始服务】";
                case 3:
                    return "【结束服务】";
                case 4:
                    return "【计算账单】";
                case 9:
                    return "【二次付款】";
                default:
                    return "";
            }
        }

    
        public string GetCurrentPosotion()
        {
            var orderbll = new OrderBLL();
            if (string.IsNullOrEmpty(id))
            {
                return ("位置未知");

            }
            var carinfo = orderbll.GetDriverCar(id);
            if (carinfo == null || carinfo.Rows.Count == 0)
            {
                return ("位置未知");
            }
            var carno = carinfo.Rows[0]["carno"].ToString();
            if (string.IsNullOrEmpty(carno))
            {
                return ("位置未知");

            }
            try
            {
                var gpsInstance = GPSOperation.GetGpsVid(id);
                var data = GPSOperation.PostCarposition(gpsInstance.Info.vid);
                if (data == null)
                {
                    return ("位置未知");

                }
                if (data.error == 0)
                {
                    var carposition = JsonConvert.DeserializeObject<List<CarPositionInfo>>(data.calist.ToString());
                    var positionInfo = carposition.FirstOrDefault();
                    if (positionInfo != null)
                    {
                        positionInfo.driverName = carinfo.Rows[0]["driverName"].ToString();
                        positionInfo.distance = "0.00";
                        return (positionInfo.position + "（GPS时间" + positionInfo.gpstime + "）");

                    }
                    return ("位置未知");

                }
                return ("位置未知");
            }
            catch (Exception exception)
            {
                return ("位置未知");
            }
        }
        public string GetTimeString(decimal time)
        {
            var minutes = (int)time;
            if (minutes < 60)
            {
                return minutes + "分钟";
            }
            else if (Math.Abs(minutes - 60) == 0)
            {
                return "1小时";
            }
            else
            {
                var hour = minutes / 60;
                var minute = minutes - hour * 60;
                return hour + "小时" + minute + "分钟";
            }
        }
        public string GetPayStatus(Common.PayStatus status)
        {
            if (status == Common.PayStatus.CashPaid)
            {
                return "现金支付完成";
            }
            else if (status == Common.PayStatus.CashPaying)
            {
                return "现金支付给司机";
            }
            else if (status == Common.PayStatus.Paid)
            {
                return "已经支付";
            }
            else if (status == Common.PayStatus.unPaid)
            {
                return "未支付";
            }
            else
            {
                return "";
            }
        }
        protected string GetHotLineName(int id)
        {
            object obj = new HotLineBLL().GetHotNameById(id.ToString());
            return obj == null ? "" : obj.ToString();
        }
        public string GetStartAddress(int rentcarid)
        {
            var rentModel = (new RentCarBLL()).GetModel(rentcarid);
            if (rentModel == null)
            {
                return "";
            }
            if (rentModel.carusewayID == 1)
            {
                var airportModel = (new AirportBLL()).GetModel(OrderModel.airportID);
                return airportModel == null ? "机场信息不存在" : airportModel.AirPortName;
            }
            return OrderModel.startAddress + "，" + OrderModel.startAddressDetail;
        }
        public string GetEndAddress(int rentcarid)
        {
            var rentModel = (new RentCarBLL()).GetModel(rentcarid);
            if (rentModel == null)
            {
                return "";
            }
            if (rentModel.carusewayID != 2) return OrderModel.arriveAddress;
            var airportModel = (new AirportBLL()).GetModel(OrderModel.airportID);
            return airportModel == null ? "机场信息不存在" : airportModel.AirPortName;
        }
        public string GetCarUseWay(int id)
        {
            object obj = new CarUseWayBLL().GetUseName(id);
            return obj == null ? "" : obj.ToString();
        }

        public string GetTargetCity(string orderid)
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
                            return hotline.name + "(热门线路)";
                        }
                    }
                    else
                    {
                        // var countyid = model.countyId;
                        var data = (new CityBLL()).GetFullResult(ordermodel.targetCityID);
                        if (data.Rows.Count > 0)
                        {
                            return "[" + ordermodel.targetCityID + "]" + data.Rows[0]["provincename"].ToString() +
                                   data.Rows[0]["citysname"].ToString() +
                                   data.Rows[0]["townname"].ToString();
                        }
                    }
                }
            }
            return "";
        }
    }
}