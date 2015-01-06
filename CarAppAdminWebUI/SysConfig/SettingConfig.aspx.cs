using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace CarAppAdminWebUI.SysConfig
{
    public partial class SettingConfig : System.Web.UI.Page
    {
        public Settings model=new Settings();
        protected void Page_Load(object sender, EventArgs e)
        {
            model = (new SettingBLL()).GetModel();
            if (Request["action"] == "update")
            {
                var title = Request["title"];
                var description = Request["description"];
                var keywords = Request["keywords"];
                var icp = Request["icp"];
                var copyright = Request["copyright"];
                model.PageTitle = title;
                model.PageKeywords = keywords;
                model.PageDescription = description;
                model.ICP = icp;
                model.CopyRight = copyright;
                (new SettingBLL()).SettingConfig(model);
            }
        }
    }
}