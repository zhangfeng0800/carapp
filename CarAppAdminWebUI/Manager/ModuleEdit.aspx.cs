using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Manager
{
    public partial class ModuleEdit : System.Web.UI.Page
    {
        public string ModuleName;
        public Model.Module model;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var modelbll = new ModuleBLL();
                var id = int.Parse(Request.QueryString["id"]);
                model = (new ModuleBLL()).GetModel(id);
                if (model != null)
                {
                    var parentModule = modelbll.GetModel(model.ParentId);
                    if (model.ParentId == 0)
                    {
                        ModuleName = "顶级模块";
                    }
                    else
                    {
                        ModuleName = parentModule.ModuleName;
                    }

                }
            }
        }

        public string GetChecked(int val)
        {
            return val == 1 ? "checked" : "";

        }
    }
}