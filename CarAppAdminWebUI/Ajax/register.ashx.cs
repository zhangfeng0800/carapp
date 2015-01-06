using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// register 的摘要说明
    /// </summary>
    public class register : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["telphone"] != null)
            {
                var telphone = context.Request["telphone"];
                if (string.IsNullOrEmpty(telphone))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "参数错误" }));
                    return;
                }
                var userbll = new UserAccountBLL();
                var userModel = userbll.GetModel(telphone);
                if (userModel != null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "此手机号已经注册" }));
                    return;
                }
                try
                {
                    var reg = new Regex("^1\\d{10}$");
                    if (!reg.IsMatch(telphone))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "手机号码格式错误" }));
                        return;
                    }
                    var password = GetCheckCode();
                    var paypassword = GetPayCheckCode();
                    var newUser = new UserAccount()
                    {
                        Username = context.Request["name"],
                        BaiduBuserid = "",
                        BaiduChannelid = "",
                        Balance = 0,
                        CheckCode = "",
                        Compname = context.Request["name"],
                        Creater = "",
                        DeviceType = 4,
                        Email = "",
                        headPic = "",
                        Password = Common.EncryptAndDecrypt.Encrypt(password),
                        PayPassword = Common.EncryptAndDecrypt.Encrypt(paypassword),
                        Pid = 0,
                        Tel = "",
                        sex = bool.Parse(context.Request["sex"]),
                        score = 0,
                        Telphone = telphone,
                        Type = int.Parse(context.Request["type"]),
                        isdelete = false,
                        lastIP = "",
                        lastTime = DateTime.Now,
                        registTime = DateTime.Now,
                        Registerdevice = "呼叫中心"
                    };

                    var returnResult =
                        JsonConvert.SerializeObject(
                            new
                            {
                                resultcode = 1,
                                msg = "注册成功",
                                location = "/layer.aspx?telphone=" + telphone + "," + ((string.IsNullOrEmpty(context.Request["querystring"]))?"":context.Request["querystring"].Split(',')[1])
                            }); 
                    var user = new BLL.UserAccountBLL().AddDataPro(newUser);

                    if (user.Id == 0)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "注册失败" }));
                        return;
                    }
                    context.Response.Write(returnResult);
                    Common.SMS.RegisterByMobile(password, paypassword, telphone);
                    LogHelper.WriteOperation("后台客服替客户注册，客服名称："+context.User.Identity.Name+"注册手机号："+telphone+"，姓名是："+context.Request["name"],OperationType.Add,"注册成功","");
                    return;
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "注册失败" }));
                    return;
                }
            }
            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "参数错误" }));
        }

        public string GetCheckCode()
        {

            int number;
            char code;
            string checkCode = String.Empty;

            System.Random random = new Random();

            for (int i = 0; i < 6; i++)
            {
                number = random.Next();
                code = (char)('0' + (char)(number % 10));
                checkCode += code.ToString();
            }
            return checkCode;
        }
        public string GetPayCheckCode()
        {

            int number;
            char code;
            string checkCode = String.Empty;

            System.Random random = new Random();

            for (int i = 0; i < 6; i++)
            {
                number = random.Next();
                code = (char)('0' + (char)(number % 10));
                checkCode += code.ToString();
            }
            return checkCode;
        }
        public bool IsReusable
        {
            get { return false; }
        }
    }
}

