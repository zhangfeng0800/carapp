using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Car
{
    public partial class carcurrentlocation : System.Web.UI.Page
    {
        public string vid = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["vid"]))
            {
                vid = Request.QueryString["vid"].ToString();
            }

        }
    }
}