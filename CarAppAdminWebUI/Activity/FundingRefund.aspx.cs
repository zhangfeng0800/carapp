using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Activity
{
    public partial class FundingRefund : System.Web.UI.Page
    {
        protected DataTable fundingDt;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["id"]!=null)
            {
                fundingDt = new BLL.FundingBll().GetDataTable(Convert.ToInt32(Request.QueryString["id"]));
            }
        }
    }
}