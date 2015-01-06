using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Car
{
    public partial class CarInfoList : System.Web.UI.Page
    {
        protected DataTable dtbrand = null;
        protected int groupId;
        protected void Page_Load(object sender, EventArgs e)
        {
            dtbrand = new BLL.CarBrandBLL().GetAllCarBrand();
            groupId = new BLL.AdminBll().GetModel(User.Identity.Name).AdminGroupsId;

        }
    }
}