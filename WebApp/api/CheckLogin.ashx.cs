using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// CheckLogin 的摘要说明
    /// </summary>
    public class CheckLogin : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] == null)
            {
                context.Response.Write(
                    JsonConvert.SerializeObject(new 
                    {
                        Data = "",
                        Message = Message.NOTLOGIN,
                        ReturnCode = StatusCode.请求失败,
                        Location = context.Request.Form["url"]
                    }));
            }
            else
            {
                //Model.UserAccount userThis = context.Session["UserInfo"] as UserAccount;
                //if (!new BLL.UserAccountBLL().CanGetOrder(userThis.Id))
                //{
                //    context.Response.Write(
                //JsonConvert.SerializeObject(new AjaxResponse
                //{
                //    Message = "您没有预定此车型权限,",
                //    StatusCode = StatusCode.请求失败,
                //    Data = 1
                //}));
                //    return;


                //}
                context.Response.Write(
                    JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = (UserAccount)context.Session["UserInfo"],
                        Message = Message.LOGINED,
                        StatusCode = StatusCode.请求成功
                    }));
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