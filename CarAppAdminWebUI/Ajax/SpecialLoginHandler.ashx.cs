using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using System.Web.Security;
using IEZU.Log;
using Common;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// SpecialLoginHandler 的摘要说明
    /// </summary>
    public class SpecialLoginHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            var action = context.Request["action"];
            var httpCookie = context.Request.Cookies["VerifyCode"];

            //检验输入验证码是否正确 
            if (!string.IsNullOrEmpty(action) && action == "checkCode")
            {
                var code = context.Request["code"].ToString();
                context.Response.Write(code.ToLower() != httpCookie.Value.ToLower() ? "Failure" : "Success");
                return;
            }
            var _adminBll = new BLL.AdminBll();
            if (context.Request["AdminName"] != null)
            {

                if (httpCookie == null || context.Request["txt_verifycode"].ToString().ToLower() != httpCookie.Value.ToLower())
                {
                    //ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('验证码错误')", true);
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "验证码错误" }));
                    return;
                }
                string adminName = context.Request["AdminName"].ToString();
                string adminPassword = Common.EncryptAndDecrypt.Encrypt(context.Request["AdminPassword"].ToString());
                if (string.IsNullOrEmpty(adminName))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "用户名不能为空" })); //用户名不能为空 
                    return;
                }
                if (string.IsNullOrEmpty(adminPassword))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "用户密码不能为空" })); //用户密码不能为空 
                    return;
                }
                var adminModel = _adminBll.GetModel(adminName);
                if (adminModel == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "用户密码错误" })); //用户密码错误 );
                    return;
                }
                if (adminModel.IsDelete == 1)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "用户已被删除" })); //用户密码错误 );
                    return;
                }
                var isLogin = _adminBll.IsLogin(adminName, adminPassword);
                if (isLogin)
                {
                    FormsAuthentication.SetAuthCookie(adminName, false);
                    context.Response.Cookies.Add(new HttpCookie("exten", ""));
                    LogHelper.WriteOperation("后台登录", OperationType.Login, "登录成功", adminName);
                    context.Response.Write(JsonConvert.SerializeObject(new {ResultCode = 1, Msg = "成功!"}));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "登录失败" })); //用户密码错误 );
                    return;
                }
              
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}