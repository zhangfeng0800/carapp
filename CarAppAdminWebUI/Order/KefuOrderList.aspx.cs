using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Order
{
    public partial class KefuOrderList : System.Web.UI.Page
    {
        public string username = "";
        public string exten = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["username"]!=null)
            {
                username = Request.QueryString["username"];
            }
            if(Request.QueryString["exten"]!=null)
            {
                exten = Request.QueryString["exten"];
            }
        }
    }
}