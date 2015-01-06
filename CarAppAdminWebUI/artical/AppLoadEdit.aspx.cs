using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;

namespace CarAppAdminWebUI.artical
{
    public partial class AppLoadEdit : System.Web.UI.Page
    {
        protected Model.AppLoad appLoad = new AppLoad();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["id"] !=null)
            {
                int id = Convert.ToInt32(Request.QueryString["id"]);
                appLoad = new BLL.AppLoadBll().GetModel(id);
            }
        }
    }
}