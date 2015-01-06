using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// updatestatus 的摘要说明
    /// </summary>
    public class updatestatus : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] != null)
            {
                BLL.RestrictBLL bll = new RestrictBLL();
                if (context.Request.Form["userId"] != null)
                {
                    var userid = context.Request.Form["userId"];
                    var id = 0;
                    if (int.TryParse(userid, out id))
                    {
                        if (bll.UpdateStatus(id) > 0)
                        {
                            context.Response.Write(
                                JsonConvert.SerializeObject(new AjaxResponse
                                {
                                    Data = null,
                                    Message = Message.SUCCESS,
                                    StatusCode = StatusCode.请求成功
                                }));
                        }
                        else
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.EMPTY, StatusCode = StatusCode.请求失败 }));
                        }
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.BADPARAMETERS, StatusCode = StatusCode.请求失败 }));

                    }
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