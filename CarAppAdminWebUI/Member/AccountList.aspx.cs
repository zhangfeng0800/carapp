using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Member
{
    public partial class AccountList : System.Web.UI.Page
    {
        public DataTable Data = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            Data = (new AccountBLL()).GetAccountUser();
        }
    }
}