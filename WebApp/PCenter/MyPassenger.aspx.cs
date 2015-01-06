using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.PCenter
{
    public partial class MyPassenger : PageBase.PageBase
    {
        protected List<Model.ContactPerson> passengers = new List<Model.ContactPerson>();
        protected void Page_Load(object sender, EventArgs e)
        {
            passengers = new BLL.ContactPerson().GetList(userAccount.Id).OrderByDescending(s=>s.Id).ToList();
        }
    }
}