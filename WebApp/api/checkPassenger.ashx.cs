using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Model;
using Newtonsoft.Json;
using ContactPerson = BLL.ContactPerson;

namespace WebApp.api
{
    /// <summary>
    /// checkPassenger 的摘要说明
    /// </summary>
    public class checkPassenger :IHttpHandler,IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["telPhone"] != null)
            {
                if (context.Session["UserInfo"] != null)
                {
                    var userAccount = context.Session["UserInfo"] as UserAccount;
                    if (userAccount != null)
                    {
                        var userid = userAccount.Id;
                        var contactPersons = (new ContactPerson()).GetList(userid);
                        var telphone = context.Request["telPhone"].ToString();
                        if (context.Request["updateID"]!= null)
                        {
                            int id = Convert.ToInt32(context.Request["updateID"]);
                            Model.ContactPerson person = new BLL.ContactPerson().GetOneByPhone(telphone,userid.ToString());
                            if(person.Id == Convert.ToInt32(context.Request["updateID"]))
                            {
                                context.Response.Write(JsonConvert.SerializeObject(new {resultcode = 0, msg = ""}));
                                return;
                            }
                        }

                        context.Response.Write(
                            contactPersons.Exists(p => p.TelePhone ==telphone)
                                ? JsonConvert.SerializeObject(new {resultcode = 1, msg = "手机号已经存在"})
                                : JsonConvert.SerializeObject(new {resultcode = 0, msg = ""}));
                        return;
                    }
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, msg = "请登录" }));
                    return;
                }
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, msg = "请登录" }));
                return;
            }
            context.Response.Write(JsonConvert.SerializeObject(new{resultcode=1,msg="请输入手机号"}));
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