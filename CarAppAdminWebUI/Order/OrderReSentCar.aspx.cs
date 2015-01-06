using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace CarAppAdminWebUI.Order
{
    public partial class OrderReSentCar : System.Web.UI.Page
    {
        protected string carTypeId = string.Empty;
        private readonly RentCarBLL _rentCarBll = new RentCarBLL();
        private readonly CarTypeBLL _carTypeBll = new CarTypeBLL();
        protected List<CarType> list = new List<CarType>();
        protected DataTable orderModel = new DataTable();
        public DataTable cityInfo;
        public string startplace;
        public string carName;
        public string drivername;
        protected void Page_Load(object sender, EventArgs e)
        {
            list = _carTypeBll.GetList();
            string rentcarid = Request.QueryString["rentcarid"];
            if (!string.IsNullOrEmpty(rentcarid))
            {
                int id = Convert.ToInt32(rentcarid);
                var model = _rentCarBll.GetModel(id);
                if (model != null)
                {
                    carTypeId = model.carTypeID.ToString();
                }
            }
            var orderid = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
            int hascanel = 0;
            int hasext = 0;
            int hasinvoice = 0;
            int hascoupon = 0;
            int hasremark = 0;

            orderModel = (new OrderBLL()).GetDriverOrdetail(orderid, out hascanel, out hasext, out hasinvoice,
                out hascoupon, out hasremark);
            startplace = orderModel.Rows[0]["startprovincename"].ToString().Trim() +
                         orderModel.Rows[0]["startcityname"].ToString().Trim() + orderModel.Rows[0]["starttownname"].ToString().Trim();
            if (orderModel.Rows.Count == 0)
            {
                orderModel = new DataTable();
            }
            cityInfo = (new CityBLL()).GetCarCity();
            carName = orderModel.Rows[0]["carNameAndNo"].ToString();
            drivername = string.IsNullOrEmpty(orderModel.Rows[0]["driverName"].ToString())
                ? "暂无司机"
                : orderModel.Rows[0]["driverName"].ToString();
        }
    }
}