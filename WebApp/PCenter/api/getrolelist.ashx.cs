using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// getrolelist 的摘要说明
    /// </summary>
    public class getrolelist : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] != null)
            {
                var useracount = (UserAccount)context.Session["UserInfo"];
                if (useracount.Type == 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = new object[] { new { typename = "部门经理", value = 1 }, new { typename = "部门员工", value = 2 } },StatusCode = StatusCode.请求成功
                    }));
                }
                else if (useracount.Type == 1)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = new object[] { new { typename = "部门员工", value = 2 } },StatusCode = StatusCode.请求成功 }));
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.NOTLOGIN, StatusCode = StatusCode.请求失败 }));
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