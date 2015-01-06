using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Model;
using Newtonsoft.Json;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// getVouchers 的摘要说明
    /// </summary>
    public class getVouchers : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            if (context.Session["UserInfo"] == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    CodeId = 0
                }));
                return;
            }
            UserAccount ua = (UserAccount)context.Session["UserInfo"];

            DataTable dt = new BLL.VouchersBll().GetUseVouchers(ua.Id);
            context.Response.Write(JsonConvert.SerializeObject(new
                                                                   {
                                                                       CodeId = 1,
                                                                       Data = dt
                                                                   }

                                       ));
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