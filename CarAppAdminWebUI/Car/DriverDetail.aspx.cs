using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;

namespace CarAppAdminWebUI.Car
{
    public partial class DriverDetail : BasePage
    {
        private readonly DirverAccountBLL _dirverAccountBll = new DirverAccountBLL();
        protected Model.DriverAccount Model;
        protected void Page_Load(object sender, EventArgs e)
        {
            string jobnumber = Request.QueryString["id"];
            if (string.IsNullOrEmpty(jobnumber))
            {
                GoErrorPage();
            }
            else
            {
                Model = _dirverAccountBll.GetModel(jobnumber);
                if (Model == null)
                {
                    GoErrorPage();
                }
            }
        }
    }
}