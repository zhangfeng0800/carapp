using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Manager
{
    public partial class ManagerEdit : System.Web.UI.Page
    {
        private readonly AdminBll _adminBll=new AdminBll(); 
        protected Model.Admin Model;
        protected string maxjobnumber;
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            Model = _adminBll.GetModel(id);
            maxjobnumber = new BLL.AdminBll().GetMaxJobnumber();
        }
    }
}