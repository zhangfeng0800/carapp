using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;

namespace CarAppAdminWebUI.Air
{
    public partial class AirPortEdit : BasePage
    {
        protected Model.AirPort Model;
        private readonly AirportBLL _airportBll = new AirportBLL();
        private readonly CityBLL _cityBll = new CityBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request["id"]);
            Model = _airportBll.GetModel(id);
        }
    }
}