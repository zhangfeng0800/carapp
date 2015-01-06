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
    public partial class ResetPayPassword : PageBase.PageBase
    {
        protected string ErrorInfo = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            switch (Request.Form["Action"])
            {
                case "ChangePwd":
                    ModifyPassword();
                    break;
                case "PostVerifyCode":
                    PostMobileVerifyCode();
                    break;
                default:
                    break;
            }
        }

        private void ModifyPassword()
        {
            //验证码不存在
            if (Request.Cookies["VerifyCodeForMobile"] == null)
            {
                Response.Write("{\"Message\": \"请重新获取验证码！\"}");
                Response.End();
            }
            if (EncryptAndDecrypt.Encrypt(Request.Form["txtVerify"].ToUpper()) != Request.Cookies["VerifyCodeForMobile"].Value)
            {
                Response.Write("{\"Message\": \"验证码不匹配！\"}");
                Response.End();
            }
            userAccount.PayPassword = Common.EncryptAndDecrypt.Encrypt(Request.Form["payPassword"]);
            new BLL.UserAccountBLL().UpdateData(userAccount);
            Response.Write("{\"Message\": \"Complete\"}");
            Response.End();
        }

        private void PostMobileVerifyCode()
        {
            string content = Common.Tool.GetRandomCode(6, 0);
            SMS.user_ChangePassword(content, "支付", userAccount.Telphone);
            Response.SetCookie(new HttpCookie("VerifyCodeForMobile") { Value = EncryptAndDecrypt.Encrypt(content) });
            Response.Write("{\"Message\": \"Complete\"}");
            Response.End();
        }
    }
}