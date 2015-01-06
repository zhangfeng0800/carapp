using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Member
{
    public partial class TransMoney : System.Web.UI.Page
    {
        public int GroupID;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GroupID = new BLL.AdminBll().GetModel(User.Identity.Name).AdminGroupsId;
            }
        }
    }
}