using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace CarAppAdminWebUI
{
    public partial class Main : System.Web.UI.Page
    {
        protected DataTable DefaultData;
        protected void Page_Load(object sender, EventArgs e)
        {
    
            var adminBll = new AdminBll();
            DefaultData = adminBll.GetDefalutData();
          

        }

    }
}