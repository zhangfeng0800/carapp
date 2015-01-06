using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Common;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// loginout 的摘要说明
    /// </summary>
    public class loginout : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] != null)
            {
                context.Session.Abandon();
                context.Session.Clear();
                SiteBase site=new SiteBase();
                site.IsLogined = 0;
                site.Username = "游客";
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                   StatusCode = StatusCode.请求成功,
                   Location = "/"
                }));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                    StatusCode = StatusCode.请求失败,
                    Location = "/Default.aspx"
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