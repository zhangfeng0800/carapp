using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// updateauthorizeuser 的摘要说明
    /// </summary>
    public class updateauthorizeuser : IHttpHandler,IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new RestrictBLL();
            var accountBll = new UserAccountBLL();
            if (context.Session["UserInfo"] == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.NOTLOGIN, StatusCode = StatusCode.请求失败 }));
                return;
            }
            var logineduser = ((UserAccount)(context.Session["UserInfo"]));
            if (context.Request.Form["username"] != null && context.Request.Form["telphone"] != null &&
                context.Request.Form["role"] != null && context.Request.Form["deadline"] != null &&
                context.Request.Form["daterestrict"] != null && context.Request.Form["workday"] != null &&
                context.Request.Form["timell"] != null && context.Request.Form["timeul"] != null &&
                context.Request.Form["costtype"] != null && context.Request.Form["costtoplimit"] != null &&
                context.Request.Form["cartype"] != null && context.Request.Form["userid"] != null)
            {
                accountBll.UpdateUserProperty(context.Request.Form["username"], context.Request.Form["telphone"], context.Request.Form["role"], context.Request.Form["userid"]);
                DateTime date;

                if (!DateTime.TryParse(context.Request.Form["deadline"], out date))
                {
                    date = DateTime.Now;
                }
                var model = new Restrict
                {
                    Deadline = date,
                    CarType = context.Request.Form["cartype"],
                    CostToplimit = ParseInt(context.Request.Form["costtoplimit"]),
                    CostType = ParseInt(context.Request.Form["costtype"]),
                    DateRest = ParseInt(context.Request.Form["daterestrict"]),
                    TimeLL = ParseInt(context.Request.Form["timell"]),
                    TimeUL = ParseInt(context.Request.Form["timeul"]),
                    Workday = ParseInt(context.Request.Form["workday"]),
                    UserId = ParseInt(context.Request.Form["userid"])
                  
                };
                var result = bll.UpdateRestrict(model);
                if (result > 0)
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
                    context.Response.Write(
                        JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = null,
                            Message = Message.BADPARAMETERS,
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
        public int ParseInt(string s)
        {
            int returnValue = 0;
            if (!int.TryParse(s, out returnValue))
            {
                returnValue = 0;
            }
            return returnValue;
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