using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Order
{
    public partial class MapResentCar : System.Web.UI.Page
    {
        public string orderid;
        public string source;
        protected void Page_Load(object sender, EventArgs e)
        {
            orderid = Request["orderid"].ToString();

            source = (new SystemBLL()).GpsSource();
        }
    }
}