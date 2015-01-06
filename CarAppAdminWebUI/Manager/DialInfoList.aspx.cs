using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Manager
{
    public partial class DialInfoList : System.Web.UI.Page
    {
        public string AdminName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            var adminModel = new AdminBll().GetModel(User.Identity.Name);
            AdminName = adminModel == null ? "0" : adminModel.AdminId.ToString();
        }
    }
}