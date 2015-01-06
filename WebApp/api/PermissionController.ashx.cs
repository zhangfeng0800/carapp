using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace WebApp.api
{
    /// <summary>
    /// PermissionController 的摘要说明
    /// </summary>
    public class PermissionController : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var action = context.Request["action"];
            switch (action)
            {
                case "add":
                    {
                        try
                        {
                            var type = context.Request["type"];
                            new BLL.PermissionBLL().Add(new Model.Permission()
                            {
                                ErrorDate = DateTime.Now,
                                ErrorType = int.Parse(type),
                                UserID = ((Model.UserAccount)context.Session["UserInfo"]).Id
                            });
                            context.Response.Write("true");
                        }
                        catch
                        {
                            context.Response.Write("false");
                        }
                    } break;
                case "count":
                    {
                        try
                        {
                            var type = int.Parse(context.Request["type"]);
                            var model = (Model.UserAccount) context.Session["UserInfo"];
                            var count = new BLL.PermissionBLL().gettodayErrorCount(model.Id, type);
                            context.Response.Write(count);
                        }
                        catch
                        {
                            context.Response.Write("false"); 
                        }
                    }
                    break;
                default:
                    break;
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