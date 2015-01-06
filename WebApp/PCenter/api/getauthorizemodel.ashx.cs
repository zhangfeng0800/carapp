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
    /// getauthorizemodel 的摘要说明 
    /// </summary>
    public class getauthorizemodel : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] != null)
            {
                if (context.Request.QueryString["userid"] != null)
                {
                    int userid = 0;
                    if (int.TryParse(context.Request.QueryString["userid"], out userid))
                    {
                        var bll = new RestrictBLL();
                        var data = bll.GetTable(userid);
                        if (data.Rows.Count > 0)
                        {
                            context.Response.Write(
                         JsonConvert.SerializeObject(new AjaxResponse
                         {
                             Data = data,
                             Message = Message.SUCCESS,
                             StatusCode = StatusCode.请求成功
                         }));
                        }
                        else
                        {
                            context.Response.Write(
                         JsonConvert.SerializeObject(new AjaxResponse
                         {
                             Data = null,
                             Message = Message.EMPTY,
                             StatusCode = StatusCode.请求失败
                         }));
                        }
                    }
                    else
                    {
                        context.Response.Write(
                            JsonConvert.SerializeObject(new AjaxResponse
                            {
                                Data = null,
                                Message = Message.BADPARAMETERS,
                                StatusCode = StatusCode.请求失败
                            }));
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