using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace WebApp.PCenter
{
    public partial class MyAddress  : PageBase.PageBase
    {
        protected List<Model.userAddress> address = new List<Model.userAddress>();
        protected int pageSize = 10;
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
    }
}