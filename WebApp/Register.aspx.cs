using System;
using System.Web;
using System.Web.Security;
using BLL;
using Common;
using System.IO;
using System.Net;
using System.Text;

namespace WebApp
{
    public partial class Register : System.Web.UI.Page
    {
        BLL.UserAccountBLL TempBLL = new UserAccountBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            switch (Request.Form["Action"])
            {
                case "PostVerifyCode":
                    PostMobileVerifyCode();
                    break;
                case "CheckVerifyCode":
                    CheckVerifyCode();
                    break;
                case "Exist_Telphone":
                    Exist_Telphone();
                    break;
                case "Exist_Username":
                    Exist_Username();
                    break;
                case "Exist_Email":
                    Exist_Email();
                    break;
            }
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

        private void Exist_Username()
        {
            if (TempBLL.Exits_Username(Request.Form["username"]))
                Response.Write("True");
            else
                Response.Write("False");
            Response.End();
        }

        private void Exist_Email()
        {
            if (TempBLL.Exits_Email(Request.Form["txtemail"]))
                Response.Write("True");
            else
                Response.Write("False");
            Response.End();
        }

        private void PostMobileVerifyCode()
        {
            string mobile = Common.Tool.GetString(Request.Form["Value"]);
            if (TempBLL.Exits_Telphone(mobile))
            {
                Response.Write("{\"Message\": \"手机号码已存在\"}");
                Response.End();
            }
            string content = Common.Tool.GetRandomCode(6,0);
            HttpContext.Current.Response.Cookies.Add(new HttpCookie("VerifyCodeForMobile", EncryptAndDecrypt.Encrypt(Common.Tool.GetString(Request.Form["Value"]) + content)));
            Common.SMS.user_Register(content, mobile);
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