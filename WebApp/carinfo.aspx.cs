using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class carinfo : System.Web.UI.Page
    {
        public Model.carBrand car_Brand = new Model.carBrand();

        protected void Page_Load(object sender, EventArgs e)
        {
            int cbid = Common.Tool.GetInt(Request.QueryString["id"]);
            if (cbid == 0)
            {
                Response.Redirect("default.aspx", true);
            }
            car_Brand = new BLL.CarBrandBLL().GetModelCarBrand(cbid);
        }
    }
}