using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model.Ext;

namespace WebApp.PCenter
{
    public partial class AuthorizeUser : PageBase.PageBase
    {
        protected List<Model.Ext.userAccountExt> userList = new List<userAccountExt>();

        protected void Page_Load(object sender, EventArgs e)
        {
            PersonCenter pCenter = (PersonCenter)this.Master;
            pCenter.redirectMaster = userAccount.Popedom.AuthorizeUserPage;//权限判断
            if (Request.Form["Action"] == "SetStatus")//设置用户状态，启用或失效
            {
                Model.UserAccount user = new BLL.UserAccountBLL().GetModel(Convert.ToInt32(Request.Form["Value"]));
                if (user.Pid == userAccount.Id || new BLL.UserAccountBLL().GetMaster(user.Id).Id == userAccount.Id)
                {
                    Model.Restrict rest = new BLL.RestrictBLL().GetModel(user.Id);//获取限制
                    if(rest != null)
                    {
                        new BLL.RestrictBLL().UpdateStatus(user.Id, rest.Status == 1 ?"0":"1");//设置启用或失效
                    }
                    Response.Write("{\"Message\":\"success\"}");
                }
                else
                {
                    Response.Write("{\"Message\":\"failure\"}");
                }
                Response.End();
            }
            userList = new BLL.UserAccountBLL().GetExtList(new UserAccountBLL().GetSubIdArrayStr(userAccount.Id));//获取用户列表
        }
    }
}