using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class spotInfo : System.Web.UI.Page
    {
        public Model.hotLine hot_Line = new Model.hotLine();

        protected void Page_Load(object sender, EventArgs e)
        {
            int HLid = Common.Tool.GetInt(Request.QueryString["id"]);
            if (HLid == 0)
            {
                Response.Redirect("default.aspx", true);
            }
            hot_Line = new BLL.HotLineBLL().GetModel(HLid);
        }
    }
}