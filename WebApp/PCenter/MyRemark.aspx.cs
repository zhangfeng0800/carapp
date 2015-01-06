using System;
using System.Collections.Generic;
using Common;
using Model;
using BLL;

namespace WebApp.PCenter
{
    public partial class MyRemark : PageBase.PageBase
    {
        protected string carUseWayStr = "";
        protected string carTypeStr = "";
        protected Model.Coupon couponThis = new Model.Coupon();
        protected Model.OrdersExtInfo orderExt = new Model.OrdersExtInfo();

        protected Model.Orders orderThis = new Model.Orders();
        protected RentCarBLL RCB = new RentCarBLL();
        protected CarUseWayBLL CUWB = new CarUseWayBLL();
        protected Model.Remark remarkContent = new Model.Remark();
        protected Model.OrderInvoice thisInvo = new OrderInvoice();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["orderId"] == null)
            {
                Response.Redirect("/PCenter/MyAppraise.aspx");
            }

            orderThis = new OrderBLL().GetModel(Request.QueryString["orderId"]);
            if (orderThis == null)
                Response.Redirect("MyAppraise.aspx", true);
            if (orderThis.userID != userAccount.Id)
                Response.Redirect("MyAppraise.aspx", true);
            orderExt = new BLL.OrdersExtInfo().GetModel(orderThis.orderId);
            if (orderExt == null)
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
            Model.RentCar rentCarThis = new BLL.RentCarBLL().GetModel(orderThis.rentCarID);
            carUseWayStr = new BLL.CarUseWayBLL().GetCarUseWayModel(rentCarThis.carusewayID).Name;
            carTypeStr = new BLL.CarTypeBLL().GetCarType(rentCarThis.carTypeID);
            couponThis = BLL.Coupon.GetByOrderId(orderThis.orderId);
            //if (orderThis.isreceipts != 0)
            //{
            //    thisInvo = new BLL.InvoiceBLL().GetModel(orderThis.isreceipts);
            //}

            if (Convert.ToInt32(orderThis.isreceipts) != 0 || Convert.ToInt32(orderThis.invoiceID) != 0)//发票标识可能存在isreceipts字段或invoiceID字段，所以都要判断
            {   //订单已经绑定发票
                thisInvo = new BLL.OrderInvoiceBll().GetModel(orderThis.orderId);
            }
            CityModel departureCity = new CityBLL().GetModel(Convert.ToInt32(orderThis.departureCityID));
            DateTime nowTime = DateTime.Now;
            if (orderThis.orderStatusID == 1)
            {
                RentCar rentCar = new RentCarBLL().GetModelbyID(orderThis.rentCarID);
                DateTime userCarTime = new DateTime();
                if (rentCar.carusewayID == 1)//接机
                    userCarTime = orderThis.pickupTime;
                else
                    userCarTime = orderThis.departureTime;
            }
            remarkContent.Score = 5;
            if (new BLL.Remark().GetModel(Request.QueryString["orderId"]) != null)
            {
                remarkContent = new BLL.Remark().GetModel(Request.QueryString["orderId"]);
            }
        }
    }
}