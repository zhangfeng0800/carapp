using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Car
{
    public partial class DriverList : System.Web.UI.Page
    {
        protected int DriverCount;
        protected int DriverLoginCount;
        protected void Page_Load(object sender, EventArgs e)
        {
            DriverCount = new BLL.DirverAccountBLL().GetList().Count;
            DriverLoginCount = new BLL.CarInfoBLL().GetList("driverId<>0").Count;
        }
    }
}