using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Member
{
    public partial class UserHobbyEdit : System.Web.UI.Page
    {
        public Model.UserHobby Hobby;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["id"] != null)
            {
                int id = Convert.ToInt32(Request.QueryString["id"]);
                Hobby = new BLL.UserHobbyBll().GetModel(id);
            }
        }
    }
}