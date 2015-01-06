using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class article : System.Web.UI.Page
    {
        private int id = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] == null || Request.QueryString["typeid"] == null)
            {
                Response.Redirect("/Default.aspx");
            }
            if (Request.QueryString["id"] != null)
            {
                int id = Convert.ToInt32(Request.QueryString["id"]);
            }
        }

        public string Substr(string content)
        {
            return content.Length >= 14 ? content.Substring(0, 14) : content;
        }
    }
}