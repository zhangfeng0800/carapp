using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;

namespace CarAppAdminWebUI.ProvinceCity
{
    public partial class ServiceCityHotLineEdit : BasePage
    {
        protected string ImgUrl = string.Empty;
        protected int Id = 0;
        private readonly ServiceCityBLL _serviceCityBll=new ServiceCityBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            string idStr = Request.QueryString["id"];
            int id;
            if (int.TryParse(idStr, out id))
            {
                var model = _serviceCityBll.GetModel(id);
                if (model == null)
                {
                    GoErrorPage();
                }
                else
                {
                    ImgUrl = model.imgUrl;
                    Id = model.id;
                }
            }
            else
            {
                GoErrorPage();
            }
        }
    }
}