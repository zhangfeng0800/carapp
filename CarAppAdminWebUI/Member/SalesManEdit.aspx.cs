using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Member
{
    public partial class SalesManEdit : System.Web.UI.Page
    {
        public Model.SalesMan model;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["Id"]!= null)
            {
                model = new BLL.SalesManBll().GetModel(Convert.ToInt32(Request.QueryString["Id"]));
            }
        }
    }
}