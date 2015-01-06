using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.twicepay
{
    public partial class HandleUpmp : System.Web.UI.Page
    {
        public string paydata;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["paydata"] == null)
            {
                Response.Redirect("/twicepay/error.aspx");
            }
            else
            {
                paydata = Session["paydata"].ToString();
                Session["paydata"] = null;
            }
        }
    }
}