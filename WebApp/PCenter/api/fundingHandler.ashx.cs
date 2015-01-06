using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Model;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// fundingHandler 的摘要说明
    /// </summary>
    public class fundingHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var action = context.Request["action"];
            if(action == "submit")
            {
                try
                {
                    var rulesId = Convert.ToInt32(context.Request["rulesId"]);
                    var times =Convert.ToInt32(context.Request["times"]);
                    Model.UserAccount userThis = context.Session["UserInfo"] as UserAccount;
                    var result = new BLL.FundingBll().AddFundingByUser(userThis.Id, rulesId, times);

                    

                    context.Response.Write("success");

                }
                catch (Exception)
                {
                    context.Response.Write("failure");
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