using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Car
{
    public partial class CarRoute : System.Web.UI.Page
    {
        public string orderid = "";
        public string statusid = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            orderid = Request.QueryString["orderid"];
            statusid = Request.QueryString["statusid"];
        }
    }
}