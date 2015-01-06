using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.artical
{
    public partial class ArticalList : System.Web.UI.Page
    {
        public List<Model.Artical> articalTypes = new List<Model.Artical>();
        protected void Page_Load(object sender, EventArgs e)
        {
            articalTypes = BLL.ArticalBLL.GetArticalList(-1);
          
        }
    }
}