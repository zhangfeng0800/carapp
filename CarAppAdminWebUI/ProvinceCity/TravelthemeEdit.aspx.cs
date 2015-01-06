using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace CarAppAdminWebUI.ProvinceCity
{
    public partial class TravelthemeEdit : System.Web.UI.Page
    {
        protected TravelTheme Model=new TravelTheme();
        private readonly TravelthemeBll _travelthemeBll=new TravelthemeBll();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            Model = _travelthemeBll.GetModel(id);
        }
    }
}