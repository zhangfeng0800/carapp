using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// GenerateRechargeNum 的摘要说明
    /// </summary>
    public class GenerateRechargeNum : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["rechargeMo"] != null && context.Session["UserInfo"] != null)
            {
                var model = (UserAccount)context.Session["UserInfo"];
                try
                {
                    string rechargeId = new rechargeBLL().InsertRecharge(decimal.Parse(context.Request["rechargeMo"]), Convert.ToInt32(model.Id));
                    LogHelper.WriteOperation("新增了充值号码：" + rechargeId, OperationType.Add, "添加成功", model.Compname + "[" + model.Username + "]");
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        RechargeId = rechargeId,
                        CodeId = 1
                    }));
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        CodeId = 0
                    }));
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