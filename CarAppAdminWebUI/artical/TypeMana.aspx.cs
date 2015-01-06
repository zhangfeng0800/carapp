using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.artical
{
    public partial class TypeMana : System.Web.UI.Page
    {
        public Model.Artical artical = new Model.Artical();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["typeID"] != null)
            {
                int typeID =Convert.ToInt32(Request.QueryString["typeID"]);
                artical = BLL.ArticalBLL.getArticalByID(typeID);
            }
        }
    }
}