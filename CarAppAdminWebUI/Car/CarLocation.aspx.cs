using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace CarAppAdminWebUI.Car
{
    public partial class CarLocation : System.Web.UI.Page
    {
        protected DataTable dtbrand = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            dtbrand = new BLL.CarBrandBLL().GetAllCarBrand();
        }
    }
}