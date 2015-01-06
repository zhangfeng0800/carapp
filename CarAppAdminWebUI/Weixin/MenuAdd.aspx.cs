using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;

namespace CarAppAdminWebUI.Weixin
{
    public partial class MenuAdd1 : System.Web.UI.Page
    {
        public WxMenu wxmenu = new WxMenu();
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["id"] != null)
            {
                try
                {
                    wxmenu = new BLL.WxMenuBLL().GetModel(Convert.ToInt32(Request.QueryString["id"]));
                }
                catch (Exception)
                {
                    Response.Write("未知错误！");
                    Response.End();
                }

            }
        }
    }
}