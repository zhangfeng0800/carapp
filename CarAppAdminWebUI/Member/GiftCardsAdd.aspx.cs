using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;

namespace CarAppAdminWebUI.Member
{
    public partial class GiftCardsAdd : System.Web.UI.Page
    {
        public int numberMax;
        public List<Model.SalesMan> list;
        protected void Page_Load(object sender, EventArgs e)
        {
            numberMax = new BLL.GiftCards().GetMaxNumber()+1;
            int count = 0;
            list = new BLL.SalesManBll().GetPageList(" State='正常' ", 100, 1, out count);
        }
    }
}