using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Activity
{
    public partial class OrderLotterySetting : System.Web.UI.Page
    {
        public DataTable data;
        protected void Page_Load(object sender, EventArgs e)
        {
            data = new BLL.ActivitiesBLL().GetLotterySetting(int.Parse(Request.QueryString["id"].ToString()));
        }
    }
}