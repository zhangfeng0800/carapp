using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Model;

namespace WebApp.api
{
    /// <summary>
    /// addcontactor 的摘要说明
    /// </summary>
    public class addcontactor : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            if (context.Session["UserInfo"] != null)
            {
                try
                {
                    var user = context.Session["UserInfo"] as UserAccount;
                    var bll = new BLL.ContactPerson();
                    Model.ContactPerson passanger = new ContactPerson();
                    passanger.ContactName = context.Request["name"];
                    passanger.TelePhone = context.Request["telphone"];
                    passanger.UserId = user.Id;

                    var userAccount = context.Session["UserInfo"] as UserAccount;
                    if (userAccount != null)
                    {
                        var userid = userAccount.Id;
                        var contactPersons = (new BLL.ContactPerson()).GetList(userid);
                        var telphone = passanger.TelePhone;
                        if (contactPersons.Exists(p => p.TelePhone == telphone))
                        {
                            context.Response.Write("0");
                            return;
                        }
                        else if (userAccount.Telphone == telphone)
                        {
                            context.Response.Write("0");
                            return;
                        }
                    }
                    bll.Add(passanger);
                    context.Response.Write("1");
                }
                catch
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