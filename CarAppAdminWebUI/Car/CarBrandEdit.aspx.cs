using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Car
{
    public partial class CarBrandEdit : System.Web.UI.Page
    {
        private readonly CarBrandBLL _carBrandBll = new CarBrandBLL();
        protected Model.carBrand Model;
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            Model = _carBrandBll.GetModelCarBrand(id);
        }
    }
}