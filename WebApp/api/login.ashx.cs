using System;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;


namespace WebApp.api
{
    /// <summary>
    /// login 的摘要说明
    /// </summary>
    public class login : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new BLL.UserAccountBLL();
            if (context.Request.Form["verifycode"] == null)
            {
                LogHelper.WriteOperation("验证码没有输入", OperationType.Login, "登录失败");
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.EMPTYVERIFYCODE, StatusCode = StatusCode.请输入验证码 }));
            }
            else
            {
                var httpCookie = context.Request.Cookies["VerifyCode"];
                if (httpCookie != null && context.Request.Form["verifycode"].ToLower() == httpCookie.Value.ToLower())
                {
                    if (context.Request.Form["username"] != null && context.Request.Form["password"] != null)
                    {
                        string username = context.Request.Form["username"];
                        string password = context.Request.Form["password"];
                        Model.UserAccount LogUser = new UserAccount();
                        LogUser = bll.LoginByTelphone(username, password);

                        if (LogUser != null)
                        {
                            if (LogUser.IsBlack == "是")
                            {
                                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.ISBLACK, StatusCode = StatusCode.请求失败 }));
                                return;
                            }

                            LogUser.lastTime = DateTime.Now;
                            LogUser.lastIP = context.Request.UserHostAddress;
                            if (LogUser.Type == 1 || LogUser.Type == 2)//是集团下属用户
                            {
                                RestrictBLL RB = new RestrictBLL();
                                Restrict restLogUser = RB.GetModel(LogUser.Id);
                                if (restLogUser == null)
                                {
                                    context.Response.Write(JsonConvert.SerializeObject(new
                                    {
                                        StatusCode = StatusCode.请求失败,
                                        Message = Message.LOGINFAILED,
                                        accountInfo = new { }
                                    }));
                                    LogHelper.WriteOperation("用户[" + LogUser.Compname + "]登录受到限制", OperationType.Login, "登录失败");
                                    return;
                                }
                                if (restLogUser.RefurbishTime.Month != DateTime.Now.Month && restLogUser.RefurbishTime < DateTime.Now) //判断是否修改刷新日期
                                {
                                    restLogUser.RefurbishTime = DateTime.Now;
                                    restLogUser.Balance = restLogUser.CostToplimit;//把余额还原为上限，记得把别的地方涉及到余额的部分修改。这里是余额等于上限，每次订车消减余额的逻辑。
                                    RB.UpdateRestrict(restLogUser);
                                }
                            }
                            context.Session["UserInfo"] = LogUser;
                            var location = "";
                            if (context.Request.Form["url"].Contains("returnVal"))
                            {
                                location =context.Request.Form["url"].Substring(context.Request.Form["url"].IndexOf("returnVal", System.StringComparison.Ordinal) + 10);
                            }
                            LogHelper.WriteOperation("登录成功，用户名[" + LogUser.Compname + "]", OperationType.Login, "登录成功", LogUser.Compname + "[" + LogUser.Username + "]");
                            context.Response.Write(JsonConvert.SerializeObject(new
                            {
                                StatusCode = StatusCode.请求成功,
                                Message = Message.LOGINED,
                                accountInfo = LogUser,
                                location = location
                            }));
                        }
                        else
                        {
                            context.Response.Write(bll.GetModel(username) != null? JsonConvert.SerializeObject(new {StatusCode = StatusCode.密码错误, Message = "密码错误"}): JsonConvert.SerializeObject(new {StatusCode = StatusCode.用户名不存在, Message = "用户名不存在"}));
                        }
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.VERIFYCODEERROR, StatusCode = StatusCode.验证码错误 }));
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