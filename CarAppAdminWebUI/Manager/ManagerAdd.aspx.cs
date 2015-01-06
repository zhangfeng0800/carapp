using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Manager
{
    public partial class ManagerAdd : System.Web.UI.Page
    {
        protected string maxjobnumber;
        protected void Page_Load(object sender, EventArgs e)
        {
            maxjobnumber = new BLL.AdminBll().GetMaxJobnumber();
        }
    }
}