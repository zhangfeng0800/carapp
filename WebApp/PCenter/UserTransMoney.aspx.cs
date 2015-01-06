using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.PCenter
{
    public partial class UserTransMoney : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var user = Session["UserInfo"] as Model.UserAccount;
                if (user.isvip != "是")
                {
                    Response.Write("您无权限访问此页面");
                    Response.End();
                }
            }
            catch (Exception)
            {
                Response.Write("您无权限访问此页面");
                Response.End();
            }
           
        }
    }
}