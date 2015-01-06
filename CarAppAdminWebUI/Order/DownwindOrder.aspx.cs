using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BLL;

namespace CarAppAdminWebUI.Order
{
    public partial class DownwindOrder : System.Web.UI.Page
    {
        public DataTable CarType = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            CarType = (new CarTypeBLL()).GetDataTable();
        }
    }
}