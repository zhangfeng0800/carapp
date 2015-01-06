using System;
using System.Collections.Generic;
using System.Diagnostics.SymbolStore;
using System.Linq;
using System.Text;
using System.Web;

namespace WebApp.PageBase
{
    public class PageBase : System.Web.UI.Page
    {


        protected bool IsRedirect { get; set; }
        protected Model.UserAccount userAccount = new Model.UserAccount();
        public string Username { get; set; }
        public int IsLogined { get; set; }

        protected override void OnInit(EventArgs e)
        {
            if (Session["UserInfo"] == null)
            {
                Response.Redirect("~/login.aspx?returnVal=" +HttpContext.Current.Request.Url.ToString());
            }
            else
            {
                userAccount = Session["UserInfo"] as Model.UserAccount;
                IsLogined = 1;
                Username = userAccount.Compname;
            }
            base.OnInit(e);
        }
    }
}
