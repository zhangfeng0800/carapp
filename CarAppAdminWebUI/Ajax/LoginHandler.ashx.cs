using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// LoginHandler 的摘要说明
    /// </summary>
    public class LoginHandler : IHttpHandler
    {
        //121.28.211.162:9003
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            var action = context.Request["action"];
            var httpCookie = context.Request.Cookies["VerifyCode"];
            var url = WebConfigurationManager.AppSettings["callcenteraddr"];
            //检验输入验证码是否正确 
            if (!string.IsNullOrEmpty(action) && action == "checkCode")
            {
                var code = context.Request["code"].ToString();
                context.Response.Write(code.ToLower() != httpCookie.Value.ToLower() ? "Failure" : "Success");
                return;
            }

            var myselect = context.Request["myselect"].ToString();

            var _adminBll = new BLL.AdminBll();
            if (context.Request["AdminName"] != null)
            {

                if (httpCookie == null || context.Request["txt_verifycode"].ToString().ToLower() != httpCookie.Value.ToLower())
                {
                    //ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('验证码错误')", true);
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "验证码错误" }));
                    return;
                }
                if (context.Request["type"].ToString() == "true")
                {
                    var dict = new Dictionary<string, string> { { "groupid", "0" }, { "exten", myselect } };
                    //if (PingTool.PingServer(300, 10))
                    //{

                    var result = ServiceHelper.GetServiceResponse("http://" + url + "/GetStatus", dict);
                    if (result.Contains("checkedin"))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "请选择其他坐席" })); //请选择其他坐席
                    }
                    //}

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
                if (context.Request["type"].ToString() == "true" && isLogin == true && adminModel.AdminGroupsId == 2)
                {
                    var parameters = new Dictionary<string, string>
                    {
                        {"state", "1"},
                        {"groupid", "0"},
                        {"exten",myselect}
                    }; 
                    var returnResult = ServiceHelper.GetServiceResponse(
                        "http://" + url + "/CheckInOut", parameters);
                    if (string.IsNullOrEmpty(returnResult))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "登录失败" }));
                        return;
                    }
                    var dictionary = JsonConvert.DeserializeObject<Dictionary<string, string>>(returnResult);
                    switch (dictionary.First().Value)
                    {
                        case "failure":
                            context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "登录失败" }));
                            return;
                        case "success":
                            {
                                LogHelper.WriteOperation(
                                    "客服[" + adminName + "]登录，登录的坐席号是[" + myselect + "]，登录时间是[" + DateTime.Now.ToString() +
                                    "]", OperationType.Login, "登陆成功");
                                var extenlogbll = new ExtenLogBLL();
                                extenlogbll.Insert(new ExtenLog()
                                {
                                    Exten = myselect,
                                    Name = adminName,
                                    OperationTime = DateTime.Now,
                                    OperationType = CallcenterOperationType.签入.ToString()
                                });
                                FormsAuthentication.SetAuthCookie(adminName, false);
                                Global.ExtenLogin(myselect);
                                context.Response.Cookies.Add(new HttpCookie("exten", myselect));
                                context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 1, Msg = "成功!" }));
                            }
                            break;
                        default:
                            context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "登录失败" }));
                            break;
                    } 
                }
                else if (context.Request["type"].ToString() == "false" && isLogin && adminModel.AdminGroupsId != 2)
                {
                    FormsAuthentication.SetAuthCookie(adminName, false);
                    context.Response.Cookies.Add(new HttpCookie("exten", "0"));
                    LogHelper.WriteOperation("后台登录", OperationType.Login, "登录成功", adminName);
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 1, Msg = "成功!" }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { ResultCode = 0, Msg = "登录失败" }));
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