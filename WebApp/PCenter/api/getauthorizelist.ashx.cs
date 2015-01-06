using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// getauthorizelist 的摘要说明
    /// </summary>
    public class getauthorizelist : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] != null)
            {
                var user = (UserAccount)context.Session["UserInfo"];
                if (user == null)
                {
                    context.Response.Write(
                        JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = null,
                            Message = Message.NOTFOUND,
                            StatusCode = StatusCode.请求失败
                        }));
                    return;
                }
                var data = (new RestrictBLL()).GetTable(user.Id.ToString());
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
                           Message = Message.NOTLOGIN,
                           StatusCode = StatusCode.请求失败
                       }));
                return;
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