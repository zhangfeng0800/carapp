using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace CarAppAdminWebUI.Member
{
    public partial class LevelEdit : System.Web.UI.Page
    {
        protected Level Model;
        private readonly LevelBLL _levelBll=new LevelBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = int.Parse(Request.QueryString["id"]);
            Model = _levelBll.GetModel(id);
        }
    }
}