using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// CheckUserType 的摘要说明
    /// </summary>
    public class CheckUserType : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] != null)
            {
                var userinfo = ((UserAccount)(context.Session["UserInfo"])).Type;
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = userinfo, Location = userinfo == 1 ? "/Personcenter/MyAccount.aspx.aspx" : "/Personcenter/MyAccount.aspx" }));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Message = Message.SUCCESS, StatusCode = StatusCode.请求失败 }));
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