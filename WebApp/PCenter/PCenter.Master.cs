using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;

namespace WebApp.PCenter
{
    public partial class PersonCenter : System.Web.UI.MasterPage
    {
        protected Model.Popedom Pope = new Popedom();
        public bool redirectMaster = true;
        public int IsHideFunding;
        protected void Page_Load(object sender, EventArgs e)
        {
            Model.UserAccount MasterPageUser = new Model.UserAccount();
            if (Session["UserInfo"] == null)
            {
                Response.Redirect("~/login.aspx?From=" + Common.Tool.StrUrlConvert(HttpContext.Current.Request.Url.ToString()));
            }
            else
            {
                MasterPageUser = Session["UserInfo"] as Model.UserAccount;
                string[] pathArray = Request.Url.Segments;
                if (Common.Tool.GetString(MasterPageUser.PayPassword) == "" && pathArray[pathArray.Length - 1] != "AddPayPassword.aspx")
                    Response.Redirect("AddPayPassword.aspx");
                Pope = MasterPageUser.Popedom;
                IsHideFunding = MasterPageUser.IsHideFunding;
                if (!redirectMaster)
                {
                    Response.Redirect("MyOrders.aspx",true);
                }
            }
        }
    }
}