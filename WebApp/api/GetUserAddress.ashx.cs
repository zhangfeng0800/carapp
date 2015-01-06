using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// GetUserAddress 的摘要说明
    /// </summary>
    public class GetUserAddress : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                context.Response.ContentType = "text/plain";
                string cityid = context.Request["cityid"];
                string userid = context.Request["userid"];
                List<Model.userAddress> list = new BLL.UserAddressBLL().GetList(Int32.Parse(userid), cityid, 5);
                context.Response.Write(JsonConvert.SerializeObject(new { data = list, msg = "成功" }));
            }
            catch (Exception exp)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { msg = exp.Message }));
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