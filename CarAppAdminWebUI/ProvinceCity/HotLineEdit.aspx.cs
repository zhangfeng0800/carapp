using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;
using Model;

namespace CarAppAdminWebUI.ProvinceCity
{
    public partial class HotLineEdit : BasePage
    {
        private readonly HotLineBLL _hotLineBll = new HotLineBLL();
        protected hotLine model;
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            model = _hotLineBll.GetModel(id);
            if (model == null)
            {
                GoErrorPage();
            }
        }
    }
}