using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace WebApp.api
{
    /// <summary>
    /// checkPayPassword 的摘要说明
    /// </summary>
    public class checkPayPassword : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            int userid = int.Parse(context.Request["userid"]);
            string password = context.Request["password"];
            var userModel = context.Session["userInfo"] as Model.UserAccount;
            bool checkTrue = new BLL.UserAccountBLL().EnterPayPassword(userid, password);
            if (checkTrue)
            {
                context.Response.Write("1");
            }
            else
            {
                if (string.IsNullOrEmpty(userModel.PayPassword))
                {
                    context.Response.Write("2");
                }
                else
                {
                    context.Response.Write("0");
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