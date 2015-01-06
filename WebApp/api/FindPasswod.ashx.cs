using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// FindPasswod 的摘要说明
    /// </summary>
    public class FindPasswod : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.Form["CheckTelphone"] != null)
            {
                var telphone = context.Request.Form["CheckTelphone"].ToString();
                var user = new BLL.UserAccountBLL();
                var data = user.GetTableByTel(telphone);
                if (data.Rows.Count > 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        CodeId = 1
                    }));
                    return;
                }

                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    CodeId = 0,
                    Message = "该手机号码不存在，请核实"
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