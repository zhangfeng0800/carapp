using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Air
{
    public partial class AirPlaneEdit : System.Web.UI.Page
    {
        private readonly AirPlaneBLL _airPlaneBll = new AirPlaneBLL();
        private readonly AirportBLL _airportBll = new AirportBLL();
        protected Model.AirPlane Model;
        protected string ProvinceId = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request["id"]);
            Model = _airPlaneBll.GetModel(id);
            ProvinceId = _airportBll.GetProvinceIdByAirPortName(Model.AirPortName);
        }
    }
}