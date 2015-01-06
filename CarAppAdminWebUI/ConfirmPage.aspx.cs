using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;
using Coupon = Model.Coupon;

namespace CarAppAdminWebUI
{
    public partial class ConfirmPage : System.Web.UI.Page
    {
        public Model.Orders OrderModel = new Orders();
        public string UserName = "";
        public string orderid = "";
        public string CarUseway = "";
        public RentCar _rentModel = new RentCar();
        public List<Model.Coupon> CouponList = new List<Coupon>();
        public string querystring = "";
        public bool ismutil = false;
        public int ordercount = 1;
        public DataTable dt;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["orderid"] != null && !string.IsNullOrEmpty(Request.QueryString["querystring"]))
            {

                var mutilbll = new MutilOrderBLL();
                ismutil = mutilbll.IsMultipleOrder(Request.QueryString["orderid"]);
                orderid = Request.QueryString["orderid"].ToString();

                OrderModel = (new OrderBLL()).GetModel(Request.QueryString["orderid"]);
                orderid = OrderModel.orderId;

                if (OrderModel != null)
                {
                    dt = new BLL.VouchersBll().GetUseVouchers(OrderModel.userID);
                    UserName = (new UserAccountBLL()).GetModel(OrderModel.userID).Compname;
                    _rentModel = (new RentCarBLL()).GetModel(OrderModel.rentCarID);
                    if (_rentModel != null)
                    {
                        var usewayModel = (new CarUseWayBLL()).GetCarUseWayModel(_rentModel.carusewayID);
                        if (usewayModel != null)
                        {
                            CarUseway = usewayModel.Name;
                        }
                    }
                }
                CouponList = BLL.Coupon.GetList(OrderModel.userID);
                querystring = Request.QueryString["querystring"];
                if (ismutil)
                {
                    ordercount = mutilbll.GetGroupIdCount(orderid);
                }
            }

        }


        public string GetCarType(int typeid)
        {
            return (new CarTypeBLL()).GetCarType(typeid);
        }
        public string GetTargetCity(string orderId)
        {
            var ordermodel = (new OrderBLL()).GetModel(orderId);
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
                        var countyid = model.countyId;
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

        public string GetStartCityInfo(int rentcarid)
        {
            var rentModel = (new RentCarBLL()).GetModel(rentcarid);
            var townid = rentModel.countyId.ToString();
            var data = (new CityBLL()).GetFullResult(townid);
            if (data.Rows.Count > 0)
            {
                return data.Rows[0]["provincename"].ToString() + data.Rows[0]["citysname"].ToString() +
                       data.Rows[0]["townname"].ToString();
            }
            return "";
        }

        public string GetTargetCityInfo(string orderId)
        {
            var orderModel = new OrderBLL().GetModel(orderid);
            if (orderModel != null)
            {
                var rentcarid = orderModel.rentCarID;
                var rentModel = (new RentCarBLL()).GetModel(rentcarid);
                var townid = "";
                if (rentModel.carusewayID == 6)
                {
                    var hotlineid = orderModel.targetCityID;
                    var hotModel = (new HotLineBLL()).GetModel(int.Parse(hotlineid));
                    townid = hotModel.countyId;
                }
                else
                {
                    townid = orderModel.targetCityID;
                }
                var data = (new CityBLL()).GetFullResult(townid);
                if (data.Rows.Count > 0)
                {
                    return data.Rows[0]["provincename"].ToString() + data.Rows[0]["citysname"].ToString() +
                           data.Rows[0]["townname"].ToString();
                }
                return "";
            }
            return "";
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
                var airportModel =
                (new AirportBLL()).GetModel(OrderModel.airportID);
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
    }
}