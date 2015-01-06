using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.ProvinceCity
{
    public partial class ChargeDescriptionEdit : System.Web.UI.Page
    {
        protected Model.ChargeDescription Charge;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["id"]!= null)
            {
                Charge = new BLL.ChargeDescriptionBll().GetModel(Convert.ToInt32(Request.QueryString["id"]));
            }
        }
    }
}