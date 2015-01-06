using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;

namespace WebApp
{
    public partial class forgetpwd : System.Web.UI.Page
    {
        BLL.UserAccountBLL TempBLL = new UserAccountBLL();

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
                case "CheckVerifyCode":
                    CheckVerifyCode();
                    break;
                case "Exist_Telphone":
                    Exist_Telphone();
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
            if (EncryptAndDecrypt.Encrypt(Request.Form["txtmobile"] + Request.Form["txtVerify"].ToUpper()) != Request.Cookies["VerifyCodeForMobile"].Value)
            {
                Response.Write("{\"Message\": \"验证码不匹配！\"}");
                Response.End();
            }
            Model.UserAccount userThis = new BLL.UserAccountBLL().GetModel(Request.Form["txtmobile"]);
            userThis.Password = Common.EncryptAndDecrypt.Encrypt(Request.Form["password"]);
            new BLL.UserAccountBLL().UpdateData(userThis);
            Response.Write("{\"Message\": \"Complete\"}");
            Response.End();
        }

        private void CheckVerifyCode()
        {
            //验证码不存在
            if (Request.Cookies["VerifyCodeForMobile"] == null)
                Response.Write("False");
            else
            {
                //验证码错误
                if (EncryptAndDecrypt.Encrypt(Request.Form["txtmobile"] + Request.Form["txtVerify"].ToUpper()) != Request.Cookies["VerifyCodeForMobile"].Value)
                    Response.Write("False");
                else
                    Response.Write("True");
                //验证码正确
            }
            Response.End();
        }

        private void Exist_Telphone()
        {
            if (TempBLL.Exits_Telphone(Request.Form["txtmobile"]))
                Response.Write("True");
            else
                Response.Write("False");
            Response.End();
        }

        private void PostMobileVerifyCode()
        {
            string mobile = Common.Tool.GetString(Request.Form["Value"]);
            if (!TempBLL.Exits_Telphone(mobile))
            {
                Response.Write("{\"Message\": \"不存在的手机号码\"}");
                Response.End();
            }
            string content = Common.Tool.GetRandomCode(6,0);
            SMS.user_ChangePassword(content, "登录", mobile);
            HttpContext.Current.Response.Cookies.Add(new HttpCookie("VerifyCodeForMobile", EncryptAndDecrypt.Encrypt(Common.Tool.GetString(Request.Form["Value"]) + content)));
            Response.Write("{\"Message\": \"Complete\"}");
            Response.End();
        }

        protected void Output(string ParStr)
        {
            Response.Write(ParStr);
            Response.End();
        }
    }
}