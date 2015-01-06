using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarAppAdminWebUI.Member
{
    public partial class UserMessageDetail : System.Web.UI.Page
    {
        public List<Model.userMessage> list;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                BLL.userMessageBLL _userMessageBll = new BLL.userMessageBLL();
                int id = Convert.ToInt32(Request.QueryString["id"]);
                List<Model.userMessage> listM = new List<Model.userMessage>();
                list = _userMessageBll.GetList_HeadQuestion(id, listM);
            }
        }
    }
}