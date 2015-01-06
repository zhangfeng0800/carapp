using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using Common;

namespace WebApp.PCenter
{
    public partial class AddPayPassword : PageBase.PageBase
    {
        protected string ErrorInfo = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Common.Tool.GetString(userAccount.PayPassword) != "")
            {
                Response.Redirect("MyOrders.aspx",true);
            }
            if (Request.Form["action"] == "SubmitNewPW")
            {
                Model.UserAccount thisUserAccount = new BLL.UserAccountBLL().GetModel(userAccount.Id);
                if (Request.Form["newPW"] != Request.Form["confirmPW"])
                {
                    Response.Write("{\"Message\":\"两次输入的密码不一致！\"}");
                    Response.End();
                }
                thisUserAccount.PayPassword = EncryptAndDecrypt.Encrypt(Request.Form["newPW"]);
                new BLL.UserAccountBLL().UpdateData(thisUserAccount);
                Session["UserInfo"] = thisUserAccount;
                Response.Write("{\"Message\":\"Success\"}");
                Response.End();
            }
        }
    }
}