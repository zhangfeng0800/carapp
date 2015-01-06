using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class PC_TwicePaySuccess : System.Web.UI.Page
    {
        protected string orderid = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            orderid = Request.QueryString["orderid"];
            if (orderid.Contains("_"))
            {
                orderid = orderid.Split('_')[0];
            }
        }
    }
}