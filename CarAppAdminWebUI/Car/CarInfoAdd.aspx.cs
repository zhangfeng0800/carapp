using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Car
{
    public partial class CarInfoAdd : System.Web.UI.Page
    {
        protected DataTable brands;
        protected void Page_Load(object sender, EventArgs e)
        {
            brands = new BLL.CarBrandBLL().GetAllCarBrand();
        }
    }
}