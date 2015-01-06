using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Member
{
    public partial class UserAccountDetail : System.Web.UI.Page
    {
        private UserAccountBLL _userAccountBll = new UserAccountBLL();
        protected Model.UserAccount UserModel;
        protected Model.Restrict ResModel = null;
        protected int FundingMoney = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            string idStr = Request.QueryString["id"];
            if (string.IsNullOrEmpty(idStr))
            {
                ShowError();
            }
            else
            {
                int id = Convert.ToInt32(idStr);
                UserModel = _userAccountBll.GetModel(id);
                FundingMoney = new BLL.FundingBll().GetFundingMoney(id);
                if (UserModel == null)
                {
                    ShowError();
                }
            }
        }

        private void ShowError()
        {
            Server.Transfer("/Error.aspx");
        }

        protected string GetUserType(int? userType)
        {
            if (userType == null)
            {
                return "未知";
            }
            string[] types = {"集团管理员", "部门管理员", "集团员工", "个人会员"};
            return types[(int) userType];
        }
    }
}