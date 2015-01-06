using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Com;
using Common;
using Model;

namespace WebApp.PCenter
{
    public partial class MyInfo : PageBase.PageBase
    {
        BLL.UserAccountBLL TempBLL = new UserAccountBLL();
        public  Model.UserAccount thisUserAccount = new UserAccount();
        protected void Page_Load(object sender, EventArgs e)
        {
            
            switch (Request.Form["Action"])
            {
                case "PostVerifyCode"://获取短信验证码（只有在修改手机号码时用到）
                    PostMobileVerifyCode();
                    break;
                case "Submit"://提交修改
                    MyInfoSubmit();
                    break;
                default:
                    thisUserAccount = TempBLL.GetModel(userAccount.Id);
                    break;
            }
            if (Common.Tool.GetString(userAccount.headPic) == "")
                thisUserAccount.headPic = "/headPic/HeadPic.gif";
        }

        private void MyInfoSubmit()
        {
            string username = Common.Tool.GetString(Request.Form["Username"]);
            if (string.IsNullOrEmpty(Request.Form["Name"]))
            {
                Response.Write("{\"Message\": \"请输入真实姓名\"}");
                Response.End();
            }
            if (TempBLL.Exits_Username(username) && username != userAccount.Username)
            {
                Response.Write("{\"Message\": \"该昵称已存在，请修改！\"}");
                Response.End();
            }
            string userEmail = Common.Tool.GetString(Request.Form["email"]);
            if (TempBLL.Exits_Email(userEmail) && userAccount.Email != userEmail && userEmail != "")
            {
                Response.Write("{\"Message\": \"该邮箱地址已存在，请修改！\"}");
                Response.End();
            }
            BLL.UserAccountBLL UAB = new BLL.UserAccountBLL();
            Model.UserAccount userThis = UAB.GetModel(userAccount.Id);
            if (Common.Tool.GetString(Request.Form["Value"]) != userThis.Telphone)//电话号码已改变
            {
                string EncryptStr = EncryptAndDecrypt.Encrypt(Common.Tool.GetString(Request.Form["Value"]) + Request.Form["VerifyCode"].ToUpper());
                if (Request.Cookies["VerifyCodeForMobile"] == null)
                {
                    Response.Write("{\"Message\": \"请重新获取验证码！\"}");
                    Response.End();
                }
                if (Request.Cookies["VerifyCodeForMobile"].Value != EncryptStr)
                {
                    Response.Write("{\"Message\": \"验证码不匹配！\"}");
                    Response.End();
                }
                userThis.Telphone = Common.Tool.GetString(Request.Form["Value"]);
            }
            userThis.Compname = Common.Tool.GetString(Request.Form["Name"]);
            userThis.Email = Common.Tool.GetString(Request.Form["email"]);
            userThis.headPic = Common.Tool.GetString(Request.Form["headPic"]);
            if (userThis.headPic.Substring(0, 7) == "headPic")
            {
                userThis.headPic = Request.Url.Scheme + "://" + Request.Url.Authority + "/" + userThis.headPic;
            }
            userThis.Username = username;
            userThis.sex = Common.Tool.GetBoolNull(Request.Form["Sex"]);
            UAB.UpdateData(userThis);//提交修改
            Session["UserInfo"] = userThis;
            Response.Write("{\"Message\": \"Complete\"}");
            Response.End();
        }

        private void PostMobileVerifyCode()
        {
            string mobile = Request.Form["Value"];
            if (userAccount.Telphone == mobile)
            {
                Response.Write("{\"Message\": \"手机号码未改变，请勿获取验证码！\"}");
                Response.End();
            }
            if (TempBLL.Exits_Telphone(mobile))
            {
                Response.Write("{\"Message\": \"手机号码已存在，请更换为其他手机号码！\"}");
                Response.End();
            }
            string content = Common.Tool.GetRandomCode(6, 0);
            Common.SMS.user_ChangeMobile(content, mobile);
            string EncryptStr = EncryptAndDecrypt.Encrypt(Common.Tool.GetString(mobile + content.ToUpper()));
            Response.SetCookie(new HttpCookie("VerifyCodeForMobile") { Value = EncryptStr });
            Response.Write("{\"Message\": \"Complete\"}");
            Response.End();
        }
    }
}