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
    public partial class CityEdit : BasePage
    {
        private readonly CityBLL _cityBll=new CityBLL();
        protected CityModel Model;
        protected void Page_Load(object sender, EventArgs e)
        {
            string idStr = Request.QueryString["id"];
            if (string.IsNullOrEmpty(idStr))
            {
                GoErrorPage();
            }
            int id;
            if (!int.TryParse(idStr, out id))
            {
                GoErrorPage();
            }
            Model = _cityBll.GetModel(id);
            if (Model == null)
            {
                GoErrorPage();
            }
        }
    }
}