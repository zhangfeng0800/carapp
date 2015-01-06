using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace CarAppAdminWebUI.Order
{
    public partial class DownwindDeduction : System.Web.UI.Page
    {
        protected DataTable lotery;
        protected void Page_Load(object sender, EventArgs e)
        {
            lotery = new BLL.ActivitiesBLL().GetLotterySetting(3);
        }
    }
}