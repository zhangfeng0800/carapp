using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Order
{
    public partial class AMapRentCar : System.Web.UI.Page
    {

        protected DataTable dtbrand = null;
        public string orderid = "";
        public string source = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            dtbrand = new BLL.CarBrandBLL().GetAllCarBrand();
            if (Request.QueryString["orderid"] != null)
            {
                orderid = Request.QueryString["orderid"]??"";
            }
            source = (new SystemBLL()).GpsSource();
        }

    }
}