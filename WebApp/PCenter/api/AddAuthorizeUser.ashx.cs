using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.SessionState;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// AddAuthorizeUser 的摘要说明
    /// </summary>
    public class AddAuthorizeUser : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)//by wang
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
                context.Request.Form["cartype"] != null)
            {
                var useraccount = new UserAccount
                {
                    Username = context.Request.Form["username"],
                    Compname = logineduser.Compname,
                    Email = "",
                    Password = EncryptAndDecrypt.Encrypt("123456"),
                    Telphone = context.Request.Form["telphone"],
                    Tel = "",
                    Balance = 0,
                    Type = ParseInt(context.Request.Form["role"]),
                    Pid = logineduser.Id,
                    Creater = "",
                    isdelete = false,
                    BaiduBuserid = "",
                    BaiduChannelid = "",
                    PayPassword = "",
                    DeviceType = 0,
                    CheckCode = ""
                };
                var userid = accountBll.AddData(useraccount);
                DateTime date;

                if (!DateTime.TryParse(context.Request.Form["deadline"], out date))
                {
                    date = DateTime.Now;
                }
                var model = new Restrict
                {
                    Deadline = date,
                    Balance = 0,
                    CarType = context.Request.Form["cartype"],
                    CostToplimit = ParseInt(context.Request.Form["costtoplimit"]),
                    CostType = ParseInt(context.Request.Form["costtype"]),
                    DateRest = ParseInt(context.Request.Form["daterestrict"]),
                    RefurbishTime = DateTime.Now,
                    TimeLL = ParseInt(context.Request.Form["timell"]),
                    TimeUL = ParseInt(context.Request.Form["timeul"]),
                    Workday = ParseInt(context.Request.Form["workday"]),
                    UserId = userid,
                    Status = logineduser.Type == 0 ? 1 : 0//添加人管理员，启用；非管理员则是未启用
                };
                if (logineduser.Type != 0)//添加人的用户类型不是"集团管理员"，则发给集团管理员一个操作申请
                {

                }
                var result = bll.AddRestrict(model);
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