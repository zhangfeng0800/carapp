using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Activity
{
    public partial class FundingList : System.Web.UI.Page
    {
        protected int TotalMoney;
        protected List<Model.Admin> list;
        protected void Page_Load(object sender, EventArgs e)
        {
            TotalMoney = new BLL.FundingBll().GetFundingMoney(0);
            int count = 0;
            list =  new BLL.AdminBll().GetList(1, 20, "", out count);
        }
    }
}