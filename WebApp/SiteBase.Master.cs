using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace WebApp
{
    public partial class SiteBase : System.Web.UI.MasterPage
    {
        public string Username { get; set; }
        public int IsLogined { get; set; }
        protected bool IsRedirect { get; set; }
        protected Model.UserAccount userAccount = new Model.UserAccount();
        protected string Doc = "PCenter";
        protected override void OnInit(EventArgs e)
        {
            if (Session["UserInfo"] == null)
            {
                IsLogined = 0;
                Username = "游客";
              
            }
            else
            {
                userAccount = Session["UserInfo"] as Model.UserAccount;
                IsLogined = 1;
                Username = userAccount.Compname;
                //if (userAccount.Type != 3)
                //{
                //    Doc = "CompanyCenter";
                //}
            }
            base.OnInit(e);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
          
 
        }
    }
}