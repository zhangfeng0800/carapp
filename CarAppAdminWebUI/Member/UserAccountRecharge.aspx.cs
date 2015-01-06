using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;

namespace CarAppAdminWebUI.Member
{
    public partial class UserAccountRecharge : BasePage
    {
        protected Model.UserAccount Model;
        private readonly UserAccountBLL _userAccountBll = new UserAccountBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            string idStr = Request.QueryString["id"];
            if (string.IsNullOrEmpty(idStr))
            {
                GoErrorPage();
            }
            Model = _userAccountBll.GetModel(Convert.ToInt32(idStr));
            if (Model == null)
            {
                GoErrorPage();
            }
        }
    }
}