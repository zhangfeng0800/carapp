using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;

namespace CarAppAdminWebUI.Activity
{
    public partial class RechargeActivityEdit : System.Web.UI.Page
    {
        private readonly BLL.GiveMoney _giveMoney = new BLL.GiveMoney();
        protected Model.GiveMoney Model=new GiveMoney();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            Model = _giveMoney.GetModel(id);
        }
    }
}