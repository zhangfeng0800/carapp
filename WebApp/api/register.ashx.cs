using System;
using System.Collections.Generic;
using System.Web.Security;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
//using Microsoft.AspNet.SignalR;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// register 的摘要说明
    /// </summary>
    public class register : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            HttpCookie DelVC_Cookie = new HttpCookie("VerifyCodeForMobile");
            DelVC_Cookie.Expires = DateTime.Now.AddDays(-1);
            context.Response.Cookies.Add(DelVC_Cookie);

            context.Response.ContentType = "application/json";
            try
            {
                if (context.Request.Form.Count == 10)
                {
                    var bll = new UserAccountBLL();
                    var model = new Model.UserAccount();
                    String username = context.Request.Form["username"];
                    string password = context.Request.Form["password"];
                    string mobile = context.Request.Form["txtmobile"];
                    string verifyCodeStr = context.Request.Form["txtVerify"];
                    string company = context.Request.Form["txtcompany"];
                    string realname = context.Request.Form["txtrealname"];
                    string email = context.Request.Form["txtemail"];
                    string telphone = context.Request.Form["txttelphone"];
                    string sex = context.Request["sex"];
                    int usertype = Convert.ToInt32(context.Request.Form["usertype"]);
                    if (context.Request.Cookies["VerifyCodeForMobile"] == null)//短信验证码不存在
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Message = "请重新获取验证码", StatusCode = StatusCode.请求失败 }));
                        return;
                    }
                    string EncryptStr = EncryptAndDecrypt.Encrypt(mobile + verifyCodeStr);

                    if (EncryptAndDecrypt.Encrypt(context.Request.Form["txtmobile"] + context.Request.Form["txtVerify"].ToUpper()) != context.Request.Cookies["VerifyCodeForMobile"].Value)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Message = "验证码不匹配", StatusCode = StatusCode.请求失败 }));
                        return;
                    }
                    //if (bll.Exits_Telphone(mobile))
                    //{
                    //    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Message = "手机号已经存在，请直接登录", StatusCode = StatusCode.请求失败 }));
                    //    return;
                    //}
                    //if (bll.Exits_Username(username))
                    //{
                    //    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Message = "用户名已经存在", StatusCode = StatusCode.请求失败 }));
                    //    return;
                    //}
                    //if (bll.Exits_Email(email))
                    //{
                    //    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Message = "邮箱已经存在", StatusCode = StatusCode.请求失败 }));
                    //    return;
                    //}
                    //model.Creater = "";
                    model.Balance = 0;
                    model.Compname = company;
                    model.Email = email;
                    model.Password = EncryptAndDecrypt.Encrypt(password);
                    model.Pid = 0;
                    model.Tel = telphone;
                    model.Telphone = mobile;
                    model.Type = usertype;
                    model.Username = username;
                    model.Creater = realname;
                    model.isdelete = false;
                    model.score = 0;
                    model.registTime = DateTime.Now;
                    model.headPic = "/headPic/HeadPic.gif";
                    model.sex = null;
                    model.lastTime = DateTime.Now;
                    model.lastIP = context.Request.UserHostAddress;
                    model.BaiduBuserid = "";
                    model.BaiduChannelid = "";
                    model.DeviceType = 0;
                    model.PayPassword = "";
                    model.CheckCode = "";
                    model.sex = bool.Parse(context.Request["sex"]);
                    //初始支付密码
                    string payPassword = getRandomPay();
                    model.PayPassword = EncryptAndDecrypt.Encrypt(payPassword);
                 

                    context.Session["UserInfo"] = model;
                    model.Registerdevice = "电脑网站";

                    var user = bll.AddDataPro(model);

                    SMS.sendUserPaypwd(company, payPassword, mobile);
                    LogHelper.WriteOperation("新用户注册,手机号码为:["+telphone+"]", OperationType.Add, "注册成功");
                    context.Session["UserInfo"] = user;

                    context.Response.Write(
                            JsonConvert.SerializeObject(new AjaxResponse { Message = "注册成功", StatusCode = StatusCode.请求成功 }));
                }
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Message = exception.Message, StatusCode = StatusCode.请求失败 }));
            }

        }
        /// <summary>
        /// 获取6为随机密码
        /// </summary>
        /// <returns></returns>
        public string getRandomPay()
        {
            Random r = new Random();
            string s = "";
            for(int i=0;i<6;i++)
            {
                s += r.Next(0, 10);
            }
            return s;
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