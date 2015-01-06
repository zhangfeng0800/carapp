using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Activity
{
    public partial class FundRulesEdit : System.Web.UI.Page
    {
        protected Model.FundRules rules;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["id"]!=null)
            {
                rules = new BLL.FundRulesBll().GetModel(Convert.ToInt32(Request.QueryString["id"]));
            }
        }
    }
}